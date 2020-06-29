codeunit 50010 "BOSA Management"
{
    // version TL2.0


    trigger OnRun()
    begin
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalLine2: Record "Gen. Journal Line";
        LineNo: Integer;
        Vendor: Record "Vendor";
        i: Integer;
        CBSSetup: Record "CBS Setup";
        Customer: Record "Customer";
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        Text000: Label 'Interest Due for ';
        Text001: Label '-Prin. in Arrears';
        Text002: Label '-Int. in Arrears';
        Text003: Label '-Principal Paid';
        Text004: Label '-Interest Paid';
        Text005: Label '-Transaction Charges';
        Text006: Label '-Penalty Charges';
        SourceCode: Code[20];
        JournalTemplateName: Code[20];
        JournalBatchName: Code[20];
        DocumentNo: Code[20];
        Description: Text[50];
        Text007: Label '-Principal Overpayment';
        SourceCodeSetup: Record "Source Code Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text008: Label 'Loan Recovery-';
        Text009: Label 'Refund-';
        Text010: Label '-Excise Duty';
        Text011: Label '-Withholding Tax';
        Text012: Label '-Commission';
        Text013: Label '-Gross Amount';
        Text014: Label '-Net Amount';
        Text015: Label '-Shares Topup';
        Text016: Label '-Charges';
        Text017: Label 'Reversal-';
        Error000: Label 'You cannot boost shares from %1 account';
        SMTPSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        Text018: Label 'Exit Fees posted successfully';
        Text019: Label 'Remittance for %1 %2';
        Text020: Label 'Loan Product Recovery-';
        Member: Record "Member";
        LoanApplication: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";

    procedure GetFileSize(FileName: Text[1024]) FileSize: Integer
    var
        MyFile: File;
    begin
        BEGIN
            /*  MyFile.Open(FileName) ;
             FileSize := MyFile.Len() ;
             MyFile.Close(); */
        END;
        EXIT(ROUND(FileSize / 1000, 1, '>'));
    end;

    procedure AddAttachment(RecordID: Text[50]; DocumentNo: Code[20]; FileName: Text[200])
    var
        CBSAttachment: Record "CBS Attachment";
        CBSAttachment2: Record "CBS Attachment";
        EntryNo: Integer;
    begin
        IF CBSAttachment2.FINDLAST THEN
            EntryNo := CBSAttachment2."Entry No."
        ELSE
            EntryNo := 0;
        CBSAttachment."Entry No." := EntryNo + 1;
        CBSAttachment.RecordID := RecordID;
        CBSAttachment."Document No." := DocumentNo;
        CBSAttachment."File Name" := FileName;
        CBSAttachment.Attachment.IMPORT(FileName);
        CBSAttachment.INSERT;
    end;

    procedure CalculateRepaymentSchedule(LoanNo: Code[10]; LoanAmount: Decimal)
    var
        LoanApplication: Record "Loan Application";
        NoOfInstallments: Integer;
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        ApprovedLoanAmount: Decimal;
        ConstantAmount: Decimal;
        LastRepaymentDate: Date;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
    begin
        IF LoanApplication.GET(LoanNo) THEN BEGIN
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
            LoanRepaymentSchedule.DELETEALL;

            EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
            i := 1;
            LastRepaymentDate := CALCDATE(FORMAT(LoanApplication."Repayment Period") + 'M', LoanApplication."Next Due Date");
            NextRepaymentDate := LoanApplication."Next Due Date";
            NoOfInstallments := GetNoofInstallments(LoanApplication."No.", NextRepaymentDate, LastRepaymentDate);
            ApprovedLoanAmount := LoanAmount;
            IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Straight Line" THEN BEGIN
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                InterestAmount := ApprovedLoanAmount * (LoanApplication."Interest Rate" / 12 * LoanApplication."Repayment Period" / 100);
                FOR i := 1 TO NoOfInstallments DO BEGIN
                    CreateRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;

            IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::"Reducing Balance" THEN BEGIN
                PrincipalAmount := ApprovedLoanAmount / NoOfInstallments;
                FOR i := 1 TO NoOfInstallments DO BEGIN
                    InterestAmount := ApprovedLoanAmount * (LoanApplication."Interest Rate" / 12 * LoanApplication."Repayment Period" / 100);
                    CreateRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;

            IF LoanApplication."Repayment Method" = LoanApplication."Repayment Method"::Amortization THEN BEGIN
                ConstantAmount := ApprovedLoanAmount *
                                ((LoanApplication."Interest Rate" / NoOfInstallments / 100) *
                                (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments / 100), NoOfInstallments))) /
                                (POWER(1 + (LoanApplication."Interest Rate" / NoOfInstallments) / 100, NoOfInstallments) - 1);
                FOR i := 1 TO NoOfInstallments DO BEGIN
                    InterestAmount := (ApprovedLoanAmount) * (LoanApplication."Interest Rate" / 12 * LoanApplication."Repayment Period" / 100);
                    PrincipalAmount := ConstantAmount - InterestAmount;
                    CreateRepaymentSchedule(LoanApplication, NextRepaymentDate, ApprovedLoanAmount, PrincipalAmount, InterestAmount / NoOfInstallments, i);
                    ApprovedLoanAmount -= PrincipalAmount;
                    NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                END;
            END;
        END;
    end;

    local procedure CreateRepaymentSchedule(LoanApplication: Record "Loan Application"; RepaymentDate: Date; LoanBalance: Decimal; PrincipalAmount: Decimal; InterestAmount: Decimal; InstallmentNo: Integer)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        LoanRepaymentSchedule.INIT;
        LoanRepaymentSchedule."Loan No." := LoanApplication."No.";
        LoanRepaymentSchedule."Repayment Date" := RepaymentDate;
        LoanRepaymentSchedule."Member No." := LoanApplication."Member No.";
        LoanRepaymentSchedule."Member Name" := LoanApplication."Member Name";
        LoanRepaymentSchedule."Instalment No." := InstallmentNo;
        LoanRepaymentSchedule."Loan Amount" := LoanBalance;
        LoanRepaymentSchedule."Principal Installment" := PrincipalAmount;
        LoanRepaymentSchedule."Interest Installment" := InterestAmount;
        LoanRepaymentSchedule."Total Installment" := PrincipalAmount + InterestAmount;
        LoanRepaymentSchedule.INSERT;
    end;

    local procedure GetNoofInstallments(LoanNo: Code[20]; StartDate: Date; EndDate: Date): Integer
    var
        LoanApplication: Record "Loan Application";
        j: Integer;
        LastRepaymentDate: Date;
        NextRepaymentDate: Date;
        DateFormula: DateFormula;
    begin
        j := 0;
        IF LoanApplication.GET(LoanNo) THEN BEGIN
            EVALUATE(DateFormula, GetRepaymentFrequencyDateFormula(LoanApplication));
            LastRepaymentDate := EndDate;
            NextRepaymentDate := StartDate;
            WHILE NextRepaymentDate <= LastRepaymentDate DO BEGIN
                NextRepaymentDate := CALCDATE(DateFormula, NextRepaymentDate);
                j += 1;
            END;
        END;
        EXIT(j - 1);
    end;

    procedure GetRepaymentFrequencyDateFormula(LoanApplication: Record "Loan Application") DateFormula: Code[20]
    var
        LoanProductType: Record "Loan Product Type";
    begin
        IF LoanProductType.GET(LoanApplication."Loan Product Type") THEN BEGIN
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Annually THEN
                DateFormula := '1Y';
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Quarterly THEN
                DateFormula := '3M';
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Monthly THEN
                DateFormula := '1M';
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Fortnightly THEN
                DateFormula := '2W';
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Weekly THEN
                DateFormula := '1W';
            IF LoanProductType."Repayment Frequency" = LoanProductType."Repayment Frequency"::Daily THEN
                DateFormula := '1D';
        END;
        EXIT(DateFormula);
    end;

    procedure PostLoan(var LoanApplication: Record "Loan Application") ok: Boolean
    var
        GenJournalLine: Record "Gen. Journal Line";
        LoanProductCharge: Record "Loan Product Charge";
        RecRef: RecordRef;
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
        DisbursalAmount: Decimal;
        Text000: Label 'Loan Refinancing-';
        LoanProductType: Record "Loan Product Type";
    begin
        ok := FALSE;
        WITH LoanApplication DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Total Refinanced Amount");
            DisbursalAmount := "Approved Amount" - "Total Refinanced Amount";

            CreateLoanAccount(LoanApplication);
            ClearJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name");
            CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Customer, "No.", Description, "Approved Amount", SourceCodeSetup.Loan, "Global Dimension 1 Code");
            CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Vendor, "FOSA Account No.", Description, -DisbursalAmount, SourceCodeSetup.Loan, "Global Dimension 1 Code");

            IF "Refinance Another Loan" THEN BEGIN
                LoanRefinancingEntry.RESET;
                LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
                LoanRefinancingEntry.SETRANGE(Select, TRUE);
                IF LoanRefinancingEntry.FINDSET THEN BEGIN
                    REPEAT
                        CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                      LoanRefinancingEntry."Loan To Refinance", Text000 + "No.", -LoanRefinancingEntry."Outstanding Balance", SourceCodeSetup.Loan, "Global Dimension 1 Code");
                    UNTIL LoanRefinancingEntry.NEXT = 0;
                END;
            END;

            LoanProductCharge.RESET;
            LoanProductCharge.SETRANGE("Loan Product Type", "Loan Product Type");
            IF LoanProductCharge.FINDSET THEN BEGIN
                REPEAT
                    IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"% of Loan" THEN BEGIN
                        CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      "FOSA Account No.", LoanProductCharge.Description, ((ABS(LoanProductCharge.Value) * "Approved Amount") / 100), LoanProductCharge."Source Code", "Global Dimension 1 Code");
                        CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      LoanProductCharge."Account No", LoanProductCharge.Description, -((ABS(LoanProductCharge.Value) * "Approved Amount") / 100), LoanProductCharge."Source Code", "Global Dimension 1 Code");
                    END;
                    IF LoanProductCharge."Calculation Mode" = LoanProductCharge."Calculation Mode"::"Flat Amount" THEN BEGIN
                        CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "FOSA Account No.", LoanProductCharge.Description, ABS(LoanProductCharge.Value), LoanProductCharge."Source Code", "Global Dimension 1 Code");
                        CreateJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::"G/L Account", LoanProductCharge."Account No", LoanProductCharge.Description, -(ABS(LoanProductCharge.Value)), LoanProductCharge."Source Code", "Global Dimension 1 Code");
                    END;
                UNTIL LoanProductCharge.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Loan Disbursal Template Name", CBSSetup."Loan Disbursal Batch Name") THEN BEGIN
                Posted := TRUE;
                "Disbursed By" := USERID;
                "Disbursal Date" := TODAY;
                "Disbursal Time" := TIME;
                "Created By" := USERID;
                GetHostInfo(HostName, HostIP, HostMac);
                "Disbursed By Host Name" := HostName;
                "Disbursed By Host IP" := HostIP;
                "Disbursed By Host MAC" := HostMac;

                IF MODIFY THEN BEGIN
                    CalculateRepaymentSchedule("No.", "Approved Amount");
                    RecRef.GetTable(LoanApplication);
                    SendNotification(RecRef, "Approved Amount", "Approved Amount");
                END;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN BEGIN
                    IF Customer.GET("No.") THEN
                        Customer.DELETE;
                    ERROR(GETLASTERRORTEXT);
                END;
            END;
        END;
        ok := TRUE;
        EXIT(ok);
    end;

    procedure CreateJournal(JournalTemplateName: Code[20]; JournalBatchName: Code[20]; DocumentNo: Code[20]; ExternalDocNo: Code[20]; PostingDate: Date; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; AccountNo: Code[20]; Description: Text[100]; Amount: Decimal; SourceCode: Code[20]; GlobalDimensionCode: Code[20]): Boolean
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
        GenJournalLine."Line No." := GetLastJournalLineNo(JournalTemplateName, JournalBatchName) + 10000;
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


    procedure GetSavingsAccount(var MemberNo: Code[20]) SavingsAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::Savings);
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                SavingsAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetShareCapitalAccount(var MemberNo: Code[20]) ShareCapitalAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::"Share Capital");
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                ShareCapitalAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetDepositAccount(var MemberNo: Code[20]) DepositAccount: Code[20]
    var
        Customer: Record "Customer";
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Type, AccountType.Type::Deposit);
        IF AccountType.FINDSET THEN BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Account Type", AccountType.Code);
            Vendor.SETRANGE("Member No.", MemberNo);
            IF Vendor.FINDSET THEN BEGIN
                Vendor.Blocked := Vendor.Blocked::" ";
                Vendor.MODIFY;
                DepositAccount := Vendor."No.";
            END;
        END;
    end;

    procedure GetDimension(var MemberNo: Code[20]) DimensionCode: Code[20]
    var
        Customer: Record "Customer";
    begin
        DimensionCode := '';
        Member.GET(MemberNo);
        DimensionCode := Member."Global Dimension 1 Code";
    end;

    local procedure GetLastJournalLineNo(JournalTemplateName: Code[20]; JournalBatchName: Code[20]) LineNo: Integer
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

    procedure CreateLoanAccount(LoanApplication: Record "Loan Application")
    begin
        WITH LoanApplication DO BEGIN
            IF NOT Customer.GET("No.") THEN BEGIN
                Customer.INIT;
                Customer."No." := "No.";
                Customer.Name := Description;
                Customer."Customer Posting Group" := "Loan Product Type";
                Customer."Member No." := "Member No.";
                //Customer."Member Name":="Member Name";
                Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
                Customer.Status := Customer.Status::Active;
                // Customer."Customer Type":=Customer."Customer Type"::Loan;
                Customer.INSERT;
            END;
        END;
    end;

    procedure GetHostInfo(var HName: Code[20]; var HIP: Code[20]; var HMac: Code[20])
    var
        Dns: DotNet Dns;
        GetIPMac2: DotNet GetIPMac;
        IPHostEntry: DotNet IPHostEntry;
        IPAddress: DotNet IPAddress;
    begin
        HName := Dns.GetHostName();
        Clear(GetIPMac2);
        GetIPMac2 := GetIPMac2.GetIPMac();
        HIP := GetIPMac2.GetIP(HName);
        HMac := GetIPMac2.GetMac();
    end;

    procedure CapitalizeInterest(var LoanApplication: Record "Loan Application")
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanProductType: Record "Loan Product Type";
        OriginalPostingGroup: Code[20];
    begin
        WITH LoanApplication DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            OriginalPostingGroup := "Loan Product Type";
            LoanProductType.GET("Loan Product Type");
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
            IF LoanRepaymentSchedule.FINDSET THEN BEGIN
                IF LoanProductType."Interest Cap. Frequency" = LoanProductType."Interest Cap. Frequency"::"On Due Date" THEN
                    LoanRepaymentSchedule.SETRANGE("Repayment Date", "Next Due Date");

                IF LoanProductType."Interest Cap. Frequency" = LoanProductType."Interest Cap. Frequency"::"On Every" THEN BEGIN
                    REPEAT
                        LoanProductType.TESTFIELD("Interest Cap. Day");
                        IF (LoanProductType."Interest Cap. Day" = DATE2DMY(LoanRepaymentSchedule."Repayment Date", 1)) AND
                           (DATE2DMY(TODAY, 2) = DATE2DMY(LoanRepaymentSchedule."Repayment Date", 2)) AND
                           (DATE2DMY(TODAY, 3) = DATE2DMY(LoanRepaymentSchedule."Repayment Date", 3))
                        THEN
                            LoanRepaymentSchedule.MARK(TRUE);
                    UNTIL LoanRepaymentSchedule.NEXT = 0;
                    LoanRepaymentSchedule.MARKEDONLY;
                    LoanRepaymentSchedule.COPY(LoanRepaymentSchedule);
                END;
            END;
            IF LoanRepaymentSchedule.FINDFIRST THEN BEGIN
                IF LoanProductType."Interest Realization Mode" = LoanProductType."Interest Realization Mode"::"On Capitalization" THEN BEGIN
                    CreateJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                  "No.", Text000 + "No.", LoanRepaymentSchedule."Interest Installment", SourceCodeSetup."Interest Due", "Global Dimension 1 Code");
                    CreateJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                  LoanProductType."Interest Income Account", Text000 + "No.", -LoanRepaymentSchedule."Interest Installment", SourceCodeSetup."Interest Due", "Global Dimension 1 Code");
                    ChangeCustomerPostingGroup("No.", OriginalPostingGroup);
                END;
                IF LoanProductType."Interest Realization Mode" = LoanProductType."Interest Realization Mode"::"On Payment" THEN BEGIN
                    ChangeCustomerPostingGroup("No.", LoanProductType."Interest Accrued Account");
                    CreateJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                  "No.", Text000 + "No.", LoanRepaymentSchedule."Interest Installment", SourceCodeSetup."Interest Due", "Global Dimension 1 Code");
                    CreateJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                  LoanProductType."Interest Control Account", Text000 + "No.", -LoanRepaymentSchedule."Interest Installment", SourceCodeSetup."Interest Due", "Global Dimension 1 Code");
                    ChangeCustomerPostingGroup("No.", OriginalPostingGroup);
                END;
            END;
        END;
    end;

    local procedure ChangeCustomerPostingGroup(LoanNo: Code[20]; NewPostingGroup: Code[20])
    var
        Customer: Record "Customer";
    begin
        IF Customer.GET(LoanNo) THEN BEGIN
            Customer."Customer Posting Group" := NewPostingGroup;
            Customer.MODIFY;
        END;
    end;

    procedure PostStandingOrder(var StandingOrder: Record "Standing Order")
    var
        StandingOrderSetup: Record "Standing Order Setup";
        StandingOrderLine: Record "Standing Order Line";
        TotalDeductedAmount: array[4] of Decimal;
        ChargeAmount: array[4] of Decimal;
        AccountBalance: Decimal;
        PerHeaderLine: array[4] of Boolean;
        SMSText: BigText;
        EmailText: Text;
        RecRef: RecordRef;
    begin
        WITH StandingOrder DO BEGIN

            CBSSetup.GET;
            SourceCodeSetup.GET;
            StandingOrderSetup.GET;
            SMTPSetup.GET;
            CALCFIELDS("Total Amount");
            i := 0;
            TotalDeductedAmount[2] := 0;
            AccountBalance := GetAccountBalance(0, "Source Account No.");
            GetAdditionalPostingInfo('', CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", Description);
            IF StandingOrderSetup."Charge Transaction" THEN BEGIN
                IF StandingOrderSetup."Charge Option" = StandingOrderSetup."Charge Option"::"Per Header" THEN BEGIN
                    ChargeAmount[1] := 0;
                    GetStandingOrderCharges(StandingOrderSetup, "Total Amount", 0, ChargeAmount[1]);
                    IF AccountBalance >= ChargeAmount[1] THEN BEGIN
                        ChargeAmount[1] := ChargeAmount[1];
                        AccountBalance -= ChargeAmount[1];
                    END ELSE BEGIN
                        IF StandingOrderSetup."Allow Partial Deduction" THEN BEGIN
                            ChargeAmount[1] := AccountBalance;
                            AccountBalance := 0;
                        END ELSE BEGIN
                            ChargeAmount[1] := 0;
                            AccountBalance := AccountBalance;
                            ;
                        END;
                        IF StandingOrderSetup."Allow Overdrawing" THEN BEGIN
                            ChargeAmount[1] := ChargeAmount[1];
                            AccountBalance := AccountBalance;
                        END ELSE BEGIN

                        END;
                    END;
                    IF AccountBalance < "Total Amount" THEN BEGIN
                        IF StandingOrderSetup."Charge Penalty" THEN BEGIN
                            IF StandingOrderSetup."Penalty Option" = StandingOrderSetup."Penalty Option"::"Per Header" THEN BEGIN
                                GetStandingOrderCharges(StandingOrderSetup, "Total Amount", 1, ChargeAmount[2]);
                                IF AccountBalance >= ChargeAmount[2] THEN BEGIN
                                    ChargeAmount[2] := ChargeAmount[2];
                                    AccountBalance -= ChargeAmount[2];
                                END ELSE BEGIN
                                    IF StandingOrderSetup."Allow Partial Deduction" THEN BEGIN
                                        ChargeAmount[2] := AccountBalance;
                                        AccountBalance := 0;
                                    END ELSE BEGIN
                                        ChargeAmount[2] := 0;
                                        AccountBalance := AccountBalance;
                                        ;
                                    END;
                                    IF StandingOrderSetup."Allow Overdrawing" THEN BEGIN
                                        ChargeAmount[2] := ChargeAmount[2];
                                        AccountBalance := AccountBalance;
                                    END ELSE BEGIN

                                    END;
                                END;
                            END;
                        END;
                    END;
                END;
            END;

            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                  GenJournalLine."Account Type"::"G/L Account", StandingOrderSetup."Transaction G/L Account", Description + Text005, -ChargeAmount[1], SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                          GenJournalLine."Account Type"::"G/L Account", StandingOrderSetup."Penalty G/L Account", Description + Text006, -ChargeAmount[2], SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
            TotalDeductedAmount[2] += ChargeAmount[1] + ChargeAmount[2];

            StandingOrderLine.RESET;
            StandingOrderLine.SETRANGE("Document No.", "No.");
            IF StandingOrderLine.FINDSET THEN BEGIN
                IF StandingOrderSetup."Use Priority Posting" THEN
                    StandingOrderLine.SETCURRENTKEY(Priority);
                REPEAT
                    //GetStandingOrderCharges
                    IF StandingOrderSetup."Charge Transaction" THEN BEGIN
                        IF StandingOrderSetup."Charge Option" = StandingOrderSetup."Charge Option"::"Per Line" THEN BEGIN
                            ChargeAmount[1] := 0;
                            GetStandingOrderCharges(StandingOrderSetup, StandingOrderLine."Line Amount", 0, ChargeAmount[1]);
                            IF AccountBalance >= ChargeAmount[1] THEN BEGIN
                                ChargeAmount[1] := ChargeAmount[1];
                                AccountBalance -= ChargeAmount[1];
                            END ELSE BEGIN
                                IF StandingOrderSetup."Allow Partial Deduction" THEN BEGIN
                                    ChargeAmount[1] := AccountBalance;
                                    AccountBalance := 0;
                                END ELSE BEGIN
                                    ChargeAmount[1] := 0;
                                    AccountBalance := AccountBalance;
                                    ;
                                END;
                                IF StandingOrderSetup."Allow Overdrawing" THEN BEGIN
                                    ChargeAmount[1] := ChargeAmount[1];
                                    AccountBalance := AccountBalance;
                                END ELSE BEGIN

                                END;
                            END;
                            IF AccountBalance < StandingOrderLine."Line Amount" THEN BEGIN
                                IF StandingOrderSetup."Charge Penalty" THEN BEGIN
                                    IF StandingOrderSetup."Penalty Option" = StandingOrderSetup."Penalty Option"::"Per Line" THEN BEGIN
                                        GetStandingOrderCharges(StandingOrderSetup, StandingOrderLine."Line Amount", 1, ChargeAmount[2]);
                                        IF AccountBalance >= ChargeAmount[2] THEN BEGIN
                                            ChargeAmount[2] := ChargeAmount[2];
                                            AccountBalance -= ChargeAmount[2];
                                        END ELSE BEGIN
                                            IF StandingOrderSetup."Allow Partial Deduction" THEN BEGIN
                                                ChargeAmount[2] := AccountBalance;
                                                AccountBalance := 0;
                                            END ELSE BEGIN
                                                ChargeAmount[2] := 0;
                                                AccountBalance := AccountBalance;
                                                ;
                                            END;
                                            IF StandingOrderSetup."Allow Overdrawing" THEN BEGIN
                                                ChargeAmount[2] := ChargeAmount[2];
                                                AccountBalance := AccountBalance;
                                            END ELSE BEGIN

                                            END;
                                        END;
                                    END;
                                END;
                            END;
                        END;
                    END;
                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"G/L Account", StandingOrderSetup."Transaction G/L Account", Description + Text005, -ChargeAmount[1], SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                  GenJournalLine."Account Type"::"G/L Account", StandingOrderSetup."Penalty G/L Account", Description + Text006, -ChargeAmount[2], SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                    TotalDeductedAmount[2] += ChargeAmount[1] + ChargeAmount[2];

                    //CASE B
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        //MESSAGE('CASE B');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, StandingOrderLine."Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            ;
                            TotalDeductedAmount[2] += AccountBalance;
                        END;
                    END;
                    //CASE C
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE C');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE D
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        //MESSAGE('CASE D');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END ELSE BEGIN
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                                IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE E
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        //MESSAGE('CASE E');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            ;
                            TotalDeductedAmount[2] += AccountBalance;
                        END;
                    END;

                    //CASE F
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        //MESSAGE('CASE F');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF "Member No." <> StandingOrderLine."Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE G
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        //MESSAGE('CASE G');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                    ;
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF "Member No." <> StandingOrderLine."Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                            GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE H
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE H');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END
                        END;
                    END;

                    //CASE I
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE I');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, StandingOrderLine."Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            ;
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE J
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE J');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END
                    END;

                    //CASE K
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE K');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE L
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE L');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            ;
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE M
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE M');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            ;
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE N
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE N');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE O
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE O');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                CheckApplicationAreaArrears(2, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE P
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                       AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE P');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE Q
                    IF ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                       ((AccountBalance < StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                        AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE Q');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF StandingOrderLine."Member No." <> "Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, "Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                    TotalDeductedAmount[1] := 0;
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;

                    //CASE R
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE R');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                CheckApplicationAreaArrears(2, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                            GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE S
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE S');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                            GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE T
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (NOT StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE T');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF StandingOrderLine."Member No." <> "Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;

                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE U
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE U');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END
                    END;

                    //CASE V
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (NOT StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE V');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE W
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (NOT StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE W');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1])
                                ELSE
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                AccountBalance -= TotalDeductedAmount[1];
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE X
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (NOT StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE X');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                IF AccountBalance > StandingOrderLine."Line Amount" THEN BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance -= StandingOrderLine."Line Amount";
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                                  GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                    AccountBalance := 0;
                                    TotalDeductedAmount[2] += AccountBalance;
                                END;
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF StandingOrderLine."Member No." <> "Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 0, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;

                                TotalDeductedAmount[1] := 0;
                                IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                                END ELSE BEGIN
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, AccountBalance, TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            IF AccountBalance >= StandingOrderLine."Line Amount" THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                ;
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END ELSE BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -AccountBalance, SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                                AccountBalance := 0;
                                TotalDeductedAmount[2] += AccountBalance;
                            END;
                        END;
                    END;

                    //CASE Y
                    IF ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                      AND (NOT StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears")) OR

                    ((AccountBalance >= StandingOrderLine."Line Amount") AND (StandingOrderSetup."Charge Penalty") AND (StandingOrderSetup."Recover Source Arrears")
                    AND (StandingOrderSetup."Allow Partial Deduction") AND (StandingOrderSetup."Allow Overdrawing") AND (StandingOrderSetup."Recover Destination Arrears"))
                    THEN BEGIN
                        MESSAGE('CASE Y');
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                            TotalDeductedAmount[1] := 0;
                            CheckApplicationAreaArrears(1, "Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                            AccountBalance -= TotalDeductedAmount[1];
                            TotalDeductedAmount[2] += TotalDeductedAmount[1];

                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                              GenJournalLine."Account Type"::Vendor, StandingOrderLine."Account No.", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode(StandingOrderLine."Member No."));
                                AccountBalance -= StandingOrderLine."Line Amount";
                                TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                            END;
                            IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN BEGIN
                                IF StandingOrderLine."Member No." <> "Member No." THEN BEGIN
                                    TotalDeductedAmount[1] := 0;
                                    CheckApplicationAreaArrears(2, StandingOrderLine."Member No.", 1, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];

                                    TotalDeductedAmount[1] := 0;
                                    DeductInstallmentDue(StandingOrderLine."Account No.", TODAY, StandingOrderLine."Line Amount", TotalDeductedAmount[1]);
                                    AccountBalance -= TotalDeductedAmount[1];
                                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                                END;
                            END;
                        END;
                        IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                            StandingOrderSetup.TESTFIELD("Bank Control Account");
                            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", StandingOrderLine."Document No.", TODAY,
                                          GenJournalLine."Account Type"::"Bank Account", StandingOrderSetup."Bank Control Account", Description, -StandingOrderLine."Line Amount", SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
                            AccountBalance -= StandingOrderLine."Line Amount";
                            TotalDeductedAmount[2] += StandingOrderLine."Line Amount";
                        END;
                    END;
                UNTIL StandingOrderLine.NEXT = 0;
            END;

            //Balancing Account
            CreateJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Vendor, "Source Account No.", Description, TotalDeductedAmount[2], SOURCECODESETUP."STANDING ORDER", GetBranchCode("Member No."));
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name") THEN BEGIN
                //"Next Run Date":=CALCDATE(Frequency,"Next Run Date");
                MODIFY;

                CLEAR(RecRef);
                RecRef.GETTABLE(StandingOrder);
                SendNotification(RecRef, TotalDeductedAmount[2], TotalDeductedAmount[2]);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;

        END;
    end;

    local procedure CreateSTOEntry(var StandingOrder: Record "Standing Order"; Amount: Decimal)
    var
        StandingOrderEntry: Record "Standing Order Entry";
    begin
        WITH StandingOrder DO BEGIN
            StandingOrderEntry.INIT;
            StandingOrderEntry."Entry No." := StandingOrderEntry."Entry No." + 1;
            StandingOrderEntry."STO No." := "No.";
            StandingOrderEntry."Member No." := "Member No.";
            StandingOrderEntry."Member Name" := "Member Name";
            StandingOrderEntry."Account No." := "Source Account No.";
            StandingOrderEntry."Account Name" := "Source Account Name";
            StandingOrderEntry.Amount := Amount;
            StandingOrderEntry.INSERT;
        END;
    end;

    local procedure GetStandingOrderCharges(StandingOrderSetup: Record "Standing Order Setup"; AmountToDeduct: Decimal; ChargeType: Integer; var ChargeAmount: Decimal): Decimal
    begin
        WITH StandingOrderSetup DO BEGIN
            CASE ChargeType OF
                0:
                    BEGIN
                        IF "Charge Transaction" THEN BEGIN
                            IF "Transaction Calculation Method" = "Transaction Calculation Method"::"%" THEN
                                ChargeAmount := "Transaction %" / 100 * AmountToDeduct;
                            IF "Transaction Calculation Method" = "Transaction Calculation Method"::"Flat Amount" THEN
                                ChargeAmount := "Transaction Flat Amount";
                        END ELSE
                            ChargeAmount := 0;
                    END;
                1:
                    BEGIN
                        IF "Charge Penalty" THEN BEGIN
                            IF "Penalty Calculation Method" = "Penalty Calculation Method"::"%" THEN
                                ChargeAmount := "Penalty %" / 100 * AmountToDeduct;
                            IF "Penalty Calculation Method" = "Penalty Calculation Method"::"Flat Amount" THEN
                                ChargeAmount := "Penalty Flat Amount";
                        END ELSE
                            ChargeAmount := 0;
                    END;
            END;
        END;
    end;

    procedure CalculateLoanArrears(LoanNo: Code[20]; StartDate: Date; EndDate: Date; var PArrears: Decimal; var IArrears: Decimal; var POverpayment: Decimal; var IOverpayment: Decimal)
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        InstallmentDue: array[4] of Decimal;
        InstallmentPaid: array[4] of Decimal;
    begin
        InstallmentDue[1] := 0;
        InstallmentDue[2] := 0;
        InstallmentPaid[1] := 0;
        InstallmentPaid[2] := 0;
        PArrears := 0;
        IArrears := 0;
        POverpayment := 0;
        IOverpayment := 0;
        SourceCodeSetup.GET;
        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.SETRANGE("Repayment Date", StartDate, EndDate);
        IF LoanRepaymentSchedule.FINDSET THEN BEGIN
            REPEAT
                InstallmentDue[1] += LoanRepaymentSchedule."Principal Installment";
                InstallmentDue[2] += LoanRepaymentSchedule."Interest Installment";
            UNTIL LoanRepaymentSchedule.NEXT = 0;
        END;

        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", StartDate, EndDate);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS("Amount (LCY)");
                IF CustLedgerEntry."Source Code" = SourceCodeSetup."Principal Paid" THEN
                    InstallmentPaid[1] += CustLedgerEntry."Amount (LCY)";
                IF CustLedgerEntry."Source Code" = SourceCodeSetup."Interest Paid" THEN
                    InstallmentPaid[2] += CustLedgerEntry."Amount (LCY)";
            UNTIL CustLedgerEntry.NEXT = 0;
        END;
        IF InstallmentDue[1] > ABS(InstallmentPaid[1]) THEN BEGIN
            PArrears := InstallmentDue[1] - ABS(InstallmentPaid[1]);
            POverpayment := 0;
        END ELSE BEGIN
            POverpayment := ABS(InstallmentPaid[1]) - InstallmentDue[1];
            PArrears := 0;
        END;
        IF InstallmentDue[2] > ABS(InstallmentPaid[2]) THEN BEGIN
            IArrears := InstallmentDue[2] - ABS(InstallmentPaid[2]);
            IOverpayment := 0;
        END ELSE BEGIN
            IOverpayment := ABS(InstallmentPaid[2]) - InstallmentDue[2];
            IArrears := 0;
        END;
    end;

    local procedure CheckApplicationAreaArrears(ApplicationArea: Integer; MemberNo: Code[20]; DeductionType: Integer; var DeductionAmount: Decimal; var TotalDeductedArrears: Decimal)
    var
        LoanProductType: Record "Loan Product Type";
        LoanApplication: Record "Loan Application";
    begin
        TotalDeductedArrears := 0;
        LoanApplication.RESET;
        LoanApplication.SETRANGE("Member No.", MemberNo);
        IF LoanApplication.FINDSET THEN BEGIN
            REPEAT
                IF IsLoanProductAvailable(ApplicationArea, LoanApplication."Loan Product Type") THEN BEGIN
                    DeductLoanArrears(LoanApplication."No.", DeductionType, DeductionAmount, TotalDeductedArrears);
                END;
            UNTIL LoanApplication.NEXT = 0;
        END;
    end;

    local procedure DeductLoanArrears(LoanNo: Code[20]; DeductionType: Integer; var DeductionAmount: Decimal; var TotalDeductedArrears: Decimal)
    var
        LoanProductType: Record "Loan Product Type";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        StandingOrderSetup: Record "Standing Order Setup";
        RemainingAmount: array[4] of Decimal;
    begin
        SourceCodeSetup.GET;
        IF Customer.GET(LoanNo) THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            ArrearsAmount[1] := 0;
            ArrearsAmount[2] := 0;
            CalculateLoanArrears(Customer."No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);

            CASE DeductionType OF
                0:
                    BEGIN  //Partial deduction
                        IF DeductionAmount > 0 THEN BEGIN
                            //IIA
                            IF DeductionAmount >= ArrearsAmount[2] THEN BEGIN
                                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                              Customer."No.", Description + Text002, -ArrearsAmount[2], SourceCodeSetup."Interest Paid", GetBranchCode(Customer."Member No."));
                                RemainingAmount[1] := DeductionAmount - ArrearsAmount[2];
                                TotalDeductedArrears += ArrearsAmount[2];
                            END ELSE BEGIN
                                CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                            Customer."No.", Description + Text002, -DeductionAmount, SourceCodeSetup."Interest Paid", GetBranchCode(Customer."Member No."));
                                RemainingAmount[1] := 0;
                                TotalDeductedArrears += DeductionAmount;
                            END;
                            //PIA
                            IF RemainingAmount[1] > 0 THEN BEGIN
                                IF RemainingAmount[1] >= ArrearsAmount[1] THEN BEGIN
                                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                                  Customer."No.", Description + Text001, -ArrearsAmount[1], SourceCodeSetup."Principal Paid", GetBranchCode(Customer."Member No."));
                                    RemainingAmount[2] := RemainingAmount[1] - ArrearsAmount[1];
                                    TotalDeductedArrears += ArrearsAmount[1];
                                END ELSE BEGIN
                                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                                Customer."No.", Description + Text001, -RemainingAmount[1], SourceCodeSetup."Principal Paid", GetBranchCode(Customer."Member No."));
                                    RemainingAmount[2] := 0;
                                    TotalDeductedArrears += RemainingAmount[1];
                                END;
                            END;
                            DeductionAmount := RemainingAmount[2];
                        END;
                    END;
                1:
                    BEGIN  //Full Deduction
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                      Customer."No.", Description + Text002, -ArrearsAmount[2], SourceCodeSetup."Interest Paid", GetBranchCode(Customer."Member No."));
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                      Customer."No.", Description + Text001, -ArrearsAmount[1], SourceCodeSetup."Interest Paid", GetBranchCode(Customer."Member No."));
                        TotalDeductedArrears += ArrearsAmount[1] + ArrearsAmount[2];
                    END;
            END;//CASE
        END;
    end;

    local procedure DeductInstallmentDue(LoanNo: Code[20]; RepaymentDate: Date; var AmountToPay: Decimal; var TotalDeductedInstallment: Decimal)
    var
        LoanProductType: Record "Loan Product Type";
        InstallmentDue: array[4] of Decimal;
        RemainingAmount: array[4] of Decimal;
    begin
        IF Customer.GET(LoanNo) THEN BEGIN
            TotalDeductedInstallment := 0;

            CBSSetup.GET;
            GetInstallmentDue(LoanNo, RepaymentDate, InstallmentDue[1], InstallmentDue[2]);

            IF AmountToPay > 0 THEN BEGIN
                //Interest
                IF AmountToPay >= InstallmentDue[2] THEN BEGIN
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                  LoanNo, Description + Text004, -InstallmentDue[2], SourceCode, GetBranchCode(Customer."Member No."));
                    RemainingAmount[1] := AmountToPay - InstallmentDue[2];
                    TotalDeductedInstallment += InstallmentDue[2];
                END ELSE BEGIN
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                  LoanNo, Description + Text004, -AmountToPay, SourceCodeSetup."Interest Paid", GetBranchCode(Customer."Member No."));
                    RemainingAmount[1] := 0;
                    TotalDeductedInstallment += AmountToPay;
                END;

                //Principal
                IF RemainingAmount[1] > 0 THEN BEGIN
                    IF RemainingAmount[1] >= InstallmentDue[1] THEN BEGIN
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                                             LoanNo, Description + Text003, -InstallmentDue[1], SourceCodeSetup."Principal Paid", GetBranchCode(Customer."Member No."));
                        RemainingAmount[2] := RemainingAmount[1] - InstallmentDue[1];
                        TotalDeductedInstallment += InstallmentDue[1];
                    END ELSE BEGIN
                        CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                    LoanNo, Description + Text003, -RemainingAmount[1], SourceCodeSetup."Principal Paid", GetBranchCode(Customer."Member No."));
                        RemainingAmount[2] := 0;
                        TotalDeductedInstallment += RemainingAmount[1];
                    END;
                END;

                //Principal Overpayment
                IF RemainingAmount[2] > 0 THEN BEGIN
                    CreateJournal(JournalTemplateName, JournalBatchName, DocumentNo, DocumentNo, TODAY, GenJournalLine."Account Type"::Customer,
                                  LoanNo, Description + Text007, -RemainingAmount[2], SourceCodeSetup."Principal Paid", GetBranchCode(Customer."Member No."));
                    RemainingAmount[3] := 0;
                    TotalDeductedInstallment += RemainingAmount[2]
                END;
            END;
        END;
    end;

    local procedure GetInstallmentDue(LoanNo: Code[20]; RepaymentDate: Date; var PDue: Decimal; var IDue: Decimal)
    var
        InstallmentDue: array[4] of Decimal;
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        InstallmentDue[1] := 0;
        InstallmentDue[2] := 0;

        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.SETRANGE("Repayment Date", RepaymentDate);
        IF LoanRepaymentSchedule.FINDFIRST THEN BEGIN
            InstallmentDue[1] := LoanRepaymentSchedule."Principal Installment";
            InstallmentDue[2] := LoanRepaymentSchedule."Interest Installment";
        END;

        PDue := InstallmentDue[1];
        IDue := InstallmentDue[2];
    end;

    local procedure GetAdditionalPostingInfo(SCode: Code[20]; JTemplateName: Code[20]; JBatchName: Code[20]; DocNo: Code[20]; Desc: Text[50])
    begin
        SourceCode := SCode;
        JournalTemplateName := JTemplateName;
        JournalBatchName := JBatchName;
        DocumentNo := DocNo;
        Description := Desc;
    end;

    procedure GetAccountBalance(AccountCategory: Option Vendor,Customer,"Bank Account"; AccountNo: Code[20]): Decimal
    var
        AccountType: Record "Account Type";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        AccountBalance: Decimal;
    begin
        CASE AccountCategory OF
            AccountCategory::Vendor:
                BEGIN
                    IF Vendor.GET(AccountNo) THEN BEGIN
                        Vendor.CALCFIELDS("Balance (LCY)");
                        IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                            AccountBalance := ABS(Vendor."Balance (LCY)") - AccountType."Minimum Balance";
                            IF AccountBalance > 0 THEN
                                EXIT(AccountBalance)
                            ELSE
                                EXIT(0);
                        END;
                    END;
                END;
            AccountCategory::Customer:
                BEGIN
                    IF Customer.GET(AccountNo) THEN BEGIN
                        Customer.CALCFIELDS("Balance (LCY)");
                        IF AccountType.GET(Customer."Account Type") THEN BEGIN
                            AccountBalance := ABS(Customer."Balance (LCY)") - AccountType."Minimum Balance";
                            IF AccountBalance > 0 THEN
                                EXIT(AccountBalance)
                            ELSE
                                EXIT(0);
                        END;
                    END;
                END;
        END;
    end;

    local procedure GetBranchCode(MemberNo: Code[20]): Code[20]
    var
        Member: Record "Member";
    begin
        IF Member.GET(MemberNo) THEN
            EXIT(Member."Global Dimension 1 Code");
    end;

    procedure PostFundTransfer(var FundTransfer: Record "Fund Transfer")
    var
        FundTransferSetup: Record "Fund Transfer Setup";
        TotalDeductedAmount: array[4] of Decimal;
        AmountToTransfer: Decimal;
        RecRef: RecordRef;
    begin
        WITH FundTransfer DO BEGIN
            CBSSetup.GET;
            FundTransferSetup.GET;
            SourceCodeSetup.GET;
            ClearJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name");
            GetAdditionalPostingInfo(SourceCodeSetup."Fund Transfer", CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", Description);

            //CASE B
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE B');
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Source Account Balance", SOURCECODESETUP."FUND TRANSFER", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Source Account Balance";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    DeductInstallmentDue("Destination Account No.", TODAY, "Source Account Balance", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE B or C
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE B OR C');
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Source Account Balance", SOURCECODESETUP."FUND TRANSFER", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += "Source Account Balance";
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SOURCECODESETUP."FUND TRANSFER", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += "Amount to Transfer";
                    END;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, "Source Account Balance", TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                END;
            END;

            //CASE C
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE C');
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE D
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE D');
                IF "Source Account Balance" < "Amount to Transfer" THEN
                    AmountToTransfer := "Source Account Balance";
                IF "Source Account Balance" > "Amount to Transfer" THEN
                    AmountToTransfer := "Amount to Transfer";

                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(4, "Destination Member No.", 0, AmountToTransfer, TotalDeductedAmount[1]);
                AmountToTransfer -= TotalDeductedAmount[1];
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += AmountToTransfer;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, AmountToTransfer, TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE E
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE E');
                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(4, "Destination Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE D OR E
            IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE D OR E');
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(4, "Destination Member No.", 1, "Source Account Balance", TotalDeductedAmount[1]);
                    AmountToTransfer := "Source Account Balance" - TotalDeductedAmount[1];
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(4, "Destination Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                    AmountToTransfer := "Amount to Transfer" - TotalDeductedAmount[1];
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;

                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        AmountToTransfer -= TotalDeductedAmount[1];
                        TotalDeductedAmount[2] += AmountToTransfer;
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += "Amount to Transfer";
                    END;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, AmountToTransfer, TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                END;
            END;

            //CASE F
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE F');
                IF "Source Account Balance" < "Amount to Transfer" THEN
                    AmountToTransfer := "Source Account Balance";
                IF "Source Account Balance" > "Amount to Transfer" THEN
                    AmountToTransfer := "Amount to Transfer";

                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 0, AmountToTransfer, TotalDeductedAmount[1]);
                AmountToTransfer -= TotalDeductedAmount[1];
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += AmountToTransfer;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, AmountToTransfer, TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE G
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE G');
                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE F OR G
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE F OR G');
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(3, "Member No.", 0, "Source Account Balance", TotalDeductedAmount[1]);
                    AmountToTransfer := "Source Account Balance" - TotalDeductedAmount[1];
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += AmountToTransfer;
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                    GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += "Amount to Transfer";
                    END;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, AmountToTransfer, TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                        TotalDeductedAmount[2] += TotalDeductedAmount[1];
                    END;
                END;
            END;

            //CASE F OR K
            IF (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
              AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE F OR K');
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(3, "Member No.", 0, "Amount to Transfer", TotalDeductedAmount[1]);
                    AmountToTransfer := "Amount to Transfer" - TotalDeductedAmount[1];
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Partial THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                      GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += AmountToTransfer;
                    END;
                    IF FundTransferSetup."Overdraw/Partial Priority" = FundTransferSetup."Overdraw/Partial Priority"::Overdrawing THEN BEGIN
                        CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                    GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                        TotalDeductedAmount[2] += "Amount to Transfer";
                    END;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE H
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE H');
                IF "Source Account Balance" < "Amount to Transfer" THEN
                    AmountToTransfer := "Source Account Balance";
                IF "Source Account Balance" > "Amount to Transfer" THEN
                    AmountToTransfer := "Amount to Transfer";

                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 0, AmountToTransfer, TotalDeductedAmount[1]);
                AmountToTransfer -= TotalDeductedAmount[1];
                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                IF "Destination Member No." <> "Member No." THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(4, "Destination Member No.", 0, AmountToTransfer, TotalDeductedAmount[1]);
                    AmountToTransfer -= TotalDeductedAmount[1];
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -AmountToTransfer, SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += AmountToTransfer;
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, AmountToTransfer, TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE I
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE I');
                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                IF "Destination Member No." <> "Member No." THEN BEGIN
                    TotalDeductedAmount[1] := 0;
                    CheckApplicationAreaArrears(4, "Destination Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
            END;

            //CASE H OR I
            IF (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE H OR I');
                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];

                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(4, "Destination Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE J
            IF (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (NOT FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction")) OR
                (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
               (("Source Account Balance" > "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                MESSAGE('CASE J');
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //CASE K
            IF (("Source Account Balance" > "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                  AND (FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
            THEN BEGIN
                //MESSAGE('CASE K');
                TotalDeductedAmount[1] := 0;
                CheckApplicationAreaArrears(3, "Member No.", 1, "Amount to Transfer", TotalDeductedAmount[1]);
                TotalDeductedAmount[2] += TotalDeductedAmount[1];
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                                  GenJournalLine."Account Type"::Vendor, "Destination Account No.", Description, -"Amount to Transfer", SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
                    TotalDeductedAmount[2] += "Amount to Transfer";
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    DeductInstallmentDue("Destination Account No.", TODAY, "Amount to Transfer", TotalDeductedAmount[1]);
                    TotalDeductedAmount[2] += TotalDeductedAmount[1];
                END;
            END;

            //Balancing Account
            CreateJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name", "No.", "No.", TODAY,
                          GenJournalLine."Account Type"::Vendor, "Source Account No.", Description, TotalDeductedAmount[2], SourceCodeSetup."Fund Transfer", GetBranchCode("Member No."));
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Fund Transfer Template Name", CBSSetup."Fund Transfer Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;

                CLEAR(RecRef);
                RecRef.GETTABLE(FundTransfer);
                SendNotification(RecRef, TotalDeductedAmount[2], TotalDeductedAmount[2]);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure SendNotification(var RecRef: RecordRef; var DebitAmount: Decimal; var CreditAmount: Decimal)
    var
        LoanApplication: Record "Loan Application";
        LoanApplicationSetup: Record "Loan Application Setup";
        FundTransfer: Record "Fund Transfer";
        FundTransferSetup: Record "Fund Transfer Setup";
        StandingOrder: Record "Standing Order";
        StandingOrderLine: Record "Standing Order Line";
        StandingOrderSetup: Record "Standing Order Setup";
        PayoutHeader: Record "Payout Header";
        PayoutLine: Record "Payout Line";
        PayoutSetup: Record "Payout Setup";
        DividendHeader: Record "Dividend Header";
        DividendSetup: Record "Dividend Setup";
        SMSText: BigText;
        EmailText: BigText;
        Member: Record "Member";
        Member2: Record "Member";
        FldRef: FieldRef;
    begin
        SMTPSetup.GET;
        DebitAmount := ROUND(DebitAmount, 0.01, '>');
        CASE RecRef.NUMBER OF
            DATABASE::"Loan Application":
                BEGIN
                    RecRef.SETTABLE(LoanApplication);
                    FldRef := RecRef.FIELD(1);
                    LoanApplicationSetup.GET;
                    IF LoanApplicationSetup."Notify Member" THEN BEGIN
                        Member.GET(LoanApplication."Member No.");
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((LoanApplicationSetup."Notification Option" = LoanApplicationSetup."Notification Option"::Email) OR (LoanApplicationSetup."Notification Option" = LoanApplicationSetup."Notification Option"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template", LoanApplication."No.", LoanApplication.Description, DebitAmount));
                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((LoanApplicationSetup."Notification Option" = LoanApplicationSetup."Notification Option"::SMS) OR (LoanApplicationSetup."Notification Option" = LoanApplicationSetup."Notification Option"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(LoanApplicationSetup."Email Template", LoanApplication."No.", LoanApplication.Description, DebitAmount));
                            CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Loan);
                        END;
                    END;
                END;
            DATABASE::"Fund Transfer":
                BEGIN
                    RecRef.SETTABLE(FundTransfer);
                    Member.GET(FundTransfer."Member No.");
                    Member2.GET(FundTransfer."Destination Member No.");
                    FundTransferSetup.GET;
                    IF FundTransferSetup."Notify Source Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Email) OR (FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Source Email Template", FundTransfer."Source Account No.", FundTransfer."Source Account Name", DebitAmount));
                            ////SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::SMS) OR (FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Source SMS Template", FundTransfer."Source Account No.", FundTransfer."Source Account Name", DebitAmount));
                            CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Fund Transfer");
                        END;
                    END;
                    IF FundTransferSetup."Notify Destination Member" THEN BEGIN
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Email) OR (FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Destination Email Template", FundTransfer."Destination Account No.", FundTransfer."Destination Account Name", CreditAmount));
                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member2."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::SMS) OR (FundTransferSetup."Notification Option" = FundTransferSetup."Notification Option"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(FundTransferSetup."Destination SMS Template", FundTransfer."Destination Account No.", FundTransfer."Destination Account Name", CreditAmount));
                            CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup."Fund Transfer");
                        END;
                    END;
                END;
            DATABASE::"Standing Order":
                BEGIN
                    RecRef.SETTABLE(StandingOrder);
                    FldRef := RecRef.FIELD(1);
                    StandingOrderSetup.GET;
                    IF StandingOrderSetup."Notify Source Member" THEN BEGIN
                        Member.GET(StandingOrder."Member No.");
                        CLEAR(SMSText);
                        CLEAR(EmailText);
                        IF ((StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Email) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both)) THEN BEGIN
                            EmailText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Source Email Template", FundTransfer."Source Account No.", FundTransfer."Source Account Name", DebitAmount));
                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                            //SMTPMail.Send;
                        END;
                        IF ((StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::SMS) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both)) THEN BEGIN
                            SMSText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Source SMS Template", StandingOrder."Source Account No.", StandingOrder."Source Account Name", DebitAmount));
                            CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup."Standing Order");
                        END;
                    END;
                    IF StandingOrderSetup."Notify Destination Member" THEN BEGIN
                        StandingOrderLine.RESET;
                        StandingOrderLine.SETRANGE("Document No.", FORMAT(FldRef.VALUE));
                        IF StandingOrderLine.FINDSET THEN BEGIN
                            REPEAT
                                IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::Internal THEN BEGIN
                                    CLEAR(SMSText);
                                    CLEAR(EmailText);
                                    Member2.GET(StandingOrderLine."Member No.");
                                    IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Vendor THEN
                                        CreditAmount := GetPostedAmount(0, StandingOrder."No.", StandingOrderLine."Account No.");
                                    IF StandingOrderLine."Account Type" = StandingOrderLine."Account Type"::Customer THEN
                                        CreditAmount := GetPostedAmount(1, StandingOrder."No.", StandingOrderLine."Account No.");

                                    IF ((StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Email) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both)) THEN BEGIN
                                        EmailText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Destination Email Template", StandingOrderLine."Account No.", StandingOrderLine."Account Name", CreditAmount));
                                        //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                        //SMTPMail.Send;
                                    END;
                                    IF ((StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::SMS) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both)) THEN BEGIN
                                        SMSText.ADDTEXT(STRSUBSTNO(StandingOrderSetup."Destination SMS Template", StandingOrderLine."Account No.", StandingOrderLine."Account Name", CreditAmount));
                                        CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup."Standing Order");
                                    END;
                                END;
                                IF StandingOrderLine."Destination Type" = StandingOrderLine."Destination Type"::External THEN BEGIN
                                    CLEAR(SMSText);
                                    CLEAR(EmailText);
                                    CreditAmount := GetPostedAmount(2, StandingOrder."No.", StandingOrderSetup."Bank Control Account");
                                    IF StandingOrderSetup."Notify on External" THEN BEGIN
                                        IF (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Email) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both) THEN BEGIN
                                            EmailText.ADDTEXT(STRSUBSTNO(StandingOrderSetup.GetEmailTemplate, StandingOrder."Member Name", StandingOrderLine."Destination Account No.", StandingOrderLine."Destination Account Name",
                                                                  StandingOrderLine."Destination Bank Name", StandingOrderLine."Destination Branch Name", StandingOrderLine."Swift Code", CreditAmount));
                                            //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",StandingOrderSetup."External Email Address",'',FORMAT(EmailText),FALSE);
                                            //SMTPMail.Send;
                                        END;
                                        IF (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::SMS) OR (StandingOrderSetup."Notification Option" = StandingOrderSetup."Notification Option"::Both) THEN BEGIN
                                            SMSText.ADDTEXT(STRSUBSTNO(StandingOrderSetup.GetSMSTemplate, StandingOrder."Member Name", StandingOrderLine."Destination Account No.", StandingOrderLine."Destination Account Name",
                                                            StandingOrderLine."Destination Bank Name", StandingOrderLine."Destination Branch Name", StandingOrderLine."Swift Code", StandingOrderLine."Line Amount"));

                                            CreateSMSEntry(StandingOrderSetup."External Phone No.", SMSText, SourceCodeSetup."Standing Order");
                                        END;
                                    END;
                                END;
                            UNTIL StandingOrderLine.NEXT = 0;
                        END;
                    END;
                END;
            DATABASE::"Payout Header":
                BEGIN
                    RecRef.SETTABLE(PayoutHeader);
                    FldRef := RecRef.FIELD(1);
                    PayoutSetup.GET;
                    IF PayoutSetup."Notify Member" THEN BEGIN
                        PayoutLine.RESET;
                        PayoutLine.SETRANGE("Document No.", FORMAT(FldRef.VALUE));
                        IF PayoutLine.FINDSET THEN BEGIN
                            REPEAT
                                CLEAR(SMSText);
                                CLEAR(EmailText);
                                Member.GET(PayoutLine."Member No.");
                                CreditAmount := GetPostedAmount(0, PayoutHeader."No.", PayoutLine."Account No.");

                                IF ((PayoutSetup."Notification Option" = PayoutSetup."Notification Option"::Email) OR (PayoutSetup."Notification Option" = PayoutSetup."Notification Option"::Both)) THEN BEGIN
                                    EmailText.ADDTEXT(STRSUBSTNO(PayoutSetup."Email Template", PayoutLine."Account No.", PayoutLine."Account Name", CreditAmount));
                                    //SMTPMail.CreateMessage(SMTPSetup."Sender Name",SMTPSetup."Sender Email Address",Member."E-mail",'',FORMAT(EmailText),FALSE);
                                    //SMTPMail.Send;
                                END;
                                IF ((PayoutSetup."Notification Option" = PayoutSetup."Notification Option"::SMS) OR (PayoutSetup."Notification Option" = PayoutSetup."Notification Option"::Both)) THEN BEGIN
                                    SMSText.ADDTEXT(STRSUBSTNO(PayoutSetup."SMS Template", PayoutLine."Account No.", PayoutLine."Account Name", CreditAmount));
                                    CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Payout);
                                END;
                            UNTIL PayoutLine.NEXT = 0;
                        END;
                    END;
                END;
        END;
    end;

    local procedure GetPostedAmount(AccountCategory: Option Vendor,Customer,"Bank Account"; "DocumentNo.": Code[20]; AccountNo: Code[20]) PostedAmount: Decimal
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        CASE AccountCategory OF
            AccountCategory::Vendor:
                BEGIN
                    VendorLedgerEntry.RESET;
                    VendorLedgerEntry.SETRANGE("Document No.", DocumentNo);
                    VendorLedgerEntry.SETRANGE("Vendor No.", AccountNo);
                    VendorLedgerEntry.SETRANGE("Posting Date", TODAY);
                    IF VendorLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            VendorLedgerEntry.CALCFIELDS(Amount);
                            PostedAmount += VendorLedgerEntry.Amount;
                        UNTIL VendorLedgerEntry.NEXT = 0;
                    END;
                END;
            AccountCategory::Customer:
                BEGIN
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Document No.", DocumentNo);
                    CustLedgerEntry.SETRANGE("Customer No.", AccountNo);
                    CustLedgerEntry.SETRANGE("Posting Date", TODAY);
                    IF CustLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            CustLedgerEntry.CALCFIELDS(Amount);
                            PostedAmount += CustLedgerEntry.Amount;
                        UNTIL CustLedgerEntry.NEXT = 0;
                    END;
                END;
            AccountCategory::"Bank Account":
                BEGIN
                    BankAccountLedgerEntry.RESET;
                    BankAccountLedgerEntry.SETRANGE("Document No.", DocumentNo);
                    BankAccountLedgerEntry.SETRANGE("Bank Account No.", AccountNo);
                    BankAccountLedgerEntry.SETRANGE("Posting Date", TODAY);
                    IF BankAccountLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            PostedAmount += BankAccountLedgerEntry.Amount;
                        UNTIL BankAccountLedgerEntry.NEXT = 0;
                    END;
                END;
        END;
        EXIT(ABS(PostedAmount));
    end;

    procedure CalculateDaysInstallmentsInArrears(LoanNo: Code[20]; AmountInArrears: Decimal; var NoofDaysInArrears: Integer; var NoofInstallmentInArrears: Integer): Integer
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanApplication: Record "Loan Application";
    begin
        IF LoanApplication.GET(LoanNo) THEN BEGIN
            LoanRepaymentSchedule.RESET;
            LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
            IF NOT LoanRepaymentSchedule.FINDFIRST THEN
                CalculateRepaymentSchedule(LoanNo, LoanApplication."Approved Amount");
            IF LoanRepaymentSchedule."Total Installment" > 0 THEN
                NoofInstallmentInArrears := ROUND(AmountInArrears / LoanRepaymentSchedule."Total Installment", 1, '=');
            ;

            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Annually THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 365;
            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Quarterly THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 90;
            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Monthly THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 30;
            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Fortnightly THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 14;
            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Weekly THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 7;
            IF LoanApplication."Repayment Frequency" = LoanApplication."Repayment Frequency"::Daily THEN
                NoofDaysInArrears := NoofInstallmentInArrears * 1;
        END;
    end;

    procedure GenerateMemberRemittanceAdvice(Member: Record "Member")
    var
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        LineNo: Integer;
        MemberRemittanceHeader: Record "Member Remittance Header";
        MemberRemittanceLine: Record "Member Remittance Line";
        MemberRemittanceLine2: Record "Member Remittance Line";
        AccountType: Record "Account Type";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        RemittanceNo: Code[20];
        RemittanceCode: Record "Remittance Code";
        LoanProductType: Record "Loan Product Type";
    begin
        WITH Member DO BEGIN
            CBSSetup.GET;
            MemberRemittanceHeader.INIT;
            MemberRemittanceHeader."No." := NoSeriesManagement.GetNextNo(CBSSetup."Member Remittance Advice Nos.", TODAY, TRUE);
            MemberRemittanceHeader.VALIDATE("Member No.", "No.");
            MemberRemittanceHeader.INSERT(TRUE);

            Vendor.RESET;
            Vendor.SETRANGE("Member No.", "No.");
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    IF AccountType.GET(Vendor."Account Type") THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", AccountType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::Normal);
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 0, AccountType.Code, Vendor."No.", 0, RemittanceCode.Code, AccountType."Minimum Contribution");
                    END;
                UNTIL Vendor.NEXT = 0;
            END;

            Customer.RESET;
            Customer.SETRANGE("Member No.", "No.");
            IF Customer.FINDSET THEN BEGIN
                REPEAT
                    //AccountType.GET(Customer."Account Type");
                    LoanProductType.GET(Customer."Customer Posting Group");
                    GetInstallmentDue(Customer."No.", TODAY, InstallmentAmount[1], InstallmentAmount[2]);
                    InstallmentAmount[1] := 4000;
                    InstallmentAmount[2] := 550;
                    IF InstallmentAmount[1] > 0 THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", LoanProductType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::"Principal Due");
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 1, LoanProductType.Code, Customer."No.", 1, RemittanceCode.Code, InstallmentAmount[1]);
                    END;
                    IF InstallmentAmount[2] > 0 THEN BEGIN
                        RemittanceCode.RESET;
                        RemittanceCode.SETRANGE("Account Type", LoanProductType.Code);
                        RemittanceCode.SETRANGE("Contribution Type", RemittanceCode."Contribution Type"::"Interest Due");
                        IF RemittanceCode.FINDFIRST THEN;
                        CreateMemberRemittanceLine(MemberRemittanceHeader."No.", 1, LoanProductType.Code, Customer."No.", 2, RemittanceCode.Code, InstallmentAmount[2]);
                    END;
                UNTIL Customer.NEXT = 0;
            END;
        END;
    end;

    local procedure CreateMemberRemittanceLine(DocumentNo: Code[20]; AccountCategory: Integer; AccountType: Code[20]; AccountNo: Code[20]; ContributionType: Integer; RemittanceCode: Code[20]; Amount: Decimal)
    var
        MemberRemittanceLine: Record "Member Remittance Line";
        MemberRemittanceLine2: Record "Member Remittance Line";
        LineNo: Integer;
    begin
        MemberRemittanceLine.INIT;
        MemberRemittanceLine."Document No." := DocumentNo;
        MemberRemittanceLine2.RESET;
        MemberRemittanceLine2.SETRANGE("Document No.", DocumentNo);
        IF MemberRemittanceLine2.FINDLAST THEN
            LineNo := MemberRemittanceLine2."Line No."
        ELSE
            LineNo := 0;
        MemberRemittanceLine."Line No." := LineNo + 10000;
        MemberRemittanceLine."Account Category" := AccountCategory;
        MemberRemittanceLine."Account Type" := AccountType;
        MemberRemittanceLine."Remittance Code" := RemittanceCode;
        MemberRemittanceLine.VALIDATE("Account No.", AccountNo);
        MemberRemittanceLine."Contribution Type" := ContributionType;
        MemberRemittanceLine."Expected Amount" := Amount;
        MemberRemittanceLine."Actual Amount" := Amount;
        MemberRemittanceLine.INSERT;
    end;

    procedure PostPayout(var PayoutHeader: Record "Payout Header")
    var
        PayoutLine: Record "Payout Line";
        PayoutSetup: Record "Payout Setup";
        PayoutType: Record "Payout Type";
        PayoutLoanProduct: Record "Payout Loan Product";
        LoanApplication: Record "Loan Application";
        TotalDeductionAmount: array[4] of Decimal;
        Agency: Record Agency;
        RecRef: RecordRef;
    begin
        WITH PayoutHeader DO BEGIN
            CBSSetup.GET;
            PayoutSetup.GET;
            SourceCodeSetup.GET;
            Agency.GET("Agency Code");
            CALCFIELDS("Total Payout Amount");
            ClearJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name");

            CreateJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                          Agency."Vendor No.", Description + Text013, "Total Payout Amount", SourceCodeSetup.Payout, "Global Dimension 1 Code");

            PayoutLine.RESET;
            PayoutLine.SETRANGE("Document No.", "No.");
            IF PayoutLine.FINDSET THEN BEGIN
                REPEAT
                    IF PayoutLine."Charge Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      PayoutSetup."Charges G/L Account", Description + Text016, -PayoutLine."Charge Amount", SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code");
                    END;
                    IF PayoutLine."Excise Duty Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      CBSSetup."Excise Duty G/L Account", Description + Text010, -PayoutLine."Excise Duty Amount", SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code");
                    END;
                    IF PayoutLine."Withholding Tax Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      CBSSetup."Withholding Tax G/L Account", Description + Text011, -PayoutLine."Withholding Tax Amount", SourceCodeSetup."Payout", PayoutLine."Global Dimension 1 Code");
                    END;
                    Vendor.RESET;
                    Vendor.SETRANGE("Member No.", PayoutLine."Member No.");
                    Vendor.SETRANGE("Account Type", PayoutSetup."FOSA Account Type");
                    IF Vendor.FINDFIRST THEN;

                    GetAdditionalPostingInfo(SourceCodeSetup.Assembly, CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", Description);
                    TotalDeductionAmount[1] := 0;
                    CheckApplicationAreaArrears(5, PayoutLine."Member No.", 0, PayoutLine."Net Amount", TotalDeductionAmount[1]);
                    IF PayoutLine."Net Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      Vendor."No.", Description + Text014, -PayoutLine."Net Amount", SourceCodeSetup.Assembly, PayoutLine."Global Dimension 1 Code");
                    END;
                UNTIL PayoutLine.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Payout Template Name", CBSSetup."Payout Batch Name") THEN BEGIN
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date" := TODAY;
                "Posted Time" := TIME;
                MODIFY;

                CLEAR(RecRef);
                RecRef.GETTABLE(PayoutHeader);
                SendNotification(RecRef, "Total Payout Amount", "Total Payout Amount");
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure IsLoanProductAvailable(ApplicationArea: Integer; LoanProductType: Code[20]): Boolean
    var
        PayoutLoanProduct: Record "Payout Loan Product";
        DividendLoanProduct: Record "Dividend Loan Product";
        FTLoanProduct: Record "FT Loan Product";
        STOLoanProduct: Record "STO Loan Product";
    begin
        CASE ApplicationArea OF
            1:
                BEGIN
                    STOLoanProduct.RESET;
                    STOLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    STOLoanProduct.SETFILTER("Application Area", '%1|%2', STOLoanProduct."Application Area"::Source, STOLoanProduct."Application Area"::Both);
                    EXIT(STOLoanProduct.FINDFIRST);
                END;
            2:
                BEGIN
                    STOLoanProduct.RESET;
                    STOLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    STOLoanProduct.SETFILTER("Application Area", '%1|%2', STOLoanProduct."Application Area"::Destination, STOLoanProduct."Application Area"::Both);
                    EXIT(STOLoanProduct.FINDFIRST);
                END;
            3:
                BEGIN
                    FTLoanProduct.RESET;
                    FTLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    FTLoanProduct.SETFILTER("Application Area", '%1|%2', FTLoanProduct."Application Area"::Source, FTLoanProduct."Application Area"::Both);
                    EXIT(FTLoanProduct.FINDFIRST);
                END;
            4:
                BEGIN
                    FTLoanProduct.RESET;
                    FTLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    FTLoanProduct.SETFILTER("Application Area", '%1|%2', FTLoanProduct."Application Area"::Destination, FTLoanProduct."Application Area"::Both);
                    EXIT(FTLoanProduct.FINDFIRST);
                END;
            5:
                BEGIN
                    PayoutLoanProduct.RESET;
                    PayoutLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    EXIT(PayoutLoanProduct.FINDFIRST);
                END;
            6:
                BEGIN
                    DividendLoanProduct.RESET;
                    DividendLoanProduct.SETRANGE("Loan Product Type", LoanProductType);
                    EXIT(DividendLoanProduct.FINDFIRST);
                END;
        END;
    end;

    procedure GenerateLoanClassification(var LoanApplication: Record "Loan Application")
    var
        LoanClassificationEntry: Record "Loan Classification Entry";
        LoanClassificationEntry2: Record "Loan Classification Entry";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationClass: Text[50];
        "Provisioning%": Decimal;
        TotalPrincipalPaid: Decimal;
        TotalInterestPaid: Decimal;
        TotalPrincipalDue: Decimal;
        TotalInterestDue: Decimal;
        EntryNo: Integer;
    begin
        WITH LoanApplication DO BEGIN
            LoanClassificationEntry.INIT;
            IF LoanClassificationEntry2.FINDLAST THEN
                EntryNo := LoanClassificationEntry2."Entry No."
            ELSE
                EntryNo := 0;
            LoanClassificationEntry."Entry No." := EntryNo + 1;
            LoanClassificationEntry."Classification Date" := TODAY;
            LoanClassificationEntry."Classification Time" := TIME;
            LoanClassificationEntry."Loan No." := "No.";
            LoanClassificationEntry.Description := Description;
            LoanClassificationEntry."Member No." := "Member No.";
            LoanClassificationEntry."Member Name" := "Member Name";
            LoanClassificationEntry."Approved Amount" := "Approved Amount";
            CALCFIELDS("Outstanding Balance");
            LoanClassificationEntry."Outstanding Balance" := "Outstanding Balance";
            LoanClassificationEntry."Repayment Method" := "Repayment Method";
            LoanClassificationEntry."Repayment Period" := "Repayment Period";
            LoanClassificationEntry."Repayment Frequency" := "Repayment Frequency";
            LoanClassificationEntry."Remaining Period" := CalculateNoofMonths("Next Due Date", "Date of Completion");
            CalculateLoanArrears("No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
            LoanClassificationEntry."Principal Arrears Amount" := ArrearsAmount[1];
            LoanClassificationEntry."Interest Arrears Amount" := ArrearsAmount[2];
            LoanClassificationEntry."Total Arrears Amount" := ArrearsAmount[1] + ArrearsAmount[2];
            LoanClassificationEntry."No. of Days in Arrears" := 0;
            GetInstallmentDue("No.", "Next Due Date", InstallmentAmount[1], InstallmentAmount[2]);
            LoanClassificationEntry."Principal Installment" := InstallmentAmount[1];
            LoanClassificationEntry."Interest Installment" := InstallmentAmount[2];
            LoanClassificationEntry."Total Installment" := InstallmentAmount[1] + InstallmentAmount[2];
            CalculateTotalExpectedAmount("No.", TotalPrincipalDue, TotalInterestDue);
            CalculateTotalAmountPaid("No.", TODAY, TotalPrincipalPaid, TotalInterestPaid);
            LoanClassificationEntry."Remaining Principal Amount" := TotalPrincipalDue - TotalPrincipalPaid;
            LoanClassificationEntry."Remaining Interest Amount" := TotalInterestDue - TotalInterestPaid;
            CalculateDaysInstallmentsInArrears("No.", (ArrearsAmount[1] + ArrearsAmount[2]), NoofDaysInArrears, NoofInstallmentInArrears);
            LoanClassificationEntry."No. of Days in Arrears" := NoofDaysInArrears;
            LoanClassificationEntry."No. of Defaulted Installment" := NoofInstallmentInArrears;
            GetClassificationClass(NoofDaysInArrears, ClassificationClass, "Provisioning%");
            LoanClassificationEntry."Classification Class" := ClassificationClass;
            LoanClassificationEntry."Provisioning Amount" := ("Provisioning%" / 100) * "Outstanding Balance";
            LoanClassificationEntry."Last Payment Date" := GetLastRepaymentDate("No.", TODAY);
            LoanClassificationEntry."Principal Overpayment" := OverpaymentAmount[1];
            LoanClassificationEntry."Interest Overpayment" := OverpaymentAmount[2];
            LoanClassificationEntry."Total Overpayment" := OverpaymentAmount[1] + OverpaymentAmount[2];
            LoanClassificationEntry."Global Dimension 1 Code" := "Global Dimension 1 Code";
            LoanClassificationEntry.INSERT;
        END;
    end;

    local procedure GetClassificationClass(NoofDaysInArrears: Integer; var ClassificationClass: Text; var "Provisioning%": Decimal)
    var
        LoanClassificationSetup: Record "Loan Classification Setup";
    begin
        LoanClassificationSetup.RESET;
        IF LoanClassificationSetup.FINDSET THEN BEGIN
            REPEAT
                IF ((NoofDaysInArrears >= LoanClassificationSetup."Min. Defaulted Days") AND (NoofDaysInArrears <= LoanClassificationSetup."Max. Defaulted Days")) THEN
                    ClassificationClass := LoanClassificationSetup.Description;
                "Provisioning%" := LoanClassificationSetup."Provisioning %";
            UNTIL LoanClassificationSetup.NEXT = 0;
        END;
    end;

    procedure CalculateNoofMonths(StartDate: Date; EndDate: Date): Integer
    var
        Calender: Record "Date";
    begin
        Calender.RESET;
        Calender.SETRANGE("Period Start", StartDate, EndDate);
        Calender.SETRANGE("Period Type", Calender."Period Type"::Month);
        EXIT(Calender.COUNT);
    end;

    procedure CalculateTotalAmountPaid(LoanNo: Code[20]; EndDate: Date; var TotalPrincipalPaid: Decimal; var TotalInterestPaid: Decimal)
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
    begin
        TotalPrincipalPaid := 0;
        TotalInterestPaid := 0;
        VendorLedgerEntry.RESET;
        VendorLedgerEntry.SETRANGE("Vendor No.", LoanNo);
        VendorLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
        IF VendorLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                VendorLedgerEntry.CALCFIELDS(Amount);
                IF VendorLedgerEntry."Source Code" = '' THEN
                    TotalPrincipalPaid += ABS(VendorLedgerEntry.Amount);
                IF VendorLedgerEntry."Source Code" = '' THEN
                    TotalInterestPaid += ABS(VendorLedgerEntry.Amount);
            UNTIL VendorLedgerEntry.NEXT = 0;
        END;
    end;

    procedure CalculateTotalExpectedAmount(LoanNo: Code[20]; var TotalPrincipalDue: Decimal; var TotalInterestDue: Decimal) TotalExpectedAmount: Decimal
    var
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
    begin
        TotalPrincipalDue := 0;
        TotalInterestDue := 0;
        LoanRepaymentSchedule.RESET;
        LoanRepaymentSchedule.SETRANGE("Loan No.", LoanNo);
        LoanRepaymentSchedule.CALCSUMS("Principal Installment");
        LoanRepaymentSchedule.CALCSUMS("Interest Installment");

        TotalPrincipalDue := LoanRepaymentSchedule."Principal Installment";
        TotalInterestDue := LoanRepaymentSchedule."Interest Installment";
    end;

    procedure GenerateDefaultedLoans(var LoanApplication: Record "Loan Application")
    var
        LoanDefaultEntry: Record "Loan Default Entry";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        InstallmentAmount: array[4] of Decimal;
        NoofDaysInArrears: Integer;
        NoofInstallmentInArrears: Integer;
        ClassificationClass: Text[50];
        "Provisioning%": Decimal;
        TotalPrincipalPaid: Decimal;
        TotalInterestPaid: Decimal;
        TotalPrincipalDue: Decimal;
        TotalInterestDue: Decimal;
        EntryNo: Integer;
    begin
        WITH LoanApplication DO BEGIN
            LoanDefaultEntry.INIT;
            IF LoanDefaultEntry.FINDLAST THEN
                EntryNo := LoanDefaultEntry."Entry No."
            ELSE
                EntryNo := 0;
            LoanDefaultEntry."Entry No." := EntryNo + 1;
            LoanDefaultEntry."Loan No." := "No.";
            LoanDefaultEntry.Description := Description;
            LoanDefaultEntry."Member No." := "Member No.";
            LoanDefaultEntry."Member Name" := "Member Name";
            LoanDefaultEntry."Approved Amount" := "Approved Amount";
            CALCFIELDS("Outstanding Balance");
            LoanDefaultEntry."Outstanding Balance" := "Outstanding Balance";
            LoanDefaultEntry."Repayment Method" := "Repayment Method";
            LoanDefaultEntry."Repayment Period" := "Repayment Period";
            LoanDefaultEntry."Repayment Frequency" := "Repayment Frequency";
            LoanDefaultEntry."Remaining Period" := CalculateNoofMonths("Next Due Date", "Date of Completion");
            CalculateLoanArrears("No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
            LoanDefaultEntry."Principal Arrears Amount" := ArrearsAmount[1];
            LoanDefaultEntry."Interest Arrears Amount" := ArrearsAmount[2];
            LoanDefaultEntry."Total Arrears Amount" := ROUND(ArrearsAmount[1] + ArrearsAmount[2], 0.01, '<');
            LoanDefaultEntry."No. of Days in Arrears" := 0;
            GetInstallmentDue("No.", "Next Due Date", InstallmentAmount[1], InstallmentAmount[2]);
            LoanDefaultEntry."Principal Installment" := InstallmentAmount[1];
            LoanDefaultEntry."Interest Installment" := InstallmentAmount[2];
            LoanDefaultEntry."Total Installment" := InstallmentAmount[1] + InstallmentAmount[2];
            CalculateTotalExpectedAmount("No.", TotalPrincipalDue, TotalInterestDue);
            CalculateTotalAmountPaid("No.", TODAY, TotalPrincipalPaid, TotalInterestPaid);
            LoanDefaultEntry."Remaining Principal Amount" := TotalPrincipalDue - TotalPrincipalPaid;
            LoanDefaultEntry."Remaining Interest Amount" := TotalInterestDue - TotalInterestPaid;
            CalculateDaysInstallmentsInArrears("No.", (ArrearsAmount[1] + ArrearsAmount[2]), NoofDaysInArrears, NoofInstallmentInArrears);
            LoanDefaultEntry."No. of Days in Arrears" := NoofDaysInArrears;
            LoanDefaultEntry."No. of Defaulted Installment" := NoofInstallmentInArrears;
            GetClassificationClass(NoofDaysInArrears, ClassificationClass, "Provisioning%");
            LoanDefaultEntry."Classification Class" := ClassificationClass;
            LoanDefaultEntry."Last Payment Date" := GetLastRepaymentDate("No.", TODAY);
            IF LoanDefaultEntry."Total Arrears Amount" > 0 THEN
                LoanDefaultEntry.INSERT;
        END;
    end;

    procedure AttachLoanToGuarantor(var LoanApplication: Record "Loan Application")
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanApplication2: Record "Loan Application";
        LoanProductType: Record "Loan Product Type";
        Text000: Label 'Defaulter Loan';
    begin
        WITH LoanApplication DO BEGIN
            LoanGuarantor.RESET;
            LoanGuarantor.SETRANGE("Loan No.", "No.");
            IF LoanGuarantor.FINDSET THEN BEGIN
                REPEAT
                    LoanApplication2.TRANSFERFIELDS(LoanApplication);
                    LoanApplication2."No." := '';
                    LoanApplication2.VALIDATE("Member No.", LoanGuarantor."Member No.");
                    IF GetTotalGuaranteedAmount("No.") > 0 THEN BEGIN
                        LoanApplication2."Requested Amount" := (LoanGuarantor."Account Balance" / GetTotalGuaranteedAmount("No.")) * "Outstanding Balance";
                        LoanApplication2."Approved Amount" := (LoanGuarantor."Account Balance" / GetTotalGuaranteedAmount("No.")) * "Outstanding Balance";
                    END;
                    LoanApplication2.Remarks := Text000;
                    LoanApplication2."Attach Status" := LoanApplication2."Attach Status"::Attached;
                    LoanApplication2."Attach Loan No." := "No.";
                    LoanProductType.RESET;
                    LoanProductType.SETRANGE("Defaulter Loan", TRUE);
                    IF LoanProductType.FINDFIRST THEN
                        LoanApplication2.VALIDATE("Loan Product Type", LoanProductType.Code);
                    IF LoanApplication2.INSERT(TRUE) THEN
                        PostLoan(LoanApplication2);
                UNTIL LoanGuarantor.NEXT = 0;
            END;
        END;
    end;

    procedure ReverseAttachedLoan(var LoanApplication: Record "Loan Application")
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
        GLEntry: Record "G/L Entry";
    begin
        WITH LoanApplication DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Outstanding Balance");
            CreateJournal(CBSSetup."Reversal Template Name", CBSSetup."Reversal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                          "Attach Loan No.", Text017 + "No.", "Outstanding Balance", SourceCodeSetup.Reversal, "Global Dimension 1 Code");

            CreateJournal(CBSSetup."Reversal Template Name", CBSSetup."Reversal Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                          "No.", Text017 + "No.", -"Outstanding Balance", SourceCodeSetup.Reversal, "Global Dimension 1 Code");
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Reversal Template Name", CBSSetup."Reversal Batch Name") THEN BEGIN
                "Attach Status" := "Attach Status"::Reversed;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure GetTotalGuaranteedAmount(LoanNo: Code[20]): Decimal
    var
        LoanGuarantor: Record "Loan Guarantor";
    begin
        LoanGuarantor.RESET;
        LoanGuarantor.SETRANGE("Loan No.", LoanNo);
        LoanGuarantor.CALCSUMS("Account Balance");
        EXIT(LoanGuarantor."Account Balance");
    end;

    procedure SendDefaultNotice(var LoanDefaultEntry: Record "Loan Default Entry"; NoticeCategory: Option "First Notice","Second Notice","Third Notice")
    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanDefaultSetup: Record "Loan Default Setup";
        SMSText: BigText;
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        Member2: Record "Member";
    begin
        LoanDefaultSetup.GET;
        SourceCodeSetup.GET;
        WITH LoanDefaultEntry DO BEGIN
            LoanApplication.GET("Loan No.");
            Member.GET("Member No.");
            CASE NoticeCategory OF
                NoticeCategory::"First Notice":
                    BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup."First Notice Template", Description, "No. of Days in Arrears", "Outstanding Balance"));
                        CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Default);
                        LoanApplication."Notice Category" := LoanApplication."Notice Category"::"First Notice";
                    END;
                NoticeCategory::"Second Notice":
                    BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup."Second Notice Template", Description, "No. of Days in Arrears", "Outstanding Balance"));
                        CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Default);

                        LoanGuarantor.RESET;
                        LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                        IF LoanGuarantor.FINDSET THEN BEGIN
                            REPEAT
                                Member2.GET(LoanGuarantor."Member No.");
                                SMSText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup."Guarantor Notice Template", Description, "Member Name", "No. of Days in Arrears"));
                                CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup.Default);
                            UNTIL LoanGuarantor.NEXT = 0;
                        END;
                        LoanApplication."Notice Category" := LoanApplication."Notice Category"::"Second Notice";
                    END;
                NoticeCategory::"Third Notice":
                    BEGIN
                        SMSText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup."Third Notice Template", Description, "No. of Days in Arrears", "Outstanding Balance"));
                        CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Default);

                        LoanGuarantor.RESET;
                        LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                        IF LoanGuarantor.FINDSET THEN BEGIN
                            REPEAT
                                Member2.GET(LoanGuarantor."Member No.");
                                SMSText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup."Guarantor Notice Template", Description, "Member Name", "No. of Days in Arrears"));
                                CreateSMSEntry(Member2."Phone No.", SMSText, SourceCodeSetup.Default);
                            UNTIL LoanGuarantor.NEXT = 0;
                        END;
                        LoanApplication."Notice Category" := LoanApplication."Notice Category"::"Third Notice";
                        LoanApplication."Attach Due Date" := CALCDATE(LoanDefaultSetup."Grace Period", TODAY);
                    END;
            END;
            LoanApplication."Notice Date" := TODAY;
            LoanApplication.MODIFY;
        END;
    end;

    local procedure CreateSMSEntry(PhoneNo: Code[20]; SMSText: BigText; SourceCode: Code[20])
    var
        SMSEntry: Record "SMS Entry";
        SMSEntry2: Record "SMS Entry";
        EntryNo: Integer;
        Ostream: OutStream;
    begin
        SMSEntry.INIT;
        IF SMSEntry2.FINDLAST THEN
            EntryNo := SMSEntry2."Entry No."
        ELSE
            EntryNo := 0;
        SMSEntry."Entry No." := EntryNo + 1;
        ;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."SMS Text".CREATEOUTSTREAM(Ostream);
        SMSText.WRITE(Ostream);
        SMSEntry."Created Date" := TODAY;
        SMSEntry."Created Time" := TIME;
        SMSEntry."Source Code" := SourceCode;
        SMSEntry.INSERT;
    end;

    procedure ProcessMemberExit(var MemberExitHeader: Record "Member Exit Header")
    var
        ExitReason: Record "Exit Reason";
    begin
        WITH MemberExitHeader DO BEGIN
            ExitReason.GET("Reason Code");
            IF ExitReason."Initiate Refund" THEN
                CreateRefund(MemberExitHeader);

            IF ExitReason."Initiate Claim" THEN
                CreateClaim(MemberExitHeader);

            PostExitFee(MemberExitHeader);
        END;
    end;

    local procedure CreateRefund(var MemberExitHeader: Record "Member Exit Header")
    var
        MemberRefundHeader: Record "Member Refund Header";
        MemberRefundLine: Record "Member Refund Line";
        MemberExitLine: Record "Member Exit Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        CBSSetup.GET;
        WITH MemberExitHeader DO BEGIN
            MemberRefundHeader.TRANSFERFIELDS(MemberExitHeader);
            MemberRefundHeader."No." := '';
            MemberRefundHeader."Exit No." := "No.";
            MemberRefundHeader.VALIDATE("Member No.");
            MemberRefundHeader."No. Series" := CBSSetup."Refund Nos.";
            MemberRefundHeader.Status := MemberRefundHeader.Status::New;
            MemberRefundHeader.INSERT(TRUE);

            MemberExitLine.RESET;
            MemberExitLine.SETRANGE("Document No.", "No.");
            MemberExitLine.SETRANGE("Account Category", MemberExitLine."Account Category"::Vendor);
            IF MemberExitLine.FINDSET THEN BEGIN
                REPEAT
                    MemberRefundLine.TRANSFERFIELDS(MemberExitLine);
                    MemberRefundLine."Document No." := MemberRefundHeader."No.";
                    MemberRefundLine.INSERT;
                UNTIL MemberExitLine.NEXT = 0;
            END;
            IF ApprovalsMgmt.CheckMemberRefundApprovalPossible(MemberRefundHeader) THEN
                ApprovalsMgmt.OnSendMemberRefundForApproval(MemberRefundHeader);
        END;
    end;

    local procedure CreateClaim(var MemberExitHeader: Record "Member Exit Header")
    var
        MemberClaimHeader: Record "Member Claim Header";
        MemberClaimLine: Record "Member Claim Line";
        MemberExitLine: Record "Member Exit Line";
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        CBSSetup.GET;
        WITH MemberExitHeader DO BEGIN
            MemberClaimHeader.TRANSFERFIELDS(MemberExitHeader);
            MemberClaimHeader."No." := '';
            MemberClaimHeader."Exit No." := "No.";
            MemberClaimHeader.VALIDATE("Member No.");
            MemberClaimHeader."No. Series" := CBSSetup."Refund Nos.";
            MemberClaimHeader.Status := MemberClaimHeader.Status::New;
            MemberClaimHeader.INSERT(TRUE);

            MemberExitLine.RESET;
            MemberExitLine.SETRANGE("Document No.", "No.");
            MemberExitLine.SETRANGE("Account Category", MemberExitLine."Account Category"::Customer);
            IF MemberExitLine.FINDSET THEN BEGIN
                REPEAT
                    MemberClaimLine.TRANSFERFIELDS(MemberExitLine);
                    MemberClaimLine."Document No." := MemberClaimHeader."No.";
                    MemberClaimLine.INSERT;
                UNTIL MemberExitLine.NEXT = 0;
            END;
            IF ApprovalsMgmt.CheckMemberClaimApprovalPossible(MemberClaimHeader) THEN
                ApprovalsMgmt.OnSendMemberClaimForApproval(MemberClaimHeader);
        END;
    end;

    procedure PostLoanRecovery(var LoanApplication: Record "Loan Application")
    var
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        AmountDue: array[4] of Decimal;
        GenJournalLine: Record "Gen. Journal Line";
        AmountToRecover: array[4] of Decimal;
        TotalDeductionAmount: array[4] of Decimal;
        Text000: Label 'Amount of KES';
        Text001: Label 'will be recovered from your account';
        AccountType: Record "Account Type";
        AccountBalance: Decimal;
        LoanProductRecovery: Record "Loan Product Recovery";
        BoostAmount: Decimal;
        LoanProductType: Record "Loan Product Type";
    begin
        WITH LoanApplication DO BEGIN
            i := 0;
            CBSSetup.GET;
            SourceCodeSetup.GET;
            GetAdditionalPostingInfo('', CBSSetup."Loan Recovery Template Name", CBSSetup."Loan Recovery Batch Name", "No.", Text008);
            CalculateLoanArrears("No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);

            IF ArrearsAmount[1] >= 0 THEN
                ArrearsAmount[1] := ArrearsAmount[1]
            ELSE
                ArrearsAmount[1] := 0;

            IF ArrearsAmount[2] >= 0 THEN
                ArrearsAmount[2] := ArrearsAmount[2]
            ELSE
                ArrearsAmount[2] := 0;

            GetInstallmentDue("No.", TODAY, AmountDue[1], AmountDue[2]);
            AmountToRecover[1] := ArrearsAmount[1] + ArrearsAmount[2] + AmountDue[1] + AmountDue[2];

            Vendor.RESET;
            Vendor.SETRANGE("Member No.", "Member No.");
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    AccountType.GET(Vendor."Account Type");
                    IF AccountType.Type = AccountType.Type::Savings THEN BEGIN
                        AccountBalance := GetAccountBalance(0, Vendor."No.");
                        IF AccountBalance > 0 THEN BEGIN
                            i += 1;
                            IF AmountToRecover[1] <= AccountBalance THEN
                                AmountToRecover[2] := AmountToRecover[1]
                            ELSE
                                AmountToRecover[2] := AccountBalance;

                            IF i = 1 THEN BEGIN
                                DeductLoanArrears("No.", 0, AmountToRecover[2], TotalDeductionAmount[1]);
                                TotalDeductionAmount[2] += TotalDeductionAmount[1];
                                AmountToRecover[2] -= TotalDeductionAmount[2];

                                DeductInstallmentDue("No.", TODAY, AmountToRecover[2], TotalDeductionAmount[1]);
                                TotalDeductionAmount[2] += TotalDeductionAmount[1];
                                AmountToRecover[2] -= TotalDeductionAmount[2];
                            END ELSE BEGIN
                                IF AmountToRecover[2] > 0 THEN BEGIN
                                    DeductLoanArrears("No.", 0, AmountToRecover[2], TotalDeductionAmount[1]);
                                    TotalDeductionAmount[2] += TotalDeductionAmount[1];
                                    AmountToRecover[2] -= TotalDeductionAmount[2];

                                    DeductInstallmentDue("No.", TODAY, AmountToRecover[2], TotalDeductionAmount[1]);
                                    TotalDeductionAmount[2] += TotalDeductionAmount[1];
                                    AmountToRecover[2] -= TotalDeductionAmount[2];
                                END;
                            END;

                            //Boost Shares & NWDS
                            LoanProductType.GET("Loan Product Type");
                            IF LoanProductType."Boost on Recovery" THEN BEGIN
                                LoanProductRecovery.RESET;
                                LoanProductRecovery.SETRANGE("Loan Product Type", "Loan Product Type");
                                IF LoanProductRecovery.FINDSET THEN BEGIN
                                    REPEAT
                                        IF GetAccountNo("Member No.", LoanProductRecovery."Account Type") <> '' THEN BEGIN
                                            IF LoanProductRecovery."Calculation Method" = LoanProductRecovery."Calculation Method"::"%" THEN
                                                BoostAmount := (LoanProductRecovery.Amount / 100) * AmountToRecover[1];
                                            IF LoanProductRecovery."Calculation Method" = LoanProductRecovery."Calculation Method"::"Flat Amount" THEN
                                                BoostAmount := LoanProductRecovery.Amount;
                                            CreateJournal(CBSSetup."Loan Recovery Template Name", CBSSetup."Loan Recovery Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                                          GetAccountNo("Member No.", LoanProductRecovery."Account Type"), Text020 + "No.", -BoostAmount, SourceCodeSetup."Loan Recovery", "Global Dimension 1 Code");
                                            TotalDeductionAmount[2] += BoostAmount;
                                        END;
                                    UNTIL LoanProductRecovery.NEXT = 0;
                                END;
                            END;
                            CreateJournal(CBSSetup."Loan Recovery Template Name", CBSSetup."Loan Recovery Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          Vendor."No.", Text008 + "No.", TotalDeductionAmount[2], SourceCodeSetup."Loan Recovery", "Global Dimension 1 Code");
                        END;
                    END;
                UNTIL (Vendor.NEXT = 0);
            END;
        END;
    end;

    procedure PostRefund(var MemberRefundHeader: Record "Member Refund Header")
    var
        MemberRefundLine: Record "Member Refund Line";
        RefundAmount: Decimal;
        BeneficiaryAllocation: Record "Beneficiary Allocation";
        TotalDeductionAmount: array[4] of Decimal;
    begin
        WITH MemberRefundHeader DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            ClearJournal(CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name");
            RefundAmount := 0;
            MemberRefundLine.RESET;
            MemberRefundLine.SETRANGE("Document No.", "No.");
            IF MemberRefundLine.FINDSET THEN BEGIN
                REPEAT
                    CreateJournal(CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                  MemberRefundLine."Account No.", Text009 + "No.", MemberRefundLine."Account Balance", SourceCodeSetup."Refund", GetBranchCode("Member No."));
                    RefundAmount += MemberRefundLine."Account Balance";

                    BeneficiaryAllocation.RESET;
                    BeneficiaryAllocation.SETRANGE("Document No.", MemberRefundLine."Document No.");
                    BeneficiaryAllocation.SETRANGE("Source Account No.", MemberRefundLine."Account No.");
                    IF BeneficiaryAllocation.FINDSET THEN BEGIN
                        REPEAT
                            BeneficiaryAllocation.TESTFIELD("Account No.");
                            IF BeneficiaryAllocation."Account Category" = BeneficiaryAllocation."Account Category"::Vendor THEN BEGIN
                                CreateJournal(CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                              BeneficiaryAllocation."Account No.", Text009 + "No.", -BeneficiaryAllocation."Allocation Amount", SourceCodeSetup."Refund", GetBranchCode("Member No."));
                            END;
                            IF BeneficiaryAllocation."Account Category" = BeneficiaryAllocation."Account Category"::Customer THEN BEGIN
                                GetAdditionalPostingInfo('', CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name", "No.", Text009);
                                DeductLoanArrears(BeneficiaryAllocation."Account No.", 0, BeneficiaryAllocation."Allocation Amount", TotalDeductionAmount[1]);
                                IF BeneficiaryAllocation."Allocation Amount" > 0 THEN BEGIN
                                    CreateJournal(CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                                  BeneficiaryAllocation."Account No.", Text009 + "No." + Text007, -BeneficiaryAllocation."Allocation Amount", SourceCodeSetup."Refund", GetBranchCode("Member No."));
                                END;
                            END;
                        UNTIL BeneficiaryAllocation.NEXT = 0;
                    END;
                UNTIL MemberRefundLine.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Refund Template Name", CBSSetup."Refund Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END
    end;

    procedure CalculateDividends(var Member: Record "Member"; DividendType: Option Both,Dividend,Interest; DocumentNo: Code[20])
    var
        DividendLine: Record "Dividend Line";
        DividendLine2: Record "Dividend Line";
        Customer: Record "Customer";
        Vendor: Record "Vendor";
        LineNo: Integer;
        DividendSetup: Record "Dividend Setup";
        RemainingAmount: array[4] of Decimal;
        Amount: array[8] of Decimal;
        Found: array[4] of Boolean;
        AccountType: Record "Account Type";
    begin
        CBSSetup.GET;
        DividendSetup.GET;
        WITH Member DO BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Member No.", "No.");
            IF Vendor.FINDSET THEN BEGIN
                REPEAT
                    IF IsDividendAccountType(DividendType, Vendor."Account Type") THEN BEGIN
                        AccountType.GET(Vendor."Account Type");
                        DividendLine.INIT;
                        DividendLine2.RESET;
                        DividendLine2.SETRANGE("Document No.", DocumentNo);
                        IF DividendLine2.FINDLAST THEN
                            LineNo := DividendLine2."Line No."
                        ELSE
                            LineNo := 0;
                        DividendLine."Document No." := DocumentNo;
                        DividendLine."Line No." := LineNo + 1;
                        DividendLine.VALIDATE("Member No.", "No.");
                        DividendLine."Account Type" := Vendor."Account Type";
                        DividendLine.VALIDATE("Account No.", Vendor."No.");
                        DividendLine."Account Balance" := GetAccountBalance(0, Vendor."No.");
                        IF AccountType."Earns Dividend" THEN BEGIN
                            Amount[1] := DividendSetup."Dividend Rate %" / 100 * GetAccountBalance(0, Vendor."No.");
                            Amount[2] := 0;
                            DividendLine."Gross Earning Amount" := Amount[1];
                            DividendLine."Earning Type" := DividendLine."Earning Type"::Dividend;
                            IF DividendSetup."Topup Shares" THEN BEGIN
                                IF DividendLine."Account Balance" < AccountType."Minimum Balance" THEN
                                    Amount[5] := AccountType."Minimum Balance" - DividendLine."Account Balance"
                                ELSE
                                    Amount[5] := 0;
                            END;
                        END;
                        IF AccountType."Earns Interest" THEN BEGIN
                            Amount[1] := DividendSetup."Interest Rate %" / 100 * GetAccountBalance(0, Vendor."No.");
                            DividendLine."Gross Earning Amount" := Amount[1];
                            DividendLine."Earning Type" := DividendLine."Earning Type"::Interest;
                            IF AccountType."Earns Commission on Interest" THEN
                                Amount[2] := DividendSetup."Commission Amount";
                            Amount[5] := 0;
                        END;
                        IF DividendSetup."Charge Excise Duty" THEN
                            Amount[3] := CBSSetup."Excise Duty %" / 100 * DividendLine."Gross Earning Amount";
                        IF DividendSetup."Charge Withholdig Tax" THEN
                            Amount[4] := CBSSetup."Withholding Tax %" / 100 * DividendLine."Gross Earning Amount";

                        DistributeDividends(DividendLine."Earning Type", Amount[1], Amount[3], Amount[4], Amount[2], Amount[5]);
                        DividendLine."Excise Duty Amount" := Amount[3];
                        DividendLine."Withholding Tax Amount" := Amount[4];
                        DividendLine."Commission Amount" := Amount[2];
                        DividendLine."Shares Topup Amount" := Amount[5];
                        DividendLine."Net Earning Amount" := Amount[1];
                        //IF DividendLine."Account Balance" > 0 THEN
                        DividendLine.INSERT;
                    END;
                UNTIL Vendor.NEXT = 0;
            END;
        END;
    end;

    local procedure DistributeDividends(EarningType: Option " ",Dividend,Interest; var EarningAmount: Decimal; var ExciseDuty: Decimal; var WithholdingTax: Decimal; var Commission: Decimal; var SharesTopup: Decimal)
    var
        RemainingAmount: Decimal;
    begin
        CASE EarningType OF
            EarningType::Dividend:
                BEGIN
                    IF EarningAmount >= ExciseDuty THEN
                        ExciseDuty := ExciseDuty
                    ELSE
                        ExciseDuty := EarningAmount;
                    EarningAmount -= ExciseDuty;

                    IF EarningAmount >= WithholdingTax THEN
                        WithholdingTax := WithholdingTax
                    ELSE
                        WithholdingTax := EarningAmount;
                    EarningAmount -= WithholdingTax;

                    IF EarningAmount >= SharesTopup THEN
                        SharesTopup := SharesTopup
                    ELSE
                        SharesTopup := EarningAmount;
                    EarningAmount -= SharesTopup;

                    IF EarningAmount > 0 THEN
                        EarningAmount := EarningAmount
                    ELSE
                        EarningAmount := 0;
                END;
            EarningType::Interest:
                BEGIN
                    IF EarningAmount >= ExciseDuty THEN
                        ExciseDuty := ExciseDuty
                    ELSE
                        ExciseDuty := EarningAmount;
                    EarningAmount -= ExciseDuty;

                    IF EarningAmount >= WithholdingTax THEN
                        WithholdingTax := WithholdingTax
                    ELSE
                        WithholdingTax := EarningAmount;
                    EarningAmount -= WithholdingTax;

                    IF EarningAmount >= Commission THEN
                        Commission := Commission
                    ELSE
                        Commission := EarningAmount;
                    EarningAmount -= Commission;

                    IF EarningAmount > 0 THEN
                        EarningAmount := EarningAmount
                    ELSE
                        EarningAmount := 0;
                END;
        END;
    end;

    procedure PostDividends(var DividendHeader: Record "Dividend Header")
    var
        DividendLine: Record "Dividend Line";
        DeductionAmount: array[4] of Decimal;
        TopupAmount: Decimal;
        AccountType: Record "Account Type";
        GenJournalLine: Record "Gen. Journal Line";
        DividendSetup: Record "Dividend Setup";
        TotalDeductionAmount: array[4] of Decimal;
        LoanApplication: Record "Loan Application";
        ArrearsAmount: array[4] of Decimal;
    begin
        WITH DividendHeader DO BEGIN
            CBSSetup.GET;
            DividendSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Total Amount");
            ClearJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name");
            CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                          DividendSetup."Dividend Control G/L Account", Description + Text013, "Total Amount", SourceCodeSetup.Dividend, '');

            DividendLine.RESET;
            DividendLine.SETRANGE("Document No.", "No.");
            IF DividendLine.FINDSET THEN BEGIN
                REPEAT
                    AccountType.GET(DividendLine."Account Type");
                    IF DividendLine."Excise Duty Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      CBSSetup."Excise Duty G/L Account", Description + Text010, -DividendLine."Excise Duty Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                    END;
                    IF DividendLine."Withholding Tax Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      CBSSetup."Withholding Tax G/L Account", Description + Text011, -DividendLine."Withholding Tax Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                    END;
                    IF DividendLine."Commission Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                      DividendSetup."Commission G/L Account", Description + Text012, -DividendLine."Commission Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                    END;
                    IF DividendLine."Shares Topup Amount" > 0 THEN BEGIN
                        CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      DividendLine."Account No.", Description + Text015, -DividendLine."Shares Topup Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                    END;
                    Vendor.RESET;
                    Vendor.SETRANGE("Member No.", DividendLine."Member No.");
                    Vendor.SETRANGE("Account Type", DividendSetup."FOSA Account Type");
                    IF Vendor.FINDFIRST THEN;

                    IF DividendLine."Distribution Option" = DividendLine."Distribution Option"::"To FOSA" THEN BEGIN
                        CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      Vendor."No.", Description + Text014, -DividendLine."Net Earning Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                    END;
                    IF DividendLine."Distribution Option" = DividendLine."Distribution Option"::"To Loan" THEN BEGIN
                        GetAdditionalPostingInfo(SourceCodeSetup.Dividend, CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", Description);

                        TotalDeductionAmount[1] := 0;
                        CheckApplicationAreaArrears(6, DividendLine."Member No.", 0, DividendLine."Net Earning Amount", TotalDeductionAmount[1]);

                        IF DividendLine."Net Earning Amount" > 0 THEN BEGIN
                            CreateJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          Vendor."No.", Description + Text014, -DividendLine."Net Earning Amount", SourceCodeSetup.Dividend, DividendLine."Global Dimension 1 Code");
                        END;
                    END;

                UNTIL DividendLine.NEXT = 0;
            END;
            CLEARLASTERROR;
            IF PostJournal(CBSSetup."Dividend Template Name", CBSSetup."Dividend Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure IsDividendAccountType(DividendType: Option Both,Dividend,Interest; AccountTypeCode: Code[20]): Boolean
    var
        AccountType: Record "Account Type";
    begin
        AccountType.RESET;
        AccountType.SETRANGE(Code, AccountTypeCode);
        IF AccountType.FINDFIRST THEN BEGIN
            IF DividendType = DividendType::Dividend THEN BEGIN
                AccountType.SETRANGE("Earns Dividend", TRUE);
                EXIT(AccountType.FINDFIRST);
            END;
            IF DividendType = DividendType::Interest THEN BEGIN
                AccountType.SETRANGE("Earns Interest", TRUE);
                EXIT(AccountType.FINDFIRST);
            END;
            IF DividendType = DividendType::Both THEN BEGIN
                IF (AccountType."Earns Dividend") OR (AccountType."Earns Interest") THEN BEGIN
                    AccountType.MARK(TRUE);
                    AccountType.MARKEDONLY;
                    AccountType.COPY(AccountType);
                    EXIT(AccountType.FINDFIRST);
                END;
            END;
        END;
    end;

    procedure SendDividendsNotice(var DividendLine: Record "Dividend Line")
    var
        SMSText: BigText;
        DividendSetup: Record "Dividend Setup";
        Member: Record "Member";
    begin
        WITH DividendLine DO BEGIN
            SourceCodeSetup.GET;
            DividendSetup.GET;
            Member.GET(DividendLine."Member No.");
            IF DividendLine."Earning Type" = DividendLine."Earning Type"::Dividend THEN
                SMSText.ADDTEXT(STRSUBSTNO(DividendSetup."Dividend SMS Template", "Gross Earning Amount", "Net Earning Amount"));
            IF DividendLine."Earning Type" = DividendLine."Earning Type"::Interest THEN
                SMSText.ADDTEXT(STRSUBSTNO(DividendSetup."Interest SMS Template", "Gross Earning Amount", "Net Earning Amount"));
            CreateSMSEntry(Member."Phone No.", SMSText, SourceCodeSetup.Dividend);
        END;
    end;

    procedure GetLastRepaymentDate(LoanNo: Code[20]; EndDate: Date): Date
    var
        CustLedgerEntry: Record "Cust. Ledger Entry";
    begin
        SourceCodeSetup.GET;
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Posting Date", 0D, EndDate);
        CustLedgerEntry.SETFILTER(CustLedgerEntry."Source Code", '%1|%2', SourceCodeSetup."Principal Paid", SourceCodeSetup."Interest Paid");
        IF CustLedgerEntry.FINDLAST THEN
            EXIT(CustLedgerEntry."Posting Date");
    end;

    procedure BoostShares(var MemberExitLine: Record "Member Exit Line")
    var
        MemberExitHeader: Record "Member Exit Header";
        MemberExitHeader2: Record "Member Exit Header";
        AccountType: Record "Account Type";
        AccountType2: Record "Account Type";
        Amount: array[4] of Decimal;
        Error010: Label 'Member %1 does not have a Share Capital account';
    begin
        CBSSetup.GET;
        SourceCodeSetup.GET;
        ClearJournal(CBSSetup."Shares Boosting Template Name", CBSSetup."Shares Boosting Batch Name");
        IF MemberExitLine.FINDFIRST THEN BEGIN
            MemberExitHeader.GET(MemberExitLine."Document No.");
            AccountType.GET(MemberExitLine."Account Type");
            IF NOT ((AccountType.Type = AccountType.Type::Savings) OR (AccountType.Type = AccountType.Type::Deposit)) THEN
                ERROR(Error000, FORMAT(AccountType.Type))
            ELSE BEGIN
                AccountType2.RESET;
                AccountType2.SETRANGE(Type, AccountType2.Type::"Share Capital");
                IF AccountType2.FINDFIRST THEN;
                IF GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code) = '' THEN
                    ERROR(Error010, MemberExitHeader."Member Name");
                IF GetAccountBalance(0, GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code)) < AccountType2."Minimum Balance" THEN BEGIN
                    Amount[1] := AccountType2."Minimum Balance" - GetAccountBalance(0, GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code));
                    IF MemberExitLine."Account Balance" >= Amount[1] THEN
                        Amount[2] := Amount[1]
                    ELSE
                        Amount[2] := MemberExitLine."Account Balance";
                END;
                CreateJournal(CBSSetup."Shares Boosting Template Name", CBSSetup."Shares Boosting Batch Name", MemberExitLine."Document No.", MemberExitLine."Document No.", TODAY, GenJournalLine."Account Type"::Vendor,
                              MemberExitLine."Account No.", MemberExitHeader.Description + Text015, Amount[2], SourceCodeSetup."Member Exit", '');

                CreateJournal(CBSSetup."Shares Boosting Template Name", CBSSetup."Shares Boosting Batch Name", MemberExitLine."Document No.", MemberExitLine."Document No.", TODAY, GenJournalLine."Account Type"::Vendor,
                              GetAccountNo(MemberExitHeader."Member No.", AccountType2.Code), MemberExitHeader.Description + Text015, -Amount[2], SourceCodeSetup."Member Exit", '');
                CLEARLASTERROR;
                IF PostJournal(CBSSetup."Shares Boosting Template Name", CBSSetup."Shares Boosting Batch Name") THEN BEGIN
                    MemberExitHeader.VALIDATE("Member No.");
                END ELSE BEGIN
                    IF GETLASTERRORTEXT <> '' THEN
                        ERROR(GETLASTERRORTEXT);
                END;
            END;
        END;
    end;

    local procedure GetAccountNo(MemberNo: Code[20]; AccountType: Code[20]): Code[20]
    var
        Vendor: Record "Vendor";
    begin
        Vendor.RESET;
        Vendor.SETRANGE("Member No.", MemberNo);
        Vendor.SETRANGE("Account Type", AccountType);
        IF Vendor.FINDFIRST THEN
            EXIT(Vendor."No.");
    end;

    procedure PostLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    var
        LoanWriteoffLine: Record "Loan Writeoff Line";
        LoanWriteoffSetup: Record "Loan Writeoff Setup";
    begin
        WITH LoanWriteoffHeader DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            LoanWriteoffSetup.GET;
            CALCFIELDS("Total Writeoff Amount");
            LoanWriteoffSetup.TESTFIELD("LW G/L Control Account");
            CreateJournal(CBSSetup."Loan Writeoff Template Name", CBSSetup."Loan Writeoff Batch Name", LoanWriteoffLine."Document No.", LoanWriteoffLine."Document No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                          LoanWriteoffSetup."LW G/L Control Account", Description, "Total Writeoff Amount", SourceCodeSetup."Loan Writeoff", '');

            LoanWriteoffLine.RESET;
            LoanWriteoffLine.SETRANGE("Document No.", "No.");
            IF LoanWriteoffLine.FINDSET THEN BEGIN
                REPEAT
                    LoanWriteoffLine.TESTFIELD("Loan No.");
                    CreateJournal(CBSSetup."Loan Writeoff Template Name", CBSSetup."Loan Writeoff Batch Name", LoanWriteoffLine."Document No.", LoanWriteoffLine."Document No.", TODAY, GenJournalLine."Account Type"::Customer,
                                  LoanWriteoffLine."Loan No.", Description, LoanWriteoffLine."Outstanding Balance", SourceCodeSetup."Loan Writeoff", LoanWriteoffLine."Global Dimension 1 Code");
                UNTIL LoanWriteoffLine.NEXT = 0;
            END;
            IF PostJournal(CBSSetup."Loan Writeoff Template Name", CBSSetup."Loan Writeoff Batch Name") THEN BEGIN
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date" := TODAY;
                "Posted Time" := TIME;
                //ClearLoan();
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    local procedure ClearLoan(LoanNo: Code[20])
    var
        LoanApplication: Record "Loan Application";
    begin
        IF LoanApplication.GET(LoanNo) THEN BEGIN
            LoanApplication.Cleared := TRUE;
            LoanApplication.MODIFY;

            Customer.GET(LoanNo);
            //Customer.Status:=Customer.Status::Closed;
            Customer.MODIFY;
        END;
    end;

    procedure PostExitFee(var MemberExitHeader: Record "Member Exit Header")
    var
        ExitReason: Record "Exit Reason";
        ExitSetup: Record "Exit Setup";
        ExitReasonFee: Record "Exit Reason Fee";
        ExitFee: Record "Exit Fee";
    begin
        WITH MemberExitHeader DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            ExitSetup.GET;
            ClearJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name");
            ExitReasonFee.RESET;
            ExitReasonFee.SETRANGE("Reason Code", "Reason Code");
            IF ExitReasonFee.FINDSET THEN BEGIN
                REPEAT
                    IF ExitFee.GET(ExitReasonFee.Code) THEN BEGIN
                        IF ExitFee."Earning Party" = ExitFee."Earning Party"::Sacco THEN BEGIN
                            CreateJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          GetAccountNo("Member No.", ExitSetup."Debit FOSA Account Type"), Description, ExitReasonFee.Amount, SourceCodeSetup."Member Exit", '');
                            CreateJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                          ExitSetup."Income G/L Account", Description, -ExitReasonFee.Amount, SourceCodeSetup."Member Exit", '');
                        END;
                        IF ExitFee."Earning Party" = ExitFee."Earning Party"::Member THEN BEGIN
                            CreateJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                                          ExitSetup."Expense G/L Account", Description, ExitReasonFee.Amount, SourceCodeSetup."Member Exit", '');
                            CreateJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                          GetAccountNo("Member No.", ExitSetup."Credit FOSA Account Type"), Description, -ExitReasonFee.Amount, SourceCodeSetup."Member Exit", '');
                        END;
                    END;
                UNTIL ExitReasonFee.NEXT = 0;
            END;
            IF PostJournal(CBSSetup."Exit Template Name", CBSSetup."Exit Batch Name") THEN BEGIN
                MESSAGE(Text018);
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    procedure GenerateAgencyRemittanceHeader(AgencyCode: Code[20]; RemittancePeriodDate: Date; var DocumentNo: Code[20])
    var
        AgencyRemittanceHeader: Record "Agency Remittance Header";
        RemittancePeriod: Record "Remittance Period";
        LineNo: Integer;
    begin
        CBSSetup.GET;
        AgencyRemittanceHeader."No." := '';
        AgencyRemittanceHeader.VALIDATE("Agency Code", AgencyCode);
        IF RemittancePeriod.GET(RemittancePeriodDate) THEN;
        AgencyRemittanceHeader.Description := STRSUBSTNO(Text019, RemittancePeriod.Month, FORMAT(RemittancePeriod.Year));
        AgencyRemittanceHeader."Period Month" := RemittancePeriod.Month;
        AgencyRemittanceHeader."Period Year" := RemittancePeriod.Year;
        IF AgencyRemittanceHeader.INSERT(TRUE) THEN
            DocumentNo := AgencyRemittanceHeader."No.";
    end;

    procedure GenerateAgencyRemittanceLine(MemberRemittanceHeader: Record "Member Remittance Header"; MemberRemittanceLine: Record "Member Remittance Line"; DocumentNo: Code[20])
    var
        AgencyRemittanceLine: Record "Agency Remittance Line";
        AgencyRemittanceLine2: Record "Agency Remittance Line";
    begin
        AgencyRemittanceLine."Document No." := DocumentNo;
        AgencyRemittanceLine2.RESET;
        AgencyRemittanceLine2.SETRANGE("Document No.", DocumentNo);
        IF AgencyRemittanceLine2.FINDLAST THEN
            LineNo := AgencyRemittanceLine2."Line No."
        ELSE
            LineNo := 0;
        AgencyRemittanceLine."Line No." := LineNo + 10000;
        AgencyRemittanceLine."Member No." := MemberRemittanceHeader."Member No.";
        AgencyRemittanceLine."Member Name" := MemberRemittanceHeader."Member Name";
        AgencyRemittanceLine."Account Category" := MemberRemittanceLine."Account Category";
        AgencyRemittanceLine."Account Type" := MemberRemittanceLine."Account Type";
        AgencyRemittanceLine."Account No." := MemberRemittanceLine."Account No.";
        AgencyRemittanceLine."Account Name" := MemberRemittanceLine."Account Name";
        AgencyRemittanceLine."Contribution Type" := MemberRemittanceLine."Contribution Type";
        AgencyRemittanceLine."Remittance Code" := MemberRemittanceLine."Remittance Code";
        AgencyRemittanceLine."Expected Amount" := MemberRemittanceLine."Actual Amount";
        AgencyRemittanceLine.INSERT;
    end;

    procedure PostAgencyRemittance(var AgencyRemittanceHeader: Record "Agency Remittance Header")
    var
        AgencyRemittanceLine: Record "Agency Remittance Line";
        SourceCode: Code[20];
        Agency: Record Agency;
    begin
        WITH AgencyRemittanceHeader DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            CALCFIELDS("Total Actual Amount");
            Agency.GET("Agency Code");
            ClearJournal(CBSSetup."Remittance Template Name", CBSSetup."Remittance Batch Name");
            AgencyRemittanceLine.RESET;
            AgencyRemittanceLine.SETRANGE("Document No.", "No.");
            IF AgencyRemittanceLine.FINDSET THEN BEGIN
                REPEAT
                    SourceCode := SourceCodeSetup.Remittance;
                    IF AgencyRemittanceLine."Account Category" = AgencyRemittanceLine."Account Category"::Vendor THEN BEGIN
                        CreateJournal(CBSSetup."Remittance Template Name", CBSSetup."Remittance Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                                      AgencyRemittanceLine."Account No.", Description, AgencyRemittanceLine."Actual Amount", SourceCode, '');
                    END;
                    IF AgencyRemittanceLine."Account Category" = AgencyRemittanceLine."Account Category"::Customer THEN BEGIN
                        IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Principal Due" THEN
                            SourceCode := SourceCodeSetup."Principal Paid";
                        IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::"Interest Due" THEN
                            SourceCode := SourceCodeSetup."Interest Paid";
                        IF AgencyRemittanceLine."Contribution Type" = AgencyRemittanceLine."Contribution Type"::Insurance THEN
                            SourceCode := SourceCodeSetup."Insurance Fee";
                        CreateJournal(CBSSetup."Remittance Template Name", CBSSetup."Remittance Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                                      AgencyRemittanceLine."Account No.", Description, AgencyRemittanceLine."Actual Amount", SourceCode, '');
                    END;
                UNTIL AgencyRemittanceLine.NEXT = 0;
            END;
            CreateJournal(CBSSetup."Remittance Template Name", CBSSetup."Remittance Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Vendor,
                          Agency."Vendor No.", Description, -"Total Actual Amount", SourceCodeSetup.Remittance, '');
            IF PostJournal(CBSSetup."Remittance Template Name", CBSSetup."Remittance Batch Name") THEN BEGIN
                Status := Status::Posted;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;

    procedure PostLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    var
        LoanSelloffCharge: Record "Loan Selloff Charge";
        ChargeAmount: Decimal;
        LoanSelloffSetup: Record "Loan Selloff Setup";
    begin
        WITH LoanSelloff DO BEGIN
            CBSSetup.GET;
            SourceCodeSetup.GET;
            LoanSelloffSetup.GET;
            CALCFIELDS("Outstanding Balance");
            ClearJournal(CBSSetup."Loan Selloff Template Name", CBSSetup."Loan Selloff Batch Name");
            CreateJournal(CBSSetup."Loan Selloff Template Name", CBSSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::Customer,
                          "Loan No.", Description, -"Outstanding Balance", SourceCodeSetup."Loan Selloff", '');
            LoanSelloffCharge.RESET;
            IF LoanSelloffCharge.FINDSET THEN BEGIN
                REPEAT
                    IF (("Outstanding Balance" >= LoanSelloffCharge."Minimum Amount") AND ("Outstanding Balance" <= LoanSelloffCharge."Maximum Amount")) THEN BEGIN
                        IF LoanSelloffCharge."Calculation Method" = LoanSelloffCharge."Calculation Method"::"Flat Amount" THEN
                            ChargeAmount := LoanSelloffCharge.Amount;
                        IF LoanSelloffCharge."Calculation Method" = LoanSelloffCharge."Calculation Method"::"%" THEN
                            ChargeAmount := LoanSelloffCharge.Amount / 100 * "Outstanding Balance"
                    END;
                UNTIL LoanSelloffCharge.NEXT = 0;
            END;
            LoanSelloffSetup.TESTFIELD("Income G/L Account");
            CreateJournal(CBSSetup."Loan Selloff Template Name", CBSSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"G/L Account",
                          LoanSelloffSetup."Income G/L Account", Description, -ChargeAmount, SourceCodeSetup."Loan Selloff", '');

            LoanSelloffSetup.TESTFIELD("Receiving Bank Account");
            CreateJournal(CBSSetup."Loan Selloff Template Name", CBSSetup."Loan Selloff Batch Name", "No.", "No.", TODAY, GenJournalLine."Account Type"::"Bank Account",
                          LoanSelloffSetup."Receiving Bank Account", Description, (ChargeAmount + "Outstanding Balance"), SourceCodeSetup."Loan Selloff", '');
            IF PostJournal(CBSSetup."Loan Selloff Template Name", CBSSetup."Loan Selloff Batch Name") THEN BEGIN
                Posted := TRUE;
                MODIFY;
            END ELSE BEGIN
                IF GETLASTERRORTEXT <> '' THEN
                    ERROR(GETLASTERRORTEXT);
            END;
        END;
    end;


}

