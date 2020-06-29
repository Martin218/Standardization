table 50282 "Select Eval. Questions Entries"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Training No."; Code[20])
        {
            TableRelation = "Training Request" WHERE(Status = FILTER(Released));
        }
        field(3; Select; Boolean)
        {
        }
        field(4; Question; Text[250])
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
        SelectEvalQuestionsEntries.RESET;
        IF SelectEvalQuestionsEntries.FINDLAST THEN
            "Entry No." := SelectEvalQuestionsEntries."Entry No." + 1
        ELSE
            "Entry No." := 1;
    end;

    var
        SelectEvalQuestionsEntries: Record 50282;
}

