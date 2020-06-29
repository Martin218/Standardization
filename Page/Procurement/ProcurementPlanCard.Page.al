page 50701 "Procurement Plan Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Procurement Plan Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    Visible = true;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                    Visible = true;
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Current Budget"; "Current Budget")
                {
                    Editable = false;
                }
                field("Budget Per Branch?"; "Budget Per Branch?")
                {
                    Editable = false;
                }
                field("Budget Per Department?"; "Budget Per Department?")
                {
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                }
                field("Created On"; "Created On")
                {
                    Editable = false;
                }
                field("No. Of Approvals"; "No. Of Approvals")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
            }
            part(page1; "Procurement Plan Lines")
            {
                SubPageLink = "Plan No" = FIELD("No.");
            }
        }
        area(factboxes)
        {
            part(page; "Procurement Plan FactBox")
            {
                SubPageLink = "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Submit Procurement Plan")
            {

                trigger OnAction();
                begin
                    ProcurementManagement.OnSubmitNewProcurementPlan(Rec);
                end;
            }
            action("Recall From Submission")
            {
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeSendRequest;

                trigger OnAction();
                begin
                    ProcurementManagement.OnSubmitNewProcurementPlan(Rec);
                    IF ApprovalsMgmtExt.CheckProcurementPlanApprovalPossible(Rec) THEN BEGIN
                        ApprovalsMgmtExt.OnSendProcurementPlanForApproval(Rec);
                    END;
                    /* if ApprovalMgtTest.CheckProcurementPlanWorkflowEnabled(Rec) then begin
                        ApprovalMgtTest.OnSendProcurementPlanForApproval(Rec);
                    end; */
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
                Visible = SeeCancelReq;

                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelProcurementPlanApprovalRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            group("Release_")
            {
                Caption = 'Release';
                Image = ReleaseDoc;
                action(Release)
                {
                    ApplicationArea = Advanced;
                    Caption = 'Re&lease';
                    Image = ReleaseDoc;
                    ShortCutKey = 'Ctrl+F9';
                    ToolTip = 'Release the document to the next stage of processing. When a document is released, it will be included in all availability calculations from the expected receipt date of the items. You must reopen the document before you can make changes to it.';

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        //ReleasePurchDoc.PerformManualRelease(Rec);
                    end;
                }
                action(Reopen)
                {
                    ApplicationArea = Suite;
                    Caption = 'Re&open';
                    Image = ReOpen;
                    ToolTip = 'Reopen the document to change it after it has been approved. Approved documents have the Released status and must be opened before they can be changed';

                    trigger OnAction();
                    var
                        ReleasePurchDoc: Codeunit "Release Purchase Document";
                    begin
                        //ReleasePurchDoc.PerformManualReopen(Rec);
                    end;
                }
            }

        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        ValidateVisibility();
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ValidateVisibility();
    end;

    trigger OnOpenPage();
    begin
        ValidateVisibility();
    end;

    var
        EditableOnOpen: Boolean;
        SeeBranch: Boolean;
        SeeDepartment: Boolean;
        ProcurementManagement: Codeunit "Procurement Management";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //ApprovalsMgmtExt: Codeunit "Approvals Mgmt Ext";
        ApprovalEntry: Record "Approval Entry";
        SeeApprovals: Boolean;
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt Proc";
        SeeSendRequest: Boolean;
        SeeCancelReq: Boolean;

    //ApprovalMgtTest: Codeunit ApprovalMgtTestExt;

    local procedure ValidateVisibility();
    begin
        SeeBranch := FALSE;
        SeeDepartment := FALSE;
        IF "Budget Per Branch?" = TRUE THEN
            SeeBranch := TRUE;
        IF "Budget Per Department?" = TRUE THEN
            SeeDepartment := TRUE;
        SeeSendRequest := TRUE;
        IF Status <> Status::New THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            SeeSendRequest := FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN begin
            IF "Created By" = USERID THEN
                SeeCancelReq := TRUE
            ELSE
                SeeCancelReq := FALSE;
            SeeApprovals := true;
        end ELSE begin
            SeeCancelReq := FALSE;
        end;
    end;
}

