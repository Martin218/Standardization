table 50257 "Employee Type"
{
    // version TL2.0


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee Type"; Text[70])
        {
        }
    }

    keys
    {
        key(Key1; No, "Employee Type")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee Type")
        {
        }
    }
}

