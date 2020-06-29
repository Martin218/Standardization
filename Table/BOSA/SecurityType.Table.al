table 50103 "Security Type"
{
    // version TL2.0

    DataCaptionFields = Description;
    DrillDownPageID = 50208;
    LookupPageID = 50208;

    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[30])
        {
        }
        field(3; Factor; Decimal)
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

