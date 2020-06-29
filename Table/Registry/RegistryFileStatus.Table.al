table 50472 "Registry File Status"
{
    // version TL2.0

    //LookupPageID = 50954;

    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Status Code"; Code[10])
        {
        }
        field(3; Description; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; No, "Status Code", Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Status Code", Description)
        {
        }
    }
}

