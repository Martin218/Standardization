codeunit 50052 "Workflow Event Handling Ext HR"
{
    trigger OnRun()
    begin
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelLeaveApplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLeaveApplicationApprovalRequestCode, RunWorkflowOnSendLeaveApplicationForApprovalCode);

            RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode, RunWorkflowOnSendRecruitmentRequestForApprovalCode);

            RunWorkflowOnCancelTrainingRequestApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelTrainingRequestApprovalRequestCode, RunWorkflowOnSendTrainingRequestForApprovalCode);

            RunWorkflowOnCancelEmployeeApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelEmployeeApprovalRequestCode, RunWorkflowOnSendEmployeeForApprovalCode);

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTrainingRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendEmployeeForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnEmployeeChangedCode);
                end;

            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTrainingRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendEmployeeForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnEmployeeChangedCode);
                end;

            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLeaveApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendRecruitmentRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTrainingRequestForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendEmployeeForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnEmployeeChangedCode);
                end;

        end
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendTrainingRequestForApprovalCode, DATABASE::"Training Request", TrainingRequestSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelTrainingRequestApprovalRequestCode, DATABASE::"Training Request", TrainingRequestApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseTrainingRequestApprovalRequestCode, DATABASE::"Training Request", TrainingRequestReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLeaveApplicationForApprovalCode, DATABASE::"Leave Application", LeaveApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLeaveApplicationApprovalRequestCode, DATABASE::"Leave Application", LeaveApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseLeaveApplicationApprovalRequestCode, DATABASE::"Leave Application", LeaveApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendRecruitmentRequestForApprovalCode, DATABASE::"Recruitment Request", RecruitmentRequestSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode, DATABASE::"Recruitment Request", RecruitmentRequestApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseRecruitmentRequestApprovalRequestCode, DATABASE::"Recruitment Request", RecruitmentRequestReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendEmployeeForApprovalCode, DATABASE::Employee, EmployeeSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelEmployeeApprovalRequestCode, DATABASE::Employee, EmployeeApprovalRequestCancelEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnEmployeeChangedCode, DATABASE::Employee, EmployeeChangedTxt, 0, TRUE);

    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnCancelLeaveApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelLeaveApplicationApprovalRequest(var LeaveApplication: Record "Leave Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLeaveApplicationApprovalRequestCode, LeaveApplication);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnCancelRecruitmentRequestApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelRecruitmentRequestApprovalRequest(var RecruitmentRequest: Record "Recruitment Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode, RecruitmentRequest);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnCancelTrainingRequestApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelTrainingRequestApprovalRequest(var TrainingRequest: Record "Training Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTrainingRequestApprovalRequestCode, TrainingRequest);
    end;

    [EventSubscriber(ObjectType::Table, 5200, 'OnAfterModifyEvent', '', false, false)]
    procedure RunWorkflowOnEmployeeChanged(var Rec: Record Employee; var xRec: Record Employee; RunTrigger: Boolean)
    begin
        IF FORMAT(xRec) <> FORMAT(Rec) THEN
            WorkflowManagement.HandleEventWithxRec(RunWorkflowOnEmployeeChangedCode, Rec, xRec);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release HR Document", 'OnAfterReleaseLeaveApplication', '', false, false)]
    procedure RunWorkflowOnReleaseLeaveApplication(var LeaveApplication: Record "Leave Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseLeaveApplicationApprovalRequestCode, LeaveApplication);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release HR Document", 'OnAfterReleaseRecruitmentApplication', '', false, false)]
    procedure RunWorkflowOnReleaseRecruitmentRequest(var Recruitment: Record "Recruitment Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseRecruitmentRequestApprovalRequestCode, Recruitment);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release HR Document", 'OnAfterReleaseTrainingRequest', '', false, false)]
    procedure RunWorkflowOnReleaseTrainingRequest(var TrainingRequest: Record "Training Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseTrainingRequestApprovalRequestCode, TrainingRequest);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnSendLeaveApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendLeaveApplicationForApproval(var LeaveApplication: Record "Leave Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLeaveApplicationForApprovalCode, LeaveApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnSendRecruitmentRequestForApproval', '', false, false)]
    procedure RunWorkflowOnSendRecruitmentRequestForApproval(var RecruitmentRequest: Record "Recruitment Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendRecruitmentRequestForApprovalCode, RecruitmentRequest);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext HR", 'OnSendTrainingRequestForApproval', '', false, false)]
    procedure RunWorkflowOnSendTrainingRequestForApproval(var TrainingRequest: Record "Training Request")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTrainingRequestForApprovalCode, TrainingRequest);
    end;

    procedure RunWorkflowOnSendLeaveApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLeaveApplicationForApproval'));
    end;

    procedure RunWorkflowOnCancelLeaveApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelLeaveApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnReleaseLeaveApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseLeaveApplication'));
    end;

    procedure RunWorkflowOnSendRecruitmentRequestForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendRecruitmentRequestForApproval'));
    end;

    procedure RunWorkflowOnCancelRecruitmentRequestApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelRecruitmentRequestApprovalRequest'));
    end;

    procedure RunWorkflowOnReleaseRecruitmentRequestApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseRecruitmentRequest'));
    end;

    procedure RunWorkflowOnSendTrainingRequestForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendTrainingRequestForApproval'));
    end;

    procedure RunWorkflowOnCancelTrainingRequestApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelTrainingRequestApprovalRequest'));
    end;

    procedure RunWorkflowOnReleaseTrainingRequestApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseTrainingRequest'));
    end;

    procedure RunWorkflowOnEmployeeChangedCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnEmployeeChangedCode'));
    end;

    procedure RunWorkflowOnSendEmployeeForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendEmployeeForApproval'));
    end;

    procedure RunWorkflowOnCancelEmployeeApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelEmployeeApprovalRequest'));
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        LeaveApplicationSendForApprovalEventDescTxt: Label 'Approval of a Leave Application is requested.';
        LeaveApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Leave Application is canceled.';
        LeaveApplicationReleasedEventDescTxt: Label 'A Leave Application is released.';
        RecruitmentRequestSendForApprovalEventDescTxt: Label 'Approval of a Recruitment Request is requested.';
        RecruitmentRequestApprReqCancelledEventDescTxt: Label 'An approval request for a Recruitment Request is cancelled.';
        RecruitmentRequestReleasedEventDescTxt: Label 'A Recruitment Request is released.';
        TrainingRequestSendForApprovalEventDescTxt: Label 'Approval of a Training Request is requested.';
        TrainingRequestApprReqCancelledEventDescTxt: Label 'An approval request for a Training Request is cancelled.';
        TrainingRequestReleasedEventDescTxt: Label 'A Training Request is released.';
        EmployeeSendForApprovalEventDescTxt: Label 'Approval of an employee is requested.';
        EmployeeApprovalRequestCancelEventDescTxt: Label 'An approval request for an employee is cancelled.';
        EmployeeChangedTxt: Label 'An employee record is changed.';

}

