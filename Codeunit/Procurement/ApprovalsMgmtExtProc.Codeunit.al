codeunit 50064 "Approvals Mgmt Proc"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', true, true)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementRequest: Record "Procurement Request";
        GLBudgetName: Record "G/L Budget Name";
        RequisitionHeader: Record "Requisition Header";
    begin
        case RecRef.NUMBER of
            DATABASE::"Procurement Plan Header":
                BEGIN
                    RecRef.SETTABLE(ProcurementPlanHeader);
                    ApprovalEntryArgument."Document No." := ProcurementPlanHeader."No.";
                    ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::"Procurement Plan";
                    ProcurementPlanHeader.CALCFIELDS(Amount);
                    ApprovalEntryArgument.Amount := ProcurementPlanHeader.Amount;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    RecRef.SETTABLE(ProcurementRequest);
                    ApprovalEntryArgument."Document No." := ProcurementRequest."No.";
                    IF ProcurementRequest."Procurement Option" = ProcurementRequest."Procurement Option"::"Request For Quotation" THEN
                        ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::RFQ
                END;
            DATABASE::"G/L Budget Name":
                BEGIN
                    RecRef.SETTABLE(GLBudgetName);
                    ApprovalEntryArgument."Document No." := GLBudgetName.Name;
                    ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::GLBudget;
                END;
            DATABASE::"Requisition Header":
                BEGIN
                    RecRef.SETTABLE(RequisitionHeader);
                    ApprovalEntryArgument."Document No." := RequisitionHeader."No.";
                    RequisitionHeader.CALCFIELDS(Amount);
                    ApprovalEntryArgument.Amount := RequisitionHeader.Amount;
                    IF RequisitionHeader."Requisition Type" = RequisitionHeader."Requisition Type"::"Purchase Requisition" THEN BEGIN
                        ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::"Purchase Requisition"
                    END ELSE
                        IF RequisitionHeader."Requisition Type" = RequisitionHeader."Requisition Type"::"Store Requisition" THEN BEGIN
                            ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::"Store Requisition"
                        END ELSE
                            IF RequisitionHeader."Requisition Type" = RequisitionHeader."Requisition Type"::"Store Return" THEN BEGIN
                                ApprovalEntryArgument."Document Type Ext" := ApprovalEntryArgument."Document Type Ext"::"Store Return"
                            END;
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', true, true)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementRequest: Record "Procurement Request";
        GLBudgetName: Record "G/L Budget Name";
        RequisitionHeader: Record "Requisition Header";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Procurement Plan Header":
                BEGIN
                    RecRef.SETTABLE(ProcurementPlanHeader);
                    ProcurementPlanHeader.VALIDATE(Status, ProcurementPlanHeader.Status::"Pending Approval");
                    ProcurementPlanHeader.MODIFY(TRUE);
                    isHandled := true;
                END;
            DATABASE::"G/L Budget Name":
                BEGIN
                    RecRef.SETTABLE(GLBudgetName);
                    GLBudgetName.VALIDATE("Procurement Plan Status", GLBudgetName."Procurement Plan Status"::"Pending Approval");
                    GLBudgetName.MODIFY(TRUE);
                    isHandled := true;
                END;
            DATABASE::"Requisition Header":
                BEGIN
                    RecRef.SETTABLE(RequisitionHeader);
                    RequisitionHeader.VALIDATE(Status, RequisitionHeader.Status::"Pending Approval");
                    RequisitionHeader.MODIFY(TRUE);
                    isHandled := true;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    RecRef.SETTABLE(ProcurementRequest);
                    ProcurementRequest.VALIDATE(Status, ProcurementRequest.Status::"Pending Approval");
                    ProcurementRequest."Process Status" := ProcurementRequest."Process Status"::CEO;
                    ProcurementRequest.MODIFY(TRUE);
                    isHandled := true;
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', true, true)]
    local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementRequest: Record "Procurement Request";
        GLBudgetName: Record "G/L Budget Name";
        RequisitionHeader: Record "Requisition Header";
    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Procurement Plan Header":
                BEGIN
                    ProcurementPlanHeader.Get(ApprovalEntry."Document No.");
                    ReleaseProcurementDocument.RejectProcurementPlan(ProcurementPlanHeader);
                END;
            /*           DATABASE::"G/L Budget Name":
                        BEGIN
                          RecRef.SETTABLE(GLBudgetName);
                          GLBudgetName.VALIDATE("Procurement Plan Status",GLBudgetName."Procurement Plan Status"::"Pending Approval");
                          GLBudgetName.MODIFY(TRUE);
                          Variant := GLBudgetName;
                        END; */
            DATABASE::"Requisition Header":
                BEGIN
                    RequisitionHeader.Get(ApprovalEntry."Document No.");
                    ReleaseProcurementDocument.RejectRequisitionRequest(RequisitionHeader);
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest.get(ApprovalEntry."Document No.");
                    ReleaseProcurementDocument.RejectProcurementProcessRequest(ProcurementRequest);
                    ;
                END;
        end;
    end;

    [IntegrationEvent(false, false)]

    procedure OnSendProcurementPlanForApproval(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
    end;

    [IntegrationEvent(false, false)]

    procedure OnCancelProcurementPlanApprovalRequest(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
    end;


    procedure CheckProcurementPlanApprovalPossible(var ProcurementPlanHeader: Record "Procurement Plan Header"): Boolean;
    begin
        IF NOT IsProcurementPlanWorkflowEnabled(ProcurementPlanHeader) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;


    procedure IsProcurementPlanWorkflowEnabled(var ProcurementPlanHeader: Record "Procurement Plan Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ProcurementPlanHeader, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementPlanForApprovalCode));
    end;


    procedure ShowProcurementPlanStatus(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPlanBudgetForApproval(GLBudgetName: Record "G/L Budget Name");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPlanBudgetRequest(GLBudgetName: Record "G/L Budget Name");
    begin
    end;

    procedure CheckPlanBudgetApprovalPossible(GLBudgetName: Record "G/L Budget Name"): Boolean;
    begin
        IF NOT IsPlanBudgetWorkflowEnabled(GLBudgetName) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure IsPlanBudgetWorkflowEnabled(GLBudgetName: Record "G/L Budget Name"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GLBudgetName, WorkflowEventHandlingExt.RunWorkflowOnSendPlanBudgetForApprovalCode));
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPurchaseRequisitionForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPurchaseRequisitionApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
    end;


    procedure IsPurchaseRequisitionApprovalWorkflowEnabled(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(RequisitionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPurchaseRequisitionForApprovalCode));
    end;


    procedure CheckPurchaseRequisitionApprovalPossible(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        IF NOT IsPurchaseRequisitionApprovalWorkflowEnabled(RequisitionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStoreRequisitionForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStoreRequisitionApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
    end;


    procedure IsStoreRequisitionApprovalWorkflowEnabled(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(RequisitionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendStoreRequisitionForApprovalCode));
    end;


    procedure CheckStoreRequisitionApprovalPossible(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        IF NOT IsStoreRequisitionApprovalWorkflowEnabled(RequisitionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStoreReturnForApproval(var RequisitionHeader: Record "Requisition Header");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStoreReturnApprovalRequest(var RequisitionHeader: Record "Requisition Header");
    begin
    end;


    procedure IsStoreReturnApprovalWorkflowEnabled(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(RequisitionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendStoreReturnForApprovalCode));
    end;


    procedure CheckStoreReturnApprovalPossible(var RequisitionHeader: Record "Requisition Header"): Boolean;
    begin
        IF NOT IsStoreReturnApprovalWorkflowEnabled(RequisitionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendProcurementProcessForApproval(var ProcurementRequest: Record "Procurement Request");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelProcurementProcurementProcessRequest(var ProcurementRequest: Record "Procurement Request");
    begin
    end;


    procedure IsProcurementProcessApprovalWorkflowEnabled(var ProcurementRequest: Record "Procurement Request"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ProcurementRequest, WorkflowEventHandlingExt.RunWorkflowOnSendProcurementProcessForApprovalCode));
    end;


    procedure CheckProcurementProcessApprovalPossible(var ProcurementRequest: Record "Procurement Request"): Boolean;
    begin
        IF NOT IsProcurementProcessApprovalWorkflowEnabled(ProcurementRequest) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Proc";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseProcurementDocument: Codeunit "Release Procurement Document";


}