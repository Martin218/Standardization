page 50708 "Procurement Types"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Procurement Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Has Sub Type"; "Has Sub Type")
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

