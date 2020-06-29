table 50280 "Select Evaluation Question"
{
    // version TL2.0


    fields
    {
        field(1; "Training No."; Code[20])
        {
            TableRelation = "Training Request" WHERE(Status = FILTER(Released));

            trigger OnValidate();
            begin
                IF TrainingRequest.GET("Training No.") THEN BEGIN
                    "Course Name" := TrainingRequest."Course/Seminar Name";
                    "Start Date" := TrainingRequest."Start Date";
                    "End Date" := TrainingRequest."End Date";
                    CreateEntries;
                END;
            end;
        }
        field(2; "Course Name"; Text[250])
        {
        }
        field(3; "Start Date"; Date)
        {
        }
        field(4; "End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Training No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SelectEvalQuestionsEntries: Record 50282;
        TrainingRequest: Record 50234;

    local procedure CreateEntries();
    var
        EvaluationQuestionSetup: Record 50274;
    begin
        EvaluationQuestionSetup.RESET;
        IF EvaluationQuestionSetup.FINDSET THEN BEGIN
            REPEAT
                SelectEvalQuestionsEntries.INIT;
                SelectEvalQuestionsEntries."Training No." := "Training No.";
                SelectEvalQuestionsEntries.Question := EvaluationQuestionSetup.Question;
                SelectEvalQuestionsEntries.INSERT(TRUE);
            UNTIL EvaluationQuestionSetup.NEXT = 0;
        END;
    end;
}

