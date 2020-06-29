page 50410 "Leave Application Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50206;

    layout
    {
        area(content)
        {
            group(Application)
            {
                field("Application No"; "Application No")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Mobile No"; "Mobile No")
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
                field(Department; Department)
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
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
            }
            group("Current Application")
            {
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("Days Applied"; "Days Applied")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Resumption Date"; "Resumption Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Duties Taken Over By"; "Duties Taken Over By")
                {
                    ApplicationArea = All;
                }
                field("Substitute Name"; "Substitute Name")
                {
                    ApplicationArea = All;
                }
                field("Leave balance"; "Leave balance")
                {
                    ApplicationArea = All;
                }
                field("Reason for Leave"; "Reason for Leave")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            group(Balances)
            {
                field("Leave Earned to Date"; "Leave Earned to Date")
                {
                    ApplicationArea = All;
                }
                field("Balance brought forward"; "Balance brought forward")
                {
                    ApplicationArea = All;
                }
                field("Recalled Days"; "Recalled Days")
                {
                    ApplicationArea = All;
                }
                field("Lost Days"; "Lost Days")
                {
                    ApplicationArea = All;
                }
                field("Total Leave Days Taken"; "Total Leave Days Taken")
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
            action(SendLeaveApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit 50054;
                begin
                    IF ApprovalsMgmt.CheckLeaveApplicationApprovalPossible(Rec) THEN BEGIN
                        ApprovalsMgmt.OnSendLeaveApplicationForApproval(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action(CancelLeaveApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit 50054;
                    WorkflowWebhookMgt: Codeunit 1543;
                begin
                    ApprovalsMgmt.OnCancelLeaveApplicationApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);
                    CurrPage.CLOSE;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowApprove;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "Application No");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    END ELSE BEGIN
                        ERROR(Error000);
                    END;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowReject;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "Application No");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    END ELSE BEGIN
                        ERROR(Error001);
                    END;
                end;
            }
            action("Print Leave Form")
            {
                Image = Form;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    LeaveApplication.RESET;
                    LeaveApplication.SETFILTER("Application No", "Application No");
                    IF LeaveApplication.FINDSET THEN BEGIN
                        REPORT.RUN(50070, TRUE, FALSE, LeaveApplication);
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Visibility();
    end;

    var
        ApprovalsMgmtExt: Codeunit 50054;
        ApprovalsMgmt: Codeunit 1535;

        ApprovalEntry: Record 454;
        //LeaveApplication1: Report 50070;
        LeaveApplication: Record 50206;

        Error000: Label 'There is no record to approve!';
        Error001: Label 'There is no record to reject!';
        ShowSendForApproval: Boolean;
        ShowCancelApprovalRequest: Boolean;
        ShowApprove: Boolean;
        ShowReject: Boolean;

    local procedure Visibility();
    begin
        IF Status = Status::Open THEN BEGIN
            CurrPage.EDITABLE(TRUE);
            ShowSendForApproval := FALSE;
            ShowCancelApprovalRequest := FALSE;
            ShowReject := FALSE;
            ShowApprove := FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            ShowSendForApproval := FALSE;
            IF "User ID" = USERID THEN BEGIN
                ShowCancelApprovalRequest := TRUE;
                ShowReject := FALSE;
                ShowApprove := FALSE;
            END ELSE BEGIN
                ShowCancelApprovalRequest := FALSE;
                ShowReject := TRUE;
                ShowApprove := TRUE;
            END;
        END;
        IF (Status = Status::Rejected) OR (Status = Status::Released) THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            ShowSendForApproval := FALSE;
            ShowCancelApprovalRequest := FALSE;
            ShowReject := FALSE;
            ShowApprove := FALSE;
        END;
    end;
}

