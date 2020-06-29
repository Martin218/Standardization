table 50040 "CTS Entry"
{
    // version CTS2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "Cheque No."; Code[20])
        {
        }
        field(4; "Account No."; Code[20])
        {
            TableRelation = Vendor;
        }
        field(5; "Account Name"; Text[50])
        {
        }
        field(6; "Member No."; Code[20])
        {
            TableRelation = Member where(Status = filter(Active));
        }
        field(7; "Member Name"; Text[50])
        {
        }
        field(8; "Clearance Date"; Date)
        {
        }
        field(9; "Amount To Pay"; Decimal)
        {
        }
        field(10; Paid; Boolean)
        {
        }

        field(12; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(13; Description; Text[50])
        {
        }
        field(14; "Unpaid Reason"; Text[100])
        {
            Editable = false;
        }
        field(15; "Unpaid Code"; Code[10])
        {
            TableRelation = "CC Reason Code";
        }
        field(16; "Paid Date"; Date)
        {
        }
        field(17; "Paid Time"; Time)
        {
        }
        field(18; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(19; "Transaction Type"; Option)
        {
            OptionCaption = 'Clearance Charge,Penalty Charge,SMS Charge,Excise Duty';
            OptionMembers = "Clearance Charge","Penalty Charge","SMS Charge","Excise Duty";
        }
        field(20; "Cheque Amount"; Decimal)
        {
            Editable = false;
        }
        field(21; Indicator; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

