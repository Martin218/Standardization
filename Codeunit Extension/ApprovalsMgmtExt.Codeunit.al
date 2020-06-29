codeunit 50012 "Approvals Mgmt Ext"
{
    trigger OnRun()
    begin

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; var ApprovalEntryArgument: Record "Approval Entry")
    var
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        FundTransfer: Record "Fund Transfer";
        LoanRescheduling: Record "Loan Rescheduling";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        PayoutHeader: Record "Payout Header";
        DividendHeader: Record "Dividend Header";
        MemberExitHeader: Record "Member Exit Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSelloff: Record "Loan Selloff";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
        GroupAllocationHeader: Record "Group Allocation Header";
        PortfolioTransfer: Record "Portfolio Transfer";
        MemberActivationHeader: Record "Member Activation Header";
        AccountActivationHeader: Record "Account Activation Header";
        SpotCashApplication: Record "SpotCash Application";
        SpotCashActivationHeader: Record "SpotCash Activation Header";
        ATMApplication: Record "ATM Application";
        ATMCollection: Record "ATM Collection";
        ATMActivationHeader: Record "ATM Activation Header";
        ChequeBookApplication: Record "Cheque Book Application";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        Transactions: Record Transaction;
        TreasuryTransaction: Record "Treasury Transaction";
    begin
        case RecRef.NUMBER of
            DATABASE::"Member Application":
                begin
                    RecRef.SETTABLE(MemberApplication);
                    ApprovalEntryArgument."Document No." := MemberApplication."No.";
                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SETTABLE(AccountOpening);
                    ApprovalEntryArgument."Document No." := AccountOpening."No.";
                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SETTABLE(LoanApplication);
                    ApprovalEntryArgument."Document No." := LoanApplication."No.";
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SETTABLE(StandingOrder);
                    ApprovalEntryArgument."Document No." := StandingOrder."No.";
                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SETTABLE(FundTransfer);
                    ApprovalEntryArgument."Document No." := FundTransfer."No.";
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SETTABLE(LoanRescheduling);
                    ApprovalEntryArgument."Document No." := LoanRescheduling."No.";
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SETTABLE(GuarantorSubstitutionHeader);
                    ApprovalEntryArgument."Document No." := GuarantorSubstitutionHeader."No.";
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SETTABLE(PayoutHeader);
                    ApprovalEntryArgument."Document No." := PayoutHeader."No.";
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SETTABLE(DividendHeader);
                    ApprovalEntryArgument."Document No." := DividendHeader."No.";
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SETTABLE(MemberExitHeader);
                    ApprovalEntryArgument."Document No." := MemberExitHeader."No.";
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SETTABLE(MemberRefundHeader);
                    ApprovalEntryArgument."Document No." := MemberRefundHeader."No.";
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SETTABLE(MemberClaimHeader);
                    ApprovalEntryArgument."Document No." := MemberClaimHeader."No.";
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SETTABLE(LoanSelloff);
                    ApprovalEntryArgument."Document No." := LoanSelloff."No.";
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SETTABLE(LoanWriteoffHeader);
                    ApprovalEntryArgument."Document No." := LoanWriteoffHeader."No.";
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SETTABLE(GroupAllocationHeader);
                    ApprovalEntryArgument."Document No." := GroupAllocationHeader."No.";
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SETTABLE(PortfolioTransfer);
                    ApprovalEntryArgument."Document No." := PortfolioTransfer."No.";
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SETTABLE(MemberActivationHeader);
                    ApprovalEntryArgument."Document No." := MemberActivationHeader."No.";
                end;
            DATABASE::"Account Activation Header":
                begin
                    RecRef.SETTABLE(AccountActivationHeader);
                    ApprovalEntryArgument."Document No." := AccountActivationHeader."No.";
                end;
            DATABASE::"SpotCash Application":
                begin
                    RecRef.SETTABLE(SpotCashApplication);
                    ApprovalEntryArgument."Document No." := SpotCashApplication."No.";
                end;
            DATABASE::"SpotCash Activation Header":
                begin
                    RecRef.SETTABLE(SpotCashActivationHeader);
                    ApprovalEntryArgument."Document No." := SpotCashActivationHeader."No.";
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SETTABLE(ATMApplication);
                    ApprovalEntryArgument."Document No." := ATMApplication."No.";
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SETTABLE(ATMCollection);
                    ApprovalEntryArgument."Document No." := ATMCollection."No.";
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SETTABLE(ATMActivationHeader);
                    ApprovalEntryArgument."Document No." := ATMActivationHeader."No.";
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SETTABLE(ChequeBookApplication);
                    ApprovalEntryArgument."Document No." := ChequeBookApplication."No.";
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SETTABLE(ChequeClearanceHeader);
                    ApprovalEntryArgument."Document No." := ChequeClearanceHeader."No.";
                end;
            DATABASE::Transaction:
                begin
                    RecRef.SETTABLE(Transactions);
                    Transactions.SETFILTER("Transaction Type", '<>%1', 'INTER ACCOUNT');
                    ApprovalEntryArgument."Document No." := Transactions."No.";
                end;
            DATABASE::"Treasury Transaction":
                begin
                    RecRef.SETTABLE(TreasuryTransaction);
                    ApprovalEntryArgument."Document No." := TreasuryTransaction."No.";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var isHandled: Boolean)
    var
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        FundTransfer: Record "Fund Transfer";
        LoanRescheduling: Record "Loan Rescheduling";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        PayoutHeader: Record "Payout Header";
        DividendHeader: Record "Dividend Header";
        MemberExitHeader: Record "Member Exit Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSelloff: Record "Loan Selloff";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
        GroupAllocationHeader: Record "Group Allocation Header";
        PortfolioTransfer: Record "Portfolio Transfer";
        MemberActivationHeader: Record "Member Activation Header";
        AccountActivationHeader: Record "Account Activation Header";
        SpotCashApplication: Record "SpotCash Application";
        SpotCashActivationHeader: Record "SpotCash Activation Header";
        ATMApplication: Record "ATM Application";
        ATMCollection: Record "ATM Collection";
        ATMActivationHeader: Record "ATM Activation Header";
        ChequeBookApplication: Record "Cheque Book Application";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        Transactions: Record Transaction;
        TreasuryTransaction: Record "Treasury Transaction";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Member Application":
                begin
                    RecRef.SetTable(MemberApplication);
                    MemberApplication.Status := MemberApplication.Status::"Pending Approval";
                    MemberApplication.Modify(true);
                    isHandled := true;

                end;
            DATABASE::"Account Opening":
                begin
                    RecRef.SetTable(AccountOpening);
                    AccountOpening.Status := AccountOpening.Status::"Pending Approval";
                    AccountOpening.Modify(true);
                    isHandled := true;

                end;
            DATABASE::"Loan Application":
                begin
                    RecRef.SetTable(LoanApplication);
                    LoanApplication.Status := LoanApplication.Status::"Pending Approval";
                    LoanApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Standing Order":
                begin
                    RecRef.SetTable(StandingOrder);
                    StandingOrder.Status := StandingOrder.Status::"Pending Approval";
                    StandingOrder.Modify(true);
                    isHandled := true;

                end;
            DATABASE::"Fund Transfer":
                begin
                    RecRef.SetTable(FundTransfer);
                    FundTransfer.Status := FundTransfer.Status::"Pending Approval";
                    FundTransfer.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    RecRef.SetTable(LoanRescheduling);
                    LoanRescheduling.Status := LoanRescheduling.Status::"Pending Approval";
                    LoanRescheduling.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    RecRef.SetTable(GuarantorSubstitutionHeader);
                    GuarantorSubstitutionHeader.Status := GuarantorSubstitutionHeader.Status::"Pending Approval";
                    GuarantorSubstitutionHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Payout Header":
                begin
                    RecRef.SetTable(PayoutHeader);
                    PayoutHeader.Status := PayoutHeader.Status::"Pending Approval";
                    PayoutHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Dividend Header":
                begin
                    RecRef.SetTable(DividendHeader);
                    DividendHeader.Status := DividendHeader.Status::"Pending Approval";
                    DividendHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Exit Header":
                begin
                    RecRef.SetTable(MemberExitHeader);
                    MemberExitHeader.Status := MemberExitHeader.Status::"Pending Approval";
                    MemberExitHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Refund Header":
                begin
                    RecRef.SetTable(MemberRefundHeader);
                    MemberRefundHeader.Status := MemberRefundHeader.Status::"Pending Approval";
                    MemberRefundHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Claim Header":
                begin
                    RecRef.SetTable(MemberClaimHeader);
                    MemberClaimHeader.Status := MemberClaimHeader.Status::"Pending Approval";
                    MemberClaimHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Selloff":
                begin
                    RecRef.SetTable(LoanSelloff);
                    LoanSelloff.Status := LoanSelloff.Status::"Pending Approval";
                    LoanSelloff.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    RecRef.SetTable(LoanWriteoffHeader);
                    LoanWriteoffHeader.Status := LoanWriteoffHeader.Status::"Pending Approval";
                    LoanWriteoffHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Group Allocation Header":
                begin
                    RecRef.SetTable(GroupAllocationHeader);
                    GroupAllocationHeader.Status := GroupAllocationHeader.Status::"Pending Approval";
                    GroupAllocationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    RecRef.SetTable(PortfolioTransfer);
                    PortfolioTransfer.Status := PortfolioTransfer.Status::"Pending Approval";
                    PortfolioTransfer.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Member Activation Header":
                begin
                    RecRef.SetTable(MemberActivationHeader);
                    MemberActivationHeader.Status := MemberActivationHeader.Status::"Pending Approval";
                    MemberActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Account Activation Header":
                begin
                    RecRef.SetTable(AccountActivationHeader);
                    AccountActivationHeader.Status := AccountActivationHeader.Status::"Pending Approval";
                    AccountActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"SpotCash Application":
                begin
                    RecRef.SetTable(SpotCashApplication);
                    SpotCashApplication.Status := SpotCashApplication.Status::"Pending Approval";
                    SpotCashApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"SpotCash Activation Header":
                begin
                    RecRef.SetTable(SpotCashActivationHeader);
                    SpotCashActivationHeader.Status := SpotCashActivationHeader.Status::"Pending Approval";
                    SpotCashActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Application":
                begin
                    RecRef.SetTable(ATMApplication);
                    ATMApplication.Status := ATMApplication.Status::"Pending Approval";
                    ATMApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Collection":
                begin
                    RecRef.SetTable(ATMCollection);
                    ATMCollection.Status := ATMCollection.Status::"Pending Approval";
                    ATMCollection.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"ATM Activation Header":
                begin
                    RecRef.SetTable(ATMActivationHeader);
                    ATMActivationHeader.Status := ATMActivationHeader.Status::"Pending Approval";
                    ATMActivationHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Cheque Book Application":
                begin
                    RecRef.SetTable(ChequeBookApplication);
                    ChequeBookApplication.Status := ChequeBookApplication.Status::"Pending Approval";
                    ChequeBookApplication.Modify(true);
                    isHandled := true;
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    RecRef.SetTable(ChequeClearanceHeader);
                    ChequeClearanceHeader.Status := ChequeClearanceHeader.Status::"Pending Approval";
                    ChequeClearanceHeader.Modify(true);
                    isHandled := true;
                end;
            DATABASE::Transaction:
                begin
                    RecRef.SETTABLE(Transactions);
                    Transactions.VALIDATE(Status, Transactions.Status::"Pending Approval");
                    Transactions.MODIFY(TRUE);
                    isHandled := true;
                end;
            DATABASE::"Treasury Transaction":
                begin
                    RecRef.SETTABLE(TreasuryTransaction);
                    TreasuryTransaction.VALIDATE(Status, TreasuryTransaction.Status::"Pending Approval");
                    TreasuryTransaction.MODIFY(TRUE);
                    isHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure RejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        MemberApplication: Record "Member Application";
        AccountOpening: Record "Account Opening";
        LoanApplication: Record "Loan Application";
        StandingOrder: Record "Standing Order";
        FundTransfer: Record "Fund Transfer";
        LoanRescheduling: Record "Loan Rescheduling";
        GuarantorSubstitutionHeader: Record "Guarantor Substitution Header";
        PayoutHeader: Record "Payout Header";
        DividendHeader: Record "Dividend Header";
        MemberExitHeader: Record "Member Exit Header";
        MemberRefundHeader: Record "Member Refund Header";
        MemberClaimHeader: Record "Member Claim Header";
        LoanSelloff: Record "Loan Selloff";
        LoanWriteoffHeader: Record "Loan Writeoff Header";
        GroupAllocationHeader: Record "Group Allocation Header";
        PortfolioTransfer: Record "Portfolio Transfer";
        MemberActivationHeader: Record "Member Activation Header";
        AccountActivationHeader: Record "Account Activation Header";
        SpotCashApplication: Record "SpotCash Application";
        SpotCashActivationHeader: Record "SpotCash Activation Header";
        ATMApplication: Record "ATM Application";
        ATMCollection: Record "ATM Collection";
        ATMActivationHeader: Record "ATM Activation Header";
        ChequeBookApplication: Record "Cheque Book Application";
        ChequeClearanceHeader: Record "Cheque Clearance Header";
        Transactions: Record Transaction;
        TreasuryTransaction: Record "Treasury Transaction";
    begin
        CASE ApprovalEntry."Table ID" OF
            DATABASE::"Member Application":
                begin
                    MemberApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMemberApplication(MemberApplication);
                end;
            DATABASE::"Account Opening":
                begin
                    AccountOpening.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectAccountOpening(AccountOpening);
                end;
            DATABASE::"Loan Application":
                begin
                    LoanApplication.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanApplication(LoanApplication);
                end;
            DATABASE::"Standing Order":
                begin
                    StandingOrder.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectStandingOrder(StandingOrder);
                end;
            DATABASE::"Fund Transfer":
                begin
                    FundTransfer.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectFundTransfer(FundTransfer);
                end;
            DATABASE::"Loan Rescheduling":
                begin
                    LoanRescheduling.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanRescheduling(LoanRescheduling);
                end;
            DATABASE::"Guarantor Substitution Header":
                begin
                    GuarantorSubstitutionHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectGuarantorSubstitution(GuarantorSubstitutionHeader);
                end;
            DATABASE::"Payout Header":
                begin
                    PayoutHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectPayout(PayoutHeader);
                end;
            DATABASE::"Dividend Header":
                begin
                    DividendHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectDividend(DividendHeader);
                end;
            DATABASE::"Member Exit Header":
                begin
                    MemberExitHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberExit(MemberExitHeader);
                end;
            DATABASE::"Member Refund Header":
                begin
                    MemberRefundHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberRefund(MemberRefundHeader);
                end;
            DATABASE::"Member Claim Header":
                begin
                    MemberClaimHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectMemberClaim(MemberClaimHeader);
                end;
            DATABASE::"Loan Selloff":
                begin
                    LoanSelloff.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanSelloff(LoanSelloff);
                end;
            DATABASE::"Loan Writeoff Header":
                begin
                    LoanWriteoffHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectLoanWriteoff(LoanWriteoffHeader);
                end;
            DATABASE::"Group Allocation Header":
                begin
                    GroupAllocationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectGroupAllocation(GroupAllocationHeader);
                end;
            DATABASE::"Portfolio Transfer":
                begin
                    PortfolioTransfer.Get(ApprovalEntry."Document No.");
                    ReleaseBOSADocument.RejectPortfolioTransfer(PortfolioTransfer);
                end;
            DATABASE::"Member Activation Header":
                begin
                    MemberActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectMemberActivationDeactivation(MemberActivationHeader);
                end;
            DATABASE::"Account Activation Header":
                begin
                    AccountActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectAccountActivationDeactivation(AccountActivationHeader);
                end;
            DATABASE::"SpotCash Application":
                begin
                    SpotCashApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectSpotcashApplication(SpotCashApplication);
                end;
            DATABASE::"SpotCash Activation Header":
                begin
                    SpotCashActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectSpotcashActivationDeactivation(SpotCashActivationHeader);
                end;
            DATABASE::"ATM Application":
                begin
                    ATMApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMApplication(ATMApplication);
                end;
            DATABASE::"ATM Collection":
                begin
                    ATMCollection.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMCollection(ATMCollection);
                end;
            DATABASE::"ATM Activation Header":
                begin
                    ATMActivationHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectATMActivationDeactivation(ATMActivationHeader);
                end;
            DATABASE::"Cheque Book Application":
                begin
                    ChequeBookApplication.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectChequeBookApplication(ChequeBookApplication);
                end;
            DATABASE::"Cheque Clearance Header":
                begin
                    ChequeClearanceHeader.Get(ApprovalEntry."Document No.");
                    ReleaseFOSADocument.RejectChequeClearance(ChequeClearanceHeader);
                end;
            DATABASE::Transaction:
                begin
                    Transactions.Get(ApprovalEntry."Document No.");
                    //  ReleaseFOSADocument.RejectTellerTransaction(Transactions);
                end;
            DATABASE::"Treasury Transaction":
                begin
                    TreasuryTransaction.Get(ApprovalEntry."Document No.");
                    // ReleaseFOSADocument.RejectCloseTill(TreasuryTransaction);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAccountOpeningForApproval(var AccountOpening: Record "Account Opening")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendFundTransferForApproval(var FundTransfer: Record "Fund Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanReschedulingForApproval(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendGuarantorSubstitutionForApproval(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPayoutForApproval(var PayoutHeader: Record "Payout Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendDividendForApproval(var DividendHeader: Record "Dividend Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberExitForApproval(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberRefundForApproval(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberClaimForApproval(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanSelloffForApproval(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendLoanWriteoffForApproval(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendGroupAllocationForApproval(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendPortfolioTransferForApproval(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendMemberActivationDeactivationForApproval(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendAccountActivationDeactivationForApproval(var AccountActivationHeader: Record "Account Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendSpotcashApplicationForApproval(var SpotcashApplication: Record "SpotCash Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendSpotCashActivationDeactivationForApproval(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMCollectionForApproval(var ATMCollection: Record "ATM Collection")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendATMActivationDeactivationForApproval(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendChequeClearanceForApproval(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendTellerTransactionForApproval(VAR Transactions: Record Transaction);
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendCloseTillForApproval(VAR TreasuryTransaction: Record "Treasury Transaction");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberApplicationApprovalRequest(var MemberApplication: Record "Member Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAccountOpeningApprovalRequest(var AccountOpening: Record "Account Opening")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanApplicationApprovalRequest(var LoanApplication: Record "Loan Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelStandingOrderApprovalRequest(var StandingOrder: Record "Standing Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelFundTransferApprovalRequest(var FundTransfer: Record "Fund Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanReschedulingApprovalRequest(var LoanRescheduling: Record "Loan Rescheduling")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGuarantorSubstitutionApprovalRequest(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPayoutApprovalRequest(var PayoutHeader: Record "Payout Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelDividendApprovalRequest(var DividendHeader: Record "Dividend Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberExitApprovalRequest(var MemberExitHeader: Record "Member Exit Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberRefundApprovalRequest(var MemberRefundHeader: Record "Member Refund Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberClaimApprovalRequest(var MemberClaimHeader: Record "Member Claim Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanSelloffApprovalRequest(var LoanSelloff: Record "Loan Selloff")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelLoanWriteoffApprovalRequest(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelGroupAllocationApprovalRequest(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelPortfolioTransferApprovalRequest(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelMemberActivationDeactivationApprovalRequest(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelAccountActivationDeactivationApprovalRequest(var AccountActivationHeader: Record "Account Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelSpotCashApplicationApprovalRequest(var SpotCashApplication: Record "SpotCash Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelSpotCashActivationDeactivationApprovalRequest(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMApplicationApprovalRequest(var ATMApplication: Record "ATM Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMCollectionApprovalRequest(var ATMCollection: Record "ATM Collection")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelATMActivationDeactivationApprovalRequest(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelChequeBookApplicationApprovalRequest(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelChequeClearanceApprovalRequest(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelCloseTillApprovalRequest(VAR TreasuryTransaction: Record "Treasury Transaction");
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelTellerTransactionApprovalRequest(VAR Transactions: Record Transaction);
    begin
    end;

    procedure IsMemberApplicationApprovalsWorkflowEnabled(var MemberApplication: Record "Member Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberApplication, WorkflowEventHandlingExt.RunWorkflowOnSendMemberApplicationForApprovalCode));
    end;

    procedure IsAccountOpeningApprovalsWorkflowEnabled(var AccountOpening: Record "Account Opening"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(AccountOpening, WorkflowEventHandlingExt.RunWorkflowOnSendAccountOpeningForApprovalCode));
    end;

    procedure IsLoanApplicationApprovalsWorkflowEnabled(var LoanApplication: Record "Loan Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanApplication, WorkflowEventHandlingExt.RunWorkflowOnSendLoanApplicationForApprovalCode));
    end;

    procedure IsStandingOrderApprovalsWorkflowEnabled(var StandingOrder: Record "Standing Order"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(StandingOrder, WorkflowEventHandlingExt.RunWorkflowOnSendStandingOrderForApprovalCode));
    end;

    procedure IsFundTransferApprovalsWorkflowEnabled(var FundTransfer: Record "Fund Transfer"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(FundTransfer, WorkflowEventHandlingExt.RunWorkflowOnSendFundTransferForApprovalCode));
    end;

    procedure IsLoanReschedulingApprovalsWorkflowEnabled(var LoanRescheduling: Record "Loan Rescheduling"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanRescheduling, WorkflowEventHandlingExt.RunWorkflowOnSendLoanReschedulingForApprovalCode));
    end;

    procedure IsGuarantorSubstitutionApprovalsWorkflowEnabled(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GuarantorSubstitutionHeader, WorkflowEventHandlingExt.RunWorkflowOnSendGuarantorSubstitutionForApprovalCode));
    end;

    procedure IsPayoutApprovalsWorkflowEnabled(var PayoutHeader: Record "Payout Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PayoutHeader, WorkflowEventHandlingExt.RunWorkflowOnSendPayoutForApprovalCode));
    end;

    procedure IsDividendApprovalsWorkflowEnabled(var DividendHeader: Record "Dividend Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(DividendHeader, WorkflowEventHandlingExt.RunWorkflowOnSendDividendForApprovalCode));
    end;

    procedure IsMemberExitApprovalsWorkflowEnabled(var MemberExitHeader: Record "Member Exit Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberExitHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberExitForApprovalCode));
    end;

    procedure IsMemberRefundApprovalsWorkflowEnabled(var MemberRefundHeader: Record "Member Refund Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberRefundHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberRefundForApprovalCode));
    end;

    procedure IsMemberClaimApprovalsWorkflowEnabled(var MemberClaimHeader: Record "Member Claim Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberClaimHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberClaimForApprovalCode));
    end;

    procedure IsLoanSelloffApprovalsWorkflowEnabled(var LoanSelloff: Record "Loan Selloff"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanSelloff, WorkflowEventHandlingExt.RunWorkflowOnSendLoanSelloffForApprovalCode));
    end;

    procedure IsLoanSellWriteoffApprovalsWorkflowEnabled(var LoanWriteoffHeader: Record "Loan Writeoff Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(LoanWriteoffHeader, WorkflowEventHandlingExt.RunWorkflowOnSendLoanWriteoffForApprovalCode));
    end;

    procedure IsGroupAllocationApprovalsWorkflowEnabled(var GroupAllocationHeader: Record "Group Allocation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(GroupAllocationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendGroupAllocationForApprovalCode));
    end;

    procedure IsPortfolioTransferApprovalsWorkflowEnabled(var PortfolioTransfer: Record "Portfolio Transfer"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(PortfolioTransfer, WorkflowEventHandlingExt.RunWorkflowOnSendPortfolioTransferForApprovalCode));
    end;

    procedure IsMemberActivationDeactivationApprovalsWorkflowEnabled(var MemberActivationHeader: Record "Member Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(MemberActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendMemberActivationDeactivationForApprovalCode));
    end;

    procedure IsAccountActivationDeactivationApprovalsWorkflowEnabled(var AccountActivationHeader: Record "Account Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(AccountActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendAccountActivationDeactivationForApprovalCode));
    end;

    procedure IsSpotCashApplicationApprovalsWorkflowEnabled(var SpotCashApplication: Record "SpotCash Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(SpotCashApplication, WorkflowEventHandlingExt.RunWorkflowOnSendSpotCashApplicationForApprovalCode));
    end;

    procedure IsSpotCashActivationDeactivationApprovalsWorkflowEnabled(var SpotCashActivationHeader: Record "SpotCash Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(SpotCashActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendSpotCashActivationDeactivationForApprovalCode));
    end;

    procedure IsATMApplicationApprovalsWorkflowEnabled(var ATMApplication: Record "ATM Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMApplication, WorkflowEventHandlingExt.RunWorkflowOnSendATMApplicationForApprovalCode));
    end;

    procedure IsATMCollectionApprovalsWorkflowEnabled(var ATMCollection: Record "ATM Collection"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMCollection, WorkflowEventHandlingExt.RunWorkflowOnSendATMCollectionForApprovalCode));
    end;

    procedure IsATMActivationDeactivationApprovalsWorkflowEnabled(var ATMActivationHeader: Record "ATM Activation Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ATMActivationHeader, WorkflowEventHandlingExt.RunWorkflowOnSendATMActivationDeactivationForApprovalCode));
    end;

    procedure IsChequeBookApplicationApprovalsWorkflowEnabled(var ChequeBookApplication: Record "Cheque Book Application"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ChequeBookApplication, WorkflowEventHandlingExt.RunWorkflowOnSendChequeBookApplicationForApprovalCode));
    end;

    procedure IsChequeClearanceApprovalsWorkflowEnabled(var ChequeClearanceHeader: Record "Cheque Clearance Header"): Boolean
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(ChequeClearanceHeader, WorkflowEventHandlingExt.RunWorkflowOnSendChequeClearanceForApprovalCode));
    end;

    procedure IsTellerTransactionWorkflowEnabled(VAR Transactions: Record Transaction): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(Transactions, WorkflowEventHandlingExt.RunWorkflowOnSendTellerTransactionForApprovalCode));
    end;

    procedure IsCloseTillWorkflowEnabled(VAR TreasuryTransaction: Record "Treasury Transaction"): Boolean;
    begin
        EXIT(WorkflowManagement.CanExecuteWorkflow(TreasuryTransaction, WorkflowEventHandlingExt.RunWorkflowOnSendCloseTillForApprovalCode));
    end;


    procedure CheckMemberApplicationApprovalPossible(var MemberApplication: Record "Member Application"): Boolean
    begin
        IF NOT IsMemberApplicationApprovalsWorkflowEnabled(MemberApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckAccountOpeningApprovalPossible(var AccountOpening: Record "Account Opening"): Boolean
    begin
        IF NOT IsAccountOpeningApprovalsWorkflowEnabled(AccountOpening) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanApplicationApprovalPossible(var LoanApplication: Record "Loan Application"): Boolean
    begin
        IF NOT IsLoanApplicationApprovalsWorkflowEnabled(LoanApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckStandingOrderApprovalPossible(var StandingOrder: Record "Standing Order"): Boolean
    begin
        IF NOT IsStandingOrderApprovalsWorkflowEnabled(StandingOrder) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckFundTransferApprovalPossible(var FundTransfer: Record "Fund Transfer"): Boolean
    begin
        IF NOT IsFundTransferApprovalsWorkflowEnabled(FundTransfer) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanReschedulingApprovalPossible(var LoanRescheduling: Record "Loan Rescheduling"): Boolean
    begin
        IF NOT IsLoanReschedulingApprovalsWorkflowEnabled(LoanRescheduling) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckGuarantorSubstitutionApprovalPossible(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header"): Boolean
    begin
        IF NOT IsGuarantorSubstitutionApprovalsWorkflowEnabled(GuarantorSubstitutionHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckPayoutApprovalPossible(var PayoutHeader: Record "Payout Header"): Boolean
    begin
        IF NOT IsPayoutApprovalsWorkflowEnabled(PayoutHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckDividendApprovalPossible(var DividendHeader: Record "Dividend Header"): Boolean
    begin
        IF NOT IsDividendApprovalsWorkflowEnabled(DividendHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberExitApprovalPossible(var MemberExitHeader: Record "Member Exit Header"): Boolean
    begin
        IF NOT IsMemberExitApprovalsWorkflowEnabled(MemberExitHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberRefundApprovalPossible(var MemberRefundHeader: Record "Member Refund Header"): Boolean
    begin
        IF NOT IsMemberRefundApprovalsWorkflowEnabled(MemberRefundHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberClaimApprovalPossible(var MemberClaimHeader: Record "Member Claim Header"): Boolean
    begin
        IF NOT IsMemberClaimApprovalsWorkflowEnabled(MemberClaimHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanSelloffApprovalPossible(var LoanSelloff: Record "Loan Selloff"): Boolean
    begin
        IF NOT IsLoanSelloffApprovalsWorkflowEnabled(LoanSelloff) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckLoanWriteoffApprovalPossible(var LoanWriteoffHeader: Record "Loan Writeoff Header"): Boolean
    begin
        IF NOT IsLoanSellWriteoffApprovalsWorkflowEnabled(LoanWriteoffHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckGroupAllocationApprovalPossible(var GroupAllocationHeader: Record "Group Allocation Header"): Boolean
    begin
        IF NOT IsGroupAllocationApprovalsWorkflowEnabled(GroupAllocationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckPortfolioTransferApprovalPossible(var PortfolioTransfer: Record "Portfolio Transfer"): Boolean
    begin
        IF NOT IsPortfolioTransferApprovalsWorkflowEnabled(PortfolioTransfer) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckMemberActivationDeactivationApprovalPossible(var MemberActivationHeader: Record "Member Activation Header"): Boolean
    begin
        IF NOT IsMemberActivationDeactivationApprovalsWorkflowEnabled(MemberActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckAccountActivationDeactivationApprovalPossible(var AccountActivationHeader: Record "Account Activation Header"): Boolean
    begin
        IF NOT IsAccountActivationDeactivationApprovalsWorkflowEnabled(AccountActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckSpotCashApplicationApprovalPossible(var SpotCashApplication: Record "SpotCash Application"): Boolean
    begin
        IF NOT IsSpotCashApplicationApprovalsWorkflowEnabled(SpotCashApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckSpotCashActivationDeactivationApprovalPossible(var SpotCashActivationHeader: Record "SpotCash Activation Header"): Boolean
    begin
        IF NOT IsSpotCashActivationDeactivationApprovalsWorkflowEnabled(SpotCashActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMApplicationApprovalPossible(var ATMApplication: Record "ATM Application"): Boolean
    begin
        IF NOT IsATMApplicationApprovalsWorkflowEnabled(ATMApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMCollectionApprovalPossible(var ATMCollection: Record "ATM Collection"): Boolean
    begin
        IF NOT IsATMCollectionApprovalsWorkflowEnabled(ATMCollection) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckATMActivationDeactivationAApprovalPossible(var ATMActivationHeader: Record "ATM Activation Header"): Boolean
    begin
        IF NOT IsATMActivationDeactivationApprovalsWorkflowEnabled(ATMActivationHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckChequeBookApplicationApprovalPossible(var ChequeBookApplication: Record "Cheque Book Application"): Boolean
    begin
        IF NOT IsChequeBookApplicationApprovalsWorkflowEnabled(ChequeBookApplication) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckChequeClearanceApprovalPossible(var ChequeClearanceHeader: Record "Cheque Clearance Header"): Boolean
    begin
        IF NOT IsChequeClearanceApprovalsWorkflowEnabled(ChequeClearanceHeader) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckCloseTillApprovalPossible(VAR TreasuryTransaction: Record "Treasury Transaction"): Boolean;
    begin
        IF NOT IsCloseTillWorkflowEnabled(TreasuryTransaction) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    procedure CheckTellerTransactionApprovalPossible(VAR Transactions: Record Transaction): Boolean;
    begin
        IF NOT IsTellerTransactionWorkflowEnabled(Transactions) THEN
            ERROR(NoWorkflowEnabledErr);

        EXIT(TRUE);
    end;

    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandlingExt: Codeunit "Workflow Event Handling Ext";
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        ReleaseFOSADocument: Codeunit "Release FOSA Document";
        ReleaseBOSADocument: Codeunit "Release BOSA Document";
}