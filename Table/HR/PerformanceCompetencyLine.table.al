table 50287 "Performance Competency Line"
{
    // version TL2.0


    fields
    {
        field(1; Period; Code[20])
        {
        }
        field(2; "Employee No."; Code[20])
        {
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = "Performance Competency";

            trigger OnValidate();
            begin
                IF PerformanceCompetency.GET(Code) THEN BEGIN
                    Description := PerformanceCompetency.Description;
                END;
            end;
        }
        field(4; Description; Text[250])
        {
        }
        field(5; "Employee Comment"; Text[250])
        {
        }
        field(6; "Employee Score"; Decimal)
        {
            MaxValue = 5;
            MinValue = 0;
        }
        field(7; "Appraiser Score"; Decimal)
        {
        }
        field(8; Indicators; Text[250])
        {
        }
        field(9; "Agreed Score"; Decimal)
        {
        }
        field(10; Notes; Text[250])
        {
        }
        field(11; "Appraiser Remarks"; Text[100])
        {
        }
        field(12; "Review No."; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Review No.", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        PerformanceCompetency: Record 50283;
}

