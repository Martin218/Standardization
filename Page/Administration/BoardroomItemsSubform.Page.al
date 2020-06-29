page 50986 "Boardroom Items Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Boardroom Item";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Item; Item)
                {
                    ApplicationArea = All;

                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;

                }
                field("No."; "No.")
                {
                    Visible = false;
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
    }
}

