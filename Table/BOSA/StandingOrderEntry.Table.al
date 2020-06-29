table 50083 "Standing Order Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "STO No."; Code[20])
        {
        }
        field(3; "Member No."; Code[20])
        {
        }
        field(4; "Member Name"; Text[50])
        {
        }
        field(5; "Account No."; Code[20])
        {
        }
        field(6; "Account Name"; Text[50])
        {
        }
        field(7; Amount; Decimal)
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

