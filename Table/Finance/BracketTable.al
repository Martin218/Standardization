table 50302 "Bracket Table"
{
    


    fields
    {
        field(1;"Table Code";Code[30])
        {
        }
        field(2;Type;Option)
        {
            OptionCaption = 'Percentage,Range,Monthly,Quarterly,Annually';
            OptionMembers = Percentage,Range,Monthly,Quarterly,Annually;
        }
        field(3;Description;Text[70])
        {
        }
        field(4;"Effective Starting Date";Date)
        {
        }
        field(5;"Effective End Date";Date)
        {
        }
    }

    keys
    {
        key(Key1;"Table Code")
        {
        }
    }

    fieldgroups
    {
    }
}

