page 55026 "Group Attendance List"
{
    // version MC2.0

    Caption = '<Group Attendance>';
    CardPageID = "Group Attendance";
    PageType = List;
    SourceTable = "Group Attendance Header";
    SourceTableView = WHERE(Status = FILTER(New));

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
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field("Current Meeting Date"; "Current Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Meeting Venue"; "Meeting Venue")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(2);
        //SETRANGE("Loan Officer ID",USERID);
    end;

    var
        //MicroCreditManagement: Codeunit "55002";
        Text000: Label 'Are you sure you want to generate an attendance sheet?';
        Member: Record "Member";
        Error000: Label 'You do not have any groups assigned!';
}

