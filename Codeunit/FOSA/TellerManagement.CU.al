codeunit 50017 "Teller Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        TransactionTypes: Record 50022;
        GenJournalLine: Record 81;
        GenJournalBatch: Record 232;
        Vendor: Record 23;
        TellerGeneralSetup: Record 50021;
        Transactions: Record 50025;
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        PaymentType: Option " ",Cheque,Cash;
        TransactionCharge: Record 50023;
        LineNo: Integer;
        Vendor2: Record 23;
        AccountTypes: Record 50010;
        Member: Record 50006;
        TellerSetup: Record 50050;
        SentForApproval: Integer;
        ApprovalsMgmt: Codeunit 50012;
        Ok: Boolean;
        AccountTransferLine: Record 50052;
        WorkflowWebhookMgt: Codeunit 1543;
        CBSSetup: Record 50001;
        TreasuryCoinage: Record 50048;
        Success: Integer;
        Text000: Label 'You are almost reaching your replenishing level!';
        Text001: Label 'Transaction posted successfully';
        Error000: Label 'You are about to hit your maximum withholding amount of %1. Kindly return the excess funds back to treasury!';
        Error001: Label 'You have reached your maximum withholding level. Kindly return the excess funds back to registry before you can post this transaction!';
        Error002: Label 'You do not have enough funds to post this transaction!';
        Error003: Label 'Please specify the amount you wish to post!';
        Error004: Label 'Amount cannot be less than 0!';
        Error005: Label 'This transaction has already been posted!';
        Error006: Label 'You cannot withdraw more than the available balance!';
        Text002: Label 'This transaction will require approval. Do you wish to proceed?';
        Error007: Label 'Transaction has not yet been approved!';
        Error008: Label 'You cannot delete this record!';
        Error009: Label 'Treasury Coinage must be filled in!';
        Text003: Label 'Are you sure you want to proceed?';
        Error010: Label 'Coinage amount should tally to the transaction amount!';
        Error011: Label 'You have reached your maximum withholding amount of %1. You cannot proceed with this transaction until you return the excess funds to treasury!';
        ChequeType: Record 50026;
        Text004: Label 'Bounced Cheque Charges';
        Text005: Label 'Special Clearance Charges';
        Text006: Label 'Bounced Cheque';
        Text007: Label 'Cheque Clearance';
        Text008: Label 'Cheque Processing Fee';
        Text009: Label 'Withdrawal Commission';
        Text010: Label 'Excise Duty';
        BankAccount: Record 270;

    procedure CreateJournalLine(TransactionNo: Code[20]; Description: Text; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee; AccountNo: Code[20]; BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee; BalAccountNo: Code[20]; Amount: Decimal; Branch: Code[10]; PaymentType: Option " ",Cheque,Cash; LineNo: Integer);
    begin
        CBSSetup.GET;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := CBSSetup."Teller Template Name";
        GenJournalLine."Journal Batch Name" := CBSSetup."Teller Batch Name";
        GenJournalLine."Document No." := TransactionNo;
        GenJournalLine."External Document No." := TransactionNo;
        GenJournalLine."Line No." := LineNo;
        GenJournalLine."Account Type" := AccountType;
        GenJournalLine."Account No." := AccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Account No.");
        GenJournalLine."Shortcut Dimension 1 Code" := Branch;
        GenJournalLine.VALIDATE("Shortcut Dimension 1 Code");
        GenJournalLine."Posting Date" := TODAY;
        GenJournalLine.Description := Description;
        GenJournalLine.Amount := Amount;
        GenJournalLine.VALIDATE(GenJournalLine.Amount);
        GenJournalLine."Bal. Account Type" := BalAccountType;
        GenJournalLine."Bal. Account No." := BalAccountNo;
        GenJournalLine.VALIDATE(GenJournalLine."Bal. Account No.");
        //GenJournalLine."Payment Type" := PaymentType;
        IF GenJournalLine.Amount <> 0 THEN
            GenJournalLine.INSERT;
    end;

    procedure Post(TransactionNo: Code[20]): Boolean;
    begin
        CBSSetup.GET;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", CBSSetup."Teller Template Name");
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", CBSSetup."Teller Batch Name");
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", TransactionNo);
        if GenJournalLine.FindSet() then
            CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
    end;

    procedure ClearLines(TransactionNo: Code[20]);
    begin
        CBSSetup.GET;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", CBSSetup."Teller Template Name");
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", CBSSetup."Teller Batch Name");
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", TransactionNo);
        GenJournalLine.DELETEALL;
    end;

    procedure CheckMaxDepositWithdrawalAmounts(var Transactions: Record 50025): Integer;
    begin
        WITH Transactions DO BEGIN
            TellerSetup.GET(USERID);
            IF Deposit THEN BEGIN
                IF Amount >= TellerSetup."Max Deposit" THEN BEGIN
                    IF Status = Status::New THEN BEGIN
                        IF CONFIRM(Text002) THEN BEGIN
                            "Needs Approval" := "Needs Approval"::Yes;
                            Authorised := Authorised::No;
                            MODIFY;
                            IF ApprovalsMgmt.CheckTellerTransactionApprovalPossible(Transactions) THEN
                                ApprovalsMgmt.OnSendTellerTransactionForApproval(Transactions);
                            EXIT(1);
                        END ELSE
                            EXIT(2);
                    END;
                END;
                EXIT(0);
            END;
            IF Withdrawal THEN BEGIN
                IF Amount >= TellerSetup."Max Withdrawal" THEN BEGIN
                    IF Status = Status::New THEN BEGIN
                        IF CONFIRM(Text002) THEN BEGIN
                            "Needs Approval" := "Needs Approval"::Yes;
                            Authorised := Authorised::No;
                            MODIFY;
                            IF ApprovalsMgmt.CheckTellerTransactionApprovalPossible(Transactions) THEN
                                ApprovalsMgmt.OnSendTellerTransactionForApproval(Transactions);
                            EXIT(1);
                        END ELSE
                            EXIT(2);
                    END;
                END;
                EXIT(0);
            END;
        END;
    end;

    procedure CashDeposit(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            TellerGeneralSetup.GET;
            IF "Teller Balance" + TellerGeneralSetup."Teller Notification Level" >= TellerGeneralSetup."Teller Maximum Withholding" THEN BEGIN
                MESSAGE(Error000, TellerGeneralSetup."Teller Maximum Withholding");
            END;
            IF "Teller Balance" = TellerGeneralSetup."Teller Maximum Withholding" THEN BEGIN
                ERROR(Error011, TellerGeneralSetup."Teller Maximum Withholding");
            END;

            LineNo := 1000;
            IF Member.GET("Member No.") THEN BEGIN
                CreateJournalLine("No.", FORMAT("Transaction Type") + ' ' + FORMAT("Transacted By"), AccountType::Vendor, "Account No.", BalAccountType::"Bank Account", "Teller Tills", -Amount, Member."Global Dimension 1 Code", PaymentType::Cash, LineNo);
            END;
        END;
    end;

    procedure ChequeDeposit(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            TESTFIELD("Cheque Type");
            TESTFIELD("Bank No");
            TESTFIELD("Bank Branch No.");
            TESTFIELD("Cheque No");
            TESTFIELD("Cheque Date");

            LineNo := 1000;
            TransactionTypes.RESET;
            TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"Teller Cheque Deposit");
            IF TransactionTypes.FINDFIRST THEN BEGIN
                IF Member.GET("Member No.") THEN BEGIN
                    CreateJournalLine("No.", FORMAT("Transaction Type") + ' ' + FORMAT("Transacted By"), AccountType::"G/L Account", TransactionTypes."Sett. Control Account No.", BalAccountType::"Bank Account", "Teller Tills", -Amount,
                                       Member."Global Dimension 1 Code", PaymentType::Cheque, LineNo);
                    IF "Expected Maturity Date" = TODAY THEN BEGIN
                        "Maturity Due" := TRUE;
                        CreateJournalLine("No.", Text007, AccountType::Vendor, "Account No.", BalAccountType::"G/L Account", TransactionTypes."Sett. Control Account No.",
                                                    -Amount, Member."Global Dimension 1 Code", PaymentType::Cheque, LineNo + 1000);
                        ChequeType.GET("Cheque Type");
                        IF ChequeType."Clearing Charges" <> 0 THEN BEGIN
                            AccountTypes.RESET;
                            AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                            IF AccountTypes.FINDFIRST THEN BEGIN
                                Vendor.RESET;
                                Vendor.SETRANGE("Account Type", AccountTypes.Code);
                                Vendor.SETRANGE("Member No.", "Member No.");
                                IF Vendor.FINDFIRST THEN BEGIN
                                    IF BankAccount.GET("Teller Tills") THEN BEGIN
                                        CreateJournalLine("No.", Text008, AccountType::Vendor, Vendor."No.", BalAccountType::"G/L Account", ChequeType."Clearing Charges GL Account",
                                                                             ChequeType."Clearing Charges", BankAccount."Global Dimension 1 Code", PaymentType::Cheque, LineNo + 2000);
                                    END;
                                END;
                            END;
                        END;
                    END;
                END;
            END;

            Deposited := TRUE;
            "Deposited By" := USERID;
            "Date Deposited" := TODAY;
            "Time Deposited" := TIME;
            "Cheque Custodian" := "Teller Tills";
            MODIFY;
        END;
    end;

    procedure CashWithdrawal(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            IF "Teller Balance" <= TellerGeneralSetup."Teller Replenishing Level" THEN BEGIN
                MESSAGE(Text000);
            END;
            IF (Amount > "Teller Balance") OR ("Teller Balance" = 0) THEN BEGIN
                ERROR(Error002);
            END;
            IF Amount > "Available Balance" THEN BEGIN
                ERROR(Error006);
            END;

            LineNo := 1000;
            Member.GET("Member No.");
            CreateJournalLine("No.", FORMAT("Transaction Type") + FORMAT("Transacted By"), AccountType::Vendor, "Account No.", BalAccountType::"Bank Account", "Teller Tills", Amount, Member."Global Dimension 1 Code", PaymentType::Cash, LineNo);
            IF Member."Member Classification" = 0 THEN BEGIN
                AccountTypes.RESET;
                AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                IF AccountTypes.FINDFIRST THEN BEGIN
                    Vendor2.RESET;
                    Vendor2.SETRANGE("Member No.", "Member No.");
                    Vendor2.SETRANGE("Account Type", AccountTypes.Code);
                    IF Vendor2.FINDFIRST THEN BEGIN
                        TransactionTypes.RESET;
                        TransactionTypes.SETRANGE(Type, TransactionTypes.Type::"Teller Cash Withdrawal");
                        IF TransactionTypes.FINDFIRST THEN BEGIN
                            TransactionCharge.RESET;
                            TransactionCharge.SETRANGE("Transaction Type Code", "Transaction Type");
                            TransactionCharge.SETFILTER("Minimum Amount", '<=%1', Amount);
                            TransactionCharge.SETFILTER("Maximum Amount", '>=%1', Amount);
                            IF TransactionCharge.FINDSET THEN BEGIN
                                BankAccount.GET("Teller Tills");
                                CreateJournalLine("No.", Text009, AccountType::Vendor, Vendor2."No.", BalAccountType::"G/L Account", TransactionTypes."Settlement Account No.", TransactionCharge."Settlement Amount  (SACCO)",
                                                   BankAccount."Global Dimension 1 Code", PaymentType::Cash, LineNo + 1000);
                                IF TransactionTypes."Deduct Excise Duty" = TRUE THEN BEGIN
                                    CBSSetup.GET;
                                    CreateJournalLine("No.", Text010, AccountType::Vendor, Vendor2."No.", BalAccountType::"G/L Account", CBSSetup."Excise Duty G/L Account", TransactionCharge."Settlement Amount  (SACCO)" * (CBSSetup."Excise Duty %" / 100),
                                                       BankAccount."Global Dimension 1 Code", PaymentType::Cash, LineNo + 2000);
                                END;
                            END;
                        END;
                    END;
                END;
            END;
        END;
    end;

    procedure GetTellerTransaction(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            SentForApproval := CheckMaxDepositWithdrawalAmounts(Transactions);
            ClearLines("No.");
            IF Deposit THEN BEGIN
                CashDeposit(Transactions);
            END;
            IF Withdrawal THEN BEGIN
                CashWithdrawal(Transactions);
            END;
            IF Cheque THEN BEGIN
                ChequeDeposit(Transactions);
            END;
            IF SentForApproval = 0 THEN BEGIN
                Post("No.");
                "Date Posted" := TODAY;
                "Time Posted" := TIME;
                "Posted By" := USERID;
                Posted := TRUE;
                IF Deposit THEN BEGIN
                    Deposited := TRUE;
                    "Deposited By" := USERID;
                    "Date Deposited" := TODAY;
                    "Time Deposited" := TIME;
                END;
                IF "Maturity Due" THEN BEGIN
                    "Cheque Status" := "Cheque Status"::Honoured;
                    "Cheque Processed" := TRUE;
                    "Cleared By" := USERID;
                    "Date Cleared" := TODAY;
                    "Time Cleared" := TIME;
                    "Cheque Custodian" := "Teller Tills";
                END;
                MODIFY(TRUE);
                // COMMIT;
                Transactions.RESET;
                Transactions.SETRANGE("No.", "No.");
                IF Transactions.FINDFIRST THEN BEGIN
                    //  REPORT.RUN(50000, TRUE, FALSE, Transactions);
                END;
            END;
        END;
    end;

    procedure ProcessCheques(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            LineNo := 1000;
            TransactionTypes.GET("Transaction Type");
            ClearLines("No.");
            IF Member.GET("Teller Tills") THEN BEGIN
                CreateJournalLine("No.", Text007, AccountType::Vendor, "Account No.", BalAccountType::"G/L Account", TransactionTypes."Sett. Control Account No.",
                                                    -Amount, Member."Global Dimension 1 Code", PaymentType::Cheque, LineNo);
            END;
            ChequeType.GET("Cheque Type");
            IF ChequeType."Clearing Charges" <> 0 THEN BEGIN
                AccountTypes.RESET;
                AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                IF AccountTypes.FINDFIRST THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("Account Type", AccountTypes.Code);
                    Vendor.SETRANGE("Member No.", "Member No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        BankAccount.GET("Teller Tills");
                        CreateJournalLine("No.", Text008, AccountType::Vendor, Vendor."No.", BalAccountType::"G/L Account", ChequeType."Clearing Charges GL Account",
                                                             ChequeType."Clearing Charges", BankAccount."Global Dimension 1 Code", PaymentType::Cheque, LineNo + 1000);
                        Post("No.");
                        "Date Posted" := TODAY;
                        "Time Posted" := TIME;
                        "Posted By" := USERID;
                        Posted := TRUE;
                        "Cheque Status" := "Cheque Status"::Honoured;
                        "Cheque Processed" := TRUE;
                        "Cleared By" := USERID;
                        "Date Cleared" := TODAY;
                        "Time Cleared" := TIME;
                        "Cheque Custodian" := "Teller Tills";
                        MODIFY;
                    END;
                END;
            END;
        END;
    end;

    procedure BouncedCheques(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            LineNo := 1000;
            TransactionTypes.GET("Transaction Type");
            ClearLines("No.");
            IF Member.GET("Member No.") THEN BEGIN
                CreateJournalLine("No.", Text006, AccountType::"Bank Account", "Teller Tills", BalAccountType::"G/L Account", TransactionTypes."Sett. Control Account No.",
                                                    Amount, Member."Global Dimension 1 Code", PaymentType::Cheque, LineNo);
            END;
            ChequeType.GET("Cheque Type");
            IF ChequeType."Bounced Cheque Charges" <> 0 THEN BEGIN
                AccountTypes.RESET;
                AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                IF AccountTypes.FINDFIRST THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("Account Type", AccountTypes.Code);
                    Vendor.SETRANGE("Member No.", "Member No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        BankAccount.GET("Teller Tills");
                        CreateJournalLine("No.", Text004, AccountType::Vendor, Vendor."No.", BalAccountType::"G/L Account", ChequeType."Bounced Cheque GL Account",
                                                             ChequeType."Bounced Cheque Charges", BankAccount."Global Dimension 1 Code", PaymentType::Cheque, LineNo + 1000);
                        Post("No.");
                        "Date Posted" := TODAY;
                        "Time Posted" := TIME;
                        "Posted By" := USERID;
                        Posted := TRUE;
                        "Cheque Status" := "Cheque Status"::Honoured;
                        "Cheque Processed" := TRUE;
                        "Cleared By" := USERID;
                        "Date Cleared" := TODAY;
                        "Time Cleared" := TIME;
                        "Cheque Custodian" := "Teller Tills";
                        MODIFY;
                    END;
                END;
            END;
        END;
    end;

    procedure SpecialClearance(var Transactions: Record 50025);
    begin
        WITH Transactions DO BEGIN
            LineNo := 1000;
            TransactionTypes.GET("Transaction Type");
            ClearLines("No.");
            IF Member.GET("Member No.") THEN BEGIN
                CreateJournalLine("No.", Text007, AccountType::Vendor, "Account No.", BalAccountType::"G/L Account", TransactionTypes."Sett. Control Account No.",
                                                    -Amount, Member."Global Dimension 1 Code", PaymentType::Cheque, LineNo);
            END;
            ChequeType.GET("Cheque Type");
            IF ChequeType."Clearing Charges" <> 0 THEN BEGIN
                AccountTypes.RESET;
                AccountTypes.SETRANGE(Type, AccountTypes.Type::Savings);
                IF AccountTypes.FINDFIRST THEN BEGIN
                    Vendor.RESET;
                    Vendor.SETRANGE("Account Type", AccountTypes.Code);
                    Vendor.SETRANGE("Member No.", "Member No.");
                    IF Vendor.FINDFIRST THEN BEGIN
                        IF BankAccount.GET("Teller Tills") THEN BEGIN
                            CreateJournalLine("No.", Text005, AccountType::Vendor, Vendor."No.", BalAccountType::"G/L Account", ChequeType."Clearing Charges GL Account",
                                                                 ChequeType."Special Clearing Charges", BankAccount."Global Dimension 1 Code", PaymentType::Cheque, LineNo + 1000);
                        END;
                        Post("No.");
                        "Date Posted" := TODAY;
                        "Time Posted" := TIME;
                        "Posted By" := USERID;
                        Posted := TRUE;
                        "Cheque Status" := "Cheque Status"::Honoured;
                        "Cheque Processed" := TRUE;
                        "Cleared By" := USERID;
                        "Date Cleared" := TODAY;
                        "Time Cleared" := TIME;
                        "Cheque Custodian" := "Teller Tills";
                        MODIFY;
                    END;
                END;
            END;
        END;
    end;
}

