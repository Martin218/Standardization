table 50055 "Bank Branch"
{
    // version TL2.0


    fields
    {
        field(1; "Branch Code"; Code[10])
        {
        }
        field(2; "Branch Name"; Text[100])
        {
        }
        field(3; "Bank Code"; Code[10])
        {
            TableRelation = Banks;

            trigger OnValidate()
            begin
                IF Banks.GET("Bank Code") THEN
                    "Bank Name" := Banks.Name;
            end;
        }
        field(4; "Bank Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Branch Code")
        {
        }
        key(Key2; "Branch Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Branch Code", "Branch Name")
        {
        }
    }

    var
        Banks: Record Banks;
}

