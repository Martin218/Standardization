page 50602 "Payment Voucher"
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
                    Editable = false;
                }
                field("Payment Date"; "Payment Date")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Paying Bank"; "Paying Bank")
                {
                    ApplicationArea = All;
                }
                field("Paying/Receiving Bank Name"; "Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paying Bank Name';
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
                }
                field("Payment Mode"; "Payment Mode")
                {
                    ApplicationArea = All;
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
                field("VAT Amount"; "VAT Amount")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; "Net Amount")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Amount"; "Withholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Next Approver"; "Next Approver")
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; "Approval Status")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
            }
            group("Payment Lines")
            {
                Caption = 'Payment Lines';
                part("PV Lines"; "PV Lines")
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
                        REPORT.RUN(50440, TRUE, TRUE, Rec);
                    end;
                }
                action("Remittance Advise")
                {
                    Image = Print;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    PromotedOnly = true;
                    Visible = false;
                    ApplicationArea = Basic, Suite;
                    trigger OnAction();
                    begin
                        Rec.SETRANGE("Paying Code.", "Paying Code.");
                        REPORT.RUN(50441, TRUE, TRUE);
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
                        PaymentReceiptProcessing.PostingPaymentVoucher(Rec);
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

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgnt ExtF";
                        WorkflowWebhookMgt: Codeunit "Approvals Mgmt.";
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
        "Line type" := "Line type"::Payment;
        "Document Type" := "Document Type"::"Payment Voucher";
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
                PostingPV := TRUE;
            END;
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

