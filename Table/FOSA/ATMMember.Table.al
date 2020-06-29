table 50062 "ATM Member"
{
    // version TL2.0


    fields
    {
        field(1; "Card No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(5; "Account Name"; Code[20])
        {
            Editable = false;
        }
        field(6; "Application No."; Code[20])
        {
            Editable = false;
            TableRelation = "ATM Application";
        }
        field(7; "Collection No."; Code[20])
        {
            Editable = false;
            TableRelation = "ATM Collection";
        }
        field(8; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            FieldClass = FlowField;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("Account No.")));
            Caption = 'Balance (LCY)';
            Editable = false;

        }
        field(9; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }
        field(10; "SMS Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(11; "E-Mail Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
    }

    keys
    {
        key(Key1; "Card No.")
        {
        }
    }

    fieldgroups
    {
    }
}

