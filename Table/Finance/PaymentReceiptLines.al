table 50332 "Payment/Receipt Lines"
{

    fields
    {
        field(1; "Line No"; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Code"; Code[30])
        {
            TableRelation = "Payment/Receipt Voucher";
        }
        field(3; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor // WHERE("Vendor Type" = CONST(1))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                PaymentReceiptProcessing.ValidateAccount(Rec);
                "Account Name" := PaymentReceiptProcessing."GetVendor/CustomerName"("Account No.", "Account Type");
                GetVenderDetails("Account No.");

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
                    "Account Type"::Vendor:
                        BEGIN
                            "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocVend("Account No.");
                            GetOtherAppliesToDocVend("Applies to Doc. No");
                        END;
                    "Account Type"::Customer:
                        BEGIN
                            "Applies to Doc. No" := PaymentReceiptProcessing.LookUpAppliesToDocCust("Account No.");
                            GetOtherAppliesToDocCust("Applies to Doc. No");
                        END;
                END;
                GetVenderDetails("Account No.");
            end;
        }
        field(8; Amount; Decimal)
        {

            trigger OnValidate();
            begin
                "VAT Withheld Amount" := PaymentReceiptProcessing.VATWithheld("Account No.", "Applies to Doc. No", Amount);
                "W/Tax Amount" := PaymentReceiptProcessing.WTaxAmount("Account No.", "Applies to Doc. No", Amount);
                "Net Amount" := Amount - ("W/Tax Amount" + "VAT Withheld Amount");
                ValidateAppliesToDoc();
                IF ("Account Type" = "Account Type"::Vendor) AND ("Applies to Doc. No" <> '') THEN BEGIN
                    IF Amount > PaymentReceiptProcessing.GetVendDocumentBalance("Applies to Doc. No", "Account No.") THEN BEGIN
                        ERROR('You Cannot Pay More than Ksh. %1 From the Supplier', PaymentReceiptProcessing.GetVendDocumentBalance("Applies to Doc. No", "Account No."));
                    END;
                END;
                IF ("Account Type" = "Account Type"::Customer) AND ("Applies to Doc. No" <> '') THEN BEGIN
                    IF Amount > PaymentReceiptProcessing.GetCustDocumentBalance("Applies to Doc. No", "Account No.") THEN BEGIN
                        ERROR('You Cannot Receive More than Ksh. %1 From the Customer', PaymentReceiptProcessing.GetVendDocumentBalance("Applies to Doc. No", "Account No."));
                    END;
                END;

            end;
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

            trigger OnValidate();
            begin
                ValidateAppliesToDoc()
            end;
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
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                          "Dimension Value Type" = FILTER(Standard));
        }
        field(22; "Global Dimension 2 Code"; Code[10])
        {
            CaptionClass = '1,1,2';
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

    var
        GenJournalLine: Record "Gen. Journal Line";
        PaymentReceiptProcessing: Codeunit "Cash Management";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        Vendor: Record Vendor;
        KBACodes: Record "KBA Codes";
        BankName: Record "Bank Name";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        PVoucher: Record "Payment/Receipt Voucher";

    local procedure GetOtherAppliesToDocVend(AppliestoDocNo: Code[20]);
    begin
        VendLedgEntry.RESET;
        VendLedgEntry.SETRANGE("Vendor No.", "Account No.");
        VendLedgEntry.SETRANGE("Document No.", AppliestoDocNo);
        IF VendLedgEntry.FINDFIRST THEN BEGIN
            CLEAR("Net Amount");
            REPEAT
                VendLedgEntry.CALCFIELDS("Remaining Amount");
                "Net Amount" := "Net Amount" + ABS(VendLedgEntry."Remaining Amount");
            UNTIL VendLedgEntry.NEXT = 0;
            "Apples to Doc Type" := VendLedgEntry."Document Type";
            "External Document No" := VendLedgEntry."External Document No.";
            Description := VendLedgEntry.Description;
            Amount := "Net Amount";

            "VAT Withheld Amount" := PaymentReceiptProcessing.VATWithheld("Account No.", AppliestoDocNo, Amount);
            "W/Tax Amount" := PaymentReceiptProcessing.WTaxAmount("Account No.", "Applies to Doc. No", Amount);
            "Net Amount" := Amount - ("W/Tax Amount" + "VAT Withheld Amount");
            PurchInvHeader.RESET;
            IF PurchInvHeader.GET(AppliestoDocNo) THEN BEGIN
                PurchInvHeader.CALCFIELDS("Amount Including VAT", Amount);
                "Gross Amount" := PurchInvHeader."Amount Including VAT";
                "VAT Amount" := "Gross Amount" - PurchInvHeader.Amount;
                IF Vendor.GET("Account No.") THEN BEGIN
                    "VAT WithHeld Code" := Vendor."VAT Withheld";
                    "W/Tax Code" := Vendor."Withholding Tax";
                END;
            END;

        END;
    end;

    local procedure GetOtherAppliesToDocCust(AppliestoDocNo: Code[20]);
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", "Account No.");
        CustLedgerEntry.SETRANGE("Document No.", AppliestoDocNo);
        IF CustLedgerEntry.FINDFIRST THEN BEGIN
            CLEAR("Net Amount");
            REPEAT
                CustLedgerEntry.CALCFIELDS("Remaining Amount");
                "Net Amount" := "Net Amount" + ABS(CustLedgerEntry."Remaining Amount");
            UNTIL CustLedgerEntry.NEXT = 0;
            "Apples to Doc Type" := CustLedgerEntry."Document Type";
            "External Document No" := CustLedgerEntry."External Document No.";
            Description := CustLedgerEntry.Description;
            Amount := "Net Amount";
        END;
    end;

    procedure GetVenderDetails("AccountNo.": Code[20]);
    begin

        Vendor.RESET;
        IF Vendor.GET("Account No.") THEN BEGIN
            Vendor.TESTFIELD("Bank Account");
            Vendor.TESTFIELD("KBA Code");
            Vendor.TESTFIELD("Bank Code");
            "Bank Account No." := Vendor."Bank Account";
            "KBA Code" := Vendor."KBA Code";
            KBACodes.RESET;
            KBACodes.GET(Vendor."KBA Code", Vendor."Bank Code");
            KBACodes.TESTFIELD("KBA Name");
            "KBA Branch Code" := KBACodes."KBA Branch Code";
            "Branch Name" := KBACodes."KBA Name";
            BankName.RESET;
            BankName.GET(Vendor."Bank Code");
            BankName.TESTFIELD("BAnk Name");
            "Bank Name" := BankName."BAnk Name";
        END;
    end;

    local procedure ValidateAppliesToDoc();
    begin

        IF PVoucher.GET(Code) THEN BEGIN
            IF PVoucher."Line type" = PVoucher."Line type"::Payment THEN BEGIN
                IF ("Account Type" = "Account Type"::Vendor) THEN BEGIN
                    TESTFIELD("Applies to Doc. No");
                END;
            END;
            IF PVoucher."Line type" = PVoucher."Line type"::Receipt THEN BEGIN
                IF ("Account Type" = "Account Type"::Customer) THEN BEGIN
                    TESTFIELD("Applies to Doc. No");
                END;
            END;
        END;

    end;
}

