table 50116 "Exit Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Attachment Mandatory"; Boolean)
        {
        }
        field(3; "Insurance G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(4; "Refund Shares to Shares"; Boolean)
        {
        }
        field(5; "Expense G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(6; "Income G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Credit FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(8; "Debit FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

