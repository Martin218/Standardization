codeunit 50061 "Release Procurement Document"
{
    // version TL2.0


    trigger OnRun();
    begin
    end;

    var
        Text01: Label 'Approval Request has been Cancelled successfully.';
        RejectTxt1: Label 'Reset status to New,Reject Completely';
        RejectTxt2: Label 'Choose the Action To Perfom';
        RejectTxt3: Label 'Status Reset Successful.';
        RejectTxt4: Label 'Document has been Rejected Successfully';
        CommentErr1: Label 'Please fill in the Reject Comment.';

    [IntegrationEvent(false, false)]
    procedure OnAfterReleasePlanBudgetDocument(var GLBudgetName: Record "G/L Budget Name");
    begin
    end;

    //[Scope('Personalization')]
    procedure PerformCheckAndReleasePlanBudgetDocument(var GLBudgetName: Record "G/L Budget Name");
    begin
        WITH GLBudgetName DO BEGIN
            IF "Procurement Plan Status" = "Procurement Plan Status"::Released THEN BEGIN
                EXIT;
            END;
            IF "Procurement Plan Status" = "Procurement Plan Status"::"Pending Approval" THEN BEGIN
                "Procurement Plan Status" := "Procurement Plan Status"::Released;
                "Procurement Plan Approved" := TRUE;
                MODIFY;
                ReleasePlanEntries(GLBudgetName);
            END;
        END;
    end;

    local procedure ReleasePlanEntries(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanLines: Record "Procurement Plan Line";
        ProcurementPlanHeader: Record "Procurement Plan Header";
    begin
        WITH GLBudgetName DO BEGIN
            ProcurementPlanHeader.RESET;
            ProcurementPlanHeader.SETRANGE("Current Budget", GLBudgetName.Name);
            ProcurementPlanHeader.SETRANGE(Status, ProcurementPlanHeader.Status::Approved);
            IF ProcurementPlanHeader.FINDSET THEN BEGIN
                REPEAT
                    ProcurementPlanLines.RESET;
                    ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader."No.");
                    ProcurementPlanLines.SETRANGE(Submitted, TRUE);
                    IF ProcurementPlanLines.FINDSET THEN BEGIN
                        REPEAT
                            ProcurementPlanLines.Approved := TRUE;
                            ProcurementPlanLines.MODIFY;
                        UNTIL ProcurementPlanLines.NEXT = 0;
                    END;
                    ProcurementPlanHeader."CEO Approved" := TRUE;
                UNTIL ProcurementPlanHeader.NEXT = 0;
            END;
        END;
    end;

    procedure ReopenPlanBudget(var GLBudgetName: Record "G/L Budget Name");
    begin
        WITH GLBudgetName DO BEGIN
            IF "Procurement Plan Status" = "Procurement Plan Status"::Open THEN
                EXIT;
            "Procurement Plan Status" := "Procurement Plan Status"::Open;
            MODIFY(TRUE);
        END;
    end;

    procedure RejectPlanBudget(var GLBudgetName: Record "G/L Budget Name");
    begin
    end;

    procedure OpenProcurementPlan(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WITH ProcurementPlanHeader DO BEGIN
            IF Status = Status::New THEN BEGIN
                EXIT;
            END;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;

    procedure RejectProcurementPlan(ProcurementPlanHeader: Record "Procurement Plan Header");
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RejectCaption: Text;
        RejectSelection: Integer;
    begin
        WITH ProcurementPlanHeader DO BEGIN
            RejectCaption := RejectTxt1;
            RejectSelection := DIALOG.STRMENU(RejectCaption, 1, RejectTxt2);
            CASE RejectSelection OF
                1:
                    BEGIN
                        IF Status = Status::New THEN BEGIN
                            EXIT;
                        END;
                        ApprovalsMgmt.GetApprovalComment(ProcurementPlanHeader);
                        IF GetComment(ProcurementPlanHeader) = '' THEN
                            ERROR(CommentErr1);
                        Status := Status::New;
                        MODIFY(TRUE);
                        MESSAGE(RejectTxt3);
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN BEGIN
                            EXIT;
                        END;
                        ApprovalsMgmt.GetApprovalComment(ProcurementPlanHeader);
                        IF GetComment(ProcurementPlanHeader) = '' THEN
                            ERROR(CommentErr1);
                        Status := Status::Rejected;
                        MODIFY(TRUE);
                        MESSAGE(RejectTxt4);
                    END;
            END;
        END;
    end;

    procedure GetComment(var ProcurementPlanHeader: Record "Procurement Plan Header"): Text;
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
        ApprovalEntry: Record "Approval Entry";
        ApprovalCommentLine: Record "Approval Comment Line";
    begin
        WITH ProcurementPlanHeader DO BEGIN
            RecRef.GETTABLE(ProcurementPlanHeader);
            ApprovalCommentLine.RESET;
            ApprovalCommentLine.SETRANGE("Table ID", RecRef.NUMBER);
            ApprovalCommentLine.SETRANGE("Record ID to Approve", RecRef.RECORDID);
            IF ApprovalCommentLine.FINDFIRST THEN BEGIN
                EXIT(ApprovalCommentLine.Comment);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure PerformCheckAndReleaseProcurementPlanDocument(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WITH ProcurementPlanHeader DO BEGIN
            IF Status = Status::Approved THEN BEGIN
                EXIT;
            END;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                Submitted := TRUE;
                MODIFY(TRUE);
                ReleasePlanLines(ProcurementPlanHeader);
            END;

        END;
    end;

    [IntegrationEvent(false, false)]
    //[Scope('Personalization')]
    procedure OnAfterReleaseProcurementPlanDocument(var ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
    end;

    local procedure ReleasePlanLines(ProcurementPlanHeader: Record "Procurement Plan Header");
    var
        ProcurementPlanLines: Record "Procurement Plan Line";
    begin
        WITH ProcurementPlanHeader DO BEGIN
            ProcurementPlanLines.RESET;
            ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader."No.");
            IF ProcurementPlanLines.FINDSET THEN BEGIN
                REPEAT
                    ProcurementPlanLines.Submitted := TRUE;
                    ProcurementPlanLines.MODIFY;
                UNTIL ProcurementPlanLines.NEXT = 0;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReleaseRequisitionDocument(var RequisitionHeader: Record "Requisition Header");
    begin
    end;

    //[Scope('Personalization')]
    procedure PerformCheckAndReleaseRequisitionDocument(var RequisitionHeader: Record "Requisition Header");
    begin
        WITH RequisitionHeader DO BEGIN
            IF Status = Status::Released THEN
                EXIT;
            Status := Status::Released;
            MODIFY(TRUE);
        END;
    end;

    procedure RejectRequisitionRequest(var RequisitionHeader: Record "Requisition Header");
    begin
        WITH RequisitionHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
        END;
    end;

    procedure OpenRequisitionRequest(var RequisitionHeader: Record "Requisition Header");
    begin
        WITH RequisitionHeader DO BEGIN
            IF Status = Status::Open THEN
                EXIT;
            Status := Status::Open;
            MODIFY(TRUE);
        END;
    end;

    //[Scope('Personalization')]
    procedure ReleaseDocuments(Variant: Variant);
    var
        RecRef: RecordRef;
        ProcurementPlanHeader: Record "Procurement Plan Header";
        RequisitionHeader: Record "Requisition Header";
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Requisition Header":
                BEGIN
                    RequisitionHeader := Variant;
                END;
        //ToTest
        END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReleaseProcurementProcessDocument(var ProcurementRequest: Record "Procurement Request");
    begin
    end;

    //[Scope('Personalization')]
    procedure PerformCheckAndReleaseProcurementProcessDocument(var ProcurementRequest: Record "Procurement Request");
    begin
        WITH ProcurementRequest DO BEGIN
            IF Status = Status::Released THEN
                EXIT;
            Status := Status::Released;
            MODIFY(TRUE);
        END;
    end;

    procedure RejectProcurementProcessRequest(var ProcurementRequest: Record "Procurement Request");
    begin
        WITH ProcurementRequest DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
        END;
    end;

    procedure OpenProcurementProcessRequest(var ProcurementRequest: Record "Procurement Request");
    begin
        WITH ProcurementRequest DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;
}

