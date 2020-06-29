page 50709 "Procurement Sub Types"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Procurement Sub Types";

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
                field("Sub Type"; "Sub Type")
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

