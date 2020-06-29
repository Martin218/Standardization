codeunit 50008 "Release BOSA Document"
{
    // version TL2.0


    trigger OnRun()
    begin

    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        Member: Record "Member";
        CBSSetup: Record "CBS Setup";
        Vendor: Record "Vendor";
        AccountType: Record "Account Type";
        Customer: Record "Customer";

        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        Text005: Label '%1 %2 has been approved successfully.';
        Text006: Label '%1 %2 has been rejected sucessfully.';
        Text007: Label 'Reset to New Stage,Reject Completely';
        Text008: Label 'Choose Reject Action';
        Text009: Label '%1 %2 has been reset to New Stage.';
        RejectAction: Text[50];
        SelectedAction: Integer;
        BOSAManagement: Codeunit "BOSA Management";


    procedure PerformCheckAndReleaseLoanApplication(var LoanApplication: Record "Loan Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        RecRef: RecordRef;
    begin
        WITH LoanApplication DO BEGIN
            IF LoanApplication.Status <> LoanApplication.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(LoanApplication);
                    UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenLoanApplication(var LoanApplication: Record "Loan Application")
    begin
        WITH LoanApplication DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanApplication(var LoanApplication: Record "Loan Application")
    begin
        WITH LoanApplication DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseLoanApplication(var LoanApplication: Record "Loan Application")
    begin
    end;

    local procedure UpdateAuditInfo(RecRef: RecordRef)
    var
        LoanRescheduling: Record "Loan Rescheduling";
        LoanApplication: Record "Loan Application";
        FundTransfer: Record "Fund Transfer";
        DividendHeader: Record "Dividend Header";
        PayoutHeader: Record "Payout Header";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        StandingOrder: Record "Standing Order";
        MemberExitHeader: Record "Member Exit Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSellOff: Record "Loan Selloff";
    begin
        CASE RecRef.NUMBER OF
            DATABASE::"Loan Application":
                BEGIN
                    RecRef.SETTABLE(LoanApplication);
                    LoanApplication."Approved By" := USERID;
                    LoanApplication."Approved Date" := TODAY;
                    LoanApplication."Approved Time" := TIME;
                    BOSAManagement.GetHostInfo(HostName, HostIP, HostMac);
                    LoanApplication."Approved By Host IP" := HostIP;
                    LoanApplication."Approved By Host MAC" := HostMac;
                    LoanApplication."Approved By Host Name" := HostName;
                    LoanApplication.MODIFY;
                END;
            DATABASE::"Loan Rescheduling":
                BEGIN
                    RecRef.SETTABLE(LoanRescheduling);
                    LoanRescheduling."Approved By" := USERID;
                    LoanRescheduling."Approved Date" := TODAY;
                    LoanRescheduling."Approved Time" := TIME;
                    LoanRescheduling.MODIFY;
                END;
            DATABASE::"Guarantor Substitution Header":
                BEGIN
                    RecRef.SETTABLE(GuarantorSubstitutionHeader);
                    GuarantorSubstitutionHeader."Approved By" := USERID;
                    GuarantorSubstitutionHeader."Approved Date" := TODAY;
                    GuarantorSubstitutionHeader."Approved Time" := TIME;
                    GuarantorSubstitutionHeader.MODIFY;
                END;
            DATABASE::"Standing Order":
                BEGIN
                    RecRef.SETTABLE(StandingOrder);
                    StandingOrder."Approved By" := USERID;
                    StandingOrder."Approved Date" := TODAY;
                    StandingOrder."Approved Time" := TIME;
                    StandingOrder.MODIFY;
                END;
            DATABASE::"Fund Transfer":
                BEGIN
                    RecRef.SETTABLE(FundTransfer);
                    FundTransfer."Approved By" := USERID;
                    FundTransfer."Approved Date" := TODAY;
                    FundTransfer."Approved Time" := TIME;
                    FundTransfer.MODIFY;
                END;
            DATABASE::"Payout Header":
                BEGIN
                    RecRef.SETTABLE(PayoutHeader);
                    PayoutHeader."Approved By" := USERID;
                    PayoutHeader."Approved Date" := TODAY;
                    PayoutHeader."Approved Time" := TIME;
                    PayoutHeader.MODIFY;
                END;
            DATABASE::"Dividend Header":
                BEGIN
                    RecRef.SETTABLE(DividendHeader);
                    DividendHeader."Approved By" := USERID;
                    DividendHeader."Approved Date" := TODAY;
                    DividendHeader."Approved Time" := TIME;
                    DividendHeader.MODIFY;
                END;
            DATABASE::"Member Exit Header":
                BEGIN
                    RecRef.SETTABLE(MemberExitHeader);
                    MemberExitHeader."Approved By" := USERID;
                    MemberExitHeader."Approved Date" := TODAY;
                    MemberExitHeader."Approved Time" := TIME;
                    MemberExitHeader.MODIFY;
                END;
            DATABASE::"Member Refund Header":
                BEGIN
                    RecRef.SETTABLE(MemberRefundHeader);
                    MemberRefundHeader."Approved By" := USERID;
                    MemberRefundHeader."Approved Date" := TODAY;
                    MemberRefundHeader."Approved Time" := TIME;
                    MemberRefundHeader.MODIFY;
                END;
            DATABASE::"Member Claim Header":
                BEGIN
                    RecRef.SETTABLE(MemberClaimHeader);
                    MemberClaimHeader."Approved By" := USERID;
                    MemberClaimHeader."Approved Date" := TODAY;
                    MemberClaimHeader."Approved Time" := TIME;
                    MemberClaimHeader.MODIFY;
                END;
            DATABASE::"Loan Selloff":
                BEGIN
                    RecRef.SETTABLE(LoanSellOff);
                    LoanSellOff."Approved By" := USERID;
                    LoanSellOff."Approved Date" := TODAY;
                    LoanSellOff."Approved Time" := TIME;
                    LoanSellOff.MODIFY;
                END;
        END;
    end;

    procedure PerformCheckAndReleaseStandingOrder(var StandingOrder: Record "Standing Order")
    var

        ApprovalEntry: Record "Approval Entry";
    begin
        WITH StandingOrder DO BEGIN
            IF ApprovalsMgmt.IsStandingOrderApprovalsWorkflowEnabled(StandingOrder) AND
              (StandingOrder.Status = StandingOrder.Status::New) THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;
            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                Running := TRUE;
                IF MODIFY(TRUE) THEN BEGIN
                    MESSAGE(Text005, 'Standing Order', "No.");
                END;
            END;

        END;
    end;


    procedure ReopenStandingOrder(var StandingOrder: Record "Standing Order")
    begin
        WITH StandingOrder DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectStandingOrder(var StandingOrder: Record "Standing Order")
    begin
        WITH StandingOrder DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, 'Standing Order', "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, 'Standing Order', "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseStandingOrder(var StandingOrder: Record "Standing Order")
    begin
    end;


    procedure PerformCheckAndReleaseFundTransfer(var FundTransfer: Record "Fund Transfer")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        WITH FundTransfer DO BEGIN
            IF ApprovalsMgmt.IsFundTransferApprovalsWorkflowEnabled(FundTransfer) AND
              (FundTransfer.Status = FundTransfer.Status::"Pending Approval") THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, FundTransfer.TABLECAPTION, "No.");
            END;
            OnAfterReleaseFundTransfer(FundTransfer);
        END;
    end;


    procedure ReopenFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
        WITH FundTransfer DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
        WITH FundTransfer DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, FundTransfer.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, FundTransfer.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
    end;


    procedure PerformCheckAndReleaseLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
    begin
        WITH LoanRescheduling DO BEGIN
            IF ApprovalsMgmt.IsLoanReschedulingApprovalsWorkflowEnabled(LoanRescheduling) AND
              (LoanRescheduling.Status = LoanRescheduling.Status::"Pending Approval") THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                "Approved By" := USERID;
                "Approved Date" := TODAY;
                "Approved Time" := TIME;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, LoanRescheduling.TABLECAPTION, "No.");
            END;
            OnAfterReleaseLoanRescheduling(LoanRescheduling);
            RescheduleLoan(LoanRescheduling);
            CreateRepaymentSchedule(LoanRescheduling);
        END;
    end;


    procedure ReopenLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WITH LoanRescheduling DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WITH LoanRescheduling DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, LoanRescheduling.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, LoanRescheduling.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;

    local procedure RescheduleLoan(LoanRescheduling: Record "Loan Rescheduling")
    var
        LoanApplication: Record "Loan Application";
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
    begin
        WITH LoanRescheduling DO BEGIN
            IF LoanApplication.GET("Loan No.") THEN BEGIN
                IF ("Rescheduling Option" = "Rescheduling Option"::"Repayment Period") OR ("Rescheduling Option" = "Rescheduling Option"::All) THEN
                    LoanApplication."Repayment Period" := "New Repayment Period";
                IF ("Rescheduling Option" = "Rescheduling Option"::"Repayment Frequency") OR ("Rescheduling Option" = "Rescheduling Option"::All) THEN
                    LoanApplication."Repayment Frequency" := "New Repayment Frequency";
                IF ("Rescheduling Option" = "Rescheduling Option"::"Interest Rate") OR ("Rescheduling Option" = "Rescheduling Option"::All) THEN
                    LoanApplication."Interest Rate" := "New Interest Rate";
                LoanApplication.MODIFY;
            END;
        END;
    end;

    local procedure CreateRepaymentSchedule(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WITH LoanRescheduling DO BEGIN
            BOSAManagement.CalculateRepaymentSchedule("Loan No.", "Outstanding Loan Balance");
        END;
    end;


    procedure PerformCheckAndReleaseGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    var

    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            IF ApprovalsMgmt.IsGuarantorSubstitutionApprovalsWorkflowEnabled(GuarantorSubstitutionHeader) AND
              (GuarantorSubstitutionHeader.Status = GuarantorSubstitutionHeader.Status::"Pending Approval") THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY(TRUE) THEN
                    MESSAGE(Text005, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
            END;
            OnAfterReleaseGuarantorSubstitution(GuarantorSubstitutionHeader);
            SubstituteGuarantors(GuarantorSubstitutionHeader);
        END;
    end;


    procedure ReopenGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    BEGIN
                        IF Status = Status::New THEN
                            EXIT;
                        Status := Status::New;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text009, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
                    END;
                2:
                    BEGIN
                        IF Status = Status::Rejected THEN
                            EXIT;
                        Status := Status::Rejected;
                        IF MODIFY(TRUE) THEN
                            MESSAGE(Text006, GuarantorSubstitutionHeader.TABLECAPTION, "No.");
                    END;
            END;
        END;
    end;

    [IntegrationEvent(false, false)]

    local procedure OnAfterReleaseGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    local procedure SubstituteGuarantors(GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    var
        GuarantorSubstitutionLine: Record "Guarantor Substitution Line";
        LoanGuarantor: Record "Loan Guarantor";
        LoanGuarantor2: Record "Loan Guarantor";
        GuarantorAllocation: Record "Guarantor Allocation";
        LineNo: Integer;
    begin
        WITH GuarantorSubstitutionHeader DO BEGIN
            GuarantorAllocation.RESET;
            GuarantorAllocation.SETRANGE("Document No.", "No.");
            IF GuarantorAllocation.FINDSET THEN BEGIN
                REPEAT
                    LoanGuarantor.RESET;
                    LoanGuarantor.SETRANGE("Loan No.", "Loan No.");
                    LoanGuarantor.SETRANGE("Member No.", GuarantorAllocation."Guarantor Member No.");
                    IF LoanGuarantor.FINDFIRST THEN
                        LoanGuarantor.DELETE;

                    LoanGuarantor.INIT;
                    LoanGuarantor2.RESET;
                    LoanGuarantor2.SETRANGE("Loan No.", "Loan No.");
                    IF LoanGuarantor2.FINDLAST THEN
                        LineNo := LoanGuarantor2."Line No."
                    ELSE
                        LineNo := 0;
                    LoanGuarantor."Loan No." := "Loan No.";
                    LoanGuarantor."Line No." := LineNo + 10000;
                    LoanGuarantor.VALIDATE("Member No.", GuarantorAllocation."Member No.");
                    LoanGuarantor.VALIDATE("Account No.", GuarantorAllocation."Account No.");
                    IF LoanGuarantor.INSERT THEN
                        CreateSubstitutionEntry(GuarantorAllocation);
                UNTIL GuarantorAllocation.NEXT = 0;
            END;
        END;
    end;

    local procedure CreateSubstitutionEntry(var GuarantorAllocation: Record "Guarantor Allocation")
    var
        GuarantorSubstitutionEntry: Record "Guarantor Substitution Entry";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        Member: Record "Member";
        EntryNo: Integer;
    begin
        WITH GuarantorAllocation DO BEGIN
            GuarantorSubstitutionHeader.GET("Document No.");
            GuarantorSubstitutionHeader.CALCFIELDS("Guaranteed Amount", "Substituted Amount");
            GuarantorSubstitutionEntry.INIT;
            IF GuarantorSubstitutionEntry.FINDLAST THEN
                EntryNo := GuarantorSubstitutionEntry."Entry No."
            ELSE
                EntryNo := 0;
            GuarantorSubstitutionEntry."Entry No." := EntryNo + 1;
            GuarantorSubstitutionEntry."Document No." := "Document No.";
            GuarantorSubstitutionEntry."Previous Guarantor No." := "Guarantor Member No.";
            IF Member.GET("Guarantor Member No.") THEN
                GuarantorSubstitutionEntry."Previous Guarantor Name" := Member."Full Name";
            GuarantorSubstitutionEntry."New Guarantor No." := "Member No.";
            GuarantorSubstitutionEntry."New Guarantor Name" := "Member Name";
            GuarantorSubstitutionEntry."Loan No." := GuarantorSubstitutionHeader."Loan No.";
            GuarantorSubstitutionEntry.Description := GuarantorSubstitutionHeader.Description;
            GuarantorSubstitutionEntry."Substitution Date" := TODAY;
            GuarantorSubstitutionEntry."Substitution Time" := TIME;
            GuarantorSubstitutionEntry."Previous Amount Guaranteed" := GuarantorSubstitutionHeader."Guaranteed Amount";
            GuarantorSubstitutionEntry."New Amount Guaranteed" := GuarantorSubstitutionHeader."Substituted Amount";
            GuarantorSubstitutionEntry.INSERT;
        END;
    end;


    procedure PerformCheckAndReleasePayout(var PayoutHeader: Record "Payout Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH PayoutHeader DO BEGIN
            IF PayoutHeader.Status <> PayoutHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(PayoutHeader);
                    UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenPayout(var PayoutHeader: Record "Payout Header")
    begin
        WITH PayoutHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPayout(var PayoutHeader: Record "Payout Header")
    begin
        WITH PayoutHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleasePayout(var PayoutHeader: Record "Payout Header")
    begin
    end;


    procedure PerformCheckAndReleaseMemberExit(var MemberExitHeader: Record "Member Exit Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberExitHeader DO BEGIN
            IF MemberExitHeader.Status <> MemberExitHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseMemberExit(MemberExitHeader);
            BOSAManagement.ProcessMemberExit(MemberExitHeader);
        END;
    end;


    procedure ReopenMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
        WITH MemberExitHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
        WITH MemberExitHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;


    procedure PerformCheckAndReleaseMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberRefundHeader DO BEGIN
            IF MemberRefundHeader.Status <> MemberRefundHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(MemberRefundHeader);
                    UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WITH MemberRefundHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WITH MemberRefundHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;


    procedure PerformCheckAndReleaseMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH MemberClaimHeader DO BEGIN
            IF MemberClaimHeader.Status <> MemberClaimHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseMemberClaim(MemberClaimHeader);
        END;
    end;


    procedure ReopenMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WITH MemberClaimHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WITH MemberClaimHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;


    procedure PerformCheckAndReleaseDividend(var DividendHeader: Record "Dividend Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH DividendHeader DO BEGIN
            IF DividendHeader.Status <> DividendHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    CLEAR(RecRef);
                    RecRef.GETTABLE(DividendHeader);
                    UpdateAuditInfo(RecRef);
                END;
            END;
        END;
    end;


    procedure ReopenDividend(var DividendHeader: Record "Dividend Header")
    begin
        WITH DividendHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectDividend(var DividendHeader: Record "Dividend Header")
    begin
        WITH DividendHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseDividend(var DividendHeader: Record "Dividend Header")
    begin
    end;

    procedure PerformCheckAndReleaseLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    var
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH LoanSelloff DO BEGIN
            IF LoanSelloff.Status <> LoanSelloff.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseLoanSelloff(LoanSelloff);
        END;
    end;


    procedure ReopenLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
        WITH LoanSelloff DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
        WITH LoanSelloff DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterReleaseLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    procedure PerformCheckAndReleaseLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH LoanWriteoffHeader DO BEGIN
            IF LoanWriteoffHeader.Status <> LoanWriteoffHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseLoanWriteoff(LoanWriteoffHeader);
        END;
    end;


    procedure ReopenLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WITH LoanWriteoffHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WITH LoanWriteoffHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseLoanWriteoff(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    procedure PerformCheckAndReleaseGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH GroupAllocationHeader DO BEGIN
            IF GroupAllocationHeader.Status <> GroupAllocationHeader.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleaseGroupAllocation(GroupAllocationHeader);
        END;
    end;


    procedure ReopenGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WITH GroupAllocationHeader DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WITH GroupAllocationHeader DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleaseGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    procedure PerformCheckAndReleasePortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    var
        PrepaymentMgt: Codeunit "Prepayment Mgt.";
        ApprovalEntry: Record "Approval Entry";
        RecRef: RecordRef;
    begin
        WITH PortfolioTransfer DO BEGIN
            IF PortfolioTransfer.Status <> PortfolioTransfer.Status::"Pending Approval" THEN
                ERROR(Text002);
            IF Status = Status::Approved THEN
                EXIT;

            IF Status = Status::"Pending Approval" THEN BEGIN
                Status := Status::Approved;
                IF MODIFY THEN BEGIN
                    MESSAGE('Request Approved Successfully');
                END;
            END;
            OnAfterReleasePortfolioTransfer(PortfolioTransfer);
        END;
    end;


    procedure ReopenPortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WITH PortfolioTransfer DO BEGIN
            IF Status = Status::New THEN
                EXIT;
            Status := Status::New;
            MODIFY(TRUE);
        END;
    end;


    procedure RejectPortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WITH PortfolioTransfer DO BEGIN
            IF Status = Status::Rejected THEN
                EXIT;
            Status := Status::Rejected;
            MODIFY(TRUE);
            MESSAGE(Text007);
        END;
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterReleasePortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;
}

