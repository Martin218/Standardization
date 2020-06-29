table 50020 "Field Level User Access"
{
    // version TL2.0


    fields
    {
        field(1; "Table ID"; Integer)
        {
            NotBlank = true;
        }
        field(2; "Field ID"; Integer)
        {
            NotBlank = true;
        }
        field(3; "User ID"; Code[50])
        {
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                // UserMgt.LookupUserID("User ID");
            end;
        }
    }

    keys
    {
        key(Key1; "Table ID", "Field ID", "User ID")
        {

        }
    }

    fieldgroups
    {
    }
}

