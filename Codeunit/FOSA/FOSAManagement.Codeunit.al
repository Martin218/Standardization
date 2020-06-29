codeunit 50001 "FOSA Management"
{
    trigger OnRun()
    begin

    end;

    var
        CBSSetup: Record "CBS Setup";
        CTSSetup: Record "CTS Setup";
        Vendor: Record Vendor;
        GenJournalLine: Record "Gen. Journal Line";
        InsufficientAccBalErr: Label 'Insufficient Account Balance';
        ReasonCode: Code[10];
        Indicator: Code[10];
        CCReasonCode: Record "CC Reason Code";
        GLAccount: array[8] of Code[20];
        SmsTextMsg: Label 'Dear Member, Your Cheque No. %1 has been cleared successfully. Your Account No. %2 %3 has been debited with KES %4';
        SourceCodeSetup: Record "Source Code Setup";

    procedure PostChequeBook(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ChequeBook: Record "Cheque Book";
        AccountBalance: Decimal;
        ExciseDuty: Decimal;
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        WITH ChequeBookApplication DO BEGIN
            CBSSetup.Get();
            SourceCodeSetup.Get();
            CTSSetup.Get();
            ClearJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name");
            IF CTSSetup."Charge Excise Duty" then
                ExciseDuty := CBSSetup."Excise Duty %" / 100 * (CTSSetup."Charges Per Leaf" * "No. of Leaves");
            AccountBalance := GetAccountBalance("Account No.") - GetMinimumBalance("Account No.");
            IF AccountBalance >= (CTSSetup."Charges Per Leaf" * "No. of Leaves") THEN BEGIN
                CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor, "Account No.", Description + '-Charges',
                              (CTSSetup."Charges Per Leaf" * "No. of Leaves"), SourceCodeSetup.CTS, "Global Dimension 1 Code");
                CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account", CTSSetup."Charges G/L Account", Description + '-Charges',
                              -(CTSSetup."Charges Per Leaf" * "No. of Leaves"), SourceCodeSetup.CTS, "Global Dimension 1 Code");
                AccountBalance -= (CTSSetup."Charges Per Leaf" * "No. of Leaves");

                /* IF AccountBalance>=ExciseDuty THEN BEGIN
                   CreateJournal(CBSSetup."Cheque Template Name",CBSSetup."Cheque Batch Name","No.","No.",TODAY,GenJournalLine."Account Type"::Vendor,"Account No.",Description+'-Excise Duty',
                                 ExciseDuty,0,"Global Dimension 1 Code");
                   CreateJournal(CBSSetup."Cheque Template Name",CBSSetup."Cheque Batch Name","No.","No.",TODAY,GenJournalLine."Account Type"::"G/L Account",CBSSetup."Excise Duty G/L Account",Description+'-Excise Duty',
                                 -ExciseDuty,0,"Global Dimension 1 Code");
                 END ELSE
                   CreateCTSEntry(ChequeClearanceLine,'Cheque Book Excise Duty',3,ExciseDuty);*/

            END ELSE
                ERROR(InsufficientAccBalErr);

            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name") THEN BEGIN
                ChequeBook.GET("Cheque Book No.");
                ChequeBook.Status := ChequeBook.Status::Issued;
                ChequeBook."Issued By" := USERID;
                ChequeBook."Issued Date" := TODAY;
                ChequeBook."Issued Time" := TIME;
                ChequeBook.MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;

    end;

    local procedure GetReasonCode(AccountNo: Code[20]; Amount: Decimal)
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Vendor.Status = Vendor.Status::Active THEN BEGIN
                ReasonCode := '';
                Indicator := 'PAID';
            END ELSE BEGIN
                IF Vendor.Status = Vendor.Status::Dormant THEN BEGIN
                    ReasonCode := '64';
                    Indicator := 'UNPAID';
                END ELSE
                    IF Vendor.Status = Vendor.Status::Closed THEN BEGIN
                        ReasonCode := '74';
                        Indicator := 'UNPAID';
                    END ELSE
                        IF Vendor.Status = Vendor.Status::Frozen THEN BEGIN
                            ReasonCode := '77';
                            Indicator := 'UNPAID';
                        END ELSE BEGIN
                            ReasonCode := '77';
                            Indicator := 'UNPAID';
                        END;
            END;
            IF (GetAccountBalance(AccountNo) - Amount) < GetMinimumBalance(AccountNo) THEN BEGIN
                ReasonCode := '63';
                Indicator := 'UNPAID';
            END;
        END ELSE BEGIN
            ReasonCode := '69';
            Indicator := 'UNPAID';
        END;
    end;

    local procedure GetAccountNo(MemberNo: Code[20]): Code[20]
    var
        ChequeBook: Record "Cheque Book";
    begin
        ChequeBook.RESET;
        ChequeBook.SETRANGE("Member No.", MemberNo);
        ChequeBook.SETRANGE(Status, ChequeBook.Status::Issued);
        ChequeBook.SETRANGE(Active, TRUE);
        IF ChequeBook.FINDLAST THEN
            EXIT(ChequeBook."Account No.");
    end;

    local procedure GetAccountBalance(AccountNo: Code[20]) AccountBalance: Decimal
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            Vendor.CALCFIELDS("Balance (LCY)");
            AccountBalance := Vendor."Balance (LCY)";
            EXIT(AccountBalance);
        END;
    end;

    local procedure GetMinimumBalance(AccountNo: Code[20]) MinimumBalance: Decimal
    var
        AccountType: Record "Account Type";
    begin
        Vendor.RESET;
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF AccountType.GET(Vendor."Account Type") THEN
                MinimumBalance := AccountType."Minimum Balance";
            EXIT(MinimumBalance);
        END;
    end;

    procedure ValidatePRMEntry(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", ChequeClearanceHeader."No.");
        ChequeClearanceLine.SetRange(Select, true);
        IF ChequeClearanceLine.FINDSET THEN BEGIN
            REPEAT
                ChequeClearanceLine.TESTFIELD("Member No.");
                GetReasonCode(GetAccountNo(ChequeClearanceLine."Member No."), ChequeClearanceLine.Amount);
                ChequeClearanceLine."Unpaid Code" := ReasonCode;
                ChequeClearanceLine.VALIDATE("Unpaid Code");
                ChequeClearanceLine.Indicator := Indicator;
                ChequeClearanceLine.Validated := TRUE;
                ChequeClearanceLine.MODIFY;
            UNTIL ChequeClearanceLine.NEXT = 0;
        END;
    end;

    procedure PostChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
        Amount: array[8] of Decimal;
        AccountBalance: Decimal;
        CTSEntry: Record "CTS Entry";
        Member: Record Member;
        Vendor2: Record Vendor;
        SMSText: Text;
        AccountNo: Code[20];
        PhoneNo: Code[20];
        PhoneNoTxt: Text;
    begin
        WITH ChequeClearanceHeader DO BEGIN
            CBSSetup.GET;
            CTSSetup.Get();
            SourceCodeSetup.Get();
            ClearJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name");
            ChequeClearanceLine.RESET;
            ChequeClearanceLine.SETRANGE("Document No.", "No.");
            ChequeClearanceLine.SetRange(Select, true);
            IF ChequeClearanceLine.FINDSET THEN BEGIN
                REPEAT
                    IF ChequeClearanceLine.Indicator = 'PAID' THEN BEGIN
                        ChequeClearanceLine.TESTFIELD("Member No.");
                        ChequeClearanceLine.TESTFIELD(Description);

                        AccountNo := GetAccountNo(ChequeClearanceLine."Member No.");
                        CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      AccountNo, 'Cheque Clearance', ChequeClearanceLine.Amount, SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                        CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      CTSSetup."Cheque Clearance Account", 'Cheque Clearance', -ChequeClearanceLine.Amount, SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                        AccountBalance := GetAccountBalance(GetAccountNo(ChequeClearanceLine."Member No.")) - (GetMinimumBalance(GetAccountNo(ChequeClearanceLine."Member No.")) + ChequeClearanceLine.Amount);

                        IF AccountBalance >= CTSSetup."Clearance Charges" THEN BEGIN
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          AccountNo, 'Cheque Clearance Charges', CTSSetup."Clearance Charges", SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                          CTSSetup."Commission G/L Account", 'Cheque Clearance Charges', -CTSSetup."Clearance Charges", SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                            AccountBalance -= CTSSetup."Clearance Charges";
                        END ELSE
                            CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Charges', 0, CTSSetup."Clearance Charges");

                        Amount[2] := CBSSetup."Excise Duty %" / 100 * CTSSetup."Clearance Charges";

                        IF AccountBalance >= Amount[2] THEN BEGIN
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          AccountNo, 'Cheque Clearance Excise Duty', Amount[2], SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                          CBSSetup."Excise Duty G/L Account", 'Cheque Clearance Excise Duty', -Amount[2], SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                            AccountBalance -= Amount[2];
                        END ELSE
                            CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Excise Duty', 3, Amount[2]);

                        IF AccountBalance >= CTSSetup."SMS Charges" THEN BEGIN
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          AccountNo, 'Cheque Clearance SMS Charges', CTSSetup."SMS Charges", SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                            CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                          CTSSetup."SMS G/L Account", 'Cheque Clearance SMS Charges', -CTSSetup."SMS Charges", SourceCodeSetup.CTS, ChequeClearanceLine."Global Dimension 1 Code");
                        END ELSE
                            CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance SMS Charges', 2, CTSSetup."SMS Charges");

                        //Send SMS
                        Vendor2.GET(AccountNo);
                        Member.GET(ChequeClearanceLine."Member No.");
                        PhoneNo := Member."Phone No.";



                        PhoneNoTxt := FORMAT(PhoneNo);
                        SMSText := STRSUBSTNO(SmsTextMsg, ChequeClearanceLine."Serial No.", ChequeClearanceLine."Account No.", Vendor2.Name, ChequeClearanceLine.Amount);
                        // SendSms.Send(PhoneNoTxt, SMSText);
                    END ELSE BEGIN
                        IF CCReasonCode.GET(ChequeClearanceLine."Unpaid Code") THEN
                            Amount[1] := CCReasonCode."Charge Amount"
                        ELSE
                            Amount[1] := 0;

                        CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Penalty Charges', 1, Amount[1]);
                        CreateCTSEntry(ChequeClearanceLine, 'Cheque Clearance Excise Duty on Penalty', 3, Amount[1] * CBSSetup."Excise Duty %" / 100);
                    END;
                UNTIL ChequeClearanceLine.NEXT = 0;
            END;

            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name") THEN BEGIN
                Posted := TRUE;
                "Cleared By" := USERID;
                "Cleared Date" := TODAY;
                "Cleared Time" := TIME;
                IF MODIFY THEN
                    UpdateNextLeaf(ChequeClearanceHeader);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure CreateCTSEntry(var ChequeClearanceLine: Record "Cheque Clearance Line"; Description2: Text[50]; TransactionType: Integer; AmountToPay: Decimal)
    var
        CTSEntry: Record "CTS Entry";
        CTSEntry2: Record "CTS Entry";
        EntryNo: Integer;
        ChequeClearanceHeader: Record "Cheque Clearance Header";
    begin
        WITH ChequeClearanceLine DO BEGIN
            CBSSetup.GET;
            ChequeClearanceHeader.GET("Document No.");
            CTSEntry.INIT;
            IF CTSEntry2.FINDLAST THEN
                EntryNo := CTSEntry2."Entry No."
            ELSE
                EntryNo := 0;
            CTSEntry."Entry No." := EntryNo + 1;
            CTSEntry."Document No." := ChequeClearanceHeader."No.";
            CTSEntry."Clearance Date" := ChequeClearanceHeader."Created Date";
            CTSEntry."Cheque No." := "Serial No.";
            CTSEntry."Member No." := "Member No.";
            CTSEntry."Member Name" := "Member Name";
            CTSEntry."Account No." := "Account No.";
            CTSEntry."Account Name" := "Account Name";
            CTSEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
            CTSEntry.Description := Description2;
            CTSEntry."Amount To Pay" := AmountToPay;
            CTSEntry."Unpaid Code" := "Unpaid Code";
            CTSEntry."Unpaid Reason" := "Unpaid Reason";
            IF TransactionType = 0 THEN
                CTSEntry."G/L Account" := CTSSetup."Commission G/L Account";
            IF TransactionType = 1 THEN
                CTSEntry."G/L Account" := CTSSetup."Penalty G/L Account";
            IF TransactionType = 2 THEN
                CTSEntry."G/L Account" := CTSSetup."SMS G/L Account";
            IF TransactionType = 3 THEN
                CTSEntry."G/L Account" := CBSSetup."Excise Duty G/L Account";
            IF CTSEntry."Amount To Pay" <> 0 THEN
                CTSEntry.INSERT;
        END;
    end;

    local procedure UpdateNextLeaf(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
        ChequeBook: Record "Cheque Book";
        LastLeafUsed: Integer;
    begin
        WITH ChequeClearanceHeader DO BEGIN
            ChequeClearanceLine.RESET;
            ChequeClearanceLine.SETRANGE("Document No.", "No.");
            ChequeClearanceLine.SetRange(Select, true);
            IF ChequeClearanceLine.FINDSET THEN BEGIN
                REPEAT
                    ChequeBook.RESET;
                    ChequeBook.SETRANGE("Member No.", ChequeClearanceLine."Member No.");
                    ChequeBook.SETRANGE(Status, ChequeBook.Status::Issued);
                    IF ChequeBook.FINDFIRST THEN BEGIN
                        //EVALUATE(LastLeafUsed,ChequeBook."Last Leaf Used");
                        IF ChequeBook."Last Leaf Used" <> '' then
                            ChequeBook."Last Leaf Used" := INCSTR(ChequeBook."Last Leaf Used")
                        else
                            ChequeBook."Last Leaf Used" := ChequeBook."Start Leaf No.";
                        ChequeBook.MODIFY;

                        /* IF ChequeBook."End Leaf No."=ChequeBook."Last Leaf Used" THEN BEGIN
                           CreateChequeBook(ChequeBook."Member No.");
                           ChequeBook.Active:=FALSE;
                           ChequeBook.MODIFY;
                         END;*/
                    END;
                UNTIL ChequeClearanceLine.NEXT = 0;
            END;
        END;

    end;

    procedure RecoverUnpaidCTSEntries(var CTSEntry: Record "CTS Entry")
    var
        AccountBalance: Decimal;
    begin
        WITH CTSEntry DO BEGIN
            CTSSetup.GET;
            AccountBalance := GetAccountBalance("Account No.") - GetMinimumBalance("Account No.");
            IF AccountBalance >= "Amount To Pay" THEN BEGIN
                CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "Document No.", "Document No.", TODAY, GenJournalLine."Account Type"::Vendor,
                              "Account No.", Description, "Amount To Pay", SourceCodeSetup.CTS, "Global Dimension 1 Code");
                CreateJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name", "Document No.", "Document No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                              "G/L Account", Description, -"Amount To Pay", SourceCodeSetup.CTS, "Global Dimension 1 Code");
                AccountBalance -= "Amount To Pay";
            END;
            IF PostJournal(CBSSetup."Cheque Template Name", CBSSetup."Cheque Batch Name") THEN BEGIN
                Paid := TRUE;
                "Paid Date" := TODAY;
                "Paid Time" := TIME;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    procedure CreateJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; AccountType: Option "G/L Account",Member,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; SourceCode: Code[20]; GlobalDimensionCode: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNo: Integer;
    begin
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := JournalTemplateName;
        GenJournalLine."Journal Batch Name" := JournalBatchName;
        GenJournalLine."Document No." := DocumentNo;
        GenJournalLine."External Document No." := ExternalDocNo;
        GenJournalLine."Posting Date" := PostingDate;
        GenJournalLine."Line No." := GetLastLineNo(JournalTemplateName, JournalBatchName) + 10000;
        GenJournalLine.Description := Description;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Amount (LCY)" := Amount;
        GenJournalLine.VALIDATE("Amount (LCY)");
        GenJournalLine."Source Code" := SourceCode;
        GenJournalLine."Shortcut Dimension 1 Code" := GlobalDimensionCode;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    local procedure GetLastLineNo(JournalTemplateName: Code[20]; JournalBatchName: Code[20]) LineNo: Integer
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDLAST THEN
            LineNo := GenJournalLine."Line No."
        ELSE
            LineNo := 0;
        EXIT(LineNo);
    end;

    procedure PostJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]): Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJnlPostBatch: Codeunit "Gen. Jnl.-Post Batch";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        IF GenJournalLine.FINDSET THEN BEGIN
            COMMIT;
            IF GenJnlPostBatch.RUN(GenJournalLine) THEN
                EXIT(TRUE)
            ELSE
                EXIT(FALSE);
        END;
    end;

    procedure ClearJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20])
    var
        GenJournalLine: Record "Gen. Journal Line";
    begin
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE("Journal Template Name", JournalTemplateName);
        GenJournalLine.SETRANGE("Journal Batch Name", JournalBatchName);
        GenJournalLine.DELETEALL;
    end;


}