codeunit 50063 "Workflow Response Handling Pr"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])

    begin
        CASE ResponseFunctionName OF
            WorkflowResponseHandling.SetStatusToPendingApprovalCode:
                begin
                    Message('in');
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;
            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementPlanForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPlanBudgetForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendPurchaseRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreRequisitionForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendStoreReturnForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementProcessForApprovalCode);
                end;
            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPlanBudgetForApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelPurchaseRequisitionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelStoreRequisitionApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelStoreReturnApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelProcurementProcessRequestCode);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementRequest: Record "Procurement Request";
        GLBudgetName: Record "G/L Budget Name";
        RequisitionHeader: Record "Requisition Header";
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlanHeader);
                    ReleaseProcurementDocument.PerformCheckAndReleaseProcurementPlanDocument(ProcurementPlanHeader);
                    Handled := true;
                end;
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(GLBudgetName);
                    ReleaseProcurementDocument.PerformCheckAndReleasePlanBudgetDocument(GLBudgetName);
                    Handled := true;
                end;
            DATABASE::"Requisition Header":
                begin
                    RecRef.SetTable(RequisitionHeader);
                    ReleaseProcurementDocument.PerformCheckAndReleaseRequisitionDocument(RequisitionHeader);
                    Handled := true;
                end;
            DATABASE::"Procurement Request":
                begin
                    RecRef.SetTable((ProcurementRequest));
                    ReleaseProcurementDocument.PerformCheckAndReleaseProcurementProcessDocument(ProcurementRequest);
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementRequest: Record "Procurement Request";
        GLBudgetName: Record "G/L Budget Name";
        RequisitionHeader: Record "Requisition Header";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Plan Header":
                begin
                    RecRef.SetTable(ProcurementPlanHeader);
                    ReleaseProcurementDocument.OpenProcurementPlan(ProcurementPlanHeader);
                    Handled := true;
                end;
            DATABASE::"G/L Budget Name":
                begin
                    RecRef.SetTable(GLBudgetName);
                    ReleaseProcurementDocument.ReopenPlanBudget(GLBudgetName);
                    Handled := true;
                end;
            DATABASE::"Requisition Header":
                begin
                    RecRef.SetTable(RequisitionHeader);
                    ReleaseProcurementDocument.OpenRequisitionRequest(RequisitionHeader);
                    Handled := true;
                end;
            DATABASE::"Procurement Request":
                begin
                    RecRef.SetTable(ProcurementRequest);
                    ReleaseProcurementDocument.OpenProcurementProcessRequest(ProcurementRequest);
                    Handled := true;
                end;
        end;
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        //WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Proc";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        ReleaseProcurementDocument: Codeunit "Release Procurement Document";

        ApprovalMgmt: Codeunit "Approvals Mgmt Ext";

}