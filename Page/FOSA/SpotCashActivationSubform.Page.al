page 50152 "SpotCash Activation Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "SpotCash Activation Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {ApplicationArea=All;
                }
                field("Member Name"; "Member Name")
                {ApplicationArea=All;
                }
                // field("Phone No."; "Phone No.")
                // {
                // }
                field("Current Member Status"; "Current Member Status")
                {ApplicationArea=All;
                }
                field("Activation Code"; "Activation Code")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

