codeunit 50039 "Cash Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        BankAccount: Record "Bank Account";
        Vendor: Record Vendor;
        Customer: Record Customer;
        VendLedgEntry: Record "Vendor Ledger Entry";
        PVLines: Record "Payment/Receipt Lines";
        GenJlLine: Record "Gen. Journal Line";
        CashMngtSetup: Record "Cash Management Setup";
        LineNo: Integer;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        "AppliesToDocNo.": Code[20];
        AppliesToDocNoType: Option Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        ShortcutDimension1Code: Code[10];
        PurchInvHeader: Record "Purch. Inv. Header";
        KRATaxCodes: Record "KRA Tax Codes";
        KRADescription: Text[60];
        UserSetup: Record "User Setup";
        ApprovalEntry: Record "Approval Entry";
        PVReceipts: Record "Payment/Receipt Voucher";
        //PVLinesPage : Page "50533";
        User: Record User;
        DocumentType: Option PV,Imprest,"Imprest Surrender";
        Empl: Record Employee;
        DimensionValue: Record "Dimension Value";
        EmpName: Text;
        CustAccount: Code[20];
        AccountMappingType: Record "Account Mapping Type";
        AccountMapping: Record "Account Mapping";
        GenJournalBatch: Record "Gen. Journal Batch";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        ImprestLines: Record "Imprest Lines";
        ImprestLinesCopy: Record "Imprest Lines";
        ImprestManagement: Record "Imprest Management";
        ImprestMgt: Record "Imprest Management";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ImprestManagementCopy: Record "Imprest Management";
        RefundAmount: Decimal;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        OnesText: array[20] of Text[30];
        TensText: array[10] of Text[30];
        Text001: Label 'ZERO';
        Text002: Label 'ONE';
        Text003: Label 'TWO';
        Text004: Label 'THREE';
        Text005: Label 'FOUR';
        Text006: Label 'FIVE';
        Text007: Label 'SIX';
        Text008: Label 'SEVEN';
        Text009: Label 'EIGHT';
        Text010: Label 'NINE';
        Text011: Label 'TEN';
        Text012: Label 'ELEVEN';
        Text013: Label 'TWELVE';
        Text014: Label 'THIRTEEN';
        Text015: Label 'FOURTEEN';
        Text016: Label 'FIFTEEN';
        Text017: Label 'SIXTEEN';
        Text018: Label 'SEVENTEEN';
        Text019: Label 'EIGHTEEN';
        Text020: Label 'NINETEEN';
        Text021: Label 'TWENTY';
        Text022: Label 'THIRTY';
        Text023: Label 'FORTY';
        Text024: Label 'FIFTY';
        Text025: Label 'SIXTY';
        Text026: Label 'SEVENTY';
        Text027: Label 'EIGHTY';
        Text028: Label 'NINETY';
        Text029: Label 'HUNDRED';
        Text030: Label 'THOUSAND';
        ExponentText: array[5] of Text[30];
        Text031: Label 'MILLION';
        NumberText: array[2] of Text[200];
        MyAmountInWord: Text[200];
        Text032: Label 'BILLLION';
        Text033: Label 'AND';
        Text034: Label '%1 results in a written number that is too long.';
        DescriptionLine: array[2] of Text[200];
        BudgetManagement: Codeunit "Budget Management";

    procedure GetBankAccountName("BankAccountNo.": Code[20]) AccountName: Code[70];
    begin
        BankAccount.RESET;
        IF BankAccount.GET("BankAccountNo.") THEN BEGIN
            AccountName := BankAccount.Name;
        END;
    end;

    procedure "GetVendor/CustomerName"("AccountNo.": Code[20]; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner") AccountName: Code[70];
    begin
        CASE "Account Type" OF
            "Account Type"::Vendor:
                BEGIN
                    IF Vendor.GET("AccountNo.") THEN BEGIN
                        AccountName := Vendor.Name;
                    END
                END;
            "Account Type"::Customer:
                BEGIN
                    IF Customer.GET("AccountNo.") THEN BEGIN
                        AccountName := Customer.Name;
                    END;
                END;
            "Account Type"::"G/L Account":
                BEGIN
                    IF GLAccount.GET("AccountNo.") THEN BEGIN
                        AccountName := GLAccount.Name;
                    END;
                END;
            "Account Type"::"Fixed Asset":
                BEGIN
                    IF FixedAsset.GET("AccountNo.") THEN BEGIN
                        AccountName := FixedAsset.Description;
                    END;
                END;
        END;
    end;

    procedure LookUpAppliesToDocVend("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        VendLedgEntry.SETCURRENTKEY("Vendor No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            VendLedgEntry.SETRANGE("Vendor No.", "AccountNo.");
            VendLedgEntry.SETRANGE(Open, TRUE);
            VendLedgEntry.SETRANGE(Positive, FALSE);
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, VendLedgEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := VendLedgEntry."Document No.";
            END;
        END;
    end;

    procedure LookUpAppliesToDocCust("AccountNo.": Code[20]) "AppliestoDoc.No": Code[20];
    begin
        CustLedgerEntry.SETCURRENTKEY("Customer No.", Open, Positive, "Due Date");
        IF "AccountNo." <> '' THEN BEGIN
            CustLedgerEntry.SETRANGE("Customer No.", "AccountNo.");
            CustLedgerEntry.SETRANGE(Open, TRUE);
            CustLedgerEntry.SETRANGE(Positive, TRUE);
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            IF PAGE.RUNMODAL(0, CustLedgerEntry) = ACTION::LookupOK THEN BEGIN
                "AppliestoDoc.No" := CustLedgerEntry."Document No.";
            END;
        END;
    end;

    procedure PostingPaymentVoucher(PaymentVoucher: Record "Payment/Receipt Voucher");
    begin
        WITH PaymentVoucher DO BEGIN
            UserSetup.GET(USERID);
            IF Status <> Status::Released THEN BEGIN
                ERROR('The Payment Voucher No. %1 Cannot be Posted before it is fully Approved', "Paying Code.");
            END;
            IF Posted = TRUE THEN BEGIN
                ERROR('Payment Voucher %1 has been posted', "Paying Code.");
            END;
            LineNo := 1000;
            CashMngtSetup.RESET;
            CashMngtSetup.GET;
            GenJournalBatch.INIT;
            GenJournalBatch."Journal Template Name" := CashMngtSetup."AP Journal Template Name";
            GenJournalBatch.Name := "Paying Code.";
            IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                GenJournalBatch.INSERT;
            END;
            GenJlLine.RESET;
            GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
            GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
            GenJlLine.DELETEALL;

            CALCFIELDS("Net Amount");
            IF CONFIRM('Are you sure you want to post the Payment Voucher No. ' + "Paying Code." + ' ?') = TRUE THEN BEGIN
                MakeJournalEntries(LineNo, "Paying Code.", Description, ("Net Amount" * -1), AccountType::"Bank Account", "Paying Bank", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::Payment, ShortcutDimension1Code,
                GenJournalBatch."Journal Template Name", GenJournalBatch.Name, UserSetup."Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                LineNo := LineNo + 100;
                PVLines.RESET;
                PVLines.SETRANGE(Code, "Paying Code.");
                IF PVLines.FINDFIRST THEN BEGIN
                    REPEAT
                        LineNo := LineNo + PVLines."Line No";
                        IF PVLines."Account Type" = PVLines."Account Type"::Vendor THEN BEGIN
                            MakeJournalEntries(LineNo, "Paying Code.", PVLines.Description, PVLines."Net Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", PVLines."Apples to Doc Type", '',
                            GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                            IF PVLines."W/Tax Amount" <> 0 THEN BEGIN
                                LineNo := LineNo + 1;
                                KRATaxCodes.RESET;
                                IF KRATaxCodes.GET(PVLines."W/Tax Code") THEN BEGIN
                                    CashMngtSetup.TESTFIELD("Claim No.");
                                    KRADescription := CashMngtSetup."Claim No.";
                                    MakeJournalEntries(LineNo, "Paying Code.", KRADescription, PVLines."W/Tax Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", PVLines."Apples to Doc Type", '',
                                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                                    LineNo := LineNo + 1;
                                    MakeJournalEntries(LineNo, "Paying Code.", KRADescription, -PVLines."W/Tax Amount", KRATaxCodes."Account Type", KRATaxCodes."Account No.", "Payment Date", AccountType::"G/L Account", '', '', GenJlLine."Applies-to Doc. Type"::" ", '',
                                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                                END;
                            END;
                            IF PVLines."VAT Withheld Amount" <> 0 THEN BEGIN
                                LineNo := LineNo + 1;
                                KRATaxCodes.RESET;
                                IF KRATaxCodes.GET(PVLines."VAT WithHeld Code") THEN BEGIN
                                    CashMngtSetup.TESTFIELD("Tax Withheld Description");
                                    KRADescription := CashMngtSetup."Tax Withheld Description";
                                    MakeJournalEntries(LineNo, "Paying Code.", KRADescription, PVLines."VAT Withheld Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", PVLines."Apples to Doc Type", '',
                                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                                    LineNo := LineNo + 1;
                                    MakeJournalEntries(LineNo, "Paying Code.", KRADescription, -PVLines."VAT Withheld Amount", KRATaxCodes."Account Type", KRATaxCodes."Account No.", "Payment Date", AccountType::"G/L Account", '', '', GenJlLine."Applies-to Doc. Type"::" ", '',
                                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                                END;
                            END;
                        END ELSE
                            IF PVLines."Account Type" = PVLines."Account Type"::Customer THEN BEGIN
                                MakeJournalEntries(LineNo, "Paying Code.", PVLines.Description, PVLines."Net Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::Refund, '',
                                GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                            END ELSE
                                IF PVLines."Account Type" = PVLines."Account Type"::"G/L Account" THEN BEGIN
                                    MakeJournalEntries(LineNo, "Paying Code.", PVLines.Description, PVLines."Net Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::Refund, '',
                                    GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                                END;
                    UNTIL PVLines.NEXT = 0;
                END;
            END;
            GenJlLine.RESET;
            GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
            GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
            Posted := TRUE;
            "Posted By" := USERID;
            "Time Posted" := TIME;
            "Date Posted" := TODAY;
            MODIFY;
        END;
    end;

    procedure PostingReceipttVoucher(PaymentVoucher: Record "Payment/Receipt Voucher");
    begin
        WITH PaymentVoucher DO BEGIN
            UserSetup.GET(USERID);
            IF Posted = TRUE THEN BEGIN
                ERROR('Payment Voucher %1 has been posted', "Paying Code.");
            END;
            LineNo := 1000;
            CashMngtSetup.RESET;
            CashMngtSetup.GET;
            GenJournalBatch.INIT;
            GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
            GenJournalBatch.Name := "Paying Code.";
            IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                GenJournalBatch.INSERT;
            END;
            GenJlLine.RESET;
            GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
            GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
            GenJlLine.DELETEALL;
            CALCFIELDS("Net Amount");
            IF CONFIRM('Are you sure you want to post the Receipt Voucher No. ' + "Paying Code." + ' ?') = TRUE THEN BEGIN
                MakeJournalEntries(LineNo, "Paying Code.", Description, "Net Amount", AccountType::"Bank Account", "Paying Bank", "Payment Date", AccountType::"G/L Account", '', "AppliesToDocNo.", AppliesToDocNoType::Payment, ShortcutDimension1Code,
                GenJournalBatch."Journal Template Name", GenJournalBatch.Name, UserSetup."Global Dimension 1 Code", UserSetup."Global Dimension 2 Code");
                LineNo := LineNo + 100;
                PVLines.RESET;
                PVLines.SETRANGE(Code, "Paying Code.");
                IF PVLines.FINDFIRST THEN BEGIN
                    REPEAT
                        LineNo := LineNo + PVLines."Line No";
                        MakeJournalEntries(LineNo, "Paying Code.", PVLines.Description, -PVLines."Net Amount", PVLines."Account Type", PVLines."Account No.", "Payment Date", AccountType::"G/L Account", '', PVLines."Applies to Doc. No", AppliesToDocNoType::Payment, '',
                        GenJournalBatch."Journal Template Name", GenJournalBatch.Name, PVLines."Global Dimension 1 Code", PVLines."Global Dimension 2 Code");
                        IF PVLines."Account Type" = PVLines."Account Type"::Customer THEN BEGIN
                            IF PVLines."Applies to Doc. No" <> '' THEN BEGIN
                                MarkImprestAsSurrendered(PVLines."Applies to Doc. No", PVLines."Net Amount", PVLines."Account No.");
                                ClearSalaryAdvance(PVLines."Account No.", PVLines."Applies to Doc. No", PVLines."Net Amount");
                            END;
                        END;
                    UNTIL PVLines.NEXT = 0;
                END;
            END;
            GenJlLine.RESET;
            GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
            GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
            Posted := TRUE;
            "Posted By" := USERID;
            "Time Posted" := TIME;
            "Date Posted" := TODAY;
            MODIFY;
        END;
    end;

    procedure MakeJournalEntries(LineNo: Integer; DocumentNo: Code[20]; Description: Text[60]; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; PostingDate: Date; "Bal. Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Bal. Account No.": Code[20]; AppliesToDocNo: Code[20]; AppliesToDocNoType: Option Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund; ShortcutDimension1Code: Code[20]; JournalTemplate: Code[20]; BatchTemplate: Code[20]; Dimension1: Code[20]; Dimension2: Code[20]);
    begin
        GenJlLine.INIT;
        GenJlLine."Line No." := LineNo;
        GenJlLine."Account Type" := "Account Type";
        GenJlLine."Account No." := "Account No.";
        GenJlLine.VALIDATE("Account No.");
        GenJlLine."Posting Date" := PostingDate;
        GenJlLine.Description := Description;
        GenJlLine."Document No." := DocumentNo;
        GenJlLine.Amount := Amount;
        GenJlLine."Gen. Posting Type" := GenJlLine."Gen. Posting Type"::" ";
        GenJlLine."Gen. Bus. Posting Group" := '';
        GenJlLine."Gen. Prod. Posting Group" := '';
        GenJlLine."Shortcut Dimension 1 Code" := Dimension1;
        GenJlLine."Shortcut Dimension 2 Code" := Dimension2;
        GenJlLine.VALIDATE(Amount);
        // GenJlLine."Applies-to Doc. No." := AppliesToDocNo;
        IF (GenJlLine."Applies-to Doc. No." = '') AND (GenJlLine."Account Type" = GenJlLine."Account Type"::Customer) THEN BEGIN
            //  GenJlLine."Applies-to Doc. No." := GetCustomerAppliesDocNo(GenJlLine."Document No.");
        END;
        IF GenJlLine."Applies-to Doc. No." <> '' THEN BEGIN
            IF GenJlLine."Account Type" = GenJlLine."Account Type"::Vendor THEN BEGIN
                VendLedgEntry.RESET;
                VendLedgEntry.SETRANGE("Vendor No.", GenJlLine."Account No.");
                VendLedgEntry.SETRANGE("Document No.", GenJlLine."Applies-to Doc. No.");
                IF VendLedgEntry.FINDFIRST THEN BEGIN
                    //  GenJlLine."Applies-to Doc. Type" := VendLedgEntry."Document Type";
                    //  GenJlLine."Gen. Posting Type" := GenJlLine."Gen. Posting Type"::Purchase;
                END;
            END;
            IF GenJlLine."Account Type" = GenJlLine."Account Type"::Customer THEN BEGIN
                CustLedgerEntry.RESET;
                CustLedgerEntry.SETRANGE("Customer No.", GenJlLine."Account No.");
                CustLedgerEntry.SETRANGE("Document No.", GenJlLine."Applies-to Doc. No.");
                IF CustLedgerEntry.FINDFIRST THEN BEGIN
                    // GenJlLine."Applies-to Doc. Type" := CustLedgerEntry."Document Type";
                END;
            END;
        END;
        GenJlLine."Document Type" := AppliesToDocNoType;
        GenJlLine."Journal Template Name" := JournalTemplate;
        GenJlLine."Journal Batch Name" := BatchTemplate;
        GenJlLine."Shortcut Dimension 1 Code" := ShortcutDimension1Code;
        GenJlLine."Bal. Account Type" := "Bal. Account Type";
        GenJlLine."Bal. Account No." := "Bal. Account No.";
        IF GenJlLine.Amount <> 0 THEN BEGIN
            GenJlLine.INSERT;
        END;
    end;

    procedure GetCustomerAppliesDocNo(DocumentNo: Code[20]): Code[20];
    begin
        ImprestManagement.RESET;
        IF ImprestManagement.GET(DocumentNo) THEN BEGIN
            IF ImprestManagement."Applies-to Doc. No." <> '' THEN BEGIN
                EXIT(ImprestManagement."Applies-to Doc. No.");
            END ELSE BEGIN
                EXIT(ImprestManagement."Imprest To Surrender");
            END;
        END;
    end;

    procedure VATWithheld(AccountNo: Code[20]; AppliesToDocNo: Code[20]; GrossAmount: Decimal) VATAmount: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Vendor."VAT Withheld" <> '' THEN BEGIN
                IF KRATaxCodes.GET(Vendor."VAT Withheld") THEN BEGIN
                    KRATaxCodes.TESTFIELD(Percentage);
                    KRATaxCodes.TESTFIELD("Account No.");
                    IF PurchInvHeader.GET(AppliesToDocNo) THEN BEGIN
                        PurchInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                        IF GrossAmount > PurchInvHeader."Amount Including VAT" THEN BEGIN
                            ERROR('Gross Amount CANNOT be more Than Purchase Invoice Amount %1,', PurchInvHeader."Amount Including VAT");
                        END ELSE BEGIN
                            VATAmount := ROUND((KRATaxCodes.Percentage / 100) * PurchInvHeader.Amount, 0.01);
                        END;
                    END;
                END;
            END;
        END
    end;

    procedure WTaxAmount(AccountNo: Code[20]; AppliesToDocNo: Code[20]; GrossAmount: Decimal) WTaxAmount: Decimal;
    begin
        IF Vendor.GET(AccountNo) THEN BEGIN
            IF Vendor."VAT Withheld" <> '' THEN BEGIN
                IF KRATaxCodes.GET(Vendor."Withholding Tax") THEN BEGIN
                    KRATaxCodes.TESTFIELD(Percentage);
                    KRATaxCodes.TESTFIELD("Account No.");
                    IF PurchInvHeader.GET(AppliesToDocNo) THEN BEGIN
                        PurchInvHeader.CALCFIELDS(Amount, "Amount Including VAT");
                        IF GrossAmount > PurchInvHeader."Amount Including VAT" THEN BEGIN
                            ERROR('Gross Amount CANNOT be more Than Purchase Invoice Amount %1,', PurchInvHeader."Amount Including VAT");
                        END ELSE BEGIN
                            WTaxAmount := ROUND((KRATaxCodes.Percentage / 100) * PurchInvHeader.Amount, 0.01);
                        END;
                    END;
                END;
            END;
        END
    end;

    procedure ConcatenateKBACodes(KBACodes: Record "KBA Codes") KBACode: Code[10];
    begin
        IF STRLEN(KBACodes."KBA Code") = 1 THEN BEGIN
            KBACodes."KBA Branch Code" := '00' + '' + KBACodes."KBA Branch Code";
        END;
        IF STRLEN(KBACodes."KBA Branch Code") = 2 THEN BEGIN
            KBACodes."KBA Branch Code" := '0' + '' + KBACodes."KBA Branch Code";
        END;
        KBACode := KBACodes."Bank Code" + '' + KBACodes."KBA Branch Code";
    end;

    procedure KBABranchCodes(KBACodes: Record "KBA Codes") KBABranchCode: Code[10];
    begin
        IF STRLEN(KBACodes."KBA Code") = 1 THEN BEGIN
            KBACodes."KBA Branch Code" := '00' + '' + KBACodes."KBA Branch Code";
        END;
        IF STRLEN(KBACodes."KBA Branch Code") = 2 THEN BEGIN
            KBACodes."KBA Branch Code" := '0' + '' + KBACodes."KBA Branch Code";
        END;
        KBABranchCode := KBACodes."KBA Branch Code";
    end;

    procedure RequiredFields(PVReceipts: Record "Payment/Receipt Voucher");
    begin
        WITH PVReceipts DO BEGIN
            TESTFIELD("Paying Bank");
            TESTFIELD(Description);
            TESTFIELD("Payment Mode");
            IF "Payment Mode" = "Payment Mode"::CHEQUE THEN BEGIN
                TESTFIELD("Cheque No.");
                TESTFIELD("Cheque Date");
            END;
            PVLines.RESET;
            PVLines.SETRANGE(Code, "Paying Code.");
            IF PVLines.FINDFIRST THEN BEGIN
                REPEAT
                    PVLines.TESTFIELD(Description);
                    PVLines.TESTFIELD("Account No.");
                    PVLines.TESTFIELD("Account Name");
                    PVLines.TESTFIELD(Amount);
                UNTIL PVLines.NEXT = 0;
            END;
        END;
    end;

    procedure ImprestRequiredFields(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            TESTFIELD(Description);
            TESTFIELD("Paying Bank Account");
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest No.");
            IF ImprestLines.FINDFIRST THEN BEGIN
                REPEAT
                    ImprestLines.TESTFIELD("Account No.");
                    ImprestLines.TESTFIELD(Quantity);
                    ImprestLines.TESTFIELD("Unit Price");
                    ImprestLines.TESTFIELD(Description);
                UNTIL ImprestLines.NEXT = 0;
            END;
        END;
    end;

    procedure ImprestSurrenderRequiredFields(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            TESTFIELD(Description);
            TESTFIELD("Imprest To Surrender");
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest No.");
            IF ImprestLines.FINDFIRST THEN BEGIN
                REPEAT
                    ImprestLines.TESTFIELD(Description);
                    ImprestLines.TESTFIELD("Actual Spent");
                UNTIL ImprestLines.NEXT = 0;
            END;
            CALCFIELDS("Actual Spent");
            IF "Actual Spent" < GetPostedImprestBalance("Imprest To Surrender") THEN BEGIN
                ERROR('Please Pay The Unused Amount First %1', GetPostedImprestBalance("Imprest To Surrender") - "Actual Spent");
            END;
        END;
    end;

    procedure SalaryRequiredFields(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            TESTFIELD(Description);
            TESTFIELD("Requested Amount");
            TESTFIELD("No. Of Months");
        END;
    end;

    procedure PopulatePVLines(PV: Record "Payment/Receipt Voucher");
    begin
        WITH PV DO BEGIN
            PVLines.RESET;
            PVLines.SETRANGE(Code, "Paying Code.");
            IF PVLines.FINDFIRST THEN BEGIN
                ERROR('You Cannot');
            END ELSE BEGIN
                ;
                PVLines.INIT;
                PVLines.Code := "Paying Code.";
                PVLines."Account Type" := "Account Type";
                PVLines."Account No." := "Account No.";
                PVLines."Account Name" := "GetVendor/CustomerName"("Account No.", "Account Type");
                IF PVLines.INSERT(TRUE) THEN BEGIN
                    MESSAGE('PV Line Successfully Added!');
                END;
            END;
        END;
    end;

    procedure Approver(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer) ApproverID: Code[90];
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApproverID := ApprovalEntry."Approver ID";
        END;
    end;

    procedure ApproverDate(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer) ApprovalDate: DateTime;
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApprovalDate := ApprovalEntry."Last Date-Time Modified";
        END;
    end;

    procedure SenderApprover(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer) ApproverID: Code[90];
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApproverID := ApprovalEntry."Sender ID";
        END;
    end;

    procedure SenderDate(TableID: Integer; "DocumentNo.": Code[30]; Sequence: Integer) ApprovalDate: DateTime;
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Table ID", TableID);
        ApprovalEntry.SETRANGE("Document No.", "DocumentNo.");
        ApprovalEntry.SETRANGE("Sequence No.", Sequence);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Approved);
        IF ApprovalEntry.FINDFIRST THEN BEGIN
            ApprovalDate := ApprovalEntry."Date-Time Sent for Approval";
        END;
    end;

    procedure ValidateAccount(RecPVLines: Record "Payment/Receipt Lines");
    begin
        PVReceipts.RESET;
        PVReceipts.SETRANGE("Paying Code.", RecPVLines.Code);
        IF PVReceipts.FINDFIRST THEN BEGIN
            IF PVReceipts."Account No." <> '' THEN BEGIN
                IF (PVReceipts."Account Type" <> RecPVLines."Account Type") THEN BEGIN
                    ERROR('Account Type Must Be %1', PVReceipts."Account Type");
                END;
                IF (PVReceipts."Account No." <> RecPVLines."Account No.") THEN BEGIN
                    ERROR('Account No. Must Be %1', PVReceipts."Account No.");
                END;
            END;
        END;
    end;

    procedure EditPVReceiptLines(RecPVLines: Record "Payment/Receipt Lines") Edit: Boolean;
    begin
        PVReceipts.RESET;
        IF PVReceipts.GET(RecPVLines.Code) THEN BEGIN
            IF PVReceipts.Status = PVReceipts.Status::Open THEN BEGIN
                Edit := TRUE;
            END;
        END ELSE BEGIN
            Edit := TRUE;
        END;
    end;

    procedure EditImprestLines(ImprestLines: Record "Imprest Lines") Edit: Boolean;
    begin
        ImprestManagement.RESET;
        IF ImprestManagement.GET(ImprestLines.Code) THEN BEGIN
            IF ImprestManagement.Status = ImprestManagement.Status::Open THEN BEGIN
                Edit := TRUE;
            END;
        END ELSE BEGIN
            Edit := TRUE;
        END;
    end;

    procedure LookUpPVLines("AccountNo.": Code[20]) VendAccountNo: Code[20];
    begin
        PVLines.RESET;
        IF PAGE.RUNMODAL(50533, PVLines) = ACTION::LookupOK THEN BEGIN
            //VendAccountNo:=PVReceipts."Paying Code.";
            MESSAGE('ajajja  %1', PVLines."Account No.");
        END;
    end;

    procedure GetUsername(MyUserID: Code[90]) Fullname: Text;
    begin
        UserSetup.RESET;
        IF UserSetup.GET(MyUserID) THEN BEGIN
            UserSetup.TESTFIELD("User Name");
            Fullname := UserSetup."User Name"
        END;
    end;

    procedure PostingImprest(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            IF Posted = TRUE THEN BEGIN
                ERROR('The Imprest No. %1 has already Been Posted!', "Imprest No.");
            END;
            IF CONFIRM('Are you sure you want to Post Imprest No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                CashMngtSetup.RESET;
                CashMngtSetup.GET;
                GenJournalBatch.INIT;
                GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
                GenJournalBatch.Name := "Imprest No.";
                IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                    GenJournalBatch.INSERT;
                END;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                GenJlLine.DELETEALL;
                CALCFIELDS("Imprest Amount");
                ShortcutDimension1Code := "Global Dimension 1 Code";
                LineNo := 1000;
                MakeJournalEntries(LineNo, "Imprest No.", Description, -"Imprest Amount", AccountType::"Bank Account", "Paying Bank Account", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice, '',
                GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                MakeJournalEntries(LineNo + 100, "Imprest No.", Description, "Imprest Amount", AccountType::Vendor, "Staff A/C", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice, '',
                GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                CashMngtSetup.GET;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date Time" := CURRENTDATETIME;
                MODIFY;
            END;
        END;
    end;

    procedure PostingImprestSurrender(ImprestManagement: Record "Imprest Management");
    var
        Imprest: Record "Imprest Management";
    begin
        WITH ImprestManagement DO BEGIN
            IF Posted = TRUE THEN BEGIN
                ERROR('The Imprest Surrender No. %1 has already Been Posted!', "Imprest No.");
            END;
            IF CONFIRM('Are you sure you want to Post Imprest Surrender No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                CashMngtSetup.RESET;
                CashMngtSetup.GET;
                GenJournalBatch.INIT;
                GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
                GenJournalBatch.Name := "Imprest No.";
                IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                    GenJournalBatch.INSERT;
                END;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                GenJlLine.DELETEALL;
                CALCFIELDS("Imprest Amount");
                CALCFIELDS("Actual Spent");
                ShortcutDimension1Code := "Global Dimension 1 Code";
                LineNo := 1000;
                MakeJournalEntries(LineNo, "Imprest No.", Description, -"Actual Spent", AccountType::Vendor, "Staff A/C", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice,
                "Applies-to Doc. No.", GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                ImprestLines.RESET;
                ImprestLines.SETRANGE(Code, "Imprest No.");
                IF ImprestLines.FINDFIRST THEN BEGIN
                    REPEAT
                        LineNo += 100;
                        MakeJournalEntries(LineNo, "Imprest No.", ImprestLines.Description, ImprestLines."Actual Spent", ImprestLines."Account Type", ImprestLines."Account No.", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice, '',
                        GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                    UNTIL ImprestLines.NEXT = 0;
                END;
                CashMngtSetup.GET;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                IF "Actual Spent" >= GetPostedImprestBalance("Imprest No.") THEN BEGIN
                    IF ImprestManagementCopy.GET("Imprest To Surrender") THEN BEGIN
                        ImprestManagementCopy.Surrendered := TRUE;
                        ImprestManagementCopy.MODIFY;
                        BudgetManagement.ReverseImprest(ImprestManagementCopy);
                    END;
                END;
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date Time" := CURRENTDATETIME;
                MODIFY;
            END;
        END;
    end;

    procedure PostingImprestClaim(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            IF Posted = TRUE THEN BEGIN
                ERROR('The Claim No. %1 has already Been Posted!', "Imprest No.");
            END;
            IF CONFIRM('Are you sure you want to Post Imprest No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                CashMngtSetup.RESET;
                CashMngtSetup.GET;
                GenJournalBatch.INIT;
                GenJournalBatch."Journal Template Name" := CashMngtSetup."Imprest Surrender Template";
                GenJournalBatch.Name := "Imprest No.";
                IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                    GenJournalBatch.INSERT;
                END;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                GenJlLine.DELETEALL;
                CALCFIELDS("Imprest Amount");
                ShortcutDimension1Code := "Global Dimension 1 Code";
                LineNo := 1000;
                MakeJournalEntries(LineNo, "Imprest No.", Description, -"Imprest Amount", AccountType::"Bank Account", "Paying Bank Account", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice, '',
                CashMngtSetup."Imprest Surrender Template", CashMngtSetup."Petty Cash Template", "Global Dimension 1 Code", "Global Dimension 2 Code");
                IF "Claim Type" = "Claim Type"::"From Imprest" THEN BEGIN
                    MakeJournalEntries(LineNo + 100, "Imprest No.", Description, "Imprest Amount", AccountType::Vendor, "Staff A/C", "Request Date", AccountType::"G/L Account", '', "Imprest Surrender No.", AppliesToDocNoType::Invoice, '',
                   GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                END;
                IF "Claim Type" = "Claim Type"::"Normal Claim" THEN BEGIN
                    ImprestLines.RESET;
                    ImprestLines.SETRANGE(Code, "Imprest No.");
                    IF ImprestLines.FINDFIRST THEN BEGIN
                        REPEAT
                            LineNo += 100;
                            MakeJournalEntries(LineNo, "Imprest No.", ImprestLines.Description, ImprestLines.Amount, ImprestLines."Account Type", ImprestLines."Account No.", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Payment, '',
                           GenJournalBatch."Journal Template Name", GenJournalBatch.Name, ImprestLinesCopy."Global Dimension 1 Code", ImprestLines."Global Dimension 2 Code");
                        UNTIL ImprestLines.NEXT = 0;
                    END;
                END;
                CashMngtSetup.GET;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date Time" := CURRENTDATETIME;
                MODIFY;
            END;
        END;
    end;

    procedure PostingPettyCash(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            IF Posted = TRUE THEN BEGIN
                ERROR('The Petty Cash No. %1 has already Been Posted!', "Imprest No.");
            END;
            IF CONFIRM('Are you sure you want to Post Petty Cash No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                CashMngtSetup.RESET;
                CashMngtSetup.GET;
                GenJournalBatch.INIT;
                GenJournalBatch."Journal Template Name" := CashMngtSetup."Petty Cash Template";
                GenJournalBatch.Name := "Imprest No.";
                IF NOT GenJournalBatch.GET(GenJournalBatch."Journal Template Name", GenJournalBatch.Name) THEN BEGIN
                    GenJournalBatch.INSERT;
                END;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                GenJlLine.DELETEALL;
                CALCFIELDS("Imprest Amount");
                ShortcutDimension1Code := "Global Dimension 1 Code";
                LineNo := 1000;
                MakeJournalEntries(LineNo, "Imprest No.", Description, -"Imprest Amount", AccountType::"Bank Account", "Paying Bank Account", "Request Date", AccountType::"G/L Account", '', '', AppliesToDocNoType::Invoice,
                 '', GenJournalBatch."Journal Template Name", GenJournalBatch.Name, "Global Dimension 1 Code", "Global Dimension 2 Code");
                ImprestLines.RESET;
                ImprestLines.SETRANGE(Code, "Imprest No.");
                IF ImprestLines.FINDFIRST THEN BEGIN
                    REPEAT
                        LineNo += 100;
                        MakeJournalEntries(LineNo, "Imprest No.", ImprestLines.Description, ImprestLines.Amount, ImprestLines."Account Type", ImprestLines."Account No.", "Request Date", AccountType::"G/L Account", '', ImprestLines."Applies to Doc. No", AppliesToDocNoType::Invoice,
                        '', GenJournalBatch."Journal Template Name", GenJournalBatch.Name, ImprestLines."Global Dimension 1 Code", ImprestLines."Global Dimension 2 Code");
                        ImprestMgt.RESET;
                        IF ImprestMgt.GET(ImprestLines."Link To Doc No.") THEN BEGIN
                            ImprestMgt.Posted := TRUE;
                            ImprestMgt."Posted By" := USERID;
                            ImprestMgt."Posted Date Time" := CURRENTDATETIME;
                            ImprestMgt."Paying Document" := "Imprest No.";
                            ImprestMgt.MODIFY;
                        END;
                    UNTIL ImprestLines.NEXT = 0;
                END;
                CashMngtSetup.GET;
                GenJlLine.RESET;
                GenJlLine.SETRANGE("Journal Template Name", GenJournalBatch."Journal Template Name");
                GenJlLine.SETRANGE("Journal Batch Name", GenJournalBatch.Name);
                CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJlLine);
                Posted := TRUE;
                "Posted By" := USERID;
                "Posted Date Time" := CURRENTDATETIME;
                MODIFY;
            END;
        END;
    end;

    procedure PopulateImprestDetails(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            Empl.RESET;
            Empl.SETRANGE("No.", ImprestManagement."Employee No");
            IF Empl.FINDFIRST THEN BEGIN
                ImprestManagement."Employee Name" := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
                ;
                ImprestManagement."Global Dimension 1 Code" := Empl."Global Dimension 1 Code";
                IF Empl."Global Dimension 1 Code" <> '' THEN BEGIN
                    DimensionValue.RESET;
                    DimensionValue.SETRANGE(Code, Empl."Global Dimension 1 Code");
                    IF DimensionValue.FINDFIRST THEN BEGIN
                        //ImprestManagement.
                    END;
                END;
                //ImprestManagement.MODIFY;
            END;
        END;
    end;

    procedure GetEmployeeName(EmployeeNo: Code[20]): Text;
    begin
        EmpName := '';
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            EmpName := Empl."First Name" + ' ' + Empl."Middle Name" + ' ' + Empl."Last Name";
            EXIT(EmpName);
        END ELSE BEGIN
            EXIT(EmpName);
        END;
    end;

    procedure GetBranchCode(EmployeeNo: Code[20]): Code[10];
    begin
        UserSetup.GET(USERID);
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            IF Empl."Global Dimension 1 Code" <> '' THEN BEGIN
                EXIT(Empl."Global Dimension 1 Code");
            END ELSE BEGIN
                EXIT(UserSetup."Global Dimension 1 Code");
            END;
        END ELSE BEGIN
            EXIT(UserSetup."Global Dimension 1 Code");
        END;
    end;

    procedure GetDepartmentCode(EmployeeNo: Code[20]): Code[10];
    begin
        UserSetup.GET(USERID);
        Empl.RESET;
        Empl.SETRANGE("No.", EmployeeNo);
        IF Empl.FINDFIRST THEN BEGIN
            IF Empl."Global Dimension 2 Code" <> '' THEN BEGIN
                EXIT(Empl."Global Dimension 2 Code");
            END ELSE BEGIN
                EXIT(UserSetup."Global Dimension 2 Code");
            END;
        END ELSE BEGIN
            EXIT(UserSetup."Global Dimension 2 Code");
        END;
    end;

    procedure GetDimensionName(GlobalDimensionCode: Code[90]; GlobalDimensionNo: Integer): Code[100];
    var
        DimnValue: Record "Dimension Value";
    begin
        IF GlobalDimensionCode <> '' THEN BEGIN
            DimensionValue.RESET;
            DimensionValue.SETRANGE("Global Dimension No.", GlobalDimensionNo);
            DimensionValue.SETRANGE(Code, GlobalDimensionCode);
            IF DimensionValue.FINDFIRST THEN BEGIN
                EXIT(DimensionValue.Name);
            END;
        END;
    end;

    procedure GetBankName(BankCode: Code[20]): Text;
    begin
        BankAccount.RESET;
        BankAccount.SETRANGE("No.", BankCode);
        IF BankAccount.FINDFIRST THEN BEGIN
            EXIT(BankAccount.Name);
        END;
    end;

    procedure CreateCustomer(Employee: Record Employee; "Account Type": Option Imprest,"Salary Advance");
    var
        AccountSelect: Code[20];
    begin
        CustAccount := '';
        WITH Employee DO BEGIN
            CashMngtSetup.GET;
            IF "Account Type" = "Account Type"::Imprest THEN BEGIN
                CashMngtSetup.TESTFIELD("Imprest Code");
                AccountSelect := CashMngtSetup."Imprest Code";
            END;
            IF "Account Type" = "Account Type"::"Salary Advance" THEN BEGIN
                CashMngtSetup.TESTFIELD("Salary Advance Code");
                AccountSelect := CashMngtSetup."Salary Advance Code";
            END;
            AccountMappingType.GET(AccountSelect);
            AccountMappingType.TESTFIELD(Prefix);
            AccountMappingType.TESTFIELD("Staff Posting Group");
            CustAccount := AccountMappingType.Prefix + '' + Employee."No.";
            IF AccountMapping.GET(AccountSelect, Employee."No.") THEN BEGIN
                MESSAGE('Employee No. %1:-%2, Already has %4 Acccount :-%3', Employee."No.", Employee."First Name", AccountMapping."Staff A/C", "Account Type");
                Vendor.GET(AccountMapping."Staff A/C");
                PAGE.RUN(21, Vendor);
            END ELSE BEGIN
                Vendor.INIT;
                Vendor."No." := CustAccount;
                Vendor.Name := Employee."First Name" + ' ' + Employee."Middle Name" + ' ' + Employee."Last Name";
                Vendor."Vendor Type" := Vendor."Vendor Type"::Staff;
                Vendor."Vendor Posting Group" := AccountMappingType."Staff Posting Group";
                Vendor."VAT Bus. Posting Group" := AccountMappingType."VAT Bus. Posting Group";
                Vendor."Gen. Bus. Posting Group" := AccountMappingType."Gen. Bus. Posting Group";
                Vendor.Address := Employee.Address;
                Vendor."Address 2" := Employee."Address 2";
                Vendor."Post Code" := Employee."Post Code";
                Vendor.City := Employee.City;
                Vendor."Country/Region Code" := Employee."Country/Region Code";
                Vendor.Image := Employee.Image;
                Vendor.INSERT;
                AccountMapping.INIT;
                AccountMapping."Account Type" := AccountMappingType.Code;
                AccountMapping."Employee No." := Employee."No.";
                AccountMapping."Staff A/C" := Vendor."No.";
                AccountMapping.INSERT;
                PAGE.RUN(26, Vendor);
            END;
        END;
    end;

    procedure GetCustomerAccount(ImprestManagement: Record "Imprest Management"): Code[20];
    begin
        WITH ImprestManagement DO BEGIN
            IF ("Transaction Type" = "Transaction Type"::Imprest) OR ("Transaction Type" = "Transaction Type"::"Imprest Surrender") THEN BEGIN
                CashMngtSetup.GET;
                CashMngtSetup.TESTFIELD("Imprest Code");
                AccountMappingType.GET(CashMngtSetup."Imprest Code");
                IF AccountMapping.GET(AccountMappingType.Code, "Employee No") THEN BEGIN
                    EXIT(AccountMapping."Staff A/C");
                END;
            END ELSE
                IF "Transaction Type" = "Transaction Type"::"Salary Advance" THEN BEGIN
                    CashMngtSetup.GET;
                    CashMngtSetup.TESTFIELD("Salary Advance Code");
                    AccountMappingType.GET(CashMngtSetup."Salary Advance Code");
                    IF AccountMapping.GET(AccountMappingType.Code, "Employee No") THEN BEGIN
                        EXIT(AccountMapping."Staff A/C");
                    END;
                END;
        END;
    end;

    procedure GetCustomerName(CustomerAccount: Code[20]): Text;
    begin
        IF Vendor.GET(CustomerAccount) THEN BEGIN
            EXIT(Vendor.Name);
        END;
    end;

    procedure GetPostedImprestBalance("ImprestNo.": Code[20]): Decimal;
    begin
        ImprestManagement.GET("ImprestNo.");
        IF ImprestManagement."Paying Document" <> '' THEN BEGIN
            "ImprestNo." := ImprestManagement."Paying Document";
        END;

        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("Vendor No.", ImprestManagement."Staff A/C");
        VendLedgEntry.SETRANGE("Document No.", "ImprestNo.");
        IF VendLedgEntry.FINDSET THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            EXIT(ABS(VendLedgEntry."Remaining Amount"));
        END;
    end;

    procedure GetVendDocumentBalance("DocumentNo.": Code[20]; Vend_CustNo: Code[10]): Decimal;
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("Vendor No.", Vend_CustNo);
        VendLedgEntry.SETRANGE("Document No.", "DocumentNo.");
        IF VendLedgEntry.FINDSET THEN BEGIN
            VendLedgEntry.CALCFIELDS("Remaining Amount");
            EXIT(ABS(VendLedgEntry."Remaining Amount"));
        END;
    end;

    procedure GetCustDocumentBalance("DocumentNo.": Code[20]; Vend_CustNo: Code[10]): Decimal;
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", Vend_CustNo);
        CustLedgerEntry.SETRANGE("Document No.", "DocumentNo.");
        IF CustLedgerEntry.FINDSET THEN BEGIN
            CustLedgerEntry.CALCFIELDS("Remaining Amount");
            EXIT(ABS(CustLedgerEntry."Remaining Amount"));
        END;
    end;

    procedure GetCustomerBalance("CustNo.": Code[20]): Decimal;
    begin
        Customer.RESET;
        IF Customer.GET("CustNo.") THEN BEGIN
            Customer.CALCFIELDS("Balance (LCY)");
            EXIT(Customer."Balance (LCY)");
        END;
    end;

    procedure "GetEmployeeNo."(UserID: Code[90]): Code[20];
    begin
        UserSetup.RESET;
        IF UserSetup.GET(UserID) THEN BEGIN
            UserSetup.TESTFIELD("Employee No.");
            EXIT(UserSetup."Employee No.");
        END;
    end;

    procedure CreateSurrenderLines(ImprestManagement: Record "Imprest Management");
    begin
        WITH ImprestManagement DO BEGIN
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest No.");
            ImprestLines.DELETEALL;
            ImprestLines.RESET;
            ImprestLines.SETRANGE(Code, "Imprest To Surrender");
            IF ImprestLines.FINDFIRST THEN BEGIN
                REPEAT
                    ImprestLinesCopy.COPY(ImprestLines);
                    ImprestLinesCopy.Code := "Imprest No.";
                    ImprestLinesCopy."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    ImprestLinesCopy."Global Dimension 2 Code" := "Global Dimension 2 Code";
                    ImprestLinesCopy.INSERT;
                UNTIL ImprestLines.NEXT = 0;
            END;
        END;
    end;

    procedure CreateImprestClaim(ImprestMgnt: Record "Imprest Management");
    begin
        WITH ImprestMgnt DO BEGIN
            IF Posted = FALSE THEN BEGIN
                ERROR('You Cannot Create A claim For Imprest Surrender That Has not been Posted!');
            END;
            CashMngtSetup.GET;
            CashMngtSetup.TESTFIELD("Imprest Code");
            RefundAmount := 0;
            IF CONFIRM('Are you sure you want to post the Payment Voucher No. ' + "Imprest No." + ' ?') = TRUE THEN BEGIN
                IF "Imprest To Surrender" <> '' THEN BEGIN
                    RefundAmount := GetPostedImprestBalance("Imprest No.");
                    IF (RefundAmount <> 0) AND (RefundAmount > 0) THEN BEGIN
                        ImprestManagementCopy.COPY(ImprestMgnt);
                        ImprestManagementCopy."Imprest No." := NoSeriesMgt.GetNextNo(CashMngtSetup."Imprest Code", TODAY, TRUE);
                        ImprestManagementCopy."Transaction Type" := ImprestManagementCopy."Transaction Type"::"Imprest Claim/Refund";
                        ImprestManagementCopy."Request Date" := TODAY;
                        ImprestManagementCopy."Requested By" := USERID;
                        ImprestManagementCopy."Claim Type" := ImprestManagementCopy."Claim Type"::"From Imprest";
                        ImprestManagementCopy."Imprest Surrender No." := "Imprest No.";
                        ImprestManagementCopy.Status := ImprestManagementCopy.Status::Open;
                        ImprestManagementCopy.Posted := FALSE;
                        ImprestManagementCopy."Posted By" := '';
                        ImprestManagementCopy."Posted Date Time" := 0DT;
                        ImprestMgnt.RESET;
                        ImprestMgnt.SETRANGE("Imprest Surrender No.", "Imprest No.");
                        IF ImprestMgnt.FINDFIRST THEN BEGIN
                            MESSAGE('Imprest Claim No. %1 Has Already been Created for this document %2', ImprestMgnt."Imprest No.", "Imprest No.");
                            PAGE.RUN(50552, ImprestMgnt);
                        END ELSE BEGIN
                            ImprestManagementCopy.INSERT;
                            ImprestLines.RESET;
                            ImprestLines.SETRANGE(Code, "Imprest No.");
                            IF ImprestLines.FINDLAST THEN BEGIN
                                ImprestLinesCopy.COPY(ImprestLines);
                                ImprestLinesCopy.Code := ImprestManagementCopy."Imprest No.";
                                ImprestLinesCopy.Quantity := 1;
                                ImprestLinesCopy."Unit Price" := RefundAmount;
                                ImprestLinesCopy.Amount := RefundAmount;
                                ImprestLinesCopy.INSERT;
                            END;
                            MESSAGE('The Imprest Surrender Sussfully Created..%1', ImprestManagementCopy."Imprest No.");
                            PAGE.RUN(50552, ImprestManagementCopy);
                        END;
                        ;
                    END;
                END;
            END;
        END;
    end;

    procedure SuggestImprest(var ImprestLines: Record "Imprest Lines");
    begin
        IF PAGE.RUNMODAL(50617, ImprestManagement) = ACTION::LookupOK THEN BEGIN
            LineNo := 1000;
            ImprestLinesCopy.RESET;
            ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
            IF ImprestLinesCopy.FINDLAST THEN BEGIN
                LineNo := ImprestLinesCopy."Line No" + 100;
            END;
            ImprestManagement.CALCFIELDS("Imprest Amount");
            ImprestLinesCopy."Line No" := LineNo;
            ImprestLinesCopy.Code := ImprestLines.Code;
            ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Vendor;
            ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
            ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
            ImprestLinesCopy."Unit Price" := ImprestManagement."Imprest Amount";
            ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
            ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
            ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
            ImprestLinesCopy.Quantity := 1;
            ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
            IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                ImprestLinesCopy.INSERT;
                LineNo += 100;
            END;
        END;
    end;

    procedure SuggestImprestClaim(var ImprestLines: Record "Imprest Lines");
    begin
        IF PAGE.RUNMODAL(50553, ImprestManagement) = ACTION::LookupOK THEN BEGIN
            LineNo := 1000;
            ImprestLinesCopy.RESET;
            ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
            IF ImprestLinesCopy.FINDLAST THEN BEGIN
                LineNo := ImprestLinesCopy."Line No" + 100;
            END;
            ImprestManagement.CALCFIELDS("Imprest Amount");
            ImprestLinesCopy."Line No" := LineNo;
            ImprestLinesCopy.Code := ImprestLines.Code;
            ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Vendor;
            ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
            ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
            ImprestLinesCopy."Unit Price" := ImprestManagement."Imprest Amount";
            ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
            ImprestLinesCopy.Quantity := 1;
            ImprestLinesCopy."Applies to Doc. No" := ImprestManagement."Imprest Surrender No.";
            ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
            ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
            ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
            IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                ImprestLinesCopy.INSERT;
                LineNo += 100;
            END;
        END;
    end;

    procedure SuggestSalaryAdvance(var ImprestLines: Record "Imprest Lines");
    begin
        IF PAGE.RUNMODAL(50567, ImprestManagement) = ACTION::LookupOK THEN BEGIN
            LineNo := 1000;
            ImprestLinesCopy.RESET;
            ImprestLinesCopy.SETRANGE(Code, ImprestLines.Code);
            IF ImprestLinesCopy.FINDLAST THEN BEGIN
                LineNo := ImprestLinesCopy."Line No" + 100;
            END;
            ImprestManagement.CALCFIELDS("Imprest Amount");
            ImprestLinesCopy."Line No" := LineNo;
            ImprestLinesCopy.Code := ImprestLines.Code;
            ImprestLinesCopy."Account Type" := ImprestLinesCopy."Account Type"::Vendor;
            ImprestLinesCopy."Account No." := ImprestManagement."Staff A/C";
            ImprestLinesCopy."Account Name" := ImprestManagement."Staff Name";
            ImprestLinesCopy."Unit Price" := ImprestManagement."Amount Approved";
            ImprestLinesCopy."Link To Doc No." := ImprestManagement."Imprest No.";
            ImprestLinesCopy."Global Dimension 1 Code" := ImprestManagement."Global Dimension 1 Code";
            ImprestLinesCopy."Global Dimension 2 Code" := ImprestManagement."Global Dimension 2 Code";
            ImprestLinesCopy.Quantity := 1;
            ImprestLinesCopy.Amount := ImprestLinesCopy."Unit Price";
            IF ImprestLinesCopy.Amount <> 0 THEN BEGIN
                ImprestLinesCopy.INSERT;
                LineNo += 100;
            END;
        END;
        //50567
    end;

    procedure InitTextVariable();
    begin
        OnesText[1] := Text002;
        OnesText[2] := Text003;
        OnesText[3] := Text004;
        OnesText[4] := Text005;
        OnesText[5] := Text006;
        OnesText[6] := Text007;
        OnesText[7] := Text008;
        OnesText[8] := Text009;
        OnesText[9] := Text010;
        OnesText[10] := Text011;
        OnesText[11] := Text012;
        OnesText[12] := Text013;
        OnesText[13] := Text014;
        OnesText[14] := Text015;
        OnesText[15] := Text016;
        OnesText[16] := Text017;
        OnesText[17] := Text018;
        OnesText[18] := Text019;
        OnesText[19] := Text020;

        TensText[1] := '';
        TensText[2] := Text021;
        TensText[3] := Text022;
        TensText[4] := Text023;
        TensText[5] := Text024;
        TensText[6] := Text025;
        TensText[7] := Text026;
        TensText[8] := Text027;
        TensText[9] := Text028;

        ExponentText[1] := '';
        ExponentText[2] := Text030;
        ExponentText[3] := Text031;
        ExponentText[4] := Text032;
    end;

    local procedure AddToNoText(var NoText: array[2] of Text[80]; var NoTextIndex: Integer; var PrintExponent: Boolean; AddText: Text[30]);
    begin
        PrintExponent := TRUE;
        WHILE STRLEN(NoText[NoTextIndex] + ' ' + AddText) > MAXSTRLEN(NoText[1]) DO BEGIN
            NoTextIndex := NoTextIndex + 1;
            IF NoTextIndex > ARRAYLEN(NoText) THEN
                ERROR(Text034, AddText);
        END;
        NoText[NoTextIndex] := DELCHR(NoText[NoTextIndex] + ' ' + AddText, '<');
    end;

    procedure FormatAmountToText(var NoText: array[2] of Text[200]; Amount: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '****';

        IF Amount < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text001)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := Amount DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text029);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                Amount := Amount - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, Text033);
        FormatDecimalToText(DescriptionLine, (Amount * 100), '');
        AddToNoText(NoText, NoTextIndex, PrintExponent, FORMAT(DescriptionLine[1]) + ' CENTS ONLY');
        IF CurrencyCode <> '' THEN BEGIN
            AddToNoText(NoText, NoTextIndex, PrintExponent, '');
        END;
    end;

    procedure FormatDecimalToText(var NoText: array[2] of Text[200]; Amount: Decimal; CurrencyCode: Code[10]);
    var
        PrintExponent: Boolean;
        Ones: Integer;
        Tens: Integer;
        Hundreds: Integer;
        Exponent: Integer;
        NoTextIndex: Integer;
    begin
        InitTextVariable;
        CLEAR(NoText);
        NoTextIndex := 1;
        NoText[1] := '';

        IF Amount < 1 THEN
            AddToNoText(NoText, NoTextIndex, PrintExponent, Text001)
        ELSE BEGIN
            FOR Exponent := 4 DOWNTO 1 DO BEGIN
                PrintExponent := FALSE;
                Ones := Amount DIV POWER(1000, Exponent - 1);
                Hundreds := Ones DIV 100;
                Tens := (Ones MOD 100) DIV 10;
                Ones := Ones MOD 10;
                IF Hundreds > 0 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Hundreds]);
                    AddToNoText(NoText, NoTextIndex, PrintExponent, Text029);
                END;
                IF Tens >= 2 THEN BEGIN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, TensText[Tens]);
                    IF Ones > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Ones]);
                END ELSE
                    IF (Tens * 10 + Ones) > 0 THEN
                        AddToNoText(NoText, NoTextIndex, PrintExponent, OnesText[Tens * 10 + Ones]);
                IF PrintExponent AND (Exponent > 1) THEN
                    AddToNoText(NoText, NoTextIndex, PrintExponent, ExponentText[Exponent]);
                Amount := Amount - (Hundreds * 100 + Tens * 10 + Ones) * POWER(1000, Exponent - 1);
            END;
        END;
        AddToNoText(NoText, NoTextIndex, PrintExponent, '');
    end;

    local procedure MarkImprestAsSurrendered(ImprestNo: Code[20]; AmountPaid: Decimal; CudtomerID: Code[20]);
    begin
        ImprestMgt.RESET;
        ImprestMgt.SETRANGE("Paying Document", ImprestNo);
        IF ImprestMgt.FINDFIRST THEN BEGIN
            ImprestMgt.CALCFIELDS("Imprest Amount");
            IF ImprestMgt."Imprest Amount" = AmountPaid THEN BEGIN
                ImprestMgt.Posted := TRUE;
                ImprestMgt."Posted Date Time" := CURRENTDATETIME;
                ImprestMgt."Posted By" := USERID;
                ImprestMgt.Surrendered := TRUE;
                ImprestMgt.MODIFY;
                BudgetManagement.ReverseImprest(ImprestMgt);
            END;
        END;
    end;

    local procedure ConfirmAppliesBalance();
    begin
    end;

    procedure ClearSalaryAdvance(CustomerNo: Code[20]; DocumentNo: Code[20]; Amount: Decimal);
    begin
        IF (Amount = GetCustDocumentBalance(DocumentNo, CustomerNo)) OR (GetCustDocumentBalance(DocumentNo, CustomerNo) = 0) THEN BEGIN
            ImprestMgt.RESET;
            ImprestMgt.SETRANGE("Paying Document", DocumentNo);
            IF ImprestMgt.FINDFIRST THEN BEGIN
                IF ImprestMgt."Transaction Type" = ImprestMgt."Transaction Type"::"Salary Advance" THEN BEGIN
                    ImprestMgt.Cleared := TRUE;
                    ImprestMgt.MODIFY;
                END;
            END;
        END;
    end;
}

