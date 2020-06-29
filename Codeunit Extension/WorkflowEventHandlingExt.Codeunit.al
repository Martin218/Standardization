codeunit 50011 "Workflow Event Handling Ext"
{
    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary()
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberApplicationForApprovalCode, DATABASE::"Member Application", MemberApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberApplicationApprovalRequestCode, DATABASE::"Member Application", MemberApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseMemberApplicationApprovalRequestCode, DATABASE::"Member Application", MemberApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendAccountOpeningForApprovalCode, DATABASE::"Account Opening", AccountOpeningSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelAccountOpeningApprovalRequestCode, DATABASE::"Account Opening", AccountOpeningApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseAccountOpeningApprovalRequestCode, DATABASE::"Account Opening", AccountOpeningReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendTellerTransactionForApprovalCode, DATABASE::Transaction, TellerTransactionSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelTellerTransactionApprovalRequestCode, DATABASE::Transaction, TellerTransactionApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseTellerTransactionCode, DATABASE::Transaction, TellerTransactionReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendCloseTillForApprovalCode, DATABASE::"Treasury Transaction", CloseTillSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelCloseTillApprovalRequestCode, DATABASE::"Treasury Transaction", CloseTillApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnAfterReleaseCloseTillCode, DATABASE::"Treasury Transaction", CloseTillReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanApplicationForApprovalCode, DATABASE::"Loan Application", LoanApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanApplicationApprovalRequestCode, DATABASE::"Loan Application", LoanApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseLoanApplicationApprovalRequestCode, DATABASE::"Loan Application", LoanApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendStandingOrderForApprovalCode, DATABASE::"Standing Order", StandingOrderSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelStandingOrderApprovalRequestCode, DATABASE::"Standing Order", StandingOrderApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseStandingOrderApprovalRequestCode, DATABASE::"Standing Order", StandingOrderReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendFundTransferForApprovalCode, DATABASE::"Fund Transfer", FundTransferSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelFundTransferApprovalRequestCode, DATABASE::"Fund Transfer", FundTransferApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseFundTransferApprovalRequestCode, DATABASE::"Fund Transfer", FundTransferReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanReschedulingForApprovalCode, DATABASE::"Loan Rescheduling", LoanReschedulingSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanReschedulingApprovalRequestCode, DATABASE::"Loan Rescheduling", LoanReschedulingApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseLoanReschedulingApprovalRequestCode, DATABASE::"Loan Rescheduling", LoanReschedulingReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGuarantorSubstitutionForApprovalCode, DATABASE::"Guarantor Substitution Header", GuarantorSubstitutionSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode, DATABASE::"Guarantor Substitution Header", GuarantorSubstitutionApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseGuarantorSubstitutionApprovalRequestCode, DATABASE::"Guarantor Substitution Header", GuarantorSubstitutionReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPayoutForApprovalCode, DATABASE::"Payout Header", PayoutSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPayoutApprovalRequestCode, DATABASE::"Payout Header", PayoutApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleasePayoutApprovalRequestCode, DATABASE::"Payout Header", PayoutReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendDividendForApprovalCode, DATABASE::"Dividend Header", DividendSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelDividendApprovalRequestCode, DATABASE::"Dividend Header", DividendApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseDividendApprovalRequestCode, DATABASE::"Dividend Header", DividendReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberExitForApprovalCode, DATABASE::"Member Exit Header", MemberExitSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberExitApprovalRequestCode, DATABASE::"Member Exit Header", MemberExitApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseMemberExitApprovalRequestCode, DATABASE::"Member Exit Header", MemberExitReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberRefundForApprovalCode, DATABASE::"Member Refund Header", MemberRefundSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberRefundApprovalRequestCode, DATABASE::"Member Refund Header", MemberRefundApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseMemberRefundApprovalRequestCode, DATABASE::"Member Refund Header", MemberRefundReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberClaimForApprovalCode, DATABASE::"Member Claim Header", MemberClaimSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberClaimApprovalRequestCode, DATABASE::"Member Claim Header", MemberClaimApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseMemberClaimApprovalRequestCode, DATABASE::"Member Claim Header", MemberClaimReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanSelloffForApprovalCode, DATABASE::"Loan Selloff", LoanSelloffSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanSelloffApprovalRequestCode, DATABASE::"Loan Selloff", LoanSelloffApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseLoanSelloffApprovalRequestCode, DATABASE::"Loan Selloff", LoanSelloffReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendLoanWriteoffForApprovalCode, DATABASE::"Loan Writeoff Header", LoanWriteoffSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelLoanWriteoffApprovalRequestCode, DATABASE::"Loan Writeoff Header", LoanWriteoffApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseLoanWriteoffApprovalRequestCode, DATABASE::"Loan Writeoff Header", LoanWriteoffReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendGroupAllocationForApprovalCode, DATABASE::"Group Allocation Header", GroupAllocationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelGroupAllocationApprovalRequestCode, DATABASE::"Group Allocation Header", GroupAllocationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseGroupAllocationApprovalRequestCode, DATABASE::"Group Allocation Header", GroupAllocationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendPortfolioTransferForApprovalCode, DATABASE::"Portfolio Transfer", PortfolioTransferSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelPortfolioTransferApprovalRequestCode, DATABASE::"Portfolio Transfer", PortfolioTransferApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleasePortfolioTransferApprovalRequestCode, DATABASE::"Portfolio Transfer", PortfolioTransferReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendMemberActivationDeactivationForApprovalCode, DATABASE::"Member Activation Header", MemberActivationDeactivationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode, DATABASE::"Member Activation Header", MemberActivationDeactivationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseMemberActivationDeactivationApprovalRequestCode, DATABASE::"Member Activation Header", MemberActivationDeactivationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendAccountActivationDeactivationForApprovalCode, DATABASE::"Account Activation Header", AccountActivationDeactivationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode, DATABASE::"Account Activation Header", AccountActivationDeactivationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseAccountActivationDeactivationApprovalRequestCode, DATABASE::"Account Activation Header", AccountActivationDeactivationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendSpotcashApplicationForApprovalCode, DATABASE::"SpotCash Application", SpotcashApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelSpotcashApplicationApprovalRequestCode, DATABASE::"SpotCash Application", SpotcashApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseSpotcashApplicationApprovalRequestCode, DATABASE::"SpotCash Application", SpotcashApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendSpotcashActivationDeactivationForApprovalCode, DATABASE::"SpotCash Activation Header", SpotcashActivationDeactivationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequestCode, DATABASE::"SpotCash Activation Header", SpotcashActivationDeactivationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseSpotcashActivationDeactivationApprovalRequestCode, DATABASE::"SpotCash Activation Header", SpotcashActivationDeactivationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendATMApplicationForApprovalCode, DATABASE::"ATM Application", ATMApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelATMApplicationApprovalRequestCode, DATABASE::"ATM Application", ATMApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseATMApplicationApprovalRequestCode, DATABASE::"ATM Application", ATMApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendATMCollectionForApprovalCode, DATABASE::"ATM Collection", ATMCollectionSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelATMCollectionApprovalRequestCode, DATABASE::"ATM Collection", ATMCollectionApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseATMCollectionApprovalRequestCode, DATABASE::"ATM Collection", ATMCollectionReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendATMActivationDeactivationForApprovalCode, DATABASE::"ATM Activation Header", ATMActivationDeactivationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode, DATABASE::"ATM Activation Header", ATMActivationDeactivationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseATMActivationDeactivationApprovalRequestCode, DATABASE::"ATM Activation Header", ATMActivationDeactivationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendChequeBookApplicationForApprovalCode, DATABASE::"Cheque Book Application", ChequeBookApplicationSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode, DATABASE::"Cheque Book Application", ChequeBookApplicationApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseChequeBookApplicationApprovalRequestCode, DATABASE::"Cheque Book Application", ChequeBookApplicationReleasedEventDescTxt, 0, FALSE);

        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendChequeClearanceForApprovalCode, DATABASE::"Cheque Clearance Header", ChequeClearanceSendForApprovalEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelChequeClearanceApprovalRequestCode, DATABASE::"Cheque Clearance Header", ChequeClearanceApprReqCancelledEventDescTxt, 0, FALSE);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnReleaseChequeClearanceApprovalRequestCode, DATABASE::"Cheque Clearance Header", ChequeClearanceReleasedEventDescTxt, 0, FALSE);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', true, true)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128])
    begin
        case EventFunctionName of
            RunWorkflowOnCancelMemberApplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberApplicationApprovalRequestCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
            RunWorkflowOnCancelAccountOpeningApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelAccountOpeningApprovalRequestCode, RunWorkflowOnSendAccountOpeningForApprovalCode);
            RunWorkflowOnCancelLoanApplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanApplicationApprovalRequestCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
            RunWorkflowOnCancelStandingOrderApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelStandingOrderApprovalRequestCode, RunWorkflowOnSendStandingOrderForApprovalCode);
            RunWorkflowOnCancelFundTransferApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelFundTransferApprovalRequestCode, RunWorkflowOnSendFundTransferForApprovalCode);
            RunWorkflowOnCancelLoanReschedulingApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanReschedulingApprovalRequestCode, RunWorkflowOnSendLoanReschedulingForApprovalCode);
            RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode, RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
            RunWorkflowOnCancelPayoutApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPayoutApprovalRequestCode, RunWorkflowOnSendPayoutForApprovalCode);
            RunWorkflowOnCancelDividendApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelDividendApprovalRequestCode, RunWorkflowOnSendDividendForApprovalCode);
            RunWorkflowOnCancelMemberExitApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberExitApprovalRequestCode, RunWorkflowOnSendMemberExitForApprovalCode);
            RunWorkflowOnCancelMemberRefundApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberRefundApprovalRequestCode, RunWorkflowOnSendMemberRefundForApprovalCode);
            RunWorkflowOnCancelMemberClaimApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberClaimApprovalRequestCode, RunWorkflowOnSendMemberClaimForApprovalCode);
            RunWorkflowOnCancelLoanSelloffApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanSelloffApprovalRequestCode, RunWorkflowOnSendLoanSelloffForApprovalCode);
            RunWorkflowOnCancelLoanWriteoffApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelLoanWriteoffApprovalRequestCode, RunWorkflowOnSendLoanWriteoffForApprovalCode);
            RunWorkflowOnCancelGroupAllocationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelGroupAllocationApprovalRequestCode, RunWorkflowOnSendGroupAllocationForApprovalCode);
            RunWorkflowOnCancelPortfolioTransferApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelPortfolioTransferApprovalRequestCode, RunWorkflowOnSendPortfolioTransferForApprovalCode);
            RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode, RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
            RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode, RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
            RunWorkflowOnCancelSpotcashApplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelSpotcashApplicationApprovalRequestCode, RunWorkflowOnSendSpotcashApplicationForApprovalCode);
            RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelSPotcashActivationDeactivationApprovalRequestCode, RunWorkflowOnSendSpotcashActivationDeactivationForApprovalCode);
            RunWorkflowOnCancelATMAPplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelATMApplicationApprovalRequestCode, RunWorkflowOnSendATMApplicationForApprovalCode);
            RunWorkflowOnCancelATMCollectionApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelATMCollectionApprovalRequestCode, RunWorkflowOnSendATMCollectionForApprovalCode);
            RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode, RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
            RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
            RunWorkflowOnCancelChequeClearanceApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelChequeClearanceApprovalRequestCode, RunWorkflowOnSendChequeClearanceForApprovalCode);
            RunWorkflowOnCancelTellerTransactionApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelTellerTransactionApprovalRequestCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
            RunWorkflowOnCancelCloseTillApprovalRequestCode:
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelCloseTillApprovalRequestCode, RunWorkflowOnSendCloseTillForApprovalCode);
            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendSpotcashApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendSPotcashActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode, RunWorkflowOnSendCloseTillForApprovalCode);

                end;
            WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendSpotcashApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendSPotcashActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnRejectApprovalRequestCode, RunWorkflowOnSendCloseTillForApprovalCode);
                end;

            WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode:
                begin
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendMemberApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendAccountOpeningForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLoanApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendStandingOrderForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendFundTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLoanReschedulingForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendGuarantorSubstitutionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPayoutForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendDividendForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendMemberExitForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendMemberRefundForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendMemberClaimForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLoanSelloffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendLoanWriteoffForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendGroupAllocationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendPortfolioTransferForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendMemberActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendAccountActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendSpotcashApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendSPotcashActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendATMApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendATMCollectionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendATMActivationDeactivationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendChequeBookApplicationForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendChequeClearanceForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendTellerTransactionForApprovalCode);
                    WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnDelegateApprovalRequestCode, RunWorkflowOnSendCloseTillForApprovalCode);
                end;
        end
    end;

    procedure RunWorkflowOnSendMemberApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendMemberApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendAccountOpeningForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendAccountOpeningForApproval'));
    end;

    procedure RunWorkflowOnSendLoanApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLoanApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendStandingOrderForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendStandingOrderForApproval'));
    end;

    procedure RunWorkflowOnSendFundTransferForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendFundTransferForApproval'));
    end;

    procedure RunWorkflowOnSendLoanReschedulingForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLoanReschedulingForApproval'));
    end;

    procedure RunWorkflowOnSendGuarantorSubstitutionForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendGuarantorSubstitutionForApproval'));
    end;

    procedure RunWorkflowOnSendPayoutForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPayoutForApproval'));
    end;

    procedure RunWorkflowOnSendDividendForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendDividendForApproval'));
    end;

    procedure RunWorkflowOnSendMemberExitForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendMemberExitForApproval'));
    end;

    procedure RunWorkflowOnSendMemberRefundForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendMemberRefundForApproval'));
    end;

    procedure RunWorkflowOnSendMemberClaimForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendMemberClaimForApproval'));
    end;

    procedure RunWorkflowOnSendLoanSelloffForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLoanSelloffForApproval'));
    end;

    procedure RunWorkflowOnSendLoanWriteoffForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendLoanWriteoffForApproval'));
    end;

    procedure RunWorkflowOnSendGroupAllocationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendGroupAllocationForApproval'));
    end;

    procedure RunWorkflowOnSendPortfolioTransferForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendPortfolioTransferForApproval'));
    end;

    procedure RunWorkflowOnSendMemberActivationDeactivationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendMemberActivationDeactivationForApproval'));
    end;

    procedure RunWorkflowOnSendAccountActivationDeactivationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendAccountActivationDeactivationForApproval'));
    end;

    procedure RunWorkflowOnSendSpotcashApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendSpotcashApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendSpotcashActivationDeactivationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendSpotcashActivationDeactivationForApproval'));
    end;

    procedure RunWorkflowOnSendATMApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendATMApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendATMCollectionForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendCollectionForApproval'));
    end;

    procedure RunWorkflowOnSendATMActivationDeactivationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendATMActivationDeactivationForApproval'));
    end;

    procedure RunWorkflowOnSendChequeBookApplicationForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendChequeBookApplicationForApproval'));
    end;

    procedure RunWorkflowOnSendChequeClearanceForApprovalCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendChequeClearanceForApproval'));
    end;

    procedure RunWorkflowOnSendTellerTransactionForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendTellerTransactionForApproval'));
    end;

    procedure RunWorkflowOnSendCloseTillForApprovalCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnSendCloseTillForApproval'));
    end;

    procedure RunWorkflowOnCancelMemberApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelMemberApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelAccountOpeningApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelAccountOpeningApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelLoanApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelLoanApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelStandingOrderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelStandingOrderApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelFundTransferApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelFundTransferApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelLoanReschedulingApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelLoanReschedulingApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelGuarantorSubstitutionApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelPayoutApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPayoutApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelDividendApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelDividendApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelMemberExitApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelMemberExitApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelMemberRefundApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelMemberRefundApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelMemberClaimApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelMemberClaimApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelLoanSelloffApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelLoanSelloffApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelLoanWriteoffApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelLoanWriteoffApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelGroupAllocationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelGroupAllocationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelPortfolioTransferApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelPortfolioTransferApprovalRequest'));
    end;


    procedure RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelMemberActivationDeactivationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelAccountActivationDeactivationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelSpotcashApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelSpotcashApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelATMApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelATMApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelATMCollectionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelATMCollectionApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelATMActivationDeactivationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelChequeBookApplicationApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelChequeClearanceApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelChequeClearanceApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelTellerTransactionApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelTellerTransactionApprovalRequest'));
    end;

    procedure RunWorkflowOnCancelCloseTillApprovalRequestCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnCancelCloseTillApprovalRequest'));
    end;

    procedure RunWorkflowOnReleaseMemberApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseMemberApplication'));
    end;

    procedure RunWorkflowOnReleaseAccountOpeningApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseAccountOpening'));
    end;

    procedure RunWorkflowOnReleaseLoanApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseLoanApplication'));
    end;

    procedure RunWorkflowOnReleaseStandingOrderApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseStandingOrder'));
    end;

    procedure RunWorkflowOnReleaseFundTransferApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseFundTransfer'));
    end;

    procedure RunWorkflowOnReleaseLoanReschedulingApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseLoanRescheduling'));
    end;

    procedure RunWorkflowOnReleaseGuarantorSubstitutionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseGuarantorSubstitution'));
    end;

    procedure RunWorkflowOnReleasePayoutApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleasePayout'));
    end;

    procedure RunWorkflowOnReleaseDividendApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseDividend'));
    end;

    procedure RunWorkflowOnReleaseMemberExitApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseMemberExit'));
    end;

    procedure RunWorkflowOnReleaseMemberRefundApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseMemberRefund'));
    end;

    procedure RunWorkflowOnReleaseMemberClaimApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseMemberClaim'));
    end;

    procedure RunWorkflowOnReleaseLoanSelloffApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseLoanSelloff'));
    end;

    procedure RunWorkflowOnReleaseLoanWriteoffApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseLoanWriteoff'));
    end;

    procedure RunWorkflowOnReleaseGroupAllocationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseGroupAllocation'));
    end;

    procedure RunWorkflowOnReleasePortfolioTransferApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleasePortfolioTransfer'));
    end;

    procedure RunWorkflowOnReleaseMemberActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseMemberActivationDeactivation'));
    end;

    procedure RunWorkflowOnReleaseAccountActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseAccountActivationDeactivation'));
    end;

    procedure RunWorkflowOnReleaseSpotcashApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseSpotcashApplication'));
    end;

    procedure RunWorkflowOnReleaseSpotcashActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseActivationDeactivation'));
    end;

    procedure RunWorkflowOnReleaseATMApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseATMApplication'));
    end;

    procedure RunWorkflowOnReleaseATMCollectionApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseATMCollection'));
    end;

    procedure RunWorkflowOnReleaseATMActivationDeactivationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseATMActivationDeactivation'));
    end;

    procedure RunWorkflowOnReleaseChequeBookApplicationApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseChequeBookApplication'));
    end;

    procedure RunWorkflowOnReleaseChequeClearanceApprovalRequestCode(): Code[128]
    begin
        EXIT(UPPERCASE('RunWorkflowOnReleaseChequeClearance'));
    end;

    procedure RunWorkflowOnAfterReleaseTellerTransactionCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseTellerTransaction'));
    end;

    procedure RunWorkflowOnAfterReleaseCloseTillCode(): Code[128];
    begin
        EXIT(UPPERCASE('RunWorkflowOnAfterReleaseCloseTill'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendMemberApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendMemberApplicationForApproval(var MemberApplication: Record "Member Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberApplicationForApprovalCode, MemberApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendAccountOpeningForApproval', '', false, false)]
    procedure RunWorkflowOnSendAccountOpeningForApproval(var AccountOpening: Record "Account Opening")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendAccountOpeningForApprovalCode, AccountOpening);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendLoanApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendLoanApplicationForApproval(var LoanApplication: Record "Loan Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanApplicationForApprovalCode, LoanApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendStandingOrderForApproval', '', false, false)]
    procedure RunWorkflowOnSendStandingOrderForApproval(var StandingOrder: Record "Standing Order")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendStandingOrderForApprovalCode, StandingOrder);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendFundTransferForApproval', '', false, false)]
    procedure RunWorkflowOnSendFundTransferForApproval(var FundTransfer: Record "Fund Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendFundTransferForApprovalCode, FundTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendLoanReschedulingForApproval', '', false, false)]
    procedure RunWorkflowOnSendLoanReschedulingForApproval(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanReschedulingForApprovalCode, LoanRescheduling);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendGuarantorSubstitutionForApproval', '', false, false)]
    procedure RunWorkflowOnSendGuarantorSubstitutionForApproval(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendGuarantorSubstitutionForApprovalCode, GuarantorSubstitutionHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendPayoutForApproval', '', false, false)]
    procedure RunWorkflowOnSendPayoutForApproval(var PayoutHeader: Record "Payout Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPayoutForApprovalCode, PayoutHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendDividendForApproval', '', false, false)]
    procedure RunWorkflowOnSendDividendForApproval(var DividendHeader: Record "Dividend Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendDividendForApprovalCode, DividendHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendMemberExitForApproval', '', false, false)]
    procedure RunWorkflowOnSendMemberExitForApproval(var MemberExitHeader: Record "Member Exit Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberExitForApprovalCode, MemberExitHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendMemberRefundForApproval', '', false, false)]
    procedure RunWorkflowOnSendMemberRefundForApproval(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberRefundForApprovalCode, MemberRefundHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendMemberClaimForApproval', '', false, false)]
    procedure RunWorkflowOnSendMemberClaimForApproval(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberClaimForApprovalCode, MemberClaimHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendLoanSelloffForApproval', '', false, false)]
    procedure RunWorkflowOnSendLoanSelloffForApproval(var LoanSelloff: Record "Loan Selloff")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanSelloffForApprovalCode, LoanSelloff);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendLoanWriteoffForApproval', '', false, false)]
    procedure RunWorkflowOnSendLoanWriteoffForApproval(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendLoanWriteoffForApprovalCode, LoanWriteoffHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendGroupAllocationForApproval', '', false, false)]
    procedure RunWorkflowOnSendGroupAllocationForApproval(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendGroupAllocationForApprovalCode, GroupAllocationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendPortfolioTransferForApproval', '', false, false)]
    procedure RunWorkflowOnSendPortfolioTransferForApproval(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendPortfolioTransferForApprovalCode, PortfolioTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendMemberActivationDeactivationForApproval', '', false, false)]
    procedure RunWorkflowOnSendMemberActivationDeactivationForApproval(var MemberActivationHeader: Record "Member Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendMemberActivationDeactivationForApprovalCode, MemberActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendAccountActivationDeactivationForApproval', '', false, false)]
    procedure RunWorkflowOnSendAccountMemberActivationDeactivationForApproval(var AccountActivationHeader: Record "Account Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendAccountActivationDeactivationForApprovalCode, AccountActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendSpotcashApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendSpotcashApplicationForApproval(var SpotcashApplication: Record "SpotCash Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSpotcashApplicationForApprovalCode, SpotcashApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendSpotcashActivationDeactivationForApproval', '', false, false)]
    procedure RunWorkflowOnSendSpotcashActivationDeactivationForApproval(var SpotcashActivationHeader: Record "SpotCash Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendSpotcashActivationDeactivationForApprovalCode, SpotcashActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendATMApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendATMApplicationForApproval(var ATMApplication: Record "ATM Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendATMApplicationForApprovalCode, ATMApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendATMCollectionForApproval', '', false, false)]
    procedure RunWorkflowOnSendATMColllectionForApproval(var ATMCollection: Record "ATM Collection")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendATMCollectionForApprovalCode, ATMCollection);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendATMActivationDeactivationForApproval', '', false, false)]
    procedure RunWorkflowOnSendATMActivationDeactivationForApproval(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendATMActivationDeactivationForApprovalCode, ATMActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendChequeBookApplicationForApproval', '', false, false)]
    procedure RunWorkflowOnSendChequeBookApplicationForApproval(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendChequeBookApplicationForApprovalCode, ChequeBookApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendChequeClearanceForApproval', '', false, false)]
    procedure RunWorkflowOnSendChequeClearanceForApproval(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendChequeClearanceForApprovalCode, ChequeClearanceHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendCloseTillForApproval', '', false, false)]
    procedure RunWorkflowOnSendCloseTillForApproval(var TreasuryTransaction: Record "Treasury Transaction");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendCloseTillForApprovalCode, TreasuryTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnSendTellerTransactionForApproval', '', false, false)]
    procedure RunWorkflowOnSendTellerTransactionForApproval(var Transactions: Record Transaction);
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnSendTellerTransactionForApprovalCode, Transactions);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelMemberApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelMemberApplicationApprovalRequest(var MemberApplication: Record "Member Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberApplicationApprovalRequestCode, MemberApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelAccountOpeningApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelAccountOpeningApprovalRequest(var AccountOpening: Record "Account Opening")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelAccountOpeningApprovalRequestCode, AccountOpening);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelLoanApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCanceLoanApplicationApprovalRequest(var LoanApplication: Record "Loan Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanApplicationApprovalRequestCode, LoanApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelStandingOrderApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelStandingOrderApprovalRequest(var StandingOrder: Record "Standing Order")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelStandingOrderApprovalRequestCode, StandingOrder);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelFundTransferApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelFundTransferApprovalRequest(var FundTransfer: Record "Fund Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelFundTransferApprovalRequestCode, FundTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelLoanReschedulingApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelLoanReschedulingApprovalRequest(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanReschedulingApprovalRequestCode, LoanRescheduling);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelGuarantorSubstitutionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelGuarantorSubstitutionApprovalRequest(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelGuarantorSubstitutionApprovalRequestCode, GuarantorSubstitutionHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelPayoutApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPayoutApprovalRequest(var PayoutHeader: Record "Payout Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPayoutApprovalRequestCode, PayoutHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelDividendApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelDividendApprovalRequest(var DividendHeader: Record "Dividend Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelDividendApprovalRequestCode, DividendHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelMemberExitApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelMemberExitApprovalRequest(var MemberExitHeader: Record "Member Exit Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberExitApprovalRequestCode, MemberExitHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelMemberRefundApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelMemberRefundApprovalRequest(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberRefundApprovalRequestCode, MemberRefundHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelMemberClaimApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelMemberClaimApprovalRequest(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberClaimApprovalRequestCode, MemberClaimHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelLoanSelloffApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelLoanSelloffApprovalRequest(var LoanSelloff: Record "Loan Selloff")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanSelloffApprovalRequestCode, LoanSelloff);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelLoanWriteoffApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelLoanWriteoffApprovalRequest(var LoanWriteoffHeader: Record "Loan Writeoff Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelLoanWriteoffApprovalRequestCode, LoanWriteoffHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelGroupAllocationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelGroupAllocationApprovalRequest(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelGroupAllocationApprovalRequestCode, GroupAllocationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelPortfolioTransferApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelPortfolioTransferApprovalRequest(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelPortfolioTransferApprovalRequestCode, PortfolioTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelMemberActivationDeactivationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelMemberActivationDeactivationAApprovalRequest(var MemberActivationHeader: Record "Member Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelMemberActivationDeactivationApprovalRequestCode, MemberActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelAccountActivationDeactivationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelAccountActivationDeactivationAApprovalRequest(var AccountActivationHeader: Record "Account Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelAccountActivationDeactivationApprovalRequestCode, AccountActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelSpotcashApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelSpotcashApplicationApprovalRequest(var SpotcashApplication: Record "SpotCash Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSPotcashApplicationApprovalRequestCode, SpotcashApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelSpotcashActivationDeactivationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequest(var SpotcashActivationHeader: Record "SpotCash Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelSpotcashActivationDeactivationApprovalRequestCode, SpotcashActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelATMApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelATMApplicationApprovalRequest(var ATMApplication: Record "ATM Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelATMApplicationApprovalRequestCode, ATMApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelATMCollectionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelATMCollectionApprovalRequest(var ATMCollection: Record "ATM Collection")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelATMCollectionApprovalRequestCode, ATMCollection);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelATMActivationDeactivationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelATMActivationDeactivationApprovalRequest(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelATMActivationDeactivationApprovalRequestCode, ATMActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelChequeBookApplicationApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelChequeBookApplicationApprovalRequest(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelChequeBookApplicationApprovalRequestCode, ChequeBookApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelChequeClearanceApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelChequeClearanceApprovalRequest(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelChequeClearanceApprovalRequestCode, ChequeClearanceHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelTellerTransactionApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelTellerTransactionApprovalRequest(var Transactions: Record Transaction);
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelTellerTransactionApprovalRequestCode, Transactions);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt Ext", 'OnCancelCloseTillApprovalRequest', '', false, false)]
    procedure RunWorkflowOnCancelCloseTillApprovalRequest(var TreasuryTransaction: Record 50047);
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnCancelCloseTillApprovalRequestCode, TreasuryTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseMemberApplication', '', false, false)]
    procedure RunWorkflowOnReleaseMemberApplication(var MemberApplication: Record "Member Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseMemberApplicationApprovalRequestCode, MemberApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseAccountOpening', '', false, false)]
    procedure RunWorkflowOnReleaseAccountOpening(var AccountOpening: Record "Account Opening")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseAccountOpeningApprovalRequestCode, AccountOpening);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseLoanApplication', '', false, false)]
    procedure RunWorkflowOnReleaseLoanApplication(var LoanApplication: Record "Loan Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseLoanApplicationApprovalRequestCode, LoanApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseStandingOrder', '', false, false)]
    procedure RunWorkflowOnReleaseStandingOrder(var StandingOrder: Record "Standing Order")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseStandingOrderApprovalRequestCode, StandingOrder);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseFundTransfer', '', false, false)]
    procedure RunWorkflowOnReleaseFundTransfer(var FundTransfer: Record "Fund Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseFundTransferApprovalRequestCode, FundTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseLoanRescheduling', '', false, false)]
    procedure RunWorkflowOnReleaseLoanRescheduling(var LoanRescheduling: Record "Loan Rescheduling")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseLoanReschedulingApprovalRequestCode, LoanRescheduling);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseGuarantorSubstitution', '', false, false)]
    procedure RunWorkflowOnReleaseGuarantorSubstitution(var GuarantorSubstitutionHeader: Record "Guarantor Substitution Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseGuarantorSubstitutionApprovalRequestCode, GuarantorSubstitutionHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleasePayout', '', false, false)]
    procedure RunWorkflowOnReleasePayout(var PayoutHeader: Record "Payout Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleasePayoutApprovalRequestCode, PayoutHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseDividend', '', false, false)]
    procedure RunWorkflowOnReleaseDividend(var DividendHeader: Record "Dividend Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseDividendApprovalRequestCode, DividendHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseMemberExit', '', false, false)]
    procedure RunWorkflowOnReleaseMemberExit(var MemberExitHeader: Record "Member Exit Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseMemberExitApprovalRequestCode, MemberExitHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseMemberRefund', '', false, false)]
    procedure RunWorkflowOnReleaseMemberRefund(var MemberRefundHeader: Record "Member Refund Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseMemberRefundApprovalRequestCode, MemberRefundHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseMemberClaim', '', false, false)]
    procedure RunWorkflowOnReleaseMemberClaim(var MemberClaimHeader: Record "Member Claim Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseMemberClaimApprovalRequestCode, MemberClaimHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseLoanSelloff', '', false, false)]
    procedure RunWorkflowOnReleaseLoanSelloff(var LoanSelloff: Record "Loan Selloff")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseLoanSelloffApprovalRequestCode, LoanSelloff);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleaseGroupAllocation', '', false, false)]
    procedure RunWorkflowOnReleaseGroupAllocation(var GroupAllocationHeader: Record "Group Allocation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseGroupAllocationApprovalRequestCode, GroupAllocationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release BOSA Document", 'OnAfterReleasePortfolioTransfer', '', false, false)]
    procedure RunWorkflowOnReleasePortfolioTransfer(var PortfolioTransfer: Record "Portfolio Transfer")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleasePortfolioTransferApprovalRequestCode, PortfolioTransfer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseMemberActivationDeactivation', '', false, false)]
    procedure RunWorkflowOnReleaseMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseMemberActivationDeactivationApprovalRequestCode, MemberActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseAccountActivationDeactivation', '', false, false)]
    procedure RunWorkflowOnReleaseAccountActivationDeactivation(var AccountActivationHeader: Record "Account Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseAccountActivationDeactivationApprovalRequestCode, AccountActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseSpotcashApplication', '', false, false)]
    procedure RunWorkflowOnReleaseSpotcashApplication(var SpotcashApplication: Record "SpotCash Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseSpotcashApplicationApprovalRequestCode, SpotcashApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseSpotcashActivationDeactivation', '', false, false)]
    procedure RunWorkflowOnReleaseSpotcashActivationDeactivation(var SpotcashActivationHeader: Record "SpotCash Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseSpotcashActivationDeactivationApprovalRequestCode, SpotcashActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseATMApplication', '', false, false)]
    procedure RunWorkflowOnReleaseATMApplication(var ATMApplication: Record "ATM Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseATMApplicationApprovalRequestCode, ATMApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseATMCollection', '', false, false)]
    procedure RunWorkflowOnReleaseATMCollection(var ATMCollection: Record "ATM Collection")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseATMCollectionApprovalRequestCode, ATMCollection);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseATMActivationDeactivation', '', false, false)]
    procedure RunWorkflowOnReleaseATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseATMActivationDeactivationApprovalRequestCode, ATMActivationHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseChequeBookApplication', '', false, false)]
    procedure RunWorkflowOnReleaseChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseChequeBookApplicationApprovalRequestCode, ChequeBookApplication);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseChequeClearance', '', false, false)]
    procedure RunWorkflowOnReleaseChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnReleaseChequeClearanceApprovalRequestCode, ChequeClearanceHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseCloseTill', '', false, false)]
    procedure RunWorkflowOnAfterReleaseCloseTill(var TreasuryTransaction: Record "Treasury Transaction");
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseCloseTillCode, TreasuryTransaction);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release FOSA Document", 'OnAfterReleaseTellerTransaction', '', false, false)]
    procedure RunWorkflowOnAfterReleaseTellerTransaction(var Transactions: Record Transaction);
    begin
        WorkflowManagement.HandleEvent(RunWorkflowOnAfterReleaseTellerTransactionCode, Transactions);
    end;


    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        MemberApplicationSendForApprovalEventDescTxt: Label 'Approval of a Member Application is requested.';
        MemberApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Member Application is canceled.';
        MemberApplicationReleasedEventDescTxt: Label 'A Member Application is released.';

        TellerTransactionSendForApprovalEventDescTxt: Label 'Approval of a Teller Transaction is requested.';
        TellerTransactionApprReqCancelledEventDescTxt: Label 'An approval request for a TellerTransaction is canceled.';
        TellerTransactionReleasedEventDescTxt: Label 'A TellerTransaction is released.';

        CloseTillSendForApprovalEventDescTxt: Label 'Approval of a Close Till is requested.';
        CloseTillApprReqCancelledEventDescTxt: Label 'An approval request for a Close Till is cancelled.';
        CloseTillReleasedEventDescTxt: Label 'A Close Till is released.';

        LoanApplicationSendForApprovalEventDescTxt: Label 'Approval of a Loan Application is requested.';
        LoanApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Loan Application is canceled.';
        LoanApplicationReleasedEventDescTxt: Label 'A Loan Application is released.';

        StandingOrderSendForApprovalEventDescTxt: Label 'Approval of a Standing Order is requested.';
        StandingOrderApprReqCancelledEventDescTxt: Label 'An approval request for a Standing Order is canceled.';
        StandingOrderReleasedEventDescTxt: Label 'A Standing Order is released.';

        FundTransferSendForApprovalEventDescTxt: Label 'Approval of a Fund Trasfer is requested.';
        FundTransferApprReqCancelledEventDescTxt: Label 'An approval request for a Fund Transfer is canceled.';
        FundTransferReleasedEventDescTxt: Label 'A Fund Transfer is released.';

        GuarantorSubstitutionSendForApprovalEventDescTxt: Label 'Approval of a Guarantor Substitution is requested.';
        GuarantorSubstitutionApprReqCancelledEventDescTxt: Label 'An approval request for a Guarantor Substitution is canceled.';
        GuarantorSubstitutionReleasedEventDescTxt: Label 'A Guarantor Substitution is released.';

        LoanReschedulingSendForApprovalEventDescTxt: Label 'Approval of a Loan Rescheduling is requested.';
        LoanReschedulingApprReqCancelledEventDescTxt: Label 'An approval request for a Loan Reschedulingis canceled.';
        LoanReschedulingReleasedEventDescTxt: Label 'A Loan Rescheduling is released.';

        PayoutSendForApprovalEventDescTxt: Label 'Approval of a Payout is requested.';
        PayoutApprReqCancelledEventDescTxt: Label 'An approval request for a Payout is canceled.';
        PayoutReleasedEventDescTxt: Label 'A Payout is released.';

        DividendSendForApprovalEventDescTxt: Label 'Approval of a Dividend is requested.';
        DividendApprReqCancelledEventDescTxt: Label 'An approval request for a Dividend is canceled.';
        DividendReleasedEventDescTxt: Label 'A Dividend is released.';

        MemberExitSendForApprovalEventDescTxt: Label 'Approval of a Member Exit is requested.';
        MemberExitApprReqCancelledEventDescTxt: Label 'An approval request for a Member Exit is canceled.';
        MemberExitReleasedEventDescTxt: Label 'A Member Exit is released.';

        MemberRefundSendForApprovalEventDescTxt: Label 'Approval of a Member Refund is requested.';
        MemberRefundApprReqCancelledEventDescTxt: Label 'An approval request for a Member Refund is canceled.';
        MemberRefundReleasedEventDescTxt: Label 'A Member Refund is released.';

        MemberClaimSendForApprovalEventDescTxt: Label 'Approval of a Member Claim is requested.';
        MemberClaimApprReqCancelledEventDescTxt: Label 'An approval request for a Member Claim is canceled.';
        MemberClaimReleasedEventDescTxt: Label 'A Member Claim is released.';

        LoanSelloffSendForApprovalEventDescTxt: Label 'Approval of a LoanSelloff is requested.';
        LoanSelloffApprReqCancelledEventDescTxt: Label 'An approval request for a LoanSelloff is canceled.';
        LoanSelloffReleasedEventDescTxt: Label 'A LoanSelloff is released.';

        LoanWriteoffSendForApprovalEventDescTxt: Label 'Approval of a Loan Writeoff is requested.';
        LoanWriteoffApprReqCancelledEventDescTxt: Label 'An approval request for a Loan Writeoff is canceled.';
        LoanWriteoffReleasedEventDescTxt: Label 'A Loan Writeoff is released.';

        GroupAllocationSendForApprovalEventDescTxt: Label 'Approval of a Group Allocation is requested.';
        GroupAllocationApprReqCancelledEventDescTxt: Label 'An approval request for a Group Allocation is canceled.';
        GroupAllocationReleasedEventDescTxt: Label 'A Group Allocation is released.';

        PortfolioTransferSendForApprovalEventDescTxt: Label 'Approval of a Portfolio Transfer is requested.';
        PortfolioTransferApprReqCancelledEventDescTxt: Label 'An approval request for a Portfolio Transfer is canceled.';
        PortfolioTransferReleasedEventDescTxt: Label 'A Portfolio Transfer is released.';

        ATMApplicationSendForApprovalEventDescTxt: Label 'Approval of an ATM Application is requested.';
        ATMApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a ATM Application is canceled.';
        ATMApplicationReleasedEventDescTxt: Label 'An ATM Application is released.';
        ATMCollectionSendForApprovalEventDescTxt: Label 'Approval of an ATM Collection is requested.';
        ATMCollectionApprReqCancelledEventDescTxt: Label 'An approval request for a ATM Collection is canceled.';
        ATMCollectionReleasedEventDescTxt: Label 'An ATM Collection is released.';

        ATMActivationDeactivationSendForApprovalEventDescTxt: Label 'Approval of a ATM Activation/Deactivation is requested.';
        ATMActivationDeactivationApprReqCancelledEventDescTxt: Label 'An approval request for an ATM Activation/Deactivation is canceled.';
        ATMActivationDeactivationReleasedEventDescTxt: Label 'An ATM Activation/Deactivation is released.';

        SpotcashApplicationSendForApprovalEventDescTxt: Label 'Approval of a Spotcash Application is requested.';
        SpotcashApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Spotcash Application is canceled.';
        SpotcashApplicationReleasedEventDescTxt: Label 'A Spotcash Application is released.';

        SpotcashActivationDeactivationSendForApprovalEventDescTxt: Label 'Approval of a Spotcash Activation/Deactivation is requested.';
        SPotcashActivationDeactivationApprReqCancelledEventDescTxt: Label 'An approval request for a Spotcash Activation/Deactivation is canceled.';
        SPotcashActivationDeactivationReleasedEventDescTxt: Label 'A Spotcash Activation/Deactivation is released.';

        MemberActivationDeactivationSendForApprovalEventDescTxt: Label 'Approval of a Member Activation/Deactivation is requested.';
        MemberActivationDeactivationApprReqCancelledEventDescTxt: Label 'An approval request for a Member Activation/Deactivation is canceled.';
        MemberActivationDeactivationReleasedEventDescTxt: Label 'A Member Activation/Deactivation is released.';

        AccountActivationDeactivationSendForApprovalEventDescTxt: Label 'Approval of an Account Activation/Deactivation is requested.';
        AccountActivationDeactivationApprReqCancelledEventDescTxt: Label 'An approval request for an Account Activation/Deactivation is canceled.';
        AccountActivationDeactivationReleasedEventDescTxt: Label 'An Account Activation/Deactivation is released.';

        AccountOpeningSendForApprovalEventDescTxt: Label 'Approval of an Account Opening is requested.';
        AccountOpeningApprReqCancelledEventDescTxt: Label 'An approval request for an Account Opening is canceled.';
        AccountOpeningReleasedEventDescTxt: Label 'An Account Opening is released.';
        ChequeBookApplicationSendForApprovalEventDescTxt: Label 'Approval of a Cheque Book Application is requested.';
        ChequeBookApplicationApprReqCancelledEventDescTxt: Label 'An approval request for a Cheque Book Application is canceled.';
        ChequeBookApplicationReleasedEventDescTxt: Label 'A Cheque Book Application is released.';

        ChequeClearanceSendForApprovalEventDescTxt: Label 'Approval of a Cheque Clearance is requested.';
        ChequeClearanceApprReqCancelledEventDescTxt: Label 'An approval request for a Cheque Clearance is canceled.';
        ChequeClearanceReleasedEventDescTxt: Label 'A Cheque Clearance is released.';

}

