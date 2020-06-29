page 50434 "Leave Recalls List"
{
    // version TL2.0

    CardPageID = "Leave Recall Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = 50222;
    SourceTableView = WHERE(Status = FILTER('Open'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Leave Start Date"; "Leave Start Date")
                {
                    ApplicationArea = All;
                }
                field("Days Applied"; "Days Applied")
                {
                    ApplicationArea = All;
                }
                field("Leave Ending Date"; "Leave Ending Date")
                {
                    ApplicationArea = All;
                }
                field("Recall Date"; "Recall Date")
                {
                    ApplicationArea = All;
                }
                field("Recalled By"; "Recalled By")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("Recall Department"; "Recall Department")
                {
                    ApplicationArea = All;
                }
                field("Recall Branch"; "Recall Branch")
                {
                    ApplicationArea = All;
                }
                field("Reason for Recall"; "Reason for Recall")
                {
                    ApplicationArea = All;
                }
                field("Recalled To"; "Recalled To")
                {
                    ApplicationArea = All;
                }
                field("Recalled From"; "Recalled From")
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

