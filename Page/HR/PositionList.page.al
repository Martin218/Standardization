page 50457 "Position List"
{
    // version TL2.0

    CardPageID = "Position Card";
    PageType = List;
    SourceTable = 50230;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Reporting To"; "Reporting To")
                {
                    ApplicationArea = All;
                }
                field(Department; Department)
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                field("No. of Posts"; "No. of Posts")
                {
                    ApplicationArea = All;
                }
                field("Occupied Positions"; "Occupied Positions")
                {
                    ApplicationArea = All;
                }
                field("Vacant Positions"; "Vacant Positions")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord();
    begin
        UpdateVacantPosition;
    end;
}

