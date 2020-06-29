table 50279 "Option Set Value"
{
    // version TL2.0

    DrillDownPageID = 50522;
    LookupPageID = 50522;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Value; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Code", Value)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Value)
        {
        }
    }
}

