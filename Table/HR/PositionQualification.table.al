table 50232 "Position Qualification"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Position Code"; Code[20])
        {
        }
        field(3; "Qualification Type"; Option)
        {
            OptionCaption = '" ,Academic,Professional,Technical,Experience,Personal Attributes,Other"';
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes",Other;
        }
        field(4; "Qualification Code"; Code[30])
        {
            TableRelation = Qualification WHERE("Qualification Type" = FIELD("Qualification Type"));
        }
        field(5; Description; Text[50])
        {
        }
        field(6; Priority; Option)
        {
            OptionCaption = ',High,Medium,Low';
            OptionMembers = ,High,Medium,Low;
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Position Code")
        {
        }
    }

    fieldgroups
    {
    }
}

