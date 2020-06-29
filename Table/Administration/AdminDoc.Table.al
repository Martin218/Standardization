table 50503 "Admin Doc"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Integer)
        {
        }
        field(2; "Document Path"; Text[250])
        {
        }
        field(3; "Document Name"; Text[250])
        {
        }
        field(4; "Upload date"; Date)
        {
        }
        field(5; "Upload By"; Code[80])
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = 'Upload,Delete';
            OptionMembers = Upload,Delete;
        }
        field(7; Deleted; Boolean)
        {
        }
        field(8; "Upload Time"; Time)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResourceDoc.RESET;
        IF HumanResourceDoc.FINDLAST THEN
            "No." := HumanResourceDoc."No." + 1
        ELSE
            "No." := 1;
    end;

    var
        HumanResourceDoc: Record "Human Resource Doc";
}

