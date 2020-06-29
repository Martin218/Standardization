page 50625 "Receipt Voucher"
{
    // version TL2.0

    SourceTable = "Payment/Receipt Voucher";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Paying Code."; "Paying Code.")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt No.';
                    Editable = false;
                }
                field("Payment Date"; "Payment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Date';
                    Editable = false;
                }
                field("Paying Bank"; "Paying Bank")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank';
                }
                field("Paying/Receiving Bank Name"; "Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank Name';
                    Editable = false;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Payee Name"; "Payee Name")
                {
                    ApplicationArea = All;
                    Caption = 'Customer Name';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Transaction Details';
                    ShowMandatory = true;
                }
                field("Payment Mode"; "Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Mode';
                    ShowMandatory = true;
                }
                field("Cheque No."; "Cheque No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; "Net Amount")
                {
                    ApplicationArea = All;
                }
            }
            group(ReceiptLines)
            {
                Caption = 'Receipt Lines';
                part("Receipt Lines"; "PV Lines")
                {
                    ApplicationArea = All;
                    SubPageLink = Code = FIELD("Paying Code.");
                }
            }
        }
    }

    actions
    {
        area(creation)
        {

            group(main)
            {
                action(Print)
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        Rec.SETRANGE("Paying Code.", "Paying Code.");
                        REPORT.RUN(50447, TRUE, TRUE, Rec);
                    end;
                }
                action(Post)
                {
                    Image = PostApplication;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedOnly = true;
                    Visible = PostingPV;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        PaymentReceiptProcessing.PostingReceipttVoucher(Rec);
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
                    Visible = false;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgnt ExtF";
                    begin
                        PaymentReceiptProcessing.RequiredFields(Rec);
                        IF ApprovalsMgmt.CheckPVApprovalPossible(Rec) THEN BEGIN
                            ApprovalsMgmt.OnSendPVForApproval(Rec);
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
                    Visible = false;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgnt ExtF";
                        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    begin
                        ApprovalsMgmt.OnCancelPVApprovalRequest(Rec);
                    end;
                }
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
                    Visible = false;

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

    trigger OnModifyRecord(): Boolean;
    begin
        IF Status <> Status::Open THEN BEGIN
            IF CanRequestApprovalForFlow = TRUE THEN BEGIN
                CanRequestApprovalForFlow := FALSE;
            END;
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Line type" := "Line type"::Receipt;
        "Document Type" := "Document Type"::Receipt;
    end;

    trigger OnOpenPage();
    begin
        CanRequestApprovalForFlow := TRUE;
        IF Status <> Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF Posted = FALSE THEN BEGIN
            PostingPV := TRUE;
            CurrPage.EDITABLE(TRUE);
        END ELSE BEGIN
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    var
        PaymentReceiptProcessing: Codeunit "Cash Management";
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
        //PaymentRemittanceAdvise : Report "50441";
        PostingPV: Boolean;
}

