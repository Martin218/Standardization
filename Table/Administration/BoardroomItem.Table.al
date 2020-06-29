table 50491 "Boardroom Item"
{
    // version TL2.0


    fields
    {
        field(1; Item; Code[10])
        {
        }
        field(2; Quantity; Integer)
        {
        }
        field(3; "No."; Code[40])
        {
        }
    }

    keys
    {
        key(Key1; "No.", Quantity, Item)
        {
        }
    }

    fieldgroups
    {
    }
}

