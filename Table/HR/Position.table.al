table 50230 Position
{
    // version TL2.0

    DataCaptionFields = Code, "Job Title";

    fields
    {
        field(1; Code; Code[20])
        {
        }
        field(2; "Job Title"; Text[70])
        {
        }
        field(3; "Reporting To"; Text[70])
        {
            TableRelation = Position."Job Title";
        }
        field(4; Department; Code[50])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('DEPARTMENT'));
        }
        field(5; Grade; Code[10])
        {
            TableRelation = Grade;
        }
        field(6; "No. of Posts"; Integer)
        {
        }
        field(7; "Occupied Positions"; Integer)
        {
            CalcFormula = Count (Employee WHERE("Job Title" = FIELD("Job Title")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Vacant Positions"; Integer)
        {
            Editable = false;
        }
        field(9; Active; Boolean)
        {
        }
        field(10; "Job Description"; Text[250])
        {
        }
        field(11; "Job KPI's"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Code", "Job Title")
        {
        }
    }

    fieldgroups
    {
    }

    procedure UpdateVacantPosition();
    begin
        CALCFIELDS("Occupied Positions");
        "Vacant Positions" := "No. of Posts" - "Occupied Positions";
        MODIFY;
    end;
}

