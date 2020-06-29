table 50343 "Imprest Types"
{

    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;"G/L Account";Code[10])
        {
            TableRelation = "G/L Account" WHERE ("Account Category"=CONST(Expense),
                                                 "Account Type"=CONST(Posting));
        }
        field(3;Description;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
    }

    fieldgroups
    {
    }
}

