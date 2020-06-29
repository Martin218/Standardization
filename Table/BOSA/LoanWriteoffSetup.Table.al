table 50165 "Loan Writeoff Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "LW G/L Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Attachment Mandatory"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

