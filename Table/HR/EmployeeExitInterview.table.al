table 50240 "Employee Exit Interview"
{
    // version TL2.0


    fields
    {
        field(1; "Employee No."; Code[20])
        {
        }
        field(2; "Question Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Exit Interview Question".Code;

            trigger OnValidate();
            begin
                IF "Question Code" <> '' THEN BEGIN
                    HRExitInterviewQuestion.GET("Question Code");
                    Question := HRExitInterviewQuestion.Question;
                END ELSE BEGIN
                    Question := '';
                END;
            end;
        }
        field(3; Question; Text[100])
        {
            Editable = false;
        }
        field(4; Response; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Question Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRExitInterviewQuestion: Record 50241;
}

