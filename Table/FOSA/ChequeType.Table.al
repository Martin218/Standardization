table 50026 "Cheque Type"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Clearing Days"; DateFormula)
        {
        }
        field(4; "Clearing Charges"; Decimal)
        {
        }
        field(5; "Clearing Charges GL Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Clearing Bank Account"; Code[10])
        {
            TableRelation = "Bank Account";
        }
        field(7; "Special Clearing Days"; Decimal)
        {
        }
        field(8; "Special Clearing Charges"; Decimal)
        {
        }
        field(9; "Bounced Cheque Charges"; Decimal)
        {
        }
        field(10; "Bounced Cheque GL Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(11; CDays; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

