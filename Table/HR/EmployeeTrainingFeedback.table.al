table 50275 "Employee Training Feedback"
{
    // version TL2.0

    DataCaptionFields = "No.", "Employee Name", "Course/Seminar Name";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    "Job Title" := Employee."Job Title";
                    "Branch Code" := Employee."Global Dimension 1 Code";
                    "Branch Name" := Employee."Branch Name";
                    "Department Code" := Employee."Global Dimension 2 Code";
                    "Department Name" := Employee."Department Name";
                    "Employment Date" := Employee."Employment Date";
                END;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Job Title"; Text[100])
        {
            Editable = false;
        }
        field(5; "Branch Code"; Text[70])
        {
            Editable = false;
        }
        field(6; "Department Code"; Text[70])
        {
            Editable = false;
        }
        field(7; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(8; "Course/Seminar Name"; Text[100])
        {
            TableRelation = "Training Request";

            trigger OnValidate();
            begin
                IF TrainingRequest.GET("Course/Seminar Name") THEN BEGIN
                    "Course/Seminar Name" := TrainingRequest."Course/Seminar Name";
                    "Training Institution" := TrainingRequest."Training Institution";
                    Venue := TrainingRequest.Venue;
                    "Start Date" := TrainingRequest."Start Date";
                    "End Date" := TrainingRequest."End Date";
                    CreateEntries(TrainingRequest."No.");
                END;
            end;
        }
        field(9; "Training Institution"; Text[100])
        {
            Editable = false;
        }
        field(10; Venue; Text[50])
        {
            Editable = false;
        }
        field(11; "Start Date"; Date)
        {
            Editable = false;
        }
        field(12; "End Date"; Date)
        {
            Editable = false;
        }
        field(13; "Branch Name"; Text[50])
        {
            Editable = false;
        }
        field(14; "Department Name"; Text[70])
        {
            Editable = false;
        }
        field(15; Submitted; Boolean)
        {
        }
        field(16; "Created Date"; Date)
        {
        }
        field(17; "Created Time"; Time)
        {
        }
        field(18; "Created By"; Code[70])
        {
        }
        field(19; "Submitted Date"; Date)
        {
        }
        field(20; "Submitted Time"; Time)
        {
        }
        field(21; "Submitted By"; Code[70])
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
        HumanResourcesSetup.GET;
        "No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Evaluation No.", 0D, TRUE);
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    var
        Employee: Record 5200;
        HumanResourcesSetup: Record 5218;
        NoSeriesManagement: Codeunit 396;
        TrainingRequest: Record 50234;
        EvaluationQuestionSetup: Record 50274;
        TrainingEvaluationLine: Record 50276;
        SelectEvalQuestionsEntries: Record 50282;

    local procedure CreateEntries(TrainingNo: Code[20]);
    begin
        EvaluationQuestionSetup.RESET;
        IF EvaluationQuestionSetup.FINDSET THEN BEGIN
            REPEAT
                SelectEvalQuestionsEntries.RESET;
                SelectEvalQuestionsEntries.SETRANGE("Training No.", TrainingNo);
                SelectEvalQuestionsEntries.SETRANGE(Question, EvaluationQuestionSetup.Question);
                SelectEvalQuestionsEntries.SETRANGE(Select, TRUE);
                IF SelectEvalQuestionsEntries.FINDFIRST THEN BEGIN
                    TrainingEvaluationLine.INIT;
                    TrainingEvaluationLine."Evaluation No." := "No.";
                    TrainingEvaluationLine.Question := EvaluationQuestionSetup.Question;
                    IF EvaluationQuestionSetup."Selective Question" THEN BEGIN
                        TrainingEvaluationLine."Selective Question" := TRUE;
                        TrainingEvaluationLine."Option Set" := EvaluationQuestionSetup."Option Set";
                    END;
                    TrainingEvaluationLine.INSERT(TRUE);
                END;
            UNTIL EvaluationQuestionSetup.NEXT = 0;
        END;
    end;
}

