table 50274 "Evaluation Question Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; Question; Text[250])
        {
        }
        field(3; "Selective Question"; Boolean)
        {
        }
        field(4; "Option Set"; Code[20])
        {
            TableRelation = "Option Set";
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

