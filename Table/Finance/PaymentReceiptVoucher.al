table 50331 "Payment/Receipt Voucher"
{
    // version TL 2.0


    fields
    {
        field(1; "Paying Code."; Code[10])
        {
        }
        field(2; "Payment Date"; Date)
        {
        }
        field(3; Type; Code[10])
        {
        }
        field(4; "Payment Mode"; Option)
        {
            OptionCaption = ',CASH,CHEQUE,BCHEQUE,DRAFT,EFT,MONEY ORDER,SWIFT,SLIPS';
            OptionMembers = ,CASH,CHEQUE,BCHEQUE,DRAFT,EFT,"MONEY ORDER",SWIFT,SLIPS;
        }
        field(5; "Cheque No."; Code[10])
        {
        }
        field(6; "Cheque Date"; Date)
        {
        }
        field(7; "Paying Bank"; Code[10])
        {
            TableRelation = "Bank Account";

            trigger OnValidate();
            begin
                "Paying/Receiving Bank Name" := PaymentReceiptProcessing.GetBankAccountName("Paying Bank");
            end;
        }
        field(8; "VAT Amount"; Decimal)
        {
        }
        field(9; "Withholding Tax Amount"; Decimal)
        {
        }
        field(10; "Net Amount"; Decimal)
        {
            CalcFormula = Sum ("Payment/Receipt Lines"."Net Amount" WHERE(Code = FIELD("Paying Code.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; Amount; Decimal)
        {
        }
        field(12; Posted; Boolean)
        {
        }
        field(13; "Time Posted"; Time)
        {
        }
        field(14; "Date Posted"; Date)
        {
        }
        field(15; "Posted By"; Code[90])
        {
            TableRelation = "User Setup";
        }
        field(16; "Paying/Receiving Bank Name"; Code[80])
        {
        }
        field(17; Remarks; Text[90])
        {
        }
        field(18; "Global Dimension 1 Code"; Code[10])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(19; "Approval Status"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = count ("Approval Entry" WHERE("Document No." = field("Paying Code.")));
        }
        field(20; Status; Option)
        {
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(21; Select; Boolean)
        {
        }
        field(22; "Created By"; Code[90])
        {
            TableRelation = "User Setup";
        }
        field(23; Balance; Decimal)
        {
        }
        field(24; "Line type"; Option)
        {
            OptionCaption = ',Payment,Receipt';
            OptionMembers = ,Payment,Receipt;
        }
        field(25; "No. Series"; Code[20])
        {
        }
        field(26; Description; Text[40])
        {
        }
        field(27; "Document Type"; Option)
        {
            OptionCaption = ',Payment Voucher,Receipt';
            OptionMembers = ,"Payment Voucher",Receipt;
        }
        field(28; "Next Approver"; Code[90])
        {
            Editable = false;
            TableRelation = "Approval Entry"."Approver ID" WHERE("Document No." = FIELD("Paying Code."),
                                                                  Status = FILTER(Open));
        }
        field(29; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(30; "Account No."; Code[20])
        {

            TableRelation = IF ("Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE
            IF ("Account Type" = CONST(Customer)) Customer// WHERE ("Customer Type"=CONST(Normal))
            ELSE
            IF ("Account Type" = CONST(Vendor)) Vendor// WHERE ("Vendor Type"=CONST(FOSA))
            ELSE
            IF ("Account Type" = CONST("Bank Account")) "Bank Account"
            ELSE
            IF ("Account Type" = CONST("Fixed Asset")) "Fixed Asset"
            ELSE
            IF ("Account Type" = CONST("IC Partner")) "IC Partner";

            trigger OnValidate();
            begin
                PaymentReceiptProcessing.PopulatePVLines(Rec);
                "Payee Name" := PaymentReceiptProcessing."GetVendor/CustomerName"("Account No.", "Account Type");
                IF "Line type" = "Line type"::Receipt THEN BEGIN
                    Description := "Payee Name";
                END;
            end;
        }
        field(31; "Payee Name"; Code[90])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Paying Code.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete();
    begin
        IF Status <> Status::Open THEN BEGIN
            ERROR('You Cannot Delete This Document At This Stage!');
        END;
    end;

    trigger OnInsert();
    begin

        CashMgtSetup.RESET;
        CashMgtSetup.GET;
        IF "Line type" = "Line type"::Payment THEN BEGIN
            CashMgtSetup.TESTFIELD("PV No.");
            NoSeriesMgt.InitSeries(CashMgtSetup."PV No.", xRec."No. Series", 0D, "Paying Code.", "No. Series");
        END;
        IF "Line type" = "Line type"::Receipt THEN BEGIN
            CashMgtSetup.TESTFIELD("Cash Receipt No.");
            NoSeriesMgt.InitSeries(CashMgtSetup."Cash Receipt No.", xRec."No. Series", 0D, "Paying Code.", "No. Series");
        END;
        "Payment Date" := TODAY;
        "Created By" := USERID;

    end;

    var
        CashMgtSetup: Record "Cash Management Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        PaymentReceiptProcessing: Codeunit "Cash Management";
        PVLines: Record "Payment/Receipt Lines";

    // [Scope('Personalization')]
    procedure ReqLinesExist(): Boolean;
    begin
        PVLines.RESET;
        PVLines.SETRANGE(Code, "Paying Code.");
        EXIT(PVLines.FINDFIRST);
    end;
}

