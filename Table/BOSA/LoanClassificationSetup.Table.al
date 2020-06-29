table 50151 "Loan Classification Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {

            trigger OnValidate()
            begin
                Description := UPPERCASE(Description);
            end;
        }
        field(3; "Min. Defaulted Days"; Decimal)
        {
        }
        field(4; "Max. Defaulted Days"; Decimal)
        {
        }
        field(5; "Provisioning %"; Decimal)
        {
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

