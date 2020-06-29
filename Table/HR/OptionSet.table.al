table 50278 "Option Set"
{
    // version TL2.0


    fields
    {
        field(1;"Code";Code[20])
        {
        }
        field(2;Value;Code[20])
        {
            TableRelation = "Option Set Value" WHERE (Code=FIELD(Code));
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
        fieldgroup(DropDown;"Code",Value)
        {
        }
    }
}

