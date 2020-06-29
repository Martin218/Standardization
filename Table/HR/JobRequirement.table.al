table 50248 "Job Requirement"
{
    // version TL2.0


    fields
    {
        field(1; "Job Id"; Code[20])
        {
            NotBlank = true;
        }
        field(2; "Qualification Type"; Option)
        {
            NotBlank = false;
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes";
        }
        field(3; "Qualification Code"; Code[10])
        {
            Editable = true;
            NotBlank = true;
            TableRelation = Qualification WHERE("Qualification Type" = FIELD("Qualification Type"));

            trigger OnValidate();
            begin
                QualificationSetUp.RESET;
                QualificationSetUp.SETRANGE(QualificationSetUp.Code, "Qualification Code");
                IF QualificationSetUp.FIND('-') THEN
                    "Qualification Code" := QualificationSetUp.Description;
            end;
        }
        field(4; Qualification; Text[200])
        {
            NotBlank = false;
        }
        field(5; "Job Requirements"; Text[250])
        {
            NotBlank = true;
        }
        field(6; Priority; Option)
        {
            OptionMembers = " ",High,Medium,Low;
        }
        field(7; "Job Specification"; Option)
        {
            OptionMembers = " ",Academic,Professional,Technical,Experience;
        }
        field(8; "Score ID"; Decimal)
        {
        }
        field(9; Description; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Job Id", "Qualification Type", "Qualification Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        QualificationSetUp: Record 5202;
}

