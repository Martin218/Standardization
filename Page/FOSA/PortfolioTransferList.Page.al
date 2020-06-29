page 55091 "Portfolio Transfer List"
{
    // version MC2.0

    Caption = 'New Portfolio Transfers';
    CardPageID = "Portfolio Transfer Card";
    Editable = false;
    PageType = List;
    SourceTable = "Portfolio Transfer";
    SourceTableView = WHERE(Status = FILTER(New));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field("Transfer Type"; "Transfer Type")
                {ApplicationArea=All;
                }
                field(Category; Category)
                {ApplicationArea=All;
                }
                field("Source Branch Code"; "Source Branch Code")
                {ApplicationArea=All;
                }
                field("Source Branch Name"; "Source Branch Name")
                {ApplicationArea=All;
                }
                field("Source Loan Officer ID"; "Source Loan Officer ID")
                {ApplicationArea=All;
                }
                field("Created By"; "Created By")
                {ApplicationArea=All;
                }
                field("Created Date"; "Created Date")
                {ApplicationArea=All;
                }
                field("Created Time"; "Created Time")
                {ApplicationArea=All;
                }
                field(Status; Status)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

