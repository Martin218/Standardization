page 50419 "Leave Periods"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50212;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Starting Date"; "Starting Date")
                {
                    ApplicationArea = All;
                }
                field("Period Description"; "Period Description")
                {
                    ApplicationArea = All;
                }
                field("New Fiscal Year"; "New Fiscal Year")
                {
                    ApplicationArea = All;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = All;
                }
                field("Date Locked"; "Date Locked")
                {
                    ApplicationArea = All;
                }
                field("Reimbursement Closing Date"; "Reimbursement Closing Date")
                {
                    ApplicationArea = All;
                }
                field("Period Code"; "Period Code")
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
            action("Create Leave Year")
            {
                Caption = 'Create Year';
                Ellipsis = true;
                Image = CreateYear;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report 50251;
                ApplicationArea = All;
            }
            action("HR Leave Year - Close")
            {
                Caption = 'Close Year';
                //  Image = "<Undefined>";
                Promoted = true;
                PromotedCategory = Process;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        HRManagement.CloseLeaveYear;
                    END;
                end;
            }
            action("View Leave Days")
            {
                Image = Balance;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
            }
        }
    }

    var
        HRManagement: Codeunit 50050;
        Text000: Label 'Are you sure you want to close this leave period?';
}

