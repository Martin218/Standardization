page 50264 "Rejected Loan Resched. List"
{
    // version TL2.0

    Caption = 'Rejected Loan Reschedulings';
    CardPageID = "Loan Rescheduling";
    PageType = List;
    SourceTable = "Loan Rescheduling";
    SourceTableView = WHERE(Status = FILTER(Rejected));
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
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Approved Loan Amount"; "Approved Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Loan Balance"; "Outstanding Loan Balance")
                {
                    ApplicationArea = All;
                }
                field("Rescheduling Option"; "Rescheduling Option")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
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

