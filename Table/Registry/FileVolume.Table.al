table 50476 "File Volume"
{
    // version TL2.0


    fields
    {
        field(1; No; Code[10])
        {
        }
        field(2; Volume; Code[100])
        {
        }
        field(3; "File Number"; Code[50])
        {
        }
        field(4; "File Location"; Code[50])
        {
        }
        field(5; "Date Created"; Date)
        {
        }
        field(6; Select; Boolean)
        {
        }
        field(7; "Created By"; Code[70])
        {
            TableRelation = "User Setup";
        }
        field(8; "Previous File Number"; Code[50])
        {
        }
        field(9; MemberNo; Code[50])
        {
        }
        field(10; Volume2; Code[80])
        {
        }
        field(11; "Multiple Volumes"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; No, Volume)
        {
        }
        key(Key2; Select)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Select, Volume, "Date Created")
        {
        }
    }
}

