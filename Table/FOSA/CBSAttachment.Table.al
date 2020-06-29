table 50132 "CBS Attachment"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; RecordID; Text[50])
        {
        }
        field(3; "Document No."; Code[20])
        {
        }
        field(4; "File Name"; Text[200])
        {
        }
        field(5; Attachment; BLOB)
        {
        }
        field(6; "File Path"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

