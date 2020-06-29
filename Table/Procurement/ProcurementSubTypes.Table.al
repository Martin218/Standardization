table 50406 "Procurement Sub Types"
{

    fields
    {
        field(1;Type;Text[100])
        {
            TableRelation = "Procurement Type";
        }
        field(2;"Sub Type";Text[100])
        {
        }
    }

    keys
    {
        key(Key1;Type,"Sub Type")
        {
        }
    }

    fieldgroups
    {
    }
}

