table 50341 "Monthly Distribution"
{
    // version TL 2.0

   // DrillDownPageID = 50571;
   // LookupPageID = 50571;

    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;"Account No.";Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3;Month;Date)
        {
        }
        field(4;Amount;Decimal)
        {
        }
        field(5;Description;Text[100])
        {
        }
        field(6;"Global Dimension 1 Code";Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(7;"Global Dimension 2 Code";Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(8;"Budget Period";Option)
        {
            OptionCaption = 'Monthly,Yearly';
            OptionMembers = Monthly,Yearly;
        }
        field(9;Posted;Boolean)
        {
            Editable = false;
        }
        field(10;Submitted;Boolean)
        {
            Editable = false;
        }
        field(11;Consolidated;Boolean)
        {
            Editable = false;
        }
        field(12;CreatedBy;Code[120])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(13;"Budget Name";Code[20])
        {
            TableRelation = "G/L Budget Name";
        }
    }

    keys
    {
        key(Key1;"Entry No.","Account No.",Month,"Global Dimension 1 Code","Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }
}

