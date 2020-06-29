table 50085 "Temp Statement Entrries"
{

    fields
    {
        field(1;"Posting Date";Date)
        {
        }
        field(2;"Account Number";Code[20])
        {
        }
        field(3;Description;Text[250])
        {
        }
        field(4;"Credit Amount";Decimal)
        {
        }
        field(5;"Debit Amount";Decimal)
        {
        }
        field(6;Amount;Decimal)
        {
        }
        field(7;"Line No";Integer)
        {
        }
        field(8;"Running Balance";Decimal)
        {
        }
        field(9;"Document No";Code[20])
        {
        }
    }

    keys
    {
        key(Key1;"Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

