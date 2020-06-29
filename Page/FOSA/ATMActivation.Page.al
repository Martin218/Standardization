page 50134 "ATM Activation"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Category5,Category6,Category7,Category8';
    SourceTable = "ATM Activation Header";

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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            part("ATM Activation Subform"; "ATM Activation Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = IsVisibleSendApprovalRequest;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    IF ApprovalsMgmt.CheckATMActivationDeactivationAApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendATMActivationDeactivationForApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = IsVisibleCancelApprovalRequest;

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelATMActivationDeactivationApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    var
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;

    local procedure SetVisible()
    begin
        IF Status = Status::New THEN
            IsVisibleSendApprovalRequest := TRUE
        ELSE
            IsVisibleSendApprovalRequest := FALSE
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE;
        IF Status = Status::"Pending Approval" THEN
            CurrPage.EDITABLE := FALSE;
        IF Status = Status::Approved THEN
            CurrPage.EDITABLE := FALSE;
    end;
}

