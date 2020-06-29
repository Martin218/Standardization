codeunit 50054 "Approvals Mgmt Ext HR"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var
        LeaveApplication: Record "Leave Application";
        RecruitmentRequest: Record "Recruitment Request";
        TrainingRequest: Record "Training Request";
        Employee: Record Employee;

    begin
        case RecRef.NUMBER of
            DATABASE::"Leave Application":
                begin
                    RecRef.SETTABLE(LeaveApplication);
                    ApprovalEntryArgument."Document No." := LeaveApplication."Application No";
                end;
            DATABASE::"Recruitment Request":
                begin
                    RecRef.SETTABLE(RecruitmentRequest);
                    ApprovalEntryArgument."Document No." := RecruitmentRequest."Recruitment Needs Code";
                end;
            DATABASE::"Training Request":
                begin
                    RecRef.SETTABLE(TrainingRequest);
                    ApprovalEntryArgument."Document No." := TrainingRequest."No.";
                end;
            DATABASE::Employee:
                BEGIN
                    RecRef.SETTABLE(Employee);
                    ApprovalEntryArgument."Document No." := Employee."No.";
                END;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
    var
        LeaveApplication: Record "Leave Application";
        RecruitmentRequest: Record "Recruitment Request";
        TrainingRequest: Record "Training Request";

    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    LeaveApplication.Status := LeaveApplication.Status::"Pending Approval";
                    LeaveApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Recruitment Request":
                begin
                    RecRef.SetTable(RecruitmentRequest);
                    RecruitmentRequest.Status := RecruitmentRequest.Status::"Pending Approval";
                    RecruitmentRequest.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Training Request":
                begin
                    RecRef.SetTable(TrainingRequest);
                    TrainingRequest.Status := TrainingRequest.Status::"Pending Approval";
                    TrainingRequest.Modify(true);
                    isHandled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        LeaveApplication: Record "Leave Application";
        RecruitmentRequest: Record "Recruitment Request";
        TrainingRequest: Record "Training Request";

    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Leave Application":
                begin
                    LeaveApplication.Get(ApprovalEntry."Document No.");
                    ReleaseHRDocument.RejectLeaveApplication(LeaveApplication);
                end;
            DATABASE::"Recruitment Request":
                begin
                    RecruitmentRequest.Get(ApprovalEntry."Document No.");
                    ReleaseHRDocument.RejectRecruitmentApplication(RecruitmentRequest);
                end;
            DATABASE::"Training Request":
                begin
                    TrainingRequest.Get(ApprovalEntry."Document No.");
                    ReleaseHRDocument.RejectTrainingRequest(TrainingRequest);
                end;

        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLeaveApplicationForApproval(var LeaveApplication: Record "Leave Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendRecruitmentRequestForApproval(var RecruitmentRequest: Record "Recruitment Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTrainingRequestForApproval(var TrainingRequest: Record "Training Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendEmployeeForApproval(var Employee: Record Employee)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLeaveApplicationApprovalRequest(var LeaveApplication: Record "Leave Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelRecruitmentRequestApprovalRequest(var RecruitmentRequest: Record "Recruitment Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTrainingRequestApprovalRequest(var TrainingRequest: Record "Training Request")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelEmployeeApprovalRequest(var Employee: Record Employee)
    begin
    end;

    procedure IsLeaveApplicationApprovalsWorkflowEnabled(var LeaveApplication: Record "Leave Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LeaveApplication, WorkflowEventHandlingExt.RunWorkflowOnSendLeaveApplicationForApprovalCode));
    end;

    procedure IsRecruitmentRequestApprovalsWorkflowEnabled(var RecruitmentRequest: Record "Recruitment Request"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(RecruitmentRequest, WorkflowEventHandlingExt.RunWorkflowOnSendRecruitmentRequestForApprovalCode));
    end;

    procedure IsTrainingRequestApprovalsWorkflowEnabled(var TrainingRequest: Record "Training Request"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TrainingRequest, WorkflowEventHandlingExt.RunWorkflowOnSendTrainingRequestForApprovalCode));
    end;

    procedure IsEmployeeApprovalsWorkflowEnabled(var Employee: Record Employee): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(Employee, WorkflowEventHandlingExt.RunWorkflowOnSendEmployeeForApprovalCode));
    end;

    procedure CheckLeaveApplicationApprovalPossible(var LeaveApplication: Record "Leave Application"): Boolean
    begin
        IF NOT IsLeaveApplicationApprovalsWorkflowEnabled(LeaveApplication) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure CheckRecruitmentRequestApprovalPossible(var RecruitmentRequest: Record "Recruitment Request"): Boolean
    begin
        IF NOT IsRecruitmentRequestApprovalsWorkflowEnabled(RecruitmentRequest) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure CheckTrainingRequestApprovalPossible(var TrainingRequest: Record "Training Request"): Boolean
    begin
        IF NOT IsTrainingRequestApprovalsWorkflowEnabled(TrainingRequest) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    procedure CheckEmployeeApprovalPossible(var Employee: Record Employee): Boolean
    begin
        IF NOT IsEmployeeApprovalsWorkflowEnabled(Employee) THEN
            ERROR(NoWorkflowEnabledErr);
        EXIT(TRUE);
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext HR";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseHRDocument: Codeunit "Release HR Document";
}