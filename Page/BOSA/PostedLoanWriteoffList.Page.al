page 50332 "Posted Loan Writeoff List"
{
    // version TL2.0

    Caption = 'Posted Loan Writeoff';
    CardPageID = "Loan Writeoff";
    PageType = List;
    SourceTable = "Loan Writeoff Header";
    SourceTableView = WHERE(Status = FILTER(Approved),
                            Posted = FILTER(true));
    UsageCategory = Administration;
    ApplicationArea = All;
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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
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

