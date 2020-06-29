codeunit 50014 "Treasury Management"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        CBSSetup: Record 50001;
        GenJournalBatch: Record 232;
        GenJournalLine: Record 81;
        Text000: Label 'Are you sure you want to submit this request?';
        Text001: Label 'Request has been submitted succesfully.';
        Text002: Label 'Are you sure you want to issue this request?';
        Text003: Label 'Request issued successfully.';
        Text004: Label 'Are you sure you want to receive this request?';
        Text005: Label 'Receipt successful';
        Text006: Label 'Issue From Treasury';
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        PaymentType: Option " ",Cheque,Cash;
        LineNo: Integer;
        Text007: Label 'ReturnToTreasury';
        TellerShortageExcessAccount: Record 50053;
        BankAccount: Record 270;
        Text008: Label 'Close Till';
        Text009: Label 'Teller Shortage';
        Text010: Label 'Teller Excess';
        TreasuryTransactionType: Option "Issue To Teller","Return To Treasury","Receive From Bank","Return To Bank","Intertreasury transfers","Cheque Receipts","Request From Treasury","Close Till";
        CoinageEntryType: Option Positive,Negative;
        Transaction: Record 50025;
        Text011: Label 'Banking Cheques';

    procedure CreateJournalLine(No: Code[20]; Description: Text; AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee; AccountNo: Code[20]; BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee; BalAccountNo: Code[20]; Amount: Decimal; Branch: Code[10]; PaymentType: Option " ",Cheque,Cash; LineNo: Integer);
    begin
        CBSSetup.GET;
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := CBSSetup."Treasury Template Name";
        GenJournalLine."Journal Batch Name" := CBSSetup."Treasury Batch Name";
        GenJournalLine."Document No." := No;
        GenJournalLine."External Document No." := No;
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

    procedure Post(No: Code[20]);
    begin
        CBSSetup.GET;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", CBSSetup."Treasury Template Name");
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", CBSSetup."Treasury Batch Name");
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", No);
        CODEUNIT.RUN(CODEUNIT::"Gen. Jnl.-Post", GenJournalLine);
    end;

    procedure ClearLines(No: Code[20]);
    begin
        CBSSetup.GET;
        GenJournalLine.RESET;
        GenJournalLine.SETRANGE(GenJournalLine."Journal Template Name", CBSSetup."Treasury Template Name");
        GenJournalLine.SETRANGE(GenJournalLine."Journal Batch Name", CBSSetup."Treasury Batch Name");
        GenJournalLine.SETRANGE(GenJournalLine."Document No.", No);
        GenJournalLine.DELETEALL;
    end;

    procedure SendRequestFromTreasury(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            "Request Sent" := TRUE;
            "Issue Received" := "Issue Received"::No;
            Issued := Issued::No;
            MODIFY;
            MESSAGE(Text001);
        END;
    end;

    procedure IssueRequestFromTreasury(var TreasuryTransaction: Record 50047)
    begin
        with TreasuryTransaction do begin
            //  Error('ko');
            Issued := Issued::Yes;
            "Issued By" := USERID;
            "Date Issued" := TODAY;
            "Time Issued" := TIME;
            Modify(true);
            Message(Text003);
        end;
    end;

    procedure ReceiveFromTreasury(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            BankAccount.GET("Teller Account");
            BankAccount.Blocked := FALSE;
            BankAccount.MODIFY;
            ClearLines("No.");
            CreateJournalLine("No.", Text006, AccountType::"Bank Account", "Teller Account", BalAccountType::"Bank Account", "Treasury Account", Amount, "Branch Code", PaymentType::Cash, 1000);
            Post("No.");
            Posted := TRUE;
            "Posted By" := USERID;
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            "Issue Received" := "Issue Received"::Yes;
            "Received By" := USERID;
            "Time Issue Received" := TIME;
            "Date Issue Received" := TODAY;
            MODIFY(true);
            UpdateCoinageBalances("No.", "Treasury Account", "Teller Account", TreasuryTransactionType::"Issue To Teller", CoinageEntryType::Positive);
            UpdateCoinageBalances("No.", '', "Treasury Account", TreasuryTransactionType::"Issue To Teller", CoinageEntryType::Negative);
            MESSAGE(Text005);
        END;
    end;

    procedure ReturnToTreasury(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            ClearLines("No.");
            CreateJournalLine("No.", Text007, AccountType::"Bank Account", "Teller Account", BalAccountType::"Bank Account", "Treasury Account", -Amount, "Branch Code", PaymentType::Cash, 1000);
            Post("No.");
            Posted := TRUE;
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            "Posted By" := USERID;
            MODIFY;
            UpdateCoinageBalances("No.", "Teller Account", "Treasury Account", TreasuryTransactionType::"Return To Treasury", CoinageEntryType::Positive);
            UpdateCoinageBalances("No.", '', "Teller Account", TreasuryTransactionType::"Return To Treasury", CoinageEntryType::Negative);
        END;
    end;

    procedure CloseTill(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            ClearLines("No.");
            IF (Amount + "Cheque Amount") = "Till Balance" THEN BEGIN
                CreateJournalLine("No.", Text008, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account",
                                   "Teller Account", Amount, "Branch Code", PaymentType::Cash, LineNo);
            END;
            TellerShortageExcessAccount.RESET;
            TellerShortageExcessAccount.SETRANGE(Branch, "Branch Code");
            IF TellerShortageExcessAccount.FINDSET THEN BEGIN
                REPEAT
                    IF TellerShortageExcessAccount.Type = TellerShortageExcessAccount.Type::Shortage THEN BEGIN
                        IF (Amount + "Cheque Amount") < "Till Balance" THEN BEGIN
                            LineNo += 2000;
                            CreateJournalLine("No.", Text009, AccountType::"G/L Account", TellerShortageExcessAccount."G/L Account", BalAccountType::"Bank Account",
                                               "Teller Account", ("Till Balance" - (Amount + "Cheque Amount")), "Branch Code", PaymentType::Cash, LineNo);
                            CreateJournalLine("No.", Text008, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account",
                                               "Teller Account", (Amount + "Cheque Amount"), "Branch Code", PaymentType::Cash, LineNo + 1000);
                        END;
                    END;
                    IF TellerShortageExcessAccount.Type = TellerShortageExcessAccount.Type::Excess THEN BEGIN
                        IF (Amount + "Cheque Amount") > "Till Balance" THEN BEGIN
                            LineNo += 1000;
                            CreateJournalLine("No.", Text010, AccountType::"G/L Account", TellerShortageExcessAccount."G/L Account", BalAccountType::"Bank Account",
                                               "Teller Account", ("Till Balance" - (Amount + "Cheque Amount")), "Branch Code", PaymentType::Cash, LineNo);
                            CreateJournalLine("No.", Text008, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account",
                                               "Teller Account", (Amount + "Cheque Amount"), "Branch Code", PaymentType::Cash, LineNo + 1000);
                        END;
                    END;
                UNTIL TellerShortageExcessAccount.NEXT = 0;
            END;
            IF "Cheque Amount" <> 0 THEN BEGIN
                CreateJournalLine("No.", Text008, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account",
                                  "Teller Account", "Cheque Amount", "Branch Code", PaymentType::Cheque, LineNo + 1000);
                Transaction.RESET;
                Transaction.SETRANGE("Teller Tills", "Teller Account");
                Transaction.SETRANGE(Cheque, TRUE);
                Transaction.SETRANGE("Transaction Date", TODAY);
                IF Transaction.FINDSET THEN BEGIN
                    REPEAT
                        Transaction."Cheque Custodian" := "Treasury Account";
                        Transaction.MODIFY;
                    UNTIL Transaction.NEXT = 0;
                END;

            END;
            Post("No.");
            Posted := TRUE;
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            "Posted By" := USERID;
            MODIFY;
            BankAccount.GET("Teller Account");
            BankAccount.Blocked := TRUE;
            BankAccount.MODIFY;
            UpdateCoinageBalances("No.", "Teller Account", "Treasury Account", TreasuryTransactionType::"Close Till", CoinageEntryType::Positive);
            UpdateCoinageBalances("No.", '', "Teller Account", TreasuryTransactionType::"Close Till", CoinageEntryType::Negative);
        END;

    end;

    procedure ReceiveFromBank(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            LineNo := 1000;
            ClearLines("No.");
            CreateJournalLine("No.", Description, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account", "Bank No", Amount, "Branch Code", PaymentType::Cash, LineNo);
            Post("No.");
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            Posted := TRUE;
            "Posted By" := USERID;
            "Received By" := USERID;
            MODIFY;
            UpdateCoinageBalances("No.", "Bank No", "Treasury Account", TreasuryTransactionType::"Receive From Bank", CoinageEntryType::Positive);
        END;
    end;

    procedure ReturnToBank(var TreasuryTransaction: Record 50047);
    begin
        WITH TreasuryTransaction DO BEGIN
            LineNo := 1000;
            ClearLines("No.");
            CreateJournalLine("No.", Description, AccountType::"Bank Account", "Treasury Account", BalAccountType::"Bank Account", "Bank No", -Amount, "Branch Code", PaymentType::Cash, LineNo);
            Post("No.");
            "Date Posted" := TODAY;
            "Time Posted" := TIME;
            Posted := TRUE;
            "Posted By" := USERID;
            MODIFY;
            UpdateCoinageBalances("No.", "Treasury Account", "Bank No", TreasuryTransactionType::"Return To Bank", CoinageEntryType::Positive);
            UpdateCoinageBalances("No.", '', "Treasury Account", TreasuryTransactionType::"Return To Bank", CoinageEntryType::Negative);
        END;
    end;

    local procedure UpdateCoinageBalances(TransactionID: Code[20]; FromBank: Code[20]; ToBank: Code[20]; TransactionType: Option "Issue To Teller","Return To Treasury","Receive From Bank","Return To Bank","Intertreasury transfers","Cheque Receipts","Request From Treasury","Close Till"; EntryType: Option Positive,Negative);
    var
        CoinageBalance: Record 50051;
        TreasuryCoinage: Record 50048;
    begin
        TreasuryCoinage.RESET;
        TreasuryCoinage.SETRANGE("No.", TransactionID);
        IF TreasuryCoinage.FINDSET THEN BEGIN
            REPEAT
                CoinageBalance.INIT;
                CoinageBalance."Bank No" := ToBank;
                CoinageBalance.Code := TreasuryCoinage.Code;
                CoinageBalance."Request ID" := TreasuryCoinage."No.";
                CoinageBalance.Type := TreasuryCoinage.Type;
                CoinageBalance.Value := TreasuryCoinage.Value;
                CoinageBalance.Quantity := TreasuryCoinage.Quantity;
                CoinageBalance.VALIDATE(Quantity);
                IF EntryType = EntryType::Negative THEN BEGIN
                    CoinageBalance.Quantity := -TreasuryCoinage.Quantity;
                END;
                CoinageBalance.Description := TreasuryCoinage.Description;
                CoinageBalance."Received From" := FromBank;
                CoinageBalance."Entry Type" := EntryType;
                CoinageBalance."Posting Date" := TODAY;
                CoinageBalance.INSERT;
            UNTIL TreasuryCoinage.NEXT = 0;
        END;
    end;

    procedure BankingCheques(var Transaction: Record 50025);
    begin
        WITH Transaction DO BEGIN
            LineNo := 1000;
            ClearLines("No.");
            CreateJournalLine("No.", Text011, AccountType::"Bank Account", "Cheque Custodian", BalAccountType::"Bank Account",
                              "Destination Bank", Amount, "Global Dimension 1 Code", PaymentType::Cheque, LineNo);
            Post("No.");
            "Banked By" := USERID;
            "Date Banked" := TODAY;
            "Time Banked" := TIME;
            "Banking Posted" := TRUE;
            "Cheque Custodian" := "Destination Bank";
            MODIFY;
        END;
    end;
}

