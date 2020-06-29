table 50054 Banks
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[10])
        {
        }
        field(2; Name; Text[150])
        {
        }
        field(3; "Global Dimension 1 Code"; Text[150])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; Name)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", Name)
        {
        }
    }
}

