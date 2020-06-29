table 50035 "Cheque Book Leaf"
{
    // version TL2.0


    fields
    {
        field(1; "Cheque Book No."; Code[20])
        {
        }
        field(2; "Leaf No."; Code[20])
        {
        }
        field(3; Usage; Option)
        {
            Editable = false;
            OptionCaption = 'New,Used';
            OptionMembers = New,Used;
        }
        field(4; "Serial No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cheque Book No.", "Leaf No.")
        {
        }
    }

    fieldgroups
    {
    }
}

