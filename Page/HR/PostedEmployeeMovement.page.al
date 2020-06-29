page 50447 "Posted Employee Movement"
{
    // version TL2.0

    CardPageID = "Employee Movement";
    PageType = List;
    SourceTable = 50229;
    SourceTableView = WHERE(Status = FILTER('Posted'));
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
                field("ID Number"; "ID Number")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Branch "; "Current Branch")
                {
                    ApplicationArea = All;
                }
                field(Department; "Current Department")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Current Job Tiltle")
                {
                    ApplicationArea = All;
                }
                field(Grade; "Current Grade")
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

