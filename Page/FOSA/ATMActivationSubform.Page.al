page 50135 "ATM Activation Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "ATM Activation Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field("Card No."; "Card No.")
                // {
                // }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Current ATM Status"; "Current ATM Status")
                {
                    ApplicationArea = All;
                }
                field("Activation Code"; "Activation Code")
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

