table 50216 "Disciplinary Offense"
{
    // version TL2.0

    LookupPageID = 50426;

    fields
    {
        field(1;"Code";Code[20])
        {
            NotBlank = true;
        }
        field(2;Description;Text[200])
        {
        }
        field(3;Rating;Code[50])
        {
        }
        field(4;Comments;Text[200])
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

