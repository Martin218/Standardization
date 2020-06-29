page 50221 "Pending Fund Transfer List"
{
    // version TL2.0

    Caption = 'Pending Fund Transfers';
    CardPageID = "Fund Transfer";
    PageType = List;
    SourceTable = "Fund Transfer";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));
    UsageCategory = Lists;
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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Source Account No."; "Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; "Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Destination Account No."; "Destination Account No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Name"; "Destination Account Name")
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
                field("Amount to Transfer"; "Amount to Transfer")
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

