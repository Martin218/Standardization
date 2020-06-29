table 50019 "Field Level Security"
{
    // version TL2.0


    fields
    {
        field(1; "Table ID"; Integer)
        {
            NotBlank = true;
            TableRelation = AllObj."Object ID" WHERE("Object Type" = CONST(Table));
        }
        field(2; "Table Name"; Text[30])
        {
            FieldClass = FlowField;

            CalcFormula = Lookup (AllObj."Object Name" WHERE("Object Type" = CONST(Table),
                                                             "Object ID" = FIELD("Table ID")));
            Editable = false;
        }
        field(3; "Field ID"; Integer)
        {
            NotBlank = true;
            TableRelation = Field WHERE(TableNo = FIELD("Table ID"));
        }

        field(4; "Field Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Field.FieldName WHERE(TableNo = FIELD("Table ID"),
                                                        "No." = FIELD("Field ID")));
            Editable = false;

        }
        field(5; "Activate Change Log"; Boolean)
        {
        }
        field(6; "Request for Approval"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Table ID", "Field ID")
        {
        }
    }

    fieldgroups
    {
    }
}

