table 50109 "Loan Charge Setup"
{
    // version TL2.0

    DrillDownPageID = 50216;
    LookupPageID = 50216;

    fields
    {
        field(1; "Code"; Code[20])
        {

        }
        field(2; "Charge Description"; Text[250])
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
        fieldgroup(dropDown; "Code", "Charge Description")
        {

        }
    }
}

