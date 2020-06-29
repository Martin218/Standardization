codeunit 50027 "TL-Post Gen Jnl"
{
    // version TL 2.0

    Permissions = TableData 17 = rimd,
                  TableData 25 = rimd,
                  TableData 45 = rimd,
                  TableData 271 = rimd,
                  TableData 380 = rimd;

    trigger OnRun();
    begin
    end;

    var
        GLEntry: Record "G/L Entry";
        GLSetup: Record "General Ledger Setup";
        GlobalGLEntry: Record "G/L Entry";
        TempGLEntryBuf: Record "G/L Entry" temporary;
        TempGLEntryVAT: Record "G/L Entry" temporary;
        GLReg: Record "G/L Register";
        AddCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        VATEntry: Record "VAT Entry";
        TaxDetail: Record "Tax Detail";
        UnrealizedCustLedgEntry: Record "Cust. Ledger Entry";
        UnrealizedVendLedgEntry: Record "Vendor Ledger Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        TempVATEntry: Record "VAT Entry" temporary;
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        PaymentToleranceMgt: Codeunit "Payment Tolerance Management";
        DeferralUtilities: Codeunit "Deferral Utilities";
        DeferralDocType: Option Purchase,Sales,"G/L";
        LastDocType: Option " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder;
        AddCurrencyCode: Code[10];
        GLSourceCode: Code[10];
        LastDocNo: Code[20];
        FiscalYearStartDate: Date;
        CurrencyDate: Date;
        LastDate: Date;
        BalanceCheckAmount: Decimal;
        BalanceCheckAmount2: Decimal;
        BalanceCheckAddCurrAmount: Decimal;
        BalanceCheckAddCurrAmount2: Decimal;
        CurrentBalance: Decimal;
        TotalAddCurrAmount: Decimal;
        TotalAmount: Decimal;
        UnrealizedRemainingAmountCust: Decimal;
        UnrealizedRemainingAmountVend: Decimal;
        AmountRoundingPrecision: Decimal;
        AddCurrGLEntryVATAmt: Decimal;
        CurrencyFactor: Decimal;
        FirstEntryNo: Integer;
        NextEntryNo: Integer;
        LastEntryNo: Integer;
        NextVATEntryNo: Integer;
        FirstNewVATEntryNo: Integer;
        FirstTransactionNo: Integer;
        NextTransactionNo: Integer;
        NextConnectionNo: Integer;
        NextCheckEntryNo: Integer;
        InsertedTempGLEntryVAT: Integer;
        GLEntryNo: Integer;
        UseCurrFactorOnly: Boolean;
        NonAddCurrCodeOccured: Boolean;
        FADimAlreadyChecked: Boolean;
        OverrideDimErr: Boolean;
        JobLine: Boolean;
        CheckUnrealizedCust: Boolean;
        CheckUnrealizedVend: Boolean;
        GLSetupRead: Boolean;
        IsGLRegInserted: Boolean;
        Text000: Label 'cannot be filtered when posting recurring journals';
        Text001: Label 'Do you want to post the journal lines?';
        Text002: Label 'There is nothing to post.';
        Text003: Label 'The journal lines were successfully posted.';
        Text004: Label 'The journal lines were successfully posted. You are now in the %1 journal.';
        Text005: Label 'Using %1 for Declining Balance can result in misleading numbers for subsequent years. You should manually check the postings and correct them if necessary. Do you want to continue?';
        Text006: Label '%1 in %2 must not be equal to %3 in %4.', Comment = 'Source Code in Genenral Journal Template must not be equal to Job G/L WIP in Source Code Setup.';
        GLRigisterEntryNo: Integer;
        BankPaymentTypeMustNotBeFilledErr: Label 'Bank Payment Type must not be filled if Currency Code is different in Gen. Journal Line and Bank Account.';
        DocNoMustBeEnteredErr: Label 'Document No. must be entered when Bank Payment Type is %1.';
        CheckAlreadyExistsErr: Label 'Check %1 already exists for this Bank Account.';
        BLNextEntryNo: Integer;
        LastAmount: Decimal;

    procedure RunPostingGenJnl(var GenJnlLine2: Record "Gen. Journal Line" temporary; JournalName: Code[20]; JournalBatch: Code[20]);
    var
        GenJnlLine: Record "Gen. Journal Line" temporary;
        Window: Dialog;
        AllRecords: Integer;
        CurentRec: Integer;
        CopyGenJnlLine: Record "Gen. Journal Line" temporary;
        AmountBal: Decimal;
    begin
        //=============VALIDATING JOURNAL LINES=====================
        AmountBal := 0;
        Window.OPEN('Please Wait while the System is Validating Journal!!');
        GenJnlLine2.SETRANGE("Journal Template Name", JournalName);
        GenJnlLine2.SETRANGE("Journal Batch Name", JournalBatch);
        IF GenJnlLine2.FINDFIRST THEN BEGIN
            REPEAT
                AmountBal := AmountBal + GenJnlLine2.Amount;
            UNTIL GenJnlLine2.NEXT = 0;
        END;
        Window.CLOSE;
        IF AmountBal <> 0 THEN BEGIN
            ERROR('The Journal is out of Balance by %1 for Document: %2', AmountBal, GenJnlLine2."Document No.");
        END;
        //===================================
        IsGLRegInserted := TRUE;
        GLRigisterEntryNo := 0;
        Window.OPEN('Posting Journal Batch: #1### Posting @2@@@@ Posting Journal Line #3###');
        AllRecords := 0;
        CurentRec := 0;
        GetGLSetup;
        GenJnlLine2.SETRANGE("Journal Template Name", JournalName);
        GenJnlLine2.SETRANGE("Journal Batch Name", JournalBatch);
        AllRecords := GenJnlLine2.COUNT;
        GenJnlLine2.SETCURRENTKEY("Line No.");
        GenJnlLine2.ASCENDING(TRUE);
        IF GenJnlLine2.FINDFIRST THEN BEGIN
            REPEAT
                Window.UPDATE(1, GenJnlLine2."Journal Batch Name");
                CurentRec += 1;
                Window.UPDATE(2, ((CurentRec / AllRecords) * 10000) DIV 1);
                Window.UPDATE(3, GenJnlLine2."Line No.");
                Code(GenJnlLine2, TRUE);
            UNTIL GenJnlLine2.NEXT = 0;
            FinishPosting;
            Window.CLOSE();
            CLEAR(GenJnlLine2);
            //MESSAGE('Journal Batch Successfully Posted!');
        END;
    end;

    procedure Postme(TempGenJournalLine: Record "Gen. Journal Line" temporary);
    begin
        WITH TempGenJournalLine DO BEGIN
            IF "Account No." <> '' THEN BEGIN
                GLEntry.RESET;
                GLEntry.SETCURRENTKEY("Entry No.");
                GLEntry.ASCENDING(FALSE);
                IF GLEntry.FINDFIRST THEN BEGIN
                END;
            END;
        END;
    end;

    local procedure "Code"(var GenJnlLine: Record "Gen. Journal Line" temporary; CheckLine: Boolean);
    var
        Balancing: Boolean;
        IsTransactionConsistent: Boolean;
    begin
        GetGLSourceCode;
        StartPosting(GenJnlLine);
        WITH GenJnlLine DO BEGIN
            IF EmptyLine THEN BEGIN
                InitLastDocDate(GenJnlLine);
                EXIT;
            END;
            PostGenJnlLine(GenJnlLine, Balancing);
        END;
    end;

    local procedure PostGLAcc(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean);
    var
        GLAcc: Record "G/L Account";
        GLEntry: Record "G/L Entry";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        WITH GenJnlLine DO BEGIN
            GLAcc.GET("Account No.");
            GLAcc.TESTFIELD(Blocked, FALSE);
            GLAcc.TESTFIELD("Account Type", GLAcc."Account Type"::Posting);
            GLEntry.INIT;
            InitGLEntry(GenJnlLine, GLEntry, "Account No.", "Amount (LCY)", "Source Currency Amount", TRUE, "System-Created Entry");
            GLEntry.INSERT;
            GlobalGLEntry := GLEntry;
        END;
    end;

    local procedure InitGLEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var GLEntry: Record "G/L Entry"; GLAccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; UseAmountAddCurr: Boolean; SystemCreatedEntry: Boolean);
    var
        GLAcc: Record "G/L Account";
    begin
        WITH GLEntry DO BEGIN
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Date" := GenJnlLine."Document Date";
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            "External Document No." := GenJnlLine."External Document No.";
            Description := GenJnlLine.Description;
            "Business Unit Code" := GenJnlLine."Business Unit Code";
            "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := GenJnlLine."Dimension Set ID";
            "Source Code" := GenJnlLine."Source Code";
            IF GenJnlLine."Account Type" = GenJnlLine."Account Type"::"G/L Account" THEN BEGIN
                "Source Type" := GenJnlLine."Source Type";
                "Source No." := GenJnlLine."Source No.";
            END;
            IF (GenJnlLine."Account Type" = GenJnlLine."Account Type"::"IC Partner") OR
            (GenJnlLine."Bal. Account Type" = GenJnlLine."Bal. Account Type"::"IC Partner")
            THEN
                "Source Type" := "Source Type"::" ";
            "Job No." := GenJnlLine."Job No.";
            Quantity := GenJnlLine.Quantity;
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "User ID" := USERID;
            "No. Series" := GenJnlLine."Posting No. Series";
            "IC Partner Code" := GenJnlLine."IC Partner Code";
            //"Transaction Time" := TIME;
            //"Creation Date" := TODAY;
            ;
        END;
        GLAccNo := GenJnlLine."Account No.";
        GLEntry."Entry No." := NextEntryNo;
        GLEntry."Transaction No." := NextTransactionNo;
        GLEntry."G/L Account No." := GLAccNo;
        GLEntry."System-Created Entry" := SystemCreatedEntry;
        GLEntry.Amount := Amount;
        IF GLEntry.Amount < 0 THEN BEGIN
            GLEntry."Credit Amount" := -Amount;
        END ELSE BEGIN
            GLEntry."Debit Amount" := Amount;
        END;
    end;

    procedure PostVend(GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean);
    var
        Vend: Record Vendor;
        VendPostingGr: Record "Vendor Posting Group";
        VendLedgEntry: Record "Vendor Ledger Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldVendLedgEntry: Record "Detailed Vendor Ledg. Entry";
        PayablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
        CheckExtDocNoHandled: Boolean;
    begin
        WITH GenJnlLine DO BEGIN
            Vend.GET("Account No.");
            Vend.CheckBlockedVendOnJnls(Vend, "Document Type", TRUE);
            IF "Posting Group" = '' THEN BEGIN
                Vend.TESTFIELD("Vendor Posting Group");
                "Posting Group" := Vend."Vendor Posting Group";
            END;
            VendPostingGr.GET("Posting Group");
            PayablesAccount := VendPostingGr.GetPayablesAccount;
            DtldVendLedgEntry.LOCKTABLE;
            VendLedgEntry.LOCKTABLE;
            InitVendLedgEntry(GenJnlLine, VendLedgEntry);
            PostDtldVendtLedgEntry(GenJnlLine, VendLedgEntry);
            VendLedgEntry."Amount to Apply" := 0;
            VendLedgEntry."Applies-to Doc. No." := '';
            VendLedgEntry.INSERT(TRUE);
            CreateGLEntryVend(
              GenJnlLine, PayablesAccount, "Amount (LCY)", "Source Currency Amount",
              "Bal. Account Type"::Vendor, "Account No.");
        END;
    end;

    procedure PostCust(var GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean);
    var
        LineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist.";
        Cust: Record Customer;
        CustPostingGr: Record "Customer Posting Group";
        CustLedgEntry: Record "Cust. Ledger Entry";
        CVLedgEntryBuf: Record "CV Ledger Entry Buffer";
        TempDtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer" temporary;
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        ReceivablesAccount: Code[20];
        DtldLedgEntryInserted: Boolean;
    begin
        WITH GenJnlLine DO BEGIN
            Cust.GET("Account No.");
            Cust.CheckBlockedCustOnJnls(Cust, "Document Type", TRUE);
            IF "Posting Group" = '' THEN BEGIN
                Cust.TESTFIELD("Customer Posting Group");
                "Posting Group" := Cust."Customer Posting Group";
            END;
            CustPostingGr.GET("Posting Group");
            ReceivablesAccount := CustPostingGr.GetReceivablesAccount;
            DtldCustLedgEntry.LOCKTABLE;
            CustLedgEntry.LOCKTABLE;
            InitCustLedgEntry(GenJnlLine, CustLedgEntry);
            PostDtldCustLedgEntry(GenJnlLine, CustLedgEntry);
            CustLedgEntry."Amount to Apply" := 0;
            CustLedgEntry."Applies-to Doc. No." := '';
            CustLedgEntry.INSERT(TRUE);
            CreateGLEntryCust(
              GenJnlLine, ReceivablesAccount, "Amount (LCY)", "Source Currency Amount",
              "Bal. Account Type"::Customer, "Account No.");
        END;
    end;

    procedure PostBankAcc(var GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean);
    var
        BankAcc: Record "Bank Account";
        BankAccLedgEntry: Record "Bank Account Ledger Entry";
        CheckLedgEntry: Record "Check Ledger Entry";
        CheckLedgEntry2: Record "Check Ledger Entry";
        BankAccPostingGr: Record "Bank Account Posting Group";
    begin
        WITH GenJnlLine DO BEGIN
            BankAcc.GET("Account No.");
            BankAcc.TESTFIELD(Blocked, FALSE);
            IF "Currency Code" = '' THEN
                BankAcc.TESTFIELD("Currency Code", '')
            ELSE
                IF BankAcc."Currency Code" <> '' THEN
                    TESTFIELD("Currency Code", BankAcc."Currency Code");

            BankAcc.TESTFIELD("Bank Acc. Posting Group");
            BankAccPostingGr.GET(BankAcc."Bank Acc. Posting Group");

            BankAccLedgEntry.LOCKTABLE;
            InitBankAccLedgEntry(GenJnlLine, BankAccLedgEntry);
            BankAccLedgEntry."Bank Acc. Posting Group" := BankAcc."Bank Acc. Posting Group";
            BankAccLedgEntry."Currency Code" := BankAcc."Currency Code";
            IF BankAcc."Currency Code" <> '' THEN
                BankAccLedgEntry.Amount := Amount
            ELSE
                BankAccLedgEntry.Amount := "Amount (LCY)";
            BankAccLedgEntry."Amount (LCY)" := "Amount (LCY)";
            BankAccLedgEntry.Open := Amount <> 0;
            BankAccLedgEntry."Remaining Amount" := BankAccLedgEntry.Amount;
            BankAccLedgEntry.Positive := Amount > 0;
            BankAccLedgEntry.UpdateDebitCredit(Correction);
            IF BankAccLedgEntry.INSERT(TRUE) THEN BEGIN
                BLNextEntryNo += 1;
            END;

            IF ((Amount <= 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Computer Check") AND "Check Printed") OR
               ((Amount < 0) AND ("Bank Payment Type" = "Bank Payment Type"::"Manual Check"))
            THEN BEGIN
                IF BankAcc."Currency Code" <> "Currency Code" THEN
                    ERROR(BankPaymentTypeMustNotBeFilledErr);
                CASE "Bank Payment Type" OF
                    "Bank Payment Type"::"Computer Check":
                        BEGIN
                            TESTFIELD("Check Printed", TRUE);
                            CheckLedgEntry.LOCKTABLE;
                            CheckLedgEntry.RESET;
                            CheckLedgEntry.SETCURRENTKEY("Bank Account No.", "Entry Status", "Check No.");
                            CheckLedgEntry.SETRANGE("Bank Account No.", "Account No.");
                            CheckLedgEntry.SETRANGE("Entry Status", CheckLedgEntry."Entry Status"::Printed);
                            CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                            IF CheckLedgEntry.FINDSET THEN
                                REPEAT
                                    CheckLedgEntry2 := CheckLedgEntry;
                                    CheckLedgEntry2."Entry Status" := CheckLedgEntry2."Entry Status"::Posted;
                                    CheckLedgEntry2."Bank Account Ledger Entry No." := BankAccLedgEntry."Entry No.";
                                    CheckLedgEntry2.MODIFY;
                                UNTIL CheckLedgEntry.NEXT = 0;
                        END;
                    "Bank Payment Type"::"Manual Check":
                        BEGIN
                            IF "Document No." = '' THEN
                                ERROR(DocNoMustBeEnteredErr, "Bank Payment Type");
                            CheckLedgEntry.RESET;
                            IF NextCheckEntryNo = 0 THEN BEGIN
                                CheckLedgEntry.LOCKTABLE;
                                IF CheckLedgEntry.FINDLAST THEN
                                    NextCheckEntryNo := CheckLedgEntry."Entry No." + 1
                                ELSE
                                    NextCheckEntryNo := 1;
                            END;

                            CheckLedgEntry.SETRANGE("Bank Account No.", "Account No.");
                            CheckLedgEntry.SETFILTER(
                              "Entry Status", '%1|%2|%3',
                              CheckLedgEntry."Entry Status"::Printed,
                              CheckLedgEntry."Entry Status"::Posted,
                              CheckLedgEntry."Entry Status"::"Financially Voided");
                            CheckLedgEntry.SETRANGE("Check No.", "Document No.");
                            IF NOT CheckLedgEntry.ISEMPTY THEN
                                ERROR(CheckAlreadyExistsErr, "Document No.");

                            InitCheckLedgEntry(BankAccLedgEntry, CheckLedgEntry);
                            CheckLedgEntry."Bank Payment Type" := CheckLedgEntry."Bank Payment Type"::"Manual Check";
                            IF BankAcc."Currency Code" <> '' THEN
                                CheckLedgEntry.Amount := -Amount
                            ELSE
                                CheckLedgEntry.Amount := -"Amount (LCY)";
                            CheckLedgEntry.INSERT(TRUE);
                            NextCheckEntryNo := NextCheckEntryNo + 1;
                        END;
                END;
            END;
            BankAccPostingGr.TESTFIELD("G/L Account No.");
            CreateGLEntryBalAcc(
              GenJnlLine, BankAccPostingGr."G/L Account No.", "Amount (LCY)", "Source Currency Amount",
              "Bal. Account Type"::"Bank Account", "Account No.");
        END;
    end;

    local procedure InitCustLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var CustLedgEntry: Record "Cust. Ledger Entry");
    begin
        WITH CustLedgEntry DO BEGIN
            "Customer No." := GenJnlLine."Account No.";
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Date" := GenJnlLine."Document Date";
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            "External Document No." := GenJnlLine."External Document No.";
            Description := GenJnlLine.Description;
            "Currency Code" := GenJnlLine."Currency Code";
            "Sales (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
            "Profit (LCY)" := GenJnlLine."Profit (LCY)";
            "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
            "Sell-to Customer No." := GenJnlLine."Sell-to/Buy-from No.";
            "Customer Posting Group" := GenJnlLine."Posting Group";
            "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := GenJnlLine."Dimension Set ID";
            "Salesperson Code" := GenJnlLine."Salespers./Purch. Code";
            "Source Code" := GenJnlLine."Source Code";
            "On Hold" := GenJnlLine."On Hold";
            "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
            "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
            "Due Date" := GenJnlLine."Due Date";
            "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
            "Applies-to ID" := GenJnlLine."Applies-to ID";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Direct Debit Mandate ID" := GenJnlLine."Direct Debit Mandate ID";
            "User ID" := USERID;
            "Bal. Account Type" := GenJnlLine."Bal. Account Type";
            "Bal. Account No." := GenJnlLine."Bal. Account No.";
            "No. Series" := GenJnlLine."Posting No. Series";
            "IC Partner Code" := GenJnlLine."IC Partner Code";
            Prepayment := GenJnlLine.Prepayment;
            "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
            "Message to Recipient" := GenJnlLine."Message to Recipient";
            "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
            "Payment Method Code" := GenJnlLine."Payment Method Code";
            "Exported to Payment File" := GenJnlLine."Exported to Payment File";
        END;
        CustLedgEntry."Entry No." := NextEntryNo;
        CustLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure PostDtldCustLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; CustLedgerEntry: Record "Cust. Ledger Entry");
    var
        DetailedCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
        CLNextEntryNo: Integer;
        DtCustLedEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        IF CLNextEntryNo = 0 THEN BEGIN
            DtCustLedEntry.RESET;
            DtCustLedEntry.SETASCENDING("Entry No.", FALSE);
            IF DtCustLedEntry.FINDFIRST THEN BEGIN
                CLNextEntryNo := DtCustLedEntry."Entry No." + 1;
            END ELSE BEGIN
                CLNextEntryNo := 1;
            END;
        END;
        WITH DetailedCustLedgEntry DO BEGIN
            "Entry No." := CLNextEntryNo;
            "Transaction No." := NextTransactionNo;
            "Cust. Ledger Entry No." := CustLedgerEntry."Entry No.";
            "Customer No." := GenJnlLine."Account No.";
            "Entry Type" := "Entry Type"::"Initial Entry";
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            Amount := GenJnlLine.Amount;
            IF Amount < 0 THEN BEGIN
                "Credit Amount" := -GenJnlLine.Amount;
                "Credit Amount (LCY)" := -GenJnlLine."Amount (LCY)";
            END ELSE BEGIN
                "Debit Amount" := GenJnlLine.Amount;
                "Debit Amount (LCY)" := GenJnlLine."Amount (LCY)";
            END;
            "Ledger Entry Amount" := TRUE;
            "Amount (LCY)" := GenJnlLine."Amount (LCY)";
            "Currency Code" := GenJnlLine."Currency Code";
            "User ID" := USERID;
            "Initial Entry Due Date" := GenJnlLine."Due Date";
            "Initial Entry Global Dim. 1" := GenJnlLine."Shortcut Dimension 1 Code";
            "Initial Entry Global Dim. 2" := GenJnlLine."Shortcut Dimension 2 Code";
            "Initial Document Type" := GenJnlLine."Document Type";
            INSERT;
            CLNextEntryNo += 1;
        END;
    end;

    local procedure PostDtldCVLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; AccNo: Code[20]; var AdjAmount: array[4] of Decimal; Unapply: Boolean);
    begin
        WITH DtldCVLedgEntryBuffer DO BEGIN

        END;
    end;

    local procedure InsertDtldVendLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"; var DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry"; Offset: Integer);
    begin
        WITH DtldCustLedgEntry DO BEGIN
            INIT;
            TRANSFERFIELDS(DtldCVLedgEntryBuf);
            "Entry No." := Offset + DtldCVLedgEntryBuf."Entry No.";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Source Code" := GenJnlLine."Source Code";
            "Transaction No." := NextTransactionNo;
            UpdateDebitCredit(GenJnlLine.Correction);
            INSERT(TRUE);
        END;
    end;

    local procedure InitVendLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var VendLedgEntry: Record "Vendor Ledger Entry");
    begin
        WITH VendLedgEntry DO BEGIN
            "Vendor No." := GenJnlLine."Account No.";
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Date" := GenJnlLine."Document Date";
            //"Transaction Time" := TIME;
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            "External Document No." := GenJnlLine."External Document No.";
            Description := GenJnlLine.Description;
            "Currency Code" := GenJnlLine."Currency Code";
            "Purchase (LCY)" := GenJnlLine."Sales/Purch. (LCY)";
            "Inv. Discount (LCY)" := GenJnlLine."Inv. Discount (LCY)";
            "Buy-from Vendor No." := GenJnlLine."Sell-to/Buy-from No.";
            "Vendor Posting Group" := GenJnlLine."Posting Group";
            "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := GenJnlLine."Dimension Set ID";
            "Purchaser Code" := GenJnlLine."Salespers./Purch. Code";
            "Source Code" := GenJnlLine."Source Code";
            "On Hold" := GenJnlLine."On Hold";
            "Applies-to Doc. Type" := GenJnlLine."Applies-to Doc. Type";
            "Applies-to Doc. No." := GenJnlLine."Applies-to Doc. No.";
            "Due Date" := GenJnlLine."Due Date";
            "Pmt. Discount Date" := GenJnlLine."Pmt. Discount Date";
            "Applies-to ID" := GenJnlLine."Applies-to ID";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "User ID" := USERID;
            "Bal. Account Type" := GenJnlLine."Bal. Account Type";
            "Bal. Account No." := GenJnlLine."Bal. Account No.";
            "No. Series" := GenJnlLine."Posting No. Series";
            "IC Partner Code" := GenJnlLine."IC Partner Code";
            Prepayment := GenJnlLine.Prepayment;
            "Recipient Bank Account" := GenJnlLine."Recipient Bank Account";
            "Message to Recipient" := GenJnlLine."Message to Recipient";
            "Applies-to Ext. Doc. No." := GenJnlLine."Applies-to Ext. Doc. No.";
            "Creditor No." := GenJnlLine."Creditor No.";
            "Payment Reference" := GenJnlLine."Payment Reference";
            "Payment Method Code" := GenJnlLine."Payment Method Code";
            "Exported to Payment File" := GenJnlLine."Exported to Payment File";
            //"Transaction Type" := GenJnlLine."Transaction Type";
        END;
        VendLedgEntry."Entry No." := NextEntryNo;
        VendLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure PostDtldVendtLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; VendorLedgerEntry: Record "Vendor Ledger Entry");
    var
        DetailedVendorLedgEntry: Record "Detailed Vendor Ledg. Entry";
        VLNextEntryNo: Integer;
        DtVendLedEntry: Record "Detailed Vendor Ledg. Entry";
    begin
        IF VLNextEntryNo = 0 THEN BEGIN
            DtVendLedEntry.RESET;
            DtVendLedEntry.SETASCENDING("Entry No.", FALSE);
            IF DtVendLedEntry.FINDFIRST THEN BEGIN
                VLNextEntryNo := DtVendLedEntry."Entry No." + 1;
            END ELSE BEGIN
                VLNextEntryNo := 1;
            END;
        END;
        WITH DetailedVendorLedgEntry DO BEGIN
            "Entry No." := VLNextEntryNo;
            "Transaction No." := NextTransactionNo;
            "Vendor Ledger Entry No." := VendorLedgerEntry."Entry No.";
            "Vendor No." := GenJnlLine."Account No.";
            "Entry Type" := "Entry Type"::"Initial Entry";
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            Amount := GenJnlLine.Amount;
            IF Amount < 0 THEN BEGIN
                "Credit Amount" := -GenJnlLine.Amount;
                "Credit Amount (LCY)" := -GenJnlLine."Amount (LCY)";
            END ELSE BEGIN
                "Debit Amount" := GenJnlLine.Amount;
                "Debit Amount (LCY)" := GenJnlLine."Amount (LCY)";
            END;
            "Ledger Entry Amount" := TRUE;
            "Amount (LCY)" := GenJnlLine."Amount (LCY)";
            "Currency Code" := GenJnlLine."Currency Code";
            "User ID" := USERID;
            "Initial Entry Due Date" := GenJnlLine."Due Date";
            "Initial Entry Global Dim. 1" := GenJnlLine."Shortcut Dimension 1 Code";
            "Initial Entry Global Dim. 2" := GenJnlLine."Shortcut Dimension 2 Code";
            "Initial Document Type" := GenJnlLine."Document Type";
            //"Transaction Type" := GenJnlLine."Transaction Type";
            INSERT;
            VLNextEntryNo += 1;
        END;
    end;

    local procedure InitBankAccLedgEntry(GenJnlLine: Record "Gen. Journal Line" temporary; var BankAccLedgEntry: Record "Bank Account Ledger Entry");
    var
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
    begin
        IF BLNextEntryNo = 0 THEN BEGIN
            BankAccountLedgerEntry.RESET;
            BankAccountLedgerEntry.SETASCENDING("Entry No.", FALSE);
            IF BankAccountLedgerEntry.FINDFIRST THEN BEGIN
                BLNextEntryNo := BankAccountLedgerEntry."Entry No." + 1;
            END ELSE BEGIN
                BLNextEntryNo := 1;
            END;
        END;
        BankAccLedgEntry.INIT;
        WITH BankAccLedgEntry DO BEGIN
            "Bank Account No." := GenJnlLine."Account No.";
            "Posting Date" := GenJnlLine."Posting Date";
            "Document Date" := GenJnlLine."Document Date";
            "Document Type" := GenJnlLine."Document Type";
            "Document No." := GenJnlLine."Document No.";
            "External Document No." := GenJnlLine."External Document No.";
            Description := GenJnlLine.Description;
            "Global Dimension 1 Code" := GenJnlLine."Shortcut Dimension 1 Code";
            "Global Dimension 2 Code" := GenJnlLine."Shortcut Dimension 2 Code";
            "Dimension Set ID" := GenJnlLine."Dimension Set ID";
            "Our Contact Code" := GenJnlLine."Salespers./Purch. Code";
            "Source Code" := GenJnlLine."Source Code";
            "Journal Batch Name" := GenJnlLine."Journal Batch Name";
            "Reason Code" := GenJnlLine."Reason Code";
            "Currency Code" := GenJnlLine."Currency Code";
            "User ID" := USERID;
            "Bal. Account Type" := GenJnlLine."Bal. Account Type";
            "Bal. Account No." := GenJnlLine."Bal. Account No.";
            // "Bank Payment Type" := GenJnlLine."Payment Type";
            //"Posting Time" := TIME;
        END;
        BankAccLedgEntry."Entry No." := NextEntryNo;
        BankAccLedgEntry."Transaction No." := NextTransactionNo;
    end;

    local procedure CreateGLEntryBalAcc(GenJnlLine: Record "Gen. Journal Line" temporary; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Option; BalAccNo: Code[20]);
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."G/L Account No." := AccNo;
        GLEntry."G/L Account Name" := GenJnlLine.Description;
        GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
        GLEntry."Bal. Account No." := '';
        GLEntry."System-Created Entry" := TRUE;
        GLEntry."Source Type" := GLEntry."Source Type"::"Bank Account";
        GLEntry."Source No." := BalAccNo;
        //GLEntry."Creation Date" := GLEntry."Posting Date";
        GLEntry.INSERT;
    end;

    local procedure CreateGLEntryCust(GenJnlLine: Record "Gen. Journal Line" temporary; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Option; BalAccNo: Code[20]);
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."G/L Account No." := AccNo;
        GLEntry."G/L Account Name" := GenJnlLine.Description;
        GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
        GLEntry."Bal. Account No." := '';
        GLEntry."System-Created Entry" := TRUE;
        GLEntry."Source Type" := GLEntry."Source Type"::Customer;
        GLEntry."Source No." := BalAccNo;
        //GLEntry."Creation Date" := GLEntry."Posting Date";
        GLEntry.INSERT;
    end;

    local procedure CreateGLEntryVend(GenJnlLine: Record "Gen. Journal Line" temporary; AccNo: Code[20]; Amount: Decimal; AmountAddCurr: Decimal; BalAccType: Option; BalAccNo: Code[20]);
    var
        GLEntry: Record "G/L Entry";
    begin
        InitGLEntry(GenJnlLine, GLEntry, AccNo, Amount, AmountAddCurr, TRUE, TRUE);
        GLEntry."G/L Account No." := AccNo;
        GLEntry."G/L Account Name" := GenJnlLine.Description;
        GLEntry."Bal. Account Type" := GLEntry."Bal. Account Type"::"G/L Account";
        GLEntry."Bal. Account No." := '';
        GLEntry."System-Created Entry" := TRUE;
        GLEntry."Source Type" := GLEntry."Source Type"::Vendor;
        GLEntry."Source No." := BalAccNo;
        //GLEntry."Creation Date" := GLEntry."Posting Date";
        GLEntry.INSERT;
    end;

    local procedure InitCheckLedgEntry(BankAccLedgEntry: Record "Bank Account Ledger Entry"; var CheckLedgEntry: Record "Check Ledger Entry");
    begin
        CheckLedgEntry.INIT;
        CheckLedgEntry.CopyFromBankAccLedgEntry(BankAccLedgEntry);
        CheckLedgEntry."Entry No." := NextCheckEntryNo;
    end;

    local procedure CalcPmtTolerancePossible(GenJnlLine: Record "Gen. Journal Line" temporary; PmtDiscountDate: Date; var PmtDiscToleranceDate: Date; var MaxPaymentTolerance: Decimal);
    begin
        WITH GenJnlLine DO
            IF "Document Type" IN ["Document Type"::Invoice, "Document Type"::"Credit Memo"] THEN BEGIN
                IF PmtDiscountDate <> 0D THEN
                    PmtDiscToleranceDate :=
                      CALCDATE(GLSetup."Payment Discount Grace Period", PmtDiscountDate)
                ELSE
                    PmtDiscToleranceDate := PmtDiscountDate;

                CASE "Account Type" OF
                    "Account Type"::Customer:
                        PaymentToleranceMgt.CalcMaxPmtTolerance(
                          "Document Type", "Currency Code", Amount, "Amount (LCY)", 1, MaxPaymentTolerance);
                    "Account Type"::Vendor:
                        PaymentToleranceMgt.CalcMaxPmtTolerance(
                          "Document Type", "Currency Code", Amount, "Amount (LCY)", -1, MaxPaymentTolerance);
                END;
            END;
    end;

    local procedure GLCalcAddCurrency(Amount: Decimal; AddCurrAmount: Decimal; OldAddCurrAmount: Decimal; UseAddCurrAmount: Boolean; GenJnlLine: Record "Gen. Journal Line" temporary);
    begin
        IF (AddCurrencyCode <> '') AND
          (GenJnlLine."Additional-Currency Posting" = GenJnlLine."Additional-Currency Posting"::None) THEN BEGIN
            IF (GenJnlLine."Source Currency Code" = AddCurrencyCode) AND (UseAddCurrAmount) THEN BEGIN
            END;

        END;
    end;

    local procedure ExchangeAmtLCYToFCY2(Amount: Decimal): Decimal;
    begin
        IF UseCurrFactorOnly THEN
            EXIT(
              ROUND(
                CurrExchRate.ExchangeAmtLCYToFCYOnlyFactor(Amount, CurrencyFactor),
                AddCurrency."Amount Rounding Precision"));
        EXIT(
          ROUND(
            CurrExchRate.ExchangeAmtLCYToFCY(
              CurrencyDate, AddCurrencyCode, Amount, CurrencyFactor),
            AddCurrency."Amount Rounding Precision"));
    end;

    local procedure GetGLSourceCode();
    var
        SourceCodeSetup: Record "Source Code Setup";
    begin
        SourceCodeSetup.GET;
        GLSourceCode := SourceCodeSetup."General Journal";
    end;

    local procedure InitLastDocDate(GenJnlLine: Record "Gen. Journal Line" temporary);
    begin
        WITH GenJnlLine DO BEGIN
            LastDocType := "Document Type";
            LastDocNo := "Document No.";
            LastDate := "Posting Date";
        END;
    end;

    local procedure StartPosting(GenJnlLine: Record "Gen. Journal Line" temporary);
    var
        GenJnlTemplate: Record "Gen. Journal Template";
        AccountingPeriod: Record "Accounting Period";
    begin
        /*WITH GenJnlLine DO BEGIN
          GlobalGLEntry.LOCKTABLE;
          IF GlobalGLEntry.FINDLAST THEN BEGIN
          LastEntryNo:=NextEntryNo;
          NextEntryNo := GlobalGLEntry."Entry No." + 1;
          IF NextEntryNo<=LastEntryNo THEN BEGIN
          NextEntryNo:=LastEntryNo+1;
          END;
          IF NextTransactionNo=0 THEN BEGIN
          NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
          END;
          END ELSE BEGIN
          NextEntryNo := 1;
          IF NextTransactionNo=0 THEN BEGIN
          NextTransactionNo:= 1;;
          END;
          END;
          FirstTransactionNo := NextTransactionNo;
          InitLastDocDate(GenJnlLine);
          CurrentBalance := 0;
          AccountingPeriod.RESET;
          AccountingPeriod.SETCURRENTKEY(Closed);
          AccountingPeriod.SETRANGE(Closed,FALSE);
          AccountingPeriod.FINDFIRST;
          FiscalYearStartDate := AccountingPeriod."Starting Date";
          GetGLSetup;
          IF NOT GenJnlTemplate.GET("Journal Template Name") THEN
            GenJnlTemplate.INIT;
        
          VATEntry.LOCKTABLE;
          IF VATEntry.FINDLAST THEN
            NextVATEntryNo := VATEntry."Entry No." + 1
          ELSE
            NextVATEntryNo := 1;
          NextConnectionNo := 1;
          FirstNewVATEntryNo := NextVATEntryNo;
           GLReg.LOCKTABLE;
          IF GLReg.FINDLAST THEN
            GLReg."No." := GLReg."No." + 1
          ELSE
          GLReg."No." := 1;
          GLReg.INIT;
          GLReg."From Entry No." := NextEntryNo;
          GLReg."From VAT Entry No." := NextVATEntryNo;
          GLReg."Creation Date" := TODAY;
          GLReg."Source Code" := "Source Code";
          GLReg."Journal Batch Name" := "Journal Batch Name";
          GLReg."User ID" := USERID;
          IF IsGLRegInserted=TRUE THEN BEGIN
          IF GLReg.INSERT(TRUE) THEN BEGIN
          GLRigisterEntryNo:=GLReg."No.";
          IsGLRegInserted := FALSE;
          END;
          END;
        END;*/
        WITH GenJnlLine DO BEGIN
            LastAmount += Amount;
            GlobalGLEntry.LOCKTABLE;
            IF GlobalGLEntry.FINDLAST THEN BEGIN
                LastEntryNo := NextEntryNo;
                IF NextEntryNo = 0 THEN
                    NextTransactionNo := GlobalGLEntry."Transaction No." + 1;
                NextEntryNo := GlobalGLEntry."Entry No." + 1;
                IF NextEntryNo <= LastEntryNo THEN BEGIN
                    NextEntryNo := LastEntryNo + 1;
                END;
            END ELSE BEGIN
                NextEntryNo := 1;
                NextTransactionNo := 1;
                IF NextTransactionNo = 0 THEN BEGIN
                    NextTransactionNo := 1;
                    ;
                END;
            END;
            FirstTransactionNo := NextTransactionNo;
            InitLastDocDate(GenJnlLine);
            CurrentBalance := 0;
            AccountingPeriod.RESET;
            AccountingPeriod.SETCURRENTKEY(Closed);
            AccountingPeriod.SETRANGE(Closed, FALSE);
            AccountingPeriod.FINDFIRST;
            FiscalYearStartDate := AccountingPeriod."Starting Date";
            GetGLSetup;
            IF NOT GenJnlTemplate.GET("Journal Template Name") THEN
                GenJnlTemplate.INIT;

            VATEntry.LOCKTABLE;
            IF VATEntry.FINDLAST THEN
                NextVATEntryNo := VATEntry."Entry No." + 1
            ELSE
                NextVATEntryNo := 1;
            NextConnectionNo := 1;
            FirstNewVATEntryNo := NextVATEntryNo;
            GLReg.LOCKTABLE;
            IF GLReg.FINDLAST THEN
                GLReg."No." := GLReg."No." + 1
            ELSE
                GLReg."No." := 1;
            GLReg.INIT;
            GLReg."From Entry No." := NextEntryNo;
            GLReg."From VAT Entry No." := NextVATEntryNo;
            GLReg."Creation Date" := TODAY;
            GLReg."Source Code" := "Source Code";
            GLReg."Journal Batch Name" := "Journal Batch Name";
            GLReg."User ID" := USERID;
            IF IsGLRegInserted = TRUE THEN BEGIN
                IF GLReg.INSERT(TRUE) THEN BEGIN
                    GLRigisterEntryNo := GLReg."No.";
                    IsGLRegInserted := FALSE;
                END;
            END;
            IF LastAmount = Amount THEN
                NextTransactionNo += 1;
        END;

    end;

    local procedure GetGLSetup();
    begin
        IF GLSetupRead THEN
            EXIT;

        GLSetup.GET;
        GLSetupRead := TRUE;

        AddCurrencyCode := GLSetup."Additional Reporting Currency";
    end;

    local procedure PostGenJnlLine(var GenJnlLine: Record "Gen. Journal Line" temporary; Balancing: Boolean);
    begin
        WITH GenJnlLine DO
            CASE "Account Type" OF
                "Account Type"::"G/L Account":
                    PostGLAcc(GenJnlLine, Balancing);
                "Account Type"::Customer:
                    PostCust(GenJnlLine, Balancing);
                "Account Type"::Vendor:
                    PostVend(GenJnlLine, Balancing);
                "Account Type"::"Bank Account":
                    PostBankAcc(GenJnlLine, Balancing);

            END;
    end;

    local procedure FinishPosting() IsTransactionConsistent: Boolean;
    var
        CostAccSetup: Record "Cost Accounting Setup";
        TransferGlEntriesToCA: Codeunit "Transfer GL Entries to CA";
    begin
        GetGLSourceCode();
        GLReg.GET(GLRigisterEntryNo);
        IF GLReg."Source Code" = '' THEN
            GLReg."Source Code" := GLSourceCode;
        GLReg."To VAT Entry No." := NextVATEntryNo - 1;
        GLReg."To Entry No." := GlobalGLEntry."Entry No." + 1;
        GLReg.MODIFY;
    end;

    local procedure ValidatingGenJournal(ValGenJournalLine: Record "Gen. Journal Line" temporary);
    var
        BalancingAmount: Decimal;
        Window: Dialog;
    begin
        MESSAGE('are we making sense %1 ...%2', ValGenJournalLine."Account No.", ValGenJournalLine.COUNT);
        Window.OPEN('Please Waitwhile the System is Validating Journal!!');
        BalancingAmount := 0;
        IF ValGenJournalLine.FINDFIRST THEN BEGIN
            MESSAGE('am we making line sense %1 ...%2', ValGenJournalLine."Account No.", ValGenJournalLine.COUNT);
            //REPEAT
            //IF GenJournalLine."Bal. Account No."='' THEN BEGIN
            BalancingAmount := BalancingAmount + ValGenJournalLine.Amount;
            //END;
            //UNTIL GenJournalLine.NEXT=0;
        END;
        Window.CLOSE;
        MESSAGE('Successfull mike try F validate %1', BalancingAmount);
    end;
}

