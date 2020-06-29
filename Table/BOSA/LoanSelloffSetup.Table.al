table 50154 "Loan Selloff Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Income G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Attachment Mandatory"; Boolean)
        {
        }
        field(4; "Receiving Bank Account"; Code[20])
        {
            TableRelation = "Bank Account";
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

