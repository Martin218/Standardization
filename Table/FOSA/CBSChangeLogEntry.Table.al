table 50018 "CBS Change Log Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            Editable = false;
        }
        field(2; "Table ID"; Integer)
        {
            Editable = false;
        }
        field(3; "Field No."; Integer)
        {
            Editable = false;
        }
        field(4; "Field Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Old Value"; Text[30])
        {
            Editable = false;
        }
        field(6; "New Value"; Text[30])
        {
            Editable = false;
        }
        field(7; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(8; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(9; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(10; "Last Modified By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(11; "Last Modified By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(12; "Last Modified By MAC Address"; Code[20])
        {
            Editable = false;
        }
        field(13; "Primary Key Value"; Code[20])
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

