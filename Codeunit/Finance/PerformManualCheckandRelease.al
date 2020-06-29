codeunit 50041 "PerformManualCheckandRelease"
{
    trigger OnRun()
    begin

    end;

    procedure FindReleaseDoc(DocumentNo: Code[20]; TableID: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange("Table ID", TableID);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Approved);
        if ApprovalEntry.FindLast then begin
            exit(true)
        end else begin
            exit(false);
        end;
    end;

    procedure FindRejectedDoc(DocumentNo: Code[20]; TableID: Integer): Boolean
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.Reset;
        ApprovalEntry.SetRange("Table ID", TableID);
        ApprovalEntry.SetRange("Document No.", DocumentNo);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Rejected);
        if ApprovalEntry.FindLast then begin
            exit(true)
        end else begin
            exit(false);
        end;
    end;

    procedure ReleaseImprestDoc(var ImprestManagement: Record "Imprest Management")
    begin
        with ImprestManagement do begin
            FindReleaseDoc("Imprest No.", Database::"Imprest Management");
            if ApprovalsMgntExt.IsImprestDocApprovalsWorkflowEnabled(ImprestManagement) and (Status = Status::Open) then begin
                Error(Text002);
            end else begin
                Status := Status::Released;
                if Modify(true) then begin
                    Message(Text004, "Transaction Type", "Imprest No.");
                end;
            end;
        end;
    end;
    procedure ReleasePVDoc(var PV: Record "Payment/Receipt Voucher")
    begin
        with PV do begin
            FindReleaseDoc("Paying Code.", Database::"Payment/Receipt Voucher");
            if ApprovalsMgntExt.IsPVDocApprovalsWorkflowEnabled(PV) and (Status = Status::Open) then begin
                Error(Text002);
            end else begin
                Status := Status::Released;
                if Modify(true) then begin
                    Message(Text004, "Document Type", "Paying Code.");
                end;
            end;
        end;
    end;
    procedure ReOpenImprest(var ImprestManagement: Record "Imprest Management")
    begin
        with ImprestManagement do begin
            if Status = Status::Open then begin
                exit;
            end;
            if FindRejectedDoc("Imprest No.", Database::"Imprest Management") then begin
                Status := Status::Rejected;
            end else begin
                Status := Status::Open;
            end;
            Modify(true);
        end;
    end;
    procedure ReOpenPV(var PV: Record "Payment/Receipt Voucher")
    begin
        with PV do begin
            if Status = Status::Open then begin
                exit;
            end;
            if FindRejectedDoc("Paying Code.", Database::"Payment/Receipt Voucher") then begin
                Status := Status::Rejected;
            end else begin
                Status := Status::Open;
            end;
            Modify(true);
        end;
    end;


    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2';
        Text002: Label 'This document can only be released when the approval process is complete';
        Text003: Label 'The apporval process must be cancelled or completed to reopen the document';
        Text004: Label '%1 %2 has been approved successfully';
        Text005: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2';
        Text006: Label 'There are unposted prepayment amount on the document of type %1 with the number %2';
        Text007: Label '%1 %2 has been automatically approved. The status has been changed to %1';
        ApprovalsMgntExt: Codeunit "Approvals Mgnt ExtF";
}