table 50477 "Registry File Number"
{
    // version TL2.0


    fields
    {
        field(1; "File Number"; Code[100])
        {
            Editable = false;

        }
        field(2; Date; DateTime)
        {
            Editable = false;
        }
        field(3; "No."; Code[100])
        {
            Editable = false;
        }
        field(4; "Changed By"; Code[100])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; "File Status"; Code[10])
        {
            TableRelation = "Registry File Status"."Status Code";
        }
        field(6; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(7; "Previous File Number"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "File Number", "No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

