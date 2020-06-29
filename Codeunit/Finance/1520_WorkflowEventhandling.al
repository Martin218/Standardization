codeunit 50042 "Workflow Event Handling ExF"
{
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        ImprestSendForApprovalEventDescTxt: Label 'Approval of an Imprest is requested.';
        ImprestApprovalRequestCancelEventDescTxt: Label 'An approval request for an Imprest is canceled.';
        ImprestDocReleasedEventDescTxt: Label 'An Imprest document is released.';
        PVSendForApprovalEventDescTxt: Label 'Approval of a PV is requested.';
        PVApprovalRequestCancelEventDescTxt: Label 'An approval request for a PV is canceled.';
        PVDocReleasedEventDescTxt: Label 'A pv document is released.';

    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendImprestDocForApprovalCode, Database::"Imprest Management", ImprestSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelImprestDocApprovalRequestCode, Database::"Imprest Management", ImprestApprovalRequestCancelEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPVDocForApprovalCode, Database::"Payment/Receipt Voucher", PVSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPVDocApprovalRequestCode, Database::"Payment/Receipt Voucher", PVApprovalRequestCancelEventDescTxt, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendImprestDocForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPVDocForApprovalCode);
                end;
        end;


    end;

    procedure RunWorkflowOnSendImprestDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendImprestDocForApproval'));
    end;

    procedure RunWorkflowOnCancelImprestDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelImprestApprovalRequest'));
    end;

    procedure RunWorkflowOnSendPVDocForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendPVDocForApproval'));
    end;

    procedure RunWorkflowOnCancelPVDocApprovalRequestCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelPVApprovalRequest'));
    end;

    procedure RunWorkflowOnAfterReleaseImprestDocCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnAfterReleaseSalesDoc'));
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

    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnSendImprestForApproval', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnSendImprestDocForApproval(var ImprestManagement: Record "Imprest Management")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendImprestDocForApprovalCode, ImprestManagement);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnCancelImprestApprovalRequest', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnCancelIMprestApprovalRequest(var ImprestManagement: Record "Imprest Management")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelImprestDocApprovalRequestCode, ImprestManagement);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnSendPVForApproval', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnSendPVDocForApproval(var PV: Record "Payment/Receipt Voucher")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPVDocForApprovalCode, PV);
    end;

    [EventSubscriber(ObjectType::Codeunit, 50044, 'OnCancelPVApprovalRequest', '', false, false)]
    [Scope('OnPrem')]
    procedure RunWorkflowOnCancelPVApprovalRequest(var PV: Record "Payment/Receipt Voucher")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPVDocApprovalRequestCode, PV);
    end;
}