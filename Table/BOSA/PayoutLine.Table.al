table 50121 "Payout Line"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[10])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;
            end;
        }
        field(4; "Member Name"; Text[100])
        {
            Editable = false;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(8; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Gross Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Charge Amount"; Decimal)
        {
            Editable = false;
        }
        field(11; "Excise Duty Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "Withholding Tax Amount"; Decimal)
        {
            Editable = false;
        }
        field(15; "Net Amount"; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;

    procedure CheckLinesExist(PayoutNo: Code[20]): Boolean
    var
        PayoutLine: Record "Payout Line";
    begin
        RESET;
        SETRANGE("Document No.", PayoutNo);
        EXIT(FINDFIRST);
    end;
}

