page 50519 "Submitted Employee Eval."
{
    // version TL2.0

    CardPageID = "Employee Training Evaluation";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = 50275;
    SourceTableView = WHERE(Submitted = FILTER('Yes'));
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

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ERROR(Error000);
    end;

    trigger OnOpenPage();
    begin
        CurrPage.EDITABLE(FALSE);
    end;

    var
        Error000: Label 'You cannot create a new record from this point!';
}

