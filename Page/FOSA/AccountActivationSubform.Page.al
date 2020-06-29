page 50047 "Account Activation Subform"
{
    // version TL2.0

    CardPageID = "Account Activation";
    PageType = ListPart;
    SourceTable = "Account Activation Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Current Account Status"; "Current Account Status")
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

