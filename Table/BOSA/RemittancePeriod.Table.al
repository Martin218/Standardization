table 50147 "Remittance Period"
{
    // version TL2.0

    DrillDownPageID = 50297;
    LookupPageID = 50297;

    fields
    {
        field(1; "Start Date"; Date)
        {
        }
        field(2; Year; Integer)
        {
        }
        field(3; Month; Text[10])
        {
        }
        field(4; Closed; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Start Date")
        {
        }
        key(Key2; Year)
        {
        }
        key(Key3; Month)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(Brick; "Start Date", Month, Year)
        {
        }
        fieldgroup(DropDown; "Start Date", Month, Year)
        {
        }
    }
}

