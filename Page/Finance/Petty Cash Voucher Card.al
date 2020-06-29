page 50630 "Petty Cash Voucher Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Imprest Management";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Imprest No."; "Imprest No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                    Caption = 'Petty Cash Date';
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Purpose of Petty Cash';
                }
                field("Paying Bank Account"; "Paying Bank Account")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Paying Bank Name"; "Paying Bank Name")
                {
                    ApplicationArea = All;
                }
                field("A/C Balance"; "A/C Balance")
                {
                    ApplicationArea = All;
                    Caption = 'Balance';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Imprest Amount"; "Imprest Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
            }
            part("Petty Cash Lines"; "Petty Cash Lines")
            {
                ApplicationArea = All;
                SubPageLink = Code = FIELD("Imprest No.");
            }

        }
    }

    actions
    {
        area(creation)
        {

            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.SETRANGE("Imprest No.", "Imprest No.");
                    REPORT.RUN(50443, TRUE, TRUE, Rec);
                end;
            }
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                ToolTip = 'Request approval of the document.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgnt ExtF";
                begin
                    CashManagement.ImprestRequiredFields(Rec);
                    IF ApprovalsMgmt.CheckImprestApprovalPossible(Rec) THEN BEGIN
                        ApprovalsMgmt.OnSendImprestForApproval(Rec);
                    END;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgnt ExtF";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelImprestApprovalRequest(Rec);
                end;
            }
            action(Post)
            {
                Image = PostDocument;
                Visible = PostingImprest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    CashManagement.PostingPettyCash(Rec);
                end;
            }
        }
        area(processing)
        {

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IF Status <> Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
        END;
        IF Status = Status::Open THEN BEGIN
            ModifyFields := TRUE;
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Transaction Type" := "Transaction Type"::"Petty Cash";
    end;

    trigger OnOpenPage();
    begin
        CanRequestApprovalForFlow := TRUE;
        IF Status <> Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF Status = Status::Released THEN BEGIN
            IF Posted = FALSE THEN BEGIN
                PostingImprest := TRUE;
            END;
        END;
    end;

    var
        CashManagement: Codeunit "Cash Management";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        // PaymentRemittanceAdvise : Report "50441";
        PostingImprest: Boolean;
}

