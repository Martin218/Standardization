page 50417 "Employee Leave Plan Card"
{
    // version TL2.0

    Caption = '"Employee Leave Plan "';
    DeleteAllowed = true;
    PageType = Card;
    SourceTable = 50210;

    layout
    {
        area(content)
        {
            group(general)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; "Department Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Leave Code"; "Leave Code")
                {
                    ApplicationArea = All;
                }
                field("Leave Entitlement"; "Leave Entitlement")
                {
                    ApplicationArea = All;
                }
                field("Balance Brought Forward"; "Balance Brought Forward")
                {
                    ApplicationArea = All;
                }
                field("Added Back Days"; "Added Back Days")
                {
                    ApplicationArea = All;
                }
                field("Total Leave Days"; "Total Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Days in Plan"; "Days in Plan")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            part("Leave Plan Lines"; 50418)
            {

                SubPageLink = "No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Submit Leave Plan")
            {
                Image = SendTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SendLeavePlan;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        Status := Status::Released;
                        MODIFY;
                        MESSAGE(Text001);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Re-Open Leave Plan")
            {
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ReOpenPlan;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text002) THEN BEGIN
                        Status := Status::Open;
                        MODIFY;
                        MESSAGE(Text003);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        IF Status = Status::Open THEN BEGIN
            CurrPage.EDITABLE(TRUE);
            SendLeavePlan := TRUE;
            ReOpenPlan := FALSE;
        END ELSE BEGIN
            CurrPage.EDITABLE(FALSE);
            SendLeavePlan := FALSE;
            ReOpenPlan := TRUE;
        END;
    end;

    var
        ApprovalMgt: Codeunit 1535;
        Mail: Codeunit 397;
        Employee: Record 5200;
        LeavePlanLines: Record 50213;
        LeavePlanRec: Record 50210;
        LeaveTypes: Record 50208;
        SendLeavePlan: Boolean;
        ReOpenPlan: Boolean;
        Text000: Label 'Are you sure you want to submit your leave plan?';
        Text001: Label 'Leave Plan submitted successfully!';
        Text002: Label 'Are you sure you want to re-open your leave plan?';
        Text003: Label 'Leave Plan re-opened successfully!';
}

