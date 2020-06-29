page 50040 "Activation Charges"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Activation Charge";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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

