table 50140 "Guarantor Substitution Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Document No."; Code[20])
        {
            TableRelation = "Guarantor Substitution Header";
        }
        field(3; "Previous Guarantor No."; Code[20])
        {
            TableRelation = Member;
        }
        field(4; "Previous Guarantor Name"; Text[50])
        {
        }
        field(5; "New Guarantor No."; Code[20])
        {
            TableRelation = Member;
        }
        field(6; "New Guarantor Name"; Text[50])
        {
        }
        field(7; "Substitution Date"; Date)
        {
        }
        field(8; "Substitution Time"; Time)
        {
        }
        field(9; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(10; Description; Text[50])
        {
        }
        field(11; "Previous Amount Guaranteed"; Decimal)
        {
        }
        field(12; "New Amount Guaranteed"; Decimal)
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

