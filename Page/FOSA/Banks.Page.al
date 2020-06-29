page 50091 Banks
{
    // version TL2.0

    PageType = List;
    SourceTable = Banks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field(Name; Name)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

