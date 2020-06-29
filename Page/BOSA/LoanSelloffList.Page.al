page 50307 "Loan Selloff List"
{
    // version TL2.0

    Caption = 'New Loan Selloff';
    CardPageID = "Loan Selloff";
    PageType = List;
    SourceTable = "Loan Selloff";
    SourceTableView = WHERE(Status = FILTER(New));
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
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears Amount"; "Total Arrears Amount")
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

