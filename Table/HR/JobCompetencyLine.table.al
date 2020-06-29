table 50285 "Job Competency Line"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Performance Competency Code"; Code[20])
        {
            TableRelation = "Performance Competency";

            trigger OnValidate();
            begin
                IF PerformanceCompetency.GET("Performance Competency Code") THEN BEGIN
                    Description := PerformanceCompetency.Description;
                END;
            end;
        }
        field(3; Description; Text[100])
        {
        }
        field(4; Remarks; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Performance Competency Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PerformanceCompetency: Record 50283;
}

