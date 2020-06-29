page 50496 "Employee Training Eval. List"
{
    // version TL2.0

    CardPageID = "Employee Training Evaluation";
    PageType = List;
    SourceTable = 50275;
    SourceTableView = WHERE(Submitted = FILTER('No'));
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Course/Seminar Name"; "Course/Seminar Name")
                {
                    ApplicationArea = All;
                }
                field("Training Institution"; "Training Institution")
                {
                    ApplicationArea = All;
                }
                field(Venue; Venue)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; "Department Name")
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

