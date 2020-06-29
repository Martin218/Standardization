tableextension 50288 "Qualification Ext" extends Qualification
{
    Caption = 'Qualification';

    fields
    {
        field(4; "Qualification Type"; Option)
        {
            OptionCaption = '" ,Academic,Professional,Technical,Experience,Personal Attributes,Other"';
            OptionMembers = " ",Academic,Professional,Technical,Experience,"Personal Attributes",Other;
        }
    }

    keys
    {

    }

    fieldgroups
    {
    }
}

