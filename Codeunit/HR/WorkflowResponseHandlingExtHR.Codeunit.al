codeunit 50053 "Workflow Response Handling HR"
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
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTrainingRequestForApprovalCode);
                end;

            WorkflowResponseHandling.CreateApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendTrainingRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnSendEmployeeForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CreateApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnEmployeeChangedCode);
                end;

            WorkflowResponseHandling.SendApprovalRequestForApprovalCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendTrainingRequestForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnSendEmployeeForApprovalCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode, WorkflowEventHandlingExt.RunWorkflowOnEmployeeChangedCode);
                end;

            WorkflowResponseHandling.OpenDocumentCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelLeaveApplicationApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelTrainingRequestApprovalRequestCode);
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode, WorkflowEventHandlingExt.RunWorkflowOnCancelEmployeeApprovalRequestCode);
                end;

            WorkflowResponseHandling.CancelAllApprovalRequestsCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode, WorkflowEventHandlingExt.RunWorkflowOnCancelEmployeeApprovalRequestCode);
                end;

            WorkflowResponseHandling.RevertValueForFieldCode:
                begin
                    WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.RevertValueForFieldCode, WorkflowEventHandlingExt.RunWorkflowOnEmployeeChangedCode);
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LeaveApplication: Record "Leave Application";
        RecruitmentRequest: Record "Recruitment Request";
        TrainingRequest: Record "Training Request";
        Employee: Record Employee;
    begin

        CASE RecRef.NUMBER OF
            DATABASE::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    ReleaseHRDocument.PerformCheckAndReleaseLeaveApplication(LeaveApplication);
                    Handled := TRUE;
                end;
            DATABASE::"Recruitment Request":
                begin
                    RecRef.SetTable(RecruitmentRequest);
                    ReleaseHRDocument.PerformCheckAndReleaseRecruitmentApplication(RecruitmentRequest);
                    Handled := TRUE;
                end;
            DATABASE::"Training Request":
                begin
                    RecRef.SetTable(TrainingRequest);
                    ReleaseHRDocument.PerformCheckAndReleaseTrainingRequest(TrainingRequest);
                    Handled := TRUE;
                end;

            DATABASE::Employee:
                begin
                    RecRef.SetTable(Employee);
                    ReleaseHRDocument.PerformCheckAndReleaseEmployeeChanges(Employee);
                    Handled := TRUE;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        LeaveApplication: Record "Leave Application";
        RecruitmentRequest: Record "Recruitment Request";
        TrainingRequest: Record "Training Request";

    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Leave Application":
                begin
                    RecRef.SetTable(LeaveApplication);
                    ReleaseHRDocument.ReopenLeaveApplication(LeaveApplication);
                    Handled := true;
                end;
            DATABASE::"Recruitment Request":
                begin
                    RecRef.SetTable(RecruitmentRequest);
                    ReleaseHRDocument.ReopenRecruitmentApplication(RecruitmentRequest);
                    Handled := true;
                end;
            DATABASE::"Training Request":
                begin
                    RecRef.SetTable(TrainingRequest);
                    ReleaseHRDocument.ReopenTrainingRequest(TrainingRequest);
                    Handled := true;
                end;
        end;
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext HR";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        ReleaseHRDocument: Codeunit "Release HR Document";

        ApprovalMgmt: Codeunit "Approvals Mgmt Ext";

}