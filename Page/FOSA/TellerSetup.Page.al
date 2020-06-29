page 50080 "Teller Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Teller Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Teller ID"; "Teller ID")
                {
                    ApplicationArea = All;
                }
                field("Till No"; "Till No")
                {
                    ApplicationArea = All;
                }
                field("Till Name"; "Till Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Max Deposit"; "Max Deposit")
                {
                    ApplicationArea = All;
                }
                field("Max Withdrawal"; "Max Withdrawal")
                {
                    ApplicationArea = All;
                }
                field("Treasury Account"; "Treasury Account")
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

