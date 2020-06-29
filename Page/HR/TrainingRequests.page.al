page 50461 "Training Requests Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50234;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Training Description"; "Training Description")
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
                field(Duration; Duration)
                {
                    ApplicationArea = All;
                }
                field("Duration Units"; "Duration Units")
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
                field(Location; Location)
                {
                    ApplicationArea = All;
                }
                field("Cost of Training"; "Cost of Training")
                {
                    ApplicationArea = All;
                }
                field("Reason for Request"; "Reason for Request")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Total Cost of Training"; "Total Cost of Training")
                {
                    ApplicationArea = All;
                }
            }
            part("Training Request Line"; "Training Request Lines")
            {
                SubPageLink = "Training Request No." = FIELD("No.");
                ApplicationArea = All;
            }
            group("Audit Trail")
            {
                Editable = false;
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Request Time"; "Request Time")
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
        area(processing)
        {
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowSendForApproval;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        IF ApprovalsMgmtExt.IsTrainingRequestApprovalsWorkflowEnabled(Rec) THEN
                            ApprovalsMgmtExt.OnSendTrainingRequestForApproval(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowCancelApprovalRequest;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text002) THEN BEGIN
                        ApprovalsMgmtExt.OnCancelTrainingRequestApprovalRequest(Rec);
                    END;
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
                ApplicationArea = All;
                Visible = ShowApprove;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "No.");
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
                ApplicationArea = All;
                Visible = ShowReject;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "No.");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    ApprovalEntry.SETRANGE("Approver ID", USERID);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    END ELSE BEGIN
                        ERROR(Error001);
                    END;
                end;
            }
            action("Add To Training Calendar")
            {
                Image = Add;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeAddToCalendar;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text004) THEN BEGIN
                        "Added To Calendar" := TRUE;
                        MODIFY;
                        MESSAGE(Text006);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Submit To HR")
            {
                Image = CoupledOpportunity;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeSubmitToHR;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text005) THEN BEGIN
                        "Submitted To HR" := TRUE;
                        MODIFY;
                        MESSAGE(Text001);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Visibility;
    end;

    var
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsMgmtExt: Codeunit 50054;
        Text000: Label 'Are you sure you want to submit this training request for approval?';
        Text001: Label 'Training Request submitted successfuly!';
        Text002: Label 'Are you sure you want to cancel this training request?';
        Text003: Label 'Training Request cancelled successfuly!';

        ApprovalEntry: Record 454;
        Error000: Label 'There is no record to approve!';
        Error001: Label 'There is no record to reject!';
        ShowSendForApproval: Boolean;
        ShowCancelApprovalRequest: Boolean;
        ShowApprove: Boolean;
        ShowReject: Boolean;
        Text004: Label 'Are you sure you want to add this to the Training Calendar?';
        SeeAddToCalendar: Boolean;
        Text005: Label 'Are you sure you want to submit this training request to the HR for review?';
        SeeSubmitToHR: Boolean;
        Text006: Label 'Training Request Added Successfully!';

    local procedure Visibility();
    begin
        SeeSubmitToHR := FALSE;
        ShowSendForApproval := FALSE;
        ShowCancelApprovalRequest := FALSE;
        ShowReject := FALSE;
        ShowApprove := FALSE;
        SeeAddToCalendar := false;
        IF NOT "Submitted To HR" THEN BEGIN
            SeeSubmitToHR := TRUE;
        END;
        IF (Status = Status::Open) AND "Submitted To HR" THEN BEGIN
            CurrPage.EDITABLE(TRUE);
            SeeAddToCalendar := TRUE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            ShowReject := TRUE;
            ShowApprove := TRUE;
        END;
        IF (Status = Status::Open) AND "Added To Calendar" THEN BEGIN
            ShowSendForApproval := TRUE;
            SeeAddToCalendar := false;
        END;
    end;
}

