table 50337 "Imprest Lines"
{
    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Code"; Code[30])
        {
            TableRelation = "Imprest Management";
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";

            trigger OnLookup();
            begin
                CLEAR("Account No.");
            end;
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor WHERE("Vendor Type" = CONST(Staff));

            trigger OnValidate();
            begin


                "Account Name" := PaymentReceiptProcessing."GetVendor/CustomerName"("Account No.", "Account Type");

                ImprestManagement.RESET;
                ImprestManagement.GET(Code);
                WITH ImprestManagement DO BEGIN
                    IF "Transaction Type" = "Transaction Type"::Imprest THEN BEGIN
                        AmountSpent := 0;
                        AmountSpent := BudgetManagement.ActualExpense("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", '');
                        "Committed Amount" := BudgetManagement.GetcommitedAmount("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", '');
                        "Budgetted Amount" := BudgetManagement.GetBudgetLineAmount("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
                        IF "Budgetted Amount" = 0 THEN BEGIN
                            ERROR('No Budget Line For This GL %1', "Account No.");
                        END;
                    END;
                END;
                "Budget  Spent" := AmountSpent;
                "Available Amount" := "Budgetted Amount" - ("Budget  Spent" + "Committed Amount" + BudgetManagement.CummulativeImprestLine(Rec));

            end;
        }
        field(5; "Account Name"; Code[90])
        {
            Editable = false;
        }
        field(6; Description; Text[90])
        {
        }
        field(7; "Applies to Doc. No"; Code[20])
        {

            trigger OnLookup();
            begin
                TESTFIELD("Account Type");
                TESTFIELD("Account No.");
                CASE "Account Type" OF
                    "Account Type"::Customer:
                        BEGIN
                            "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocCust("Account No.");
                            GetOtherAppliesToDocCust("Applies to Doc. No");
                        END;
                END;
            end;
        }
        field(8; Amount; Decimal)
        {
            Editable = false;
        }
        field(9; "VAT Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "W/Tax Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Net Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "KBA Branch Code"; Code[20])
        {
            TableRelation = "KBA Codes"."KBA Branch Code";
        }
        field(13; "Bank Account No."; Code[20])
        {
        }
        field(14; "W/Tax Code"; Code[10])
        {
            Editable = false;
            TableRelation = "VAT Product Posting Group";
        }
        field(15; "Branch Name"; Text[70])
        {
            Editable = false;
        }
        field(16; "Bank Name"; Code[90])
        {
            Editable = false;
        }
        field(17; "Gross Amount"; Decimal)
        {
        }
        field(18; "VAT WithHeld Code"; Code[10])
        {
            Editable = false;
        }
        field(19; "VAT Withheld Amount"; Decimal)
        {
            Editable = false;
        }
        field(20; "VATABLE Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(22; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(23; "Apples to Doc Type"; Option)
        {
            OptionCaption = ',Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = ,Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(24; "KBA Code"; Code[10])
        {
            TableRelation = "KBA Codes";
        }
        field(25; "External Document No"; Code[70])
        {
            Editable = false;
        }
        field(26; Quantity; Decimal)
        {

            trigger OnValidate();
            begin

                IF "Unit Price" <> 0 THEN BEGIN
                    Amount := "Unit Price" * Quantity;
                    IF "Budgetted Amount" <> 0 THEN BEGIN
                        IF Amount > "Available Amount" THEN BEGIN
                            ERROR('Amount %2 cannot be more than the remaining of %1', "Remaining Amount", Amount);
                        END;
                    END;
                END;
            end;
        }
        field(27; "Unit Price"; Decimal)
        {

            trigger OnValidate();
            begin
                TESTFIELD(Quantity);
                Amount := "Unit Price" * Quantity;
                IF "Budgetted Amount" <> 0 THEN BEGIN
                    IF Amount > "Available Amount" THEN BEGIN
                        ERROR('Amount %2 cannot be more than the remaining of %1', "Remaining Amount", Amount);
                    END;
                END;
            end;
        }
        field(28; "Actual Spent"; Decimal)
        {
            Editable = true;
        }
        field(29; "Remaining Amount"; Decimal)
        {
            Editable = false;
        }
        field(30; "Link To Doc No."; Code[20])
        {
            Editable = false;
            TableRelation = "Imprest Management";
        }
        field(31; "Budgetted Amount"; Decimal)
        {
            Editable = false;
        }
        field(32; "Committed Amount"; Decimal)
        {
            Editable = false;
        }
        field(33; "Available Amount"; Decimal)
        {
            Editable = false;
        }
        field(34; "Budget  Spent"; Decimal)
        {
            Editable = false;
        }
        field(35; "Activity Name"; Code[10])
        {
            TableRelation = "Imprest Types";

            trigger OnValidate();
            begin
                ImprestTypes.GET("Activity Name");
                "Account Type" := "Account Type"::"G/L Account";
                ImprestTypes.TESTFIELD("G/L Account");
                ImprestTypes.TESTFIELD(Description);
                "Account No." := ImprestTypes."G/L Account";
                Description := ImprestTypes.Description;
                "Account Name" := PaymentReceiptProcessing."GetVendor/CustomerName"("Account No.", "Account Type");

                ImprestManagement.RESET;
                ImprestManagement.GET(Code);
                WITH ImprestManagement DO BEGIN
                    IF "Transaction Type" = "Transaction Type"::Imprest THEN BEGIN
                        AmountSpent := 0;
                        AmountSpent := BudgetManagement.ActualExpense("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", '');
                        "Committed Amount" := BudgetManagement.GetcommitedAmount("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code", '');
                        "Budgetted Amount" := BudgetManagement.GetBudgetLineAmount("Account No.", "Global Dimension 1 Code", "Global Dimension 2 Code");
                        IF "Budgetted Amount" = 0 THEN BEGIN
                            ERROR('No Budget Line For This GL %1', "Account No.");
                        END;
                    END;
                END;
                "Budget  Spent" := AmountSpent;
                "Available Amount" := "Budgetted Amount" - ("Budget  Spent" + "Committed Amount" + BudgetManagement.CummulativeImprestLine(Rec));
            end;
        }
    }

    keys
    {
        key(Key1; "Code", "Line No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        ImprestManagement.RESET;
        ImprestManagement.GET(Code);
        IF ImprestManagement."Transaction Type" = ImprestManagement."Transaction Type"::Imprest THEN BEGIN
            UserSetup.GET(USERID);
            "Global Dimension 1 Code" := UserSetup."Global Dimension 1 Code";
            "Global Dimension 2 Code" := UserSetup."Global Dimension 2 Code";
        END;
        IF ImprestManagement."Transaction Type" = ImprestManagement."Transaction Type"::"Petty Cash" THEN BEGIN
            "Account Type" := "Account Type"::Vendor;
            ImprestLines.Reset();
            ImprestLines.SetRange(Code, ImprestManagement."Imprest No.");
            IF ImprestLines.FindFirst then begin
                Error('PETTY CASH CANNOT BE USED TO PAY MORE THAN ONCE LINE!');
            END;
        END;
    end;

    var
        GenJournalLine: Record "Gen. Journal Line";
        PaymentReceiptProcessing: Codeunit "Cash Management";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        KBACodes: Record "KBA Codes";
        BankName: Record "Bank Name";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        UserSetup: Record "User Setup";
        BudgetManagement: Codeunit "Budget Management";
        ImprestManagement: Record "Imprest Management";
        AmountSpent: Decimal;
        ImprestTypes: Record "Imprest Types";
        ImprestLines: Record "Imprest Lines";

    local procedure GetOtherAppliesToDocVend(AppliestoDocNo: Code[20]);
    begin
    end;

    procedure GetVenderDetails("AccountNo.": Code[20]);
    begin
    end;

    local procedure GetOtherAppliesToDocCust(AppliestoDocNo: Code[20]);
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", "Account No.");
        CustLedgerEntry.SETRANGE("Document No.", AppliestoDocNo);
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CLEAR(Amount);
            CLEAR(Quantity);
            CLEAR("Unit Price");
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                "Unit Price" := "Unit Price" + ABS(CustLedgerEntry."Remaining Amount");
            UNTIL CustLedgerEntry.NEXT = 0;
            "Apples to Doc Type" := CustLedgerEntry."Document Type";
            "External Document No" := CustLedgerEntry."External Document No.";
            Description := CustLedgerEntry.Description;
            Amount := "Unit Price";
            Quantity := 1;
        END;
    end;
}

