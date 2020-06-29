table 50284 "Job Competency Header"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Appraisal Year"; Integer)
        {
            TableRelation = "Appraisal Period";

            trigger OnValidate();
            begin
                IF AppraisalPeriod.GET("Appraisal Year") THEN BEGIN
                    "Appraisal Year" := AppraisalPeriod.Year;
                    "Appraisal Period" := AppraisalPeriod.Code;
                END;
            end;
        }
        field(3; "Appraisal Period"; Text[50])
        {
            Editable = false;
        }
        field(4; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('DEPARTMENT'));
        }
        field(5; "Job Code"; Code[20])
        {
            TableRelation = Position;

            trigger OnValidate();
            begin
                Position.RESET;
                Position.SETRANGE(Code, "Job Code");
                IF Position.FINDFIRST THEN BEGIN
                    "Job Description" := Position."Job Title";
                END;
            end;
        }
        field(6; "Job Description"; Text[100])
        {
            Editable = false;
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

    var
        AppraisalPeriod: Record 50260;
        Position: Record 50230;
}

