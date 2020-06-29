page 50127 "ATM Collection List"
{
    // version TL2.0

    Caption = 'New ATM Collections';
    CardPageID = "ATM Collection Card";
    PageType = List;
    SourceTable = "ATM Collection";
    SourceTableView = WHERE(Status = FILTER(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Application No."; "Application No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
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


                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Card No."; "Card No.")
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

