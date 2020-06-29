codeunit 50051 "Release HR Document"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        RejectAction: Text[50];
        SelectedAction: Integer;
        Text000: Label '%1 %2 has been approved successfully.';
        Text001: Label '%1 %2 has been rejected sucessfully.';
        Text002: Label 'Reset to New Stage,Reject Completely';
        Text003: Label 'Choose Reject Action';
        Text004: Label '%1 %2 has been reset to New Stage.';
        Text005: Label 'This document can only be released when the approval process is complete.';
        Text006: Label 'Leave Application';
        HRManagement: Codeunit 50050;
        LeaveLedgerEntry: Record 50209;
        Text007: Label 'Training Request';
        Text008: Label 'Disciplinary Incident';
        Text009: Label 'Recruitment Application';
        Text010: Label 'Separation Application';

    //  
    procedure ReopenLeaveApplication(var LeaveApplication: Record 50206);
    begin
        WITH LeaveApplication DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLeaveApplication(var LeaveApplication: Record 50206);
    begin
        WITH LeaveApplication DO BEGIN
            RejectAction := Text002;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text003);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::Open THEN
                            EXIT;
                        Status := Status::Open;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text004, Text006, "Employee No");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text001, Text006, "Employee No");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseLeaveApplication(var LeaveApplication: Record 50206);
    begin
    end;


    procedure PerformCheckAndReleaseLeaveApplication(var LeaveApplication: Record 50206);
    var
        PrepaymentMgt: Codeunit 441;
        ApprovalsMgmt: Codeunit 50054;
    begin
        WITH LeaveApplication DO BEGIN
            IF ApprovalsMgmt.IsLeaveApplicationApprovalsWorkflowEnabled(LeaveApplication) AND
              (LeaveApplication.Status = LeaveApplication.Status::"Pending Approval") THEN
                ERROR(Text005);
            IF Status = Status::Released THEN
                EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Released;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text000, Text006, "Employee No");
                    HRManagement.InsertLeaveLedgerEntry(FORMAT(DATE2DMY(TODAY, 3)), "Application No", "Employee No", "Leave Code", "Leave Code", -"Days Applied", LeaveLedgerEntry."Entry Type"::Negative, FALSE, FALSE, FALSE, FALSE, FALSE);
                END;
            END;

        END;
    end;

    /*
   procedure PerformCheckAndReleaseDisciplinaryIncident(var DisciplinaryIncident : Record 50220);
   var
       PrepaymentMgt : Codeunit 441;
       ApprovalsMgmt : Codeunit 1535;
   begin
       WITH DisciplinaryIncident DO BEGIN
         IF ApprovalsMgmtExt.IsDisciplinaryIncidentApprovalsWorkflowEnabled(DisciplinaryIncident) AND
           (DisciplinaryIncident.Status = DisciplinaryIncident.Status::New) THEN
           ERROR(Text005);
           IF Status= Status::Approved THEN
             EXIT;
           IF Status= Status::"Pending Approval" THEN BEGIN
             Status:=Status::Approved;
             IF MODIFY(TRUE) THEN
              MESSAGE(Text000,Text008,"Incident No.");
           END;

       END;
   end;

   [IntegrationEvent(false, false)]

   local procedure OnAfterReleaseDisciplinaryIncident(var DisciplinaryIncident : Record "50220");
   begin
   end;


   procedure ReopenDisciplinaryIncident(var DisciplinaryIncident : Record "50220");
   begin
       WITH DisciplinaryIncident DO BEGIN
         IF Status= Status::New THEN
           EXIT;
         Status:= Status::New;
         MODIFY(TRUE);
       END;
   end;


   procedure RejectDisciplinaryIncident(var DisciplinaryIncident : Record "50220");
   begin
       WITH DisciplinaryIncident DO BEGIN
         RejectAction:=Text002;
         SelectedAction:=DIALOG.STRMENU(RejectAction, 1, Text003);
         CASE SelectedAction OF
           1:
             BEGIN
               IF Status = Status::New THEN
                 EXIT;
               Status := Status::New;
               IF MODIFY(TRUE) THEN
                 MESSAGE(Text004,Text008,"Incident No.");
            END;
           2:
             BEGIN
               IF Status = Status::Rejected THEN
                 EXIT;
               Status := Status::Rejected;
               IF MODIFY(TRUE) THEN
                 MESSAGE(Text001,Text008,"Incident No.");
            END;
         END;
       END;
   end;*/


    procedure ReopenTrainingRequest(var TrainingRequest: Record 50234);
    begin
        WITH TrainingRequest DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectTrainingRequest(var TrainingRequest: Record 50234);
    begin
        WITH TrainingRequest DO BEGIN
            RejectAction := Text002;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text003);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::Open THEN
                            EXIT;
                        Status := Status::Open;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text004, Text007, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text001, Text007, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseTrainingRequest(var TrainingRequest: Record 50234);
    begin
    end;


    procedure PerformCheckAndReleaseTrainingRequest(var TrainingRequest: Record 50234);
    var
        PrepaymentMgt: Codeunit 441;
        ApprovalsMgmt: Codeunit 50054;
    begin
        WITH TrainingRequest DO BEGIN
            if ApprovalsMgmt.IsTrainingRequestApprovalsWorkflowEnabled(TrainingRequest) and
               (TrainingRequest.Status = TrainingRequest.Status::"Pending Approval") THEN
                //   ERROR(Text005);

                IF Status = Status::Released THEN
                    EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Released;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text000, Text007, "No.");
                END;
            END;
            //AddToTrainingNeeds(TrainingRequest);
        END;
    end;

    local procedure AddToTrainingNeeds(TrainingRequest: Record 50234);
    var
        TrainingNeed: Record 50236;
    begin
        WITH TrainingRequest DO BEGIN
            TrainingNeed.INIT;
            TrainingNeed."Training Description" := "Training Description";
            TrainingNeed."Training Institution" := "Training Institution";
            TrainingNeed.Venue := Venue;
            TrainingNeed.Duration := Duration;
            TrainingNeed."Duration Units" := "Duration Units";
            TrainingNeed."Start Date" := "Start Date";
            TrainingNeed."End Date" := "End Date";
            TrainingNeed.Location := Location;
            TrainingNeed."Cost of Training" := "Cost of Training";
            TrainingNeed."Total Cost of Training" := "Total Cost of Training";
            TrainingNeed."Training Request No." := "No.";
            TrainingNeed.INSERT(TRUE);
        END;
    end;


    procedure ReopenRecruitmentApplication(var Recruitment: Record 50246);
    begin
        WITH Recruitment DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectRecruitmentApplication(var Recruitment: Record 50246);
    begin
        WITH Recruitment DO BEGIN
            RejectAction := Text002;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text003);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::Open THEN
                            EXIT;
                        Status := Status::Open;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text004, Text009, "Recruitment No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text001, Text009, "Recruitment No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseRecruitmentApplication(var Recruitment: Record 50246);
    begin
    end;


    procedure PerformCheckAndReleaseRecruitmentApplication(var Recruitment: Record 50246);
    var
        PrepaymentMgt: Codeunit 441;
        ApprovalsMgmt: Codeunit 50054;
    begin
        WITH Recruitment DO BEGIN
            IF ApprovalsMgmt.IsRecruitmentRequestApprovalsWorkflowEnabled(Recruitment) AND
             (Recruitment.Status = Recruitment.Status::"Pending Approval") THEN
                // ERROR(Text005);

                IF Status = Status::Released THEN
                    EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Released;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text000, Text009, "Recruitment No.");
                END;
            END;
            ;
        END;
    end;

    /*
           procedure ReopenSeparationApplication(var HRSeparation : Record "50237");
           begin
               WITH HRSeparation DO BEGIN
                 IF Status = Status::Open THEN
                   EXIT;
                 Status := Status::Open;
                 MODIFY(TRUE);
               END;
           end;


           procedure RejectSeparationApplication(var HRSeparation : Record "50237");
           begin
               WITH HRSeparation DO BEGIN
                 RejectAction:=Text002;
                 SelectedAction:=DIALOG.STRMENU(RejectAction, 1, Text003);
                 CASE SelectedAction OF
                   1:
                     BEGIN
                       IF Status = Status::Open THEN
                         EXIT;
                       Status := Status::Open;
                       IF MODIFY(TRUE) THEN
                         MESSAGE(Text004,Text010,"Separation No");
                    END;
                   2:
                     BEGIN
                       IF Status = Status::Closed THEN
                         EXIT;
                       Status := Status::Closed;
                       IF MODIFY(TRUE) THEN
                         MESSAGE(Text001,Text010,"Separation No");
                    END;
                 END;
               END;
           end;

           [IntegrationEvent(false, false)]

           local procedure OnAfterReleaseSeparationApplication(var HRSeparation : Record "50237");
           begin
           end;


           procedure PerformCheckAndReleaseSeparationApplication(var HRSeparation : Record "50237");
           var
               PrepaymentMgt : Codeunit 441;
               ApprovalsMgmt : Codeunit 1535;
           begin
               WITH HRSeparation DO BEGIN
                 IF ApprovalsMgmtExt.IsSeparationApplicationApprovalsWorlflowEnabled(HRSeparation) AND
                   (HRSeparation.Status = HRSeparation.Status::Open) THEN
                   ERROR(Text005);
                   IF Status=Status::Approved THEN
                     EXIT;
                   IF Status=Status::"Pending Approval" THEN BEGIN
                     Status:=Status::Approved;
                     IF MODIFY(TRUE) THEN BEGIN
                        MESSAGE(Text000,Text010,"Separation No");
                     END;
                   END;
                   ;
               END;
           end;

           [IntegrationEvent(false, false)]

           local procedure OnAfterReleaseEmployeeChanges(var Employee : Record "5200");
           begin
           end;

    */
    procedure PerformCheckAndReleaseEmployeeChanges(var Employee: Record 5200);
    var
        PrepaymentMgt: Codeunit 441;
        ApprovalsMgmt: Codeunit 50054;
    begin
        WITH Employee DO BEGIN

        END;
    end;
}

