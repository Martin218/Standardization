table 50042 "FD Instruction"
{
    // version TL2.0


    fields
    {
        field(1; "FD Account No"; Code[20])
        {
        }
        field(3; "Renew Principal & Interest"; Boolean)
        {
        }
        field(4; "Renew Interest"; Boolean)
        {
        }
        field(5; "Renew Principal"; Boolean)
        {
        }
        field(6; "Renew Amount"; Decimal)
        {
        }
        field(7; Months; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "FD Account No")
        {
        }
    }

    fieldgroups
    {
    }
}

