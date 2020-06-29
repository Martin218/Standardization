codeunit 50062 "Workflow Event Handling Proc"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnSendProcurementPlanForApprovalCode, DATABASE::"Procurement Plan Header", ProcurementPlanSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnCancelProcurementPlanApprovalRequestCode, DATABASE::"Procurement Plan Header", ProcurementPlanCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnAfterReleaseProcurementPlanCode, DATABASE::"Procurement Plan Header", ProcurementPlanReleaseEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnSendPlanBudgetForApprovalCode, DATABASE::"G/L Budget Name", PlanBudgetSendForApprovalEventDescTXt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnCancelPlanBudgetForApprovalRequestCode, DATABASE::"G/L Budget Name", PlanBudgetCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(
          RunWorkflowOnAfterReleasePlanBudgetCode, DATABASE::"G/L Budget Name", PlanBudgetReleaseEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPurchaseRequisitionForApprovalCode, DATABASE::"Requisition Header",
          PurchaseRequisitionSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode, DATABASE::"Requisition Header",
          PurchaseRequisitionCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleasePurchaseRequisitionCode, DATABASE::"Requisition Header",
          PurchaseRequisitionReleaseEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStoreRequisitionForApprovalCode, DATABASE::"Requisition Header",
          StoreRequisitionSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStoreRequisitionApprovalRequestCode, DATABASE::"Requisition Header",
          StoreRequisitionCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseStoreRequisitionCode, DATABASE::"Requisition Header",
          StoreRequisitionReleaseEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStoreReturnForApprovalCode, DATABASE::"Requisition Header",
          StoreReturnSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStoreReturnApprovalRequestCode, DATABASE::"Requisition Header",
          StoreReturnCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseStoreReturnCode, DATABASE::"Requisition Header",
          StoreReturnReleaseEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendProcurementProcessForApprovalCode, DATABASE::"Procurement Request",
          ProcurementProcessSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelProcurementProcessRequestCode, DATABASE::"Procurement Request",
          ProcurementProcessCancelApprovalReqEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseProcurementProcessCode, DATABASE::"Procurement Request",
          ProcurementProcessReleaseEventDescTxt, 0, FALSE);


    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelProcurementPlanApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelProcurementPlanApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);
            RunWorkflowOnCancelPlanBudgetForApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPlanBudgetForApprovalRequestCode, RunWorkflowOnSendPlanBudgetForApprovalCode);
            RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
            RunWorkflowOnCancelStoreRequisitionApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStoreRequisitionApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);
            RunWorkflowOnCancelStoreReturnApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStoreReturnApprovalRequestCode, RunWorkflowOnSendStoreReturnForApprovalCode);
            RunWorkflowOnCancelProcurementProcessRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelProcurementProcessRequestCode, RunWorkflowOnSendProcurementProcessForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;
        end
    end;

    procedure RunWorkflowOnSendProcurementPlanForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendProcurementPlanForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendProcurementPlanForApproval', '', false, false)]
    procedure RunWorkflowOnSendProcurementPlanForApproval(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendProcurementPlanForApprovalCode, ProcurementPlanHeader);
    end;


    procedure RunWorkflowOnCancelProcurementPlanApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelProcurementPlanRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelProcurementPlanApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelProcurementPlanRequest(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelProcurementPlanApprovalRequestCode, ProcurementPlanHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleaseProcurementPlanDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleaseProcurementPlan(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseProcurementPlanCode, ProcurementPlanHeader);
    end;


    procedure RunWorkflowOnAfterReleaseProcurementPlanCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseProcurementPlan'));
    end;

    procedure RunWorkflowOnSendPlanBudgetForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPlanBudgetForApproval'));
    end;


    procedure RunWorkflowOnCancelPlanBudgetForApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPlanBudgetApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendPlanBudgetForApproval', '', false, false)]
    procedure RunWorkflowOnSendPlanBudgetForApproval(GLBudgetName: Record "G/L Budget Name");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPlanBudgetForApprovalCode, GLBudgetName);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelPlanBudgetRequest', '', false, false)]
    procedure RunWorkflowOnCancelPlanBudgetApprovalRequest(GLBudgetName: Record "G/L Budget Name");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPlanBudgetForApprovalRequestCode, GLBudgetName);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleasePlanBudgetDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleasePlanBudget(var GLBudgetName: Record "G/L Budget Name");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleasePlanBudgetCode, GLBudgetName);
    end;


    procedure RunWorkflowOnAfterReleasePlanBudgetCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleasePlanBudget'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendPurchaseRequisitionForApproval', '', false, false)]
    procedure RunWorkflowOnSendPurchaseRequisitionForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPurchaseRequisitionForApprovalCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnSendPurchaseRequisitionForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPurchaseRequisitionForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelPurchaseRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPurchaseRequisitionApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPurchaseRequisitionApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleaseRequisitionDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleasePurchaseRequisition(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleasePurchaseRequisitionCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnAfterReleasePurchaseRequisitionCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleasePurchaseRequisition'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendStoreRequisitionForApproval', '', false, false)]
    procedure RunWorkflowOnSendStoreRequisitionForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreRequisitionForApprovalCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnSendStoreRequisitionForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendStoreRequisitionForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelStoreRequisitionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelStoreRequisitionApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreRequisitionApprovalRequestCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnCancelStoreRequisitionApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelStoreRequisitionApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleaseRequisitionDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleaseStoreRequisition(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseStoreRequisitionCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnAfterReleaseStoreRequisitionCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseStoreRequisition'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendStoreReturnForApproval', '', false, false)]
    procedure RunWorkflowOnSendStoreReturnForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStoreReturnForApprovalCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnSendStoreReturnForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendStoreReturnForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelStoreReturnApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelStoreReturnApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStoreReturnApprovalRequestCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnCancelStoreReturnApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelStoreReturnApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleaseRequisitionDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleaseStoreReturn(var RequisitionHeader: Record "Requisition Header");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseStoreReturnCode, RequisitionHeader);
    end;


    procedure RunWorkflowOnAfterReleaseStoreReturnCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseStoreReturn'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnSendProcurementProcessForApproval', '', false, false)]
    procedure RunWorkflowOnSendProcurementProcessForApproval(var ProcurementRequest: Record "Procurement Request");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendProcurementProcessForApprovalCode, ProcurementRequest);
    end;


    procedure RunWorkflowOnSendProcurementProcessForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendProcurementProcessForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Proc", 'OnCancelProcurementProcurementProcessRequest', '', false, false)]
    procedure RunWorkflowOnCancelProcurementProcessApprovalRequest(var ProcurementRequest: Record "Procurement Request");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelProcurementProcessRequestCode, ProcurementRequest);
    end;


    procedure RunWorkflowOnCancelProcurementProcessRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelProcurementProcessApprovalRequest'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Procurement Document", 'OnAfterReleaseProcurementProcessDocument', '', false, false)]
    procedure RunWorkflowOnAfterReleaseProcurementProcess(var ProcurementRequest: Record "Procurement Request");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseProcurementProcessCode, ProcurementRequest);
    end;


    procedure RunWorkflowOnAfterReleaseProcurementProcessCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseProcurementProcess'));
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

        ProcurementPlanSendForApprovalEventDesc: Label 'Approval of a Procurement Plan is Requested.';
        ProcurementPlanCancelApprovalReqEventDesc: Label 'An Approval request of a Procurement Plan is cancelled.';
        ProcurementPlanReleaseEventDesc: Label 'A Procurement Plan is released.';

        PlanBudgetSendForApprovalEventDesc: Label 'Approval of a Budget Procurement Plan is Requested.';
        PlanBudgetCancelApprovalReqEventDesc: Label 'An Approval request for a Budget Procurement Plan is cancelled.';
        PlanBudgetReleaseEventDesc: Label 'A Budget Procurement Plan is released.';

        PurchaseRequisitionSendForApprovalEventDesc: Label 'Approval for a Purchase Requisition is Requested.';
        PurchaseRequisitionCancelApprovalReqEventDesc: Label 'An Approval request for a Purchase Requisition is cancelled.';
        PurchaseRequisitionReleaseEventDesc: Label 'A Purchase Requisition is released.';

        StoreRequisitionSendForApprovalEventDesc: Label 'Approval for a Store Requisition is Requested.';
        StoreRequisitionCancelApprovalReqEventDesc: Label 'An Approval request for a Store Requisition is cancelled.';
        StoreRequisitionReleaseEventDesc: Label 'A Store Requisition is released.';

        StoreReturnSendForApprovalEventDescTxt: Label 'Approval for a Store Return is Requested.';
        StoreReturnCancelApprovalReqEventDescTxt: Label 'An Approval request for a Store Return is cancelled.';
        StoreReturnReleaseEventDescTxt: Label 'A Store Return is released.';

        ProcurementProcessSendForApprovalEventDesc: Label 'Approval for a Procurement Process is Requested.';
        ProcurementProcessCancelApprovalReqEventDesc: Label 'An Approval request for a Procurement Process is cancelled.';
        ProcurementProcessReleaseEventDesc: Label 'A Procurement Process is released.';
        PurchaseRequisitionSendForApprovalEventDescTxt: Label 'Approval for a Purchase Requisition is Requested.';
        PurchaseRequisitionCancelApprovalReqEventDescTxt: Label 'An Approval request for a Purchase Requisition is cancelled.';
        PurchaseRequisitionReleaseEventDescTxt: Label 'A Purchase Requisition is released.';
        StoreRequisitionSendForApprovalEventDescTxt: Label 'Approval for a Store Requisition is Requested.';
        StoreRequisitionCancelApprovalReqEventDescTxt: Label 'An Approval request for a Store Requisition is cancelled.';
        StoreRequisitionReleaseEventDescTxt: Label 'A Store Requisition is released.';
        ProcurementProcessSendForApprovalEventDescTxt: Label 'Approval for a Procurement Process is Requested.';
        ProcurementProcessCancelApprovalReqEventDescTxt: Label 'An Approval request for a Procurement Process is cancelled.';
        ProcurementProcessReleaseEventDescTxt: Label 'A Procurement Process is released.';
        ProcurementPlanSendForApprovalEventDescTxt: Label 'Approval of a Procurement Plan is Requested.';
        ProcurementPlanCancelApprovalReqEventDescTxt: Label 'An Approval request of a Procurement Plan is cancelled.';
        ProcurementPlanReleaseEventDescTxt: Label 'A Procurement Plan is released.';
        PlanBudgetSendForApprovalEventDescTxt: Label 'Approval of a Budget Procurement Plan is Requested.';
        PlanBudgetCancelApprovalReqEventDescTxt: Label 'An Approval request for a Budget Procurement Plan is cancelled.';
        PlanBudgetReleaseEventDescTxt: Label 'A Budget Procurement Plan is released.';
}

