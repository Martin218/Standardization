table 50286 "Performance Review Header"
{
    // version TL2.0


    fields
    {
        field(1; Period; Code[20])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "First Name" := Employee."First Name";
                    "Middle Name" := Employee."Middle Name";
                    "Last Name" := Employee."Last Name";
                    "Department Code" := Employee."Global Dimension 2 Code";
                    VALIDATE("Department Code");
                    "Employment Date" := Employee."Employment Date";
                    "Employee Position" := Employee."Job Title";
                    Period := HRManagement.GetCurrentAppraisalPeriod();

                END;
            end;
        }
        field(3; "Employee Position"; Text[100])
        {
            TableRelation = Position."Job Title";
        }
        field(4; "Department Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('DEPARTMENT'));

            trigger OnLookup();
            var
                HRSetup: Record 5218;
                DimensionValue: Record 349;
                frmDimensionValues: Page 537;
            begin
            end;

            trigger OnValidate();
            begin
                IF DimensionValue.GET('DEPARTMENT', "Department Code") THEN BEGIN
                    "Department Name" := DimensionValue.Name;
                END;
            end;
        }
        field(5; "Appraiser Name"; Text[250])
        {
        }
        field(6; "KPI Score"; Code[20])
        {
        }
        field(7; "First Name"; Text[100])
        {
        }
        field(8; "Middle Name"; Text[100])
        {
        }
        field(9; "Last Name"; Text[100])
        {
        }
        field(10; "Length Of Service"; Text[250])
        {
        }
        field(11; Photo; BLOB)
        {
            Compressed = false;
        }
        field(12; "Score is Final"; Boolean)
        {
            trigger OnValidate();
            begin
                Validate("Total Score");
            end;

        }
        field(13; "Total Score"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Performance Competency Line"."Agreed Score" WHERE("Review No." = FIELD("Review No.")));
            Editable = false;

        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Posted By"; Code[20])
        {
        }
        field(16; "Posted Date"; Date)
        {
        }
        field(17; "Posted Time"; Time)
        {
        }
        field(18; "Development Needs"; Text[250])
        {
        }
        field(19; "Career Plan"; Text[250])
        {
        }
        field(20; "Employees Comments"; Text[250])
        {
        }
        field(21; "Appraisers Comments"; Text[250])
        {
        }
        field(22; "Company Name"; Text[250])
        {
        }
        field(23; "JD Updated"; Boolean)
        {
        }
        field(24; "Employment Date"; Date)
        {
        }
        field(25; "Appraiser Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Appraiser Employee No.") THEN BEGIN
                    "Appraiser Name" := Employee.FullName;
                    "Appraiser Job Title" := Employee."Job Title";
                END;
            end;
        }
        field(26; "Appraiser Job Title"; Text[100])
        {
        }
        field(27; "KPI Description"; Text[100])
        {
        }
        field(28; "Overall Reviewer Recommend"; Text[250])
        {
        }
        field(29; "KPI Comments"; Text[250])
        {
        }
        field(30; "Development Needs Employee"; Text[250])
        {
        }
        field(31; "Career Plan Employee"; Text[250])
        {
        }
        field(32; "Document Date"; Date)
        {
            Editable = false;
        }
        field(33; "Appraisal Agreement Reached"; Boolean)
        {
        }
        field(34; "Released to Appraiser"; Boolean)
        {
            Editable = false;
        }
        field(35; "Released to HR Admin"; Boolean)
        {
            Editable = false;
        }
        field(36; "Department Name"; Text[100])
        {
        }
        field(37; "Review No."; Code[20])
        {
            trigger OnValidate();
            begin
                HRManagement.FetchJobCompetencyLines("Employee No.", "Employee Position", Period, "Review No.");
            end;
        }
    }

    keys
    {
        key(Key1; "Review No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResourcesSetup.GET;
        "Review No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Performance Review Nos.", 0D, TRUE);
        Validate("Review No.");
    end;

    var
        NoSeriesManagement: Codeunit 396;
        HRManagement: Codeunit 50050;
        UserSetup: Record 91;
        Employee: Record 5200;
        Position: Record 50230;
        DimensionValue: Record 349;

        HumanResourcesSetup: Record 5218;

        AppraisalPeriod: Record 50260;
        TempPeriod: Integer;
}

