table 50086 "Temp Teller Daily Transactions"
{

    fields
    {
        field(1; LineNo; Integer)
        {
        }
        field(2; "Till No"; Code[10])
        {
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Debit; Decimal)
        {
        }
        field(5; Credit; Decimal)
        {
        }
        field(6; "Running Balance"; Decimal)
        {
        }
        field(7; Naration; Text[100])
        {
        }
        field(8; DocumentNo; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; LineNo)
        {
        }
    }

    fieldgroups
    {
    }
}

