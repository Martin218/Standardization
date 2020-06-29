page 50189 "Rejected Standing Order List"
{
    // version TL2.0

    Caption = 'Rejected Standing Orders';
    CardPageID = "Standing Order Card";
    PageType = List;
    SourceTable = "Standing Order";
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
{ApplicationArea = All;
                }
                field(Description; Description)
{ApplicationArea = All;
                }
                field("Member No."; "Member No.")
{ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
{ApplicationArea = All;
                }
                field("Source Account No."; "Source Account No.")
{ApplicationArea = All;
                }
                field("Source Account Name"; "Source Account Name")
{ApplicationArea = All;
                }
                field(Running; Running)
{ApplicationArea = All;
                }
                field("Next Run Date"; "Next Run Date")
{ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
{ApplicationArea = All;
                }
                field("End Date"; "End Date")
{ApplicationArea = All;
                }
                field(Frequency; Frequency)
{ApplicationArea = All;
                }
                field(Status; Status)
{ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
{ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
{ApplicationArea = All;
                }
                field("Created By"; "Created By")
{ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    var
        ApprovalEntry: Record "Approval Entry";
}

