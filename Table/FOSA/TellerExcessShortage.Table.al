table 50053 "Teller Shortage/Excess Account"
{
    // version TL2.0


    fields
    {
        field(1; Branch; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = FILTER(1));
        }
        field(2; Type; Option)
        {
            OptionCaption = 'Excess,Shortage';
            OptionMembers = Excess,Shortage;
        }
        field(3; "G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; Branch, Type)
        {
        }
    }

    fieldgroups
    {
    }
}

