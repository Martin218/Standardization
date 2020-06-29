table 50049 Denomination
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[30])
        {
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
        }
        field(3; Value; Decimal)
        {
        }
        field(4; Type; Option)
        {
            OptionMembers = Note,Coin;
        }
        field(5; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
        key(Key2; Priority)
        {
        }
    }

    fieldgroups
    {
    }
}

