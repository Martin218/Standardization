table 50115 "Exit Reason"
{
    // version TL2.0

    DrillDownPageID = 50236;
    LookupPageID = 50236;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[250])
        {
        }
        field(3; "Notice Period"; DateFormula)
        {
        }
        field(4; "Initiate Refund"; Boolean)
        {
        }
        field(5; "Initiate Claim"; Boolean)
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
    }
}

