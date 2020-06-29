page 50477 "Recruitment List"
{
    // version TL2.0

    CardPageID = "Recruitment Card";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = 50246;
    SourceTableView = WHERE(Status = FILTER('Open'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Recruitment Needs Code"; "Recruitment Needs Code")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Job ID"; "Job ID")
                {
                    ApplicationArea = All;
                }
                field("Department Requested"; "Department Requested")
                {
                    ApplicationArea = All;
                }
                field("Requested Positions"; "Requested Positions")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Date"; "Recruitment Date")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Type"; "Recruitment Type")
                {
                    ApplicationArea = All;
                }
                field("Request Done By"; "Request Done By")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
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

