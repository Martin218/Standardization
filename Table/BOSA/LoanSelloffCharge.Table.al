table 50156 "Loan Selloff Charge"
{
    // version TL2.0


    fields
    {
        field(1; "Minimum Amount"; Decimal)
        {
        }
        field(2; "Maximum Amount"; Decimal)
        {
        }
        field(3; Amount; Decimal)
        {
        }
        field(4; "Calculation Method"; Option)
        {
            OptionCaption = '%,Flat Amount';
            OptionMembers = "%","Flat Amount";
        }
    }

    keys
    {
        key(Key1; "Minimum Amount")
        {
        }
    }

    fieldgroups
    {
    }
}

