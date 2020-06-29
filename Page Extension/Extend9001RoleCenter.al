pageextension 50503 "Accountant Role Center Ext" extends "Accountant Role Center"
{
    layout
    {

    }
    actions
    {
        addafter("Cost Accounting")
        {
            group(CashSetup)
            {
                Caption = 'Cash Management Setup';
                action(Cashmngetsetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cash Management Setup';
                    Image = CashFlowSetup;
                    RunObject = Page "Cash Management Setup";
                    ToolTip = 'Set up All Parameters for Cash Management Module';
                }
                action(AccountMapping)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Account Mapping Setup';
                    Image = CashFlowSetup;
                    RunObject = Page "Account Mapping Type";
                    ToolTip = 'Set up All Account Mapping Type';
                }
                action(ImprestTypesSetup)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Imprest Types Setup';
                    Image = CashFlowSetup;
                    RunObject = Page "Imprest Types Set up";
                    ToolTip = 'Set up All Imprest Types';
                }
            }

        }
        addafter(BankAccountReconciliations)
        {
            group(ImprestMagement)
            {
                Caption = 'Imprest Management';
                group(Imprest)
                {
                    Caption = 'Imprest Menu';

                    action(ImprestList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Imprest Request';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Imprest List";
                        ToolTip = 'Reconcile all imprest at applications stage';
                    }
                    action(ApprovedImprestList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Imprest List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Approved Imprest List";
                        ToolTip = 'Reconcile all imprest at Approved stage';
                    }
                    action(PostedImprestList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Imprest List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Posted Imprest List";
                        ToolTip = 'Reconcile all Posted Imprest stage';
                    }
                }
                group(ImprestSurrender)
                {
                    Caption = 'Imprest Surrender Menu';
                    action(ImprestSurrenderList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Imprest Surrender List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Imprest Surrender  List";
                        ToolTip = 'Reconcile all Imprest Surrender  List stage';
                    }
                    action(ApporvedSurrenderList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Imprest Surrender List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Approved Imprest Surrender";
                        ToolTip = 'Reconcile all Approved Imprest Surrender';
                    }
                    action(PostedSurrenderList)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Imprest Surrender List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Posted Imprest Surrender";
                        ToolTip = 'Reconcile all Posted Imprest Surrender stage';
                    }


                }
                group(Claim)
                {
                    Caption = 'Claim/Refund Menu';
                    action(ClaimR)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Imprest Claim/Refund List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Imprest Claim/Refund List";
                        ToolTip = 'Reconcile all Imprest Claim/Refund List stage';
                    }
                    action(ClaimA)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'PosteImprest Claim/Refund List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "PosteImprest Claim/Refund List";
                        ToolTip = 'Reconcile all PosteImprest Claim/Refund List stage';
                    }
                }
                group(salaryAdvance)
                {
                    Caption = 'Salary Advance Menu';
                    action(SalaryAd)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Salary Advance List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Salary Advance List";
                        ToolTip = 'Reconcile all Salary Advance List stage';
                    }
                    action(SalaryAp)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Salary Advance List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Approved Salary Advance List";
                        ToolTip = 'Reconcile all Approved Salary Advance List stage';
                    }
                }

            }
            group(PaymentReceipts)
            {
                Caption = 'Payments & Receipts';
                group(PAYMENTVOUCHER)
                {
                    Caption = 'Payment Vouchers';
                    action(voucherlist)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Payment Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Payment Voucher List";
                        ToolTip = 'Reconcile all Payment Voucher List stage';
                    }
                    action(approvedVouchers)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approved Payment Voucher';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Approved Payment Voucher";
                        ToolTip = 'Reconcile all Approved Payment Voucher stage';

                    }
                    action(postedvoucher)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Payment Voucher';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Posted Payment Voucher";
                        ToolTip = 'Reconcile all Posted Payment Voucher stage';
                    }

                }
                group(RECEIPTS)
                {
                    Caption = 'Receipt Vouchers';
                    action(ReceiptVoucher)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Receipt Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Receipt Voucher List";
                        ToolTip = 'Reconcile all Receipt Voucher List stage';

                    }
                    action(postedReceipt)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Receipt Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Posted Receipt Voucher List";
                        ToolTip = 'Reconcile all Posted Receipt Voucher List stage';

                    }
                }
                group(PettyCash)
                {
                    Caption = 'Petty Cash';
                    action(Petty_Cash)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Petty Cash Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "Petty Cash Voucher List";
                        ToolTip = 'Reconcile all Petty Cash Voucher List stage';
                    }
                    action(Petty_A)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Approve Petty Cash Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "ApprovePetty Cash Voucher List";
                        ToolTip = 'Reconcile all Approve Petty Cash Voucher List stage';
                    }
                    action(Petty_P)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Posted Petty Cash Voucher List';
                        Image = CashFlow;
                        Promoted = true;
                        PromotedCategory = Process;
                        RunObject = Page "PostedPetty Cash Voucher List";
                        ToolTip = 'Reconcile all Posted Petty Cash Voucher List stage';
                    }
                }
            }
            group(Budget)
            {
                Caption = 'Budget Management';
                action(BudgetCreation)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Budget Creation';
                    Image = LedgerBudget;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Budget Creation";
                    ToolTip = 'Reconcile all Budget Creation stage';
                }

                action(CommitmentEntry)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commitment Entry';
                    Image = LedgerBudget;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Commitment Entry";
                    ToolTip = 'Reconcile all Budget Creation Header stage';
                }
            }
        }
    }
}