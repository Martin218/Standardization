table 50423 "Contract Header"
{

    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;"Vendor No.";Code[20])
        {
        }
        field(3;"Vendor Name";Text[80])
        {
        }
        field(4;"Process No.";Code[10])
        {
        }
        field(5;Description;Text[80])
        {
        }
        field(6;"Procurement Plan";Code[20])
        {
        }
        field(7;"Procurement Plan Item No.";Integer)
        {
        }
        field(8;Amount;Decimal)
        {
        }
        field(9;"Award Date";Date)
        {
        }
        field(10;"No. Series";Code[20])
        {
        }
        field(11;"Attached Contract";Boolean)
        {
        }
        field(12;"Contract Path";Text[250])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }
}

