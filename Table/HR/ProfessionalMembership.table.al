table 50259 "Professional Membership"
{
    // version TL2.0

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Organisation; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Code", Organisation)
        {
        }
    }
}

