table 50142 "Exit Fee"
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(4; Amount; Decimal)
        {
        }
        field(5; "Earning Party"; Option)
        {
            OptionCaption = ' ,Member,Sacco';
            OptionMembers = " ",Member,Sacco;
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

