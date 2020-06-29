codeunit 50044 "Approvals Mgnt ExtF"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ImprestManagement: Record "Imprest Management";
        PV: Record "Payment/Receipt Voucher";
    begin
        case RecRef.Number of
            Database::"Imprest Management":
                begin
                    RecRef.SetTable(ImprestManagement);
                    ImprestManagement.CalcFields("Imprest Amount");
                    ApprovalEntryArgument."Document No." := ImprestManagement."Imprest No.";
                    ApprovalEntryArgument.Amount := ImprestManagement."Imprest Amount";
                    ApprovalEntryArgument."Amount (LCY)" := ImprestManagement."Imprest Amount";
                end;
            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PV.CalcFields("Net Amount");
                    ApprovalEntryArgument."Document No." := pv."Paying Code.";
                    ApprovalEntryArgument.Amount := PV."Net Amount";
                    ApprovalEntryArgument."Amount (LCY)" := PV."Net Amount";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        ImprestManagement: Record "Imprest Management";
        PV: Record "Payment/Receipt Voucher";
    begin
        case RecRef.Number of
            Database::"Imprest Management":
                begin
                    RecRef.SetTable(ImprestManagement);
                    ImprestManagement.Validate(Status, ImprestManagement.Status::"Pending Approval");
                    ImprestManagement.Modify(true);
                    Variant := ImprestManagement;
                    IsHandled := true;
                end;
            Database::"Payment/Receipt Voucher":
                begin
                    RecRef.SetTable(PV);
                    PV.Validate(Status, PV.Status::"Pending Approval");
                    PV.Modify(true);
                    Variant := PV;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendImprestForApproval(var ImprestManagement: Record "Imprest Management")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelImprestApprovalRequest(var ImprestManagement: Record "Imprest Management")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPVForApproval(var PV: Record "Payment/Receipt Voucher")
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPVApprovalRequest(var PV: Record "Payment/Receipt Voucher")
    begin
    end;

    procedure ShowImprestApprovalstatus(var ImprestManagement: Record "Imprest Management"): Boolean
    begin
        if ReleaseApprovedDocument.FindReleaseDoc(ImprestManagement."Imprest No.", Database::"Imprest Management") then begin
            Message(DocStatusChangedMsg, ImprestManagement."Imprest No.", ImprestManagement.Status::Released);
        end else begin
            Message(PendingApprovalmsg);
        end;
    end;

    procedure IsImprestDocApprovalsWorkflowEnabled(var ImprestManagement: Record "Imprest Management"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(ImprestManagement, WorkflowEventHandlingExt.RunWorkflowOnSendImprestDocForApprovalCode));
    end;

    procedure CheckImprestApprovalPossible(var ImprestManagement: Record "Imprest Management"): Boolean
    begin
        if not IsImprestDocApprovalsWorkflowEnabled(ImprestManagement) then begin
            Error(NoWorkflowEnabledErr);
        end else begin
            exit(true);
        end;
    end;

    procedure IsPVDocApprovalsWorkflowEnabled(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin
        exit(WorkflowManagement.CanExecuteWorkflow(PV, WorkflowEventHandlingExt.RunWorkflowOnSendPVDocForApprovalCode));
    end;

    procedure CheckPVApprovalPossible(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin
        if not IsPVDocApprovalsWorkflowEnabled(pv) then begin
            Error(NoWorkflowEnabledErr);
        end else begin
            exit(true);
        end;
    end;

    procedure CheckImprestDocApprovalsWorkflowEnabled(var ImprestManagement: Record "Imprest Management"): Boolean
    begin

    end;

    procedure CheckPVDocApprovalsWorkflowEnabled(var PV: Record "Payment/Receipt Voucher"): Boolean
    begin

    end;

    var
        PendingApprovalmsg: Label 'An Apporval request has been sent to your immediate approver';
        DocStatusChangedMsg: Label '%1 %2 has been automatically approved. The status has been changed to %3.';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseApprovedDocument: Codeunit PerformManualCheckandRelease;
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling ExF";

}