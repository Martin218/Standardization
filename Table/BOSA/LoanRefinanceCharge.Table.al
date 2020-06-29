table 50111 "Loan Refinance Charge"
{
    // version TL2.0

    DrillDownPageID = 50225;
    LookupPageID = 50225;

    fields
    {
        field(1; "Loan Product Code"; Code[20])
        {
        }
        field(2; "Minimum Amount Paid %"; Decimal)
        {
        }
        field(3; "Maximum Amount Paid %"; Decimal)
        {
        }
        field(4; "Refinance Rate %"; Decimal)
        {
        }
        field(5; "Refinancing Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Loan Product Code")
        {
        }
    }

    fieldgroups
    {
    }
}

