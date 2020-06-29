table 50258 "Employee Deduction Line"
{
    // version TL2.0


    fields
    {
        field(1;No;Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Employee No";Code[30])
        {
        }
        field(3;"Item Description";Text[250])
        {
        }
        field(4;"Serial No";Text[30])
        {
        }
        field(5;Amount;Decimal)
        {
        }
        field(6;"Asset Tag";Decimal)
        {
        }
    }

    keys
    {
        key(Key1;No,"Employee No")
        {
        }
    }

    fieldgroups
    {
    }
}

