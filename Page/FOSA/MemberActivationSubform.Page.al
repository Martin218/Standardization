page 50035 "Member Activation Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = ListPart;
    PromotedActionCategories = 'New,Process,Reports,Category4,Category5,Category6,Category7,Category8';
    SourceTable = "Member Activation Line";

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
                field("National ID"; "National ID")
                {ApplicationArea=All;
                }
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

