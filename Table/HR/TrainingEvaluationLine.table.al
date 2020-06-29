table 50276 "Training Evaluation Line"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Evaluation No."; Code[20])
        {
        }
        field(3; Question; Text[250])
        {
        }
        field(4; "Selective Answer"; Code[10])
        {
            TableRelation = "Option Set Value".Value WHERE(Code = FIELD("Option Set"));
        }
        field(5; "Narrative Answer"; Text[250])
        {
        }
        field(6; "Selective Question"; Boolean)
        {
        }
        field(7; "Option Set"; Code[20])
        {
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

    trigger OnInsert();
    begin
        TrainingEvaluationLine.RESET;
        IF TrainingEvaluationLine.FINDLAST THEN BEGIN
            "Entry No." := TrainingEvaluationLine."Entry No." + 1;
        END ELSE BEGIN
            "Entry No." := 1;
        END;
    end;

    var
        TrainingEvaluationLine: Record 50276;
}

