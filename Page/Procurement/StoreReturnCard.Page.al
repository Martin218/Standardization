page 50732 "Store Return Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Requisition Header";

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
                field("Employee Code"; "Employee Code")
                {
                    Editable = false;
                }
                field("Employee Name"; "Employee Name")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("No of Approvals"; "No of Approvals")
                {
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Store Requisition No."; "Store Requisition No.")
                {
                    Editable = false;
                }
                field("Requisition Date"; "Requisition Date")
                {
                    Editable = false;
                }
                field("Requested By"; "Requested By")
                {
                    Editable = false;
                }
            }
            part(page; "Store Return Line")
            {
                SubPageLink = "Requisition No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(creation)
        {
            //Caption = 'Request Approvals';
            action("Send Approval Request")
            {
                Caption = 'Request Approvals';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeSendForApproval;

                trigger OnAction();
                begin
                    ProcurementManagement.OnSendRequisitionsForApproval(Rec);
                    IF ApprovalsMgmtExt.CheckStoreReturnApprovalPossible(Rec) THEN
                        ApprovalsMgmtExt.OnSendStoreReturnForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request.")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeCancelForApproval;

                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelStoreReturnApprovalRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("DMS Link")
            {
                Image = Web;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
            }
            action("Approval Entries")
            {
                Image = Approvals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Approval Entries";
                RunPageLink = "Document No." = FIELD("No.");
                RunPageMode = View;
            }
            group(Approval)
            {
                Caption = 'Approval';
                Image = Alerts;
                Visible = SeeApprovals;
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
                action(Comment)
                {
                    ApplicationArea = Suite;
                    Caption = 'Comments';
                    Image = ViewComments;
                    //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                    //PromotedCategory = Category4;
                    Visible = SeeApprovals;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
            group(Issuance)
            {
                Caption = 'Issuance';
                action("Create Item Journal Line")
                {
                    ApplicationArea = Suite;
                    Caption = 'Create Item Journal Line';
                    Image = TransferToLines;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Create Item Journal Line';
                    Visible = SeeReturn;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ProcurementManagement.ValidateItemJournalLine(Rec);
                        CurrPage.CLOSE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ManageIconVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Requisition Type" := "Requisition Type"::"Store Requisition";
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ManageIconVisibility;
    end;

    trigger OnOpenPage();
    begin
        ManageIconVisibility;
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        //ApprovalsMgmtExt: Codeunit "Approvals Mgmt Ext";
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt Proc";
        ProcurementManagement: Codeunit "Procurement Management";
        SeeSendForApproval: Boolean;
        SeeCancelForApproval: Boolean;
        SeeApprovals: Boolean;
        SeeIssuance: Boolean;
        SeeReturn: Boolean;

    local procedure ManageIconVisibility();
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        SeeSendForApproval := TRUE;
        SeeCancelForApproval := FALSE;
        SeeApprovals := FALSE;
        SeeIssuance := FALSE;
        SeeReturn := FALSE;
        IF Status = Status::Open THEN BEGIN
            SeeSendForApproval := TRUE;
            SeeCancelForApproval := FALSE;
            SeeApprovals := FALSE;
        END ELSE
            IF Status = Status::"Pending Approval" THEN BEGIN
                SeeSendForApproval := FALSE;
                SeeCancelForApproval := TRUE;
                IF ProcurementManagement.GetCurrentDocumentApprover("No.") <> USERID THEN
                    SeeApprovals := FALSE
                ELSE
                    SeeApprovals := TRUE;
                CurrPage.EDITABLE(FALSE);
            END ELSE
                IF Status = Status::Released THEN BEGIN
                    SeeSendForApproval := FALSE;
                    SeeCancelForApproval := FALSE;
                    SeeApprovals := FALSE;
                    CurrPage.EDITABLE(FALSE);
                END ELSE BEGIN
                    SeeSendForApproval := FALSE;
                    SeeCancelForApproval := FALSE;
                    SeeApprovals := FALSE;
                    CurrPage.EDITABLE(FALSE);
                END;
        IF "Requested By" <> USERID THEN
            SeeCancelForApproval := FALSE;
        IF (Status = Status::Released) THEN
            SeeReturn := TRUE
        ELSE
            IF (Status = Status::Released) AND ("Issuance Status" = "Issuance Status"::Returned) THEN BEGIN
                SeeReturn := FALSE;
            END;
    end;
}

