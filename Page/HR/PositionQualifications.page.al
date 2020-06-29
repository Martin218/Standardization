page 50459 "Position Qualifications"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50232;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Qualification Type"; "Qualification Type")
                {
                    ApplicationArea = All;
                }
                field("Qualification Code"; "Qualification Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

