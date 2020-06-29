table 50479 "Request File Reason"
{
    // version TL2.0


    fields
    {
        field(1;"No.";Code[10])
        {
        }
        field(2;Reason;Code[100])
        {
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
        key(Key2;Reason)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Reason)
        {
        }
    }
}

