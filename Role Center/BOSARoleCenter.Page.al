page 50346 "BOSA RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'BOSA Role Center';
    layout
    {
        area(RoleCenter)
        {

            part(Part1; "BOSA RoleCenter Headline")
            {
                ApplicationArea = All;
            }

            part(Part2; "BOSA Activities")
            {
                Caption = 'BOSA';
                ApplicationArea = All;
            }
            part(Control1; "Trailing Sales Orders Chart")
            {
                AccessByPermission = TableData "Sales Shipment Header" = R;
                ApplicationArea = Basic, Suite;
            }
            part(Control4; "My Job Queue")
            {
                ApplicationArea = Basic, Suite;
                Visible = false;
            }
            part(Control1905989608; "My Items")
            {
                AccessByPermission = TableData "My Item" = R;
                ApplicationArea = Basic, Suite;
            }
            part(Control13; "Power BI Report Spinner Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Control21; "Report Inbox Part")
            {
                AccessByPermission = TableData "Report Inbox" = R;
                ApplicationArea = Suite;
            }
            systempart(Control1901377608; MyNotes)
            {
                ApplicationArea = Basic, Suite;
            }

        }
    }

    actions
    {
        area(Sections)
        {
            group("FOSA Management")
            {
                group(MemberApplication)
                {
                    Caption = 'Member Application';

                    action("New Member Applications")
                    {
                        RunObject = Page "Member Application List";
                        ApplicationArea = All;
                    }
                    action("Pending Member Applications")
                    {
                        RunObject = Page "Pending Member App. List";
                        ApplicationArea = All;
                    }
                    action("Approved Member Applications")
                    {
                        RunObject = Page "Approved Member App. List";
                        ApplicationArea = All;
                    }
                    action("Rejected Member Applications")
                    {
                        //  RunObject = Page
                        ApplicationArea = All;
                    }

                }
                group(MembersAndAccounts)
                {
                    Caption = 'Members & Member Accounts';
                    action(FOSAMembers)
                    {
                        Caption = 'Members';
                        RunObject = Page "Member List";
                        ApplicationArea = All;
                    }
                    action(SDAccounts)
                    {
                        Caption = 'Savings Accounts';
                        RunObject = Page "Member S/Dep. Account List";
                        ApplicationArea = All;
                    }
                    action(LoanAccounts)
                    {
                        Caption = 'Loan Accounts';
                        RunObject = Page "Member Loan Account List";
                        ApplicationArea = All;
                    }

                }
                group(AccountOpening)
                {
                    Caption = 'Account Opening';
                    action("New Account Opening")
                    {
                        RunObject = Page "Account Opening List";
                        ApplicationArea = All;
                    }
                    action("Pending Account Opening")
                    {
                        RunObject = Page "Pending Account Opening List";
                        ApplicationArea = All;
                    }
                    action("Approved Account Opening")
                    {
                        RunObject = Page "Approved Account Opening  List";
                        ApplicationArea = All;
                    }
                    action("Rejected Account Opening")
                    {
                        RunObject = Page "Approved Account Opening  List";
                        ApplicationArea = All;
                    }
                }
                group(Tellering)
                {
                    action("Teller Transactions")
                    {
                        RunObject = Page "Teller Transactions List";
                        ApplicationArea = All;

                    }
                    action("Pending Teller Transactions")
                    {
                        RunObject = Page "Pending Teller Transactions";
                        ApplicationArea = All;

                    }
                    action("Requests from Treasury")
                    {
                        RunObject = Page "Request From Treasury List";
                        ApplicationArea = All;

                    }
                    action("Receive from Treasury")
                    {
                        RunObject = Page "Receive From Bank List";
                        ApplicationArea = All;

                    }
                    action("Return to Treasury")
                    {
                        RunObject = Page "Return To Treasury List";
                        ApplicationArea = All;

                    }
                    action("Close Till")
                    {
                        RunObject = Page "Close Till";
                        ApplicationArea = All;

                    }
                    group(TelleringHistory)
                    {
                        Caption = 'History';
                        action("Posted Close Tills")
                        {
                            RunObject = Page "Posted Close Till Requests";
                            ApplicationArea = All;
                        }
                        action("Posted Teller Transactions")
                        {
                            RunObject = Page "Posted Teller Transactions";
                            ApplicationArea = All;
                        }
                    }
                }
                group(Treasury)
                {
                    action("Issue Requests")
                    {
                        RunObject = Page "Issue Requests";
                        ApplicationArea = All;

                    }
                    action("Issue to Teller")
                    {
                        RunObject = Page "Issue To Teller List";
                        ApplicationArea = All;

                    }
                    action("Receive from Bank")
                    {
                        RunObject = Page "Receive From Bank List";
                        ApplicationArea = All;

                    }
                    action("Return to Bank")
                    {
                        RunObject = Page "Return To Bank List";
                        ApplicationArea = All;

                    }
                    action("Banking of Cheques")
                    {
                        RunObject = Page "Banking Of Cheques";
                        ApplicationArea = All;

                    }

                    group(TreasuryHistory)
                    {
                        Caption = 'History';
                        action("Posted Receive from Bank")
                        {
                            RunObject = Page "Posted Receive From Bank";
                            ApplicationArea = All;
                        }
                        action("Received Teller Requests")
                        {
                            RunObject = Page "Received Teller Requests";
                            ApplicationArea = All;
                        }
                        action("Banked Cheques")
                        {
                            RunObject = Page "Banked Cheques";
                            ApplicationArea = All;
                        }
                    }
                }
                group(SpotCashManageement)
                {
                    Caption = 'SpotCash';
                    group(SpotCashApplication)
                    {
                        Caption = 'Application';
                        action(NewSpotCashpplication)
                        {
                            Caption = 'New SpotCash Applications';
                            RunObject = page "SpotCash Application List";
                            ApplicationArea = All;
                        }
                        action(PendingSpotCashApplication)
                        {
                            Caption = 'Pending SpotCash Applications';
                            RunObject = page "Pending SPC Application List";
                            ApplicationArea = All;
                        }
                        action(ApprovedSpotCashApplication)
                        {
                            Caption = 'Approved SpotCash Applications';
                            RunObject = page "Approved SPC Application List";
                            ApplicationArea = All;
                        }
                        action(RejectedSpotCashApplication)
                        {
                            Caption = 'Rejected SpotCash Applications';
                            RunObject = page "Rejected SPC Application List";
                            ApplicationArea = All;
                        }
                    }
                    group(GrpSPotCashMember)
                    {
                        Caption = 'Members';
                        action(SPotCashMember)
                        {
                            Caption = 'SpotCash Members';
                            RunObject = page "SpotCash Members List";
                            ApplicationArea = All;
                        }
                    }
                    group(SpotCashActvation)
                    {
                        Caption = 'Activation/Deactivation';


                        action(NewSpotCashActivation)
                        {
                            Caption = 'New SpotCash Activation/Deactivation';
                            RunObject = page "SpotCash Activation List";
                            ApplicationArea = All;
                        }
                        action(PendingSpotCashActivation)
                        {
                            Caption = 'Pending SpotCash Activation/Deactivation';
                            RunObject = page "Pending SPC Activation List";
                            ApplicationArea = All;
                        }
                        action(ApprovedSpotCashActivation)
                        {
                            Caption = 'Approved SpotCash Activation/Deactivation';
                            RunObject = page "Approved SPC Activation List";
                            ApplicationArea = All;
                        }
                        action(RejectedSpotCashActivation)
                        {
                            Caption = 'Rejected SpotCash Activation/Deactivation';
                            RunObject = page "Rejected SPC Activation List";
                            ApplicationArea = All;
                        }
                    }
                    group(SPCLedgerEntries)
                    {
                        Caption = 'Ledger Entries';
                        action(SpotCashLedgerEntries)
                        {
                            Caption = 'SpotCash Ledger Entries';
                            RunObject = page "SpotCash Ledger Entries";
                            ApplicationArea = All;
                        }
                    }
                }
                group(ATMManagement)
                {
                    Caption = 'ATM Management';
                    group(ATMApplication)
                    {
                        Caption = 'ATM Application';
                        action(NewATMApplication)
                        {
                            Caption = 'New ATM Applications';
                            RunObject = page "ATM Application List";
                            ApplicationArea = All;
                        }
                        action(PendingATMApplication)
                        {
                            Caption = 'Pending ATM Applications';
                            RunObject = page "Pending ATM Application List";
                            ApplicationArea = All;
                        }
                        action(ApprovedATMApplication)
                        {
                            Caption = 'Approved ATM Applications';
                            RunObject = page "Approved ATM Application List";
                            ApplicationArea = All;
                        }
                        action(RejectedATMApplication)
                        {
                            Caption = 'Rejected ATM Applications';
                            RunObject = page "Rejected ATM Application List";
                            ApplicationArea = All;
                        }

                    }
                    group(ATMCollection)
                    {
                        Caption = 'ATM Collection';
                        action(NewATMCollection)
                        {
                            Caption = 'New ATM Collections';
                            RunObject = page "ATM Collection List";
                            ApplicationArea = All;
                        }
                        action(PendingATMCollection)
                        {
                            Caption = 'Pending ATM Collections';
                            RunObject = page "Pending ATM Collection List";
                            ApplicationArea = All;
                        }
                        action(ApprovedATMCollection)
                        {
                            Caption = 'Approved ATM Collections';
                            RunObject = page "Approved ATM Collection List";
                            ApplicationArea = All;
                        }
                        action(RejectedATMCollection)
                        {
                            Caption = 'Rejected ATM Collections';
                            RunObject = page "Rejected ATM Collection List";
                            ApplicationArea = All;
                        }

                    }
                    group(ATMMembers)
                    {
                        Caption = 'Members';
                        action("ATM Members")
                        {
                            RunObject = page "ATM Members List";
                            ApplicationArea = All;
                        }

                    }
                    group(ATMActivation)
                    {
                        Caption = 'ATM Activation';
                        action(NewATMActivation)
                        {
                            Caption = 'New ATM Activations';
                            RunObject = page "ATM Activation List";
                            ApplicationArea = All;
                        }
                        action(PendingATMActivation)
                        {
                            Caption = 'Pending ATM Activations';
                            RunObject = page "Pending ATM Activation List";
                            ApplicationArea = All;
                        }
                        action(ApprovedATMActivation)
                        {
                            Caption = 'Approved ATM Activations';
                            RunObject = page "Approved ATM Activation List";
                            ApplicationArea = All;
                        }
                        action(RejectedATMActivation)
                        {
                            Caption = 'Rejected ATM Activations';
                            RunObject = page "Rejected ATM Activation List";
                            ApplicationArea = All;
                        }

                    }

                    group(ATMLedgerEntries)
                    {
                        Caption = 'Ledger Entries';
                        action(ATMLedgerEntries2)
                        {
                            Caption = 'ATM Ledger Entries';
                            RunObject = page "ATM Ledger Entries";
                            ApplicationArea = All;
                        }
                    }
                }
                group(CTSManagement)
                {
                    Caption = 'CTS Management';
                    group(ChequeBooks)
                    {
                        Caption = 'Cheque Books';
                        action("New Cheque Books")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Cheque Book List";
                        }
                        action("Issued Cheque Books")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Issued Cheque Book List";
                        }
                    }
                    group(ChequeBookApplication)
                    {
                        Caption = 'Cheque Book Application';
                        action("New Cheque Book Appications")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Cheque Book Application List";
                        }
                        action("Pending Cheque Book Applications")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Pending CB Application List";
                        }
                        action("Approved Cheque Book Applications")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Approved CB Application List";
                        }
                        action("Rejected Cheque Book Applications")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Rejected CB Application List";
                        }
                    }
                    group(ChequeClearance)
                    {
                        Caption = 'Cheque Clearance';
                        action("New Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Cheq. Clearance List";
                        }
                        action("Pending Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Pending Cheq. Clearance List";
                        }
                        action("Approved Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Approved Cheq. Clearance List";
                        }
                        action("Rejected Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Rejected Cheq. Clearance List";
                        }
                        action("Posted Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Posted Cheq. Clearance List";
                        }

                    }
                    group(CTSSetup)
                    {
                        Caption = 'Setup';
                        action("CTS Setup")
                        {
                            ApplicationArea = All;
                            RunObject = Page "CTS Setup";
                        }
                        action("Cheque Reason Codes")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Cheq. Reason Codes";
                        }

                    }
                    group(CTSHistory)
                    {
                        Caption = 'History';
                        action("Pending CTS Entries")
                        {
                            ApplicationArea = All;
                            RunObject = Page "Pending CTS Entries";
                        }
                    }
                    group(CTSPeriodicActivities)
                    {
                        Caption = 'Periodic Activities';
                        action("Recover CTS Entries")
                        {
                            ApplicationArea = All;
                            RunObject = report "Recover CTS Entries";
                        }
                    }
                    group(CTSReports)
                    {
                        Caption = 'Reports';
                        action("Cheque Books")
                        {
                            ApplicationArea = All;
                            RunObject = report "Cheque Books";
                        }
                        action("Cheque Clearance")
                        {
                            ApplicationArea = All;
                            RunObject = report "Cheque Clearance";
                        }
                        action("CTS Entries")
                        {
                            ApplicationArea = All;
                            RunObject = report "CTS Entries";
                        }
                    }
                }
                group(Setup)
                {
                    action("Account Types")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Account Type List";

                    }
                    action("Teller Setup")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Teller Setup";

                    }
                    action("Teller General Setup")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Teller General Setup";

                    }
                    action("Treasury Accounts")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Treasury Accounts List";

                    }
                    action("Transaction Types")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Transaction Types List";

                    }
                    action("Supervisor Approvals Setup")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Supervisors Approval Amount";
                    }
                    action("Fixed Deposit Rate Setup")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Fixed Deposit Rate List";
                    }
                    action("Cheque Types")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Cheque Types";

                    }
                    action("Banks")
                    {
                        ApplicationArea = All;
                        RunObject = Page Banks;

                    }
                    action("Bank Branches")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Banks Branch";

                    }
                    action("Member Categories")
                    {
                        ApplicationArea = All;
                        RunObject = Page "Member Categories";

                    }
                    action(FOSAAgencies)
                    {
                        Caption = 'Agencies';
                        ApplicationArea = All;
                        RunObject = Page "Agency List";

                    }
                }
            }


            group("BOSA Management")
            {
                Caption = 'BOSA Management';
                Image = RegisteredDocs;
                group(LoanApplication)
                {
                    Caption = 'Loan Application';

                    action("New Application")
                    {
                        RunObject = Page "Loan Application List";
                        ApplicationArea = All;
                    }
                    action("Pending Appraisal")
                    {
                        RunObject = Page "Pending Loan Applications List";
                        ApplicationArea = All;
                    }
                    action("Pending Disbursal")
                    {
                        RunObject = Page "Pending Disbursal Loan List";
                        ApplicationArea = All;
                    }
                    action("Rejected Loans")
                    {
                        RunObject = Page "Rejected Loans List";
                        ApplicationArea = All;
                    }
                    action("Posted Loans")
                    {
                        RunObject = Page "Posted Loan List";
                        ApplicationArea = All;

                    }
                    group(LASetup)
                    {
                        Caption = 'Setup';
                        action("Loan Application Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Application Setup";
                        }
                    }
                }

                group(StandingOrders)
                {
                    Caption = 'Standing Orders';
                    action("New Standing Order")
                    {
                        RunObject = Page "Standing Order List";
                        ApplicationArea = All;
                    }
                    action("Pending Standing Order")
                    {
                        RunObject = Page "Pending Standing Order List";
                        ApplicationArea = All;
                    }
                    action("Approved Standing Order")
                    {
                        RunObject = Page "Approved Standing Order List";
                        ApplicationArea = All;
                    }
                    action("Rejected Standing Order")
                    {
                        RunObject = Page "Rejected Standing Order List";
                        ApplicationArea = All;
                    }
                    action("Running Standing Order")
                    {
                        RunObject = Page "Running Standing Order List";
                        ApplicationArea = All;
                    }
                    group(STOSetup)
                    {
                        Caption = 'Setup';
                        action("Standing Order Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Standing Order Setup";
                        }
                        action("STO Loan  Products")
                        {
                            ApplicationArea = All;
                            RunObject = page "STO Loan Products";
                        }
                    }
                }

                group(LoanClassification)
                {
                    Caption = 'Loan Classification';
                    action("Classification Entries")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Classification Entries";
                    }
                    action("Classification Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Classification Setup";
                    }
                    action("Generate Classification")
                    {
                        ApplicationArea = All;
                        RunObject = report "Generate Loan Classification";
                    }
                }
                group(FundTransfer)
                {
                    Caption = 'Fund Transfer';
                    action("New Fund Transfer")
                    {
                        ApplicationArea = All;
                        RunObject = page "Fund Transfer List";

                    }
                    action("Pending Fund Transfer")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Fund Transfer List";

                    }
                    action("Approved Fund Transfer")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Fund Transfer List";

                    }
                    action("Rejected Fund Transfer")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Fund Transfer List";

                    }
                    action("Posted Fund Transfer")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Fund Transfer List";

                    }
                    group(FTSetup)
                    {
                        Caption = 'Setup';
                        action("Fund Transfer Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Fund Transfer Setup";
                        }
                        action("FT Loan Products")
                        {
                            ApplicationArea = All;
                            RunObject = page "FT Loan Products";
                        }
                    }
                }
                group(LoanRescheduling)
                {
                    Caption = 'Loan Rescheduling';
                    action("New Loan Rescheduling")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Rescheduling List";
                    }
                    action("Pending Loan Rescheduling")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Loan Rescheduling List";
                    }
                    action("Approved Loan Rescheduling")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Loan Resched. List";
                    }
                    action("Rejected Loan Rescheduling")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Loan Resched. List";
                    }
                    group(LSSetup)
                    {
                        Caption = 'Setup';
                        action("Loan Rescheduling Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Rescheduling Setup";
                        }
                    }
                }
                group(GuarantorSubstitution)
                {
                    Caption = 'Guarantor Substitution';
                    action("New Guarantor Substitution")
                    {
                        ApplicationArea = All;
                        RunObject = page "Guarantor Substitution List";
                    }
                    action("Pending Guarantor Substitution")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Guarantor Sub. List";
                    }
                    action("Approved Guarantor Substitution")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Guarantor Sub. List";
                    }
                    action("Rejected Guarantor Substitution")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Guarantor Sub. List";
                    }
                    action("GuarantorSubstitutionEntries")
                    {
                        Caption = 'Guarantor Substitution Entries';
                        ApplicationArea = All;
                        RunObject = page "Guarantor Substitution Entries";
                    }
                }
                group(Payout)
                {
                    Caption = 'Payout Processing';
                    action("New Payout")
                    {
                        ApplicationArea = All;
                        RunObject = page "Payout List";
                    }
                    action("Pending Payout")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Payout List";
                    }
                    action("Approved Payout")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Payout List";
                    }
                    action("Rejected Payout")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Payout List";
                    }
                    action("Posted Payout")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Payout List";
                    }
                    group(PayoutSetup)
                    {
                        Caption = 'Setup';
                        action("Payout Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Payout Setup";
                        }
                        action("Payout Types")
                        {
                            ApplicationArea = All;
                            RunObject = page "Payout Types List";
                        }
                    }
                }
                group(LoanSelloff)
                {
                    Caption = 'Loan Selloff';
                    action("New Loan Selloff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Selloff List";
                    }
                    action("Pending Loan Selloff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Loan Selloff List";
                    }
                    action("Approved Loan Selloff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Loan Selloff List";
                    }
                    action("Rejected Loan Selloff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Loan Selloff List";
                    }
                    action("Posted Loan Selloff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Loan Selloff List";
                    }
                    group(LoanSelloffSetup)
                    {
                        Caption = 'Setup';
                        action("Loan Selloff Charges")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Selloff Charges";
                        }
                        action("Loan Selloff Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Selloff Setup";
                        }
                    }
                }
                group(LoanWriteofff)
                {
                    Caption = 'Loan Writeoff';
                    action("New Loan Writeofff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Writeoff List";
                    }
                    action("Pending Loan Writeoff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Loan Writeoff List";
                    }
                    action("Approved Loan Writeoff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Loan Writeoff List";
                    }
                    action("Rejected Loan Writeoff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Rejected Loan Writeoff List";
                    }
                    action("Posted Loan Writeoff")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Loan Writeoff List";
                    }
                    group(LWSetup)
                    {
                        Caption = 'Setup';
                        action("Loan Writeoff Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Writeoff Setup";
                        }
                    }
                }
                group(Remittance)
                {
                    Caption = 'Remittance Processing';
                    action("Member Advice")
                    {
                        ApplicationArea = All;
                        RunObject = page "Member Remittance Advice List";
                    }
                    action("Agency Advice")
                    {
                        ApplicationArea = All;
                        RunObject = page "Agency Remittance Advice List";
                    }
                    action("Generate Member Advice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Generate Member Advice";
                    }
                    action("Generate Agency Advice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Generate Agency Advice";
                    }
                    group(RemittanceSetup)
                    {
                        Caption = 'Setup';
                        action("Remittance Codes")
                        {
                            ApplicationArea = All;
                            RunObject = page "Remittance Codes";
                        }
                        action("Remittance Periods")
                        {
                            ApplicationArea = All;
                            RunObject = page "Remittance Periods";
                        }
                        action("Remittance Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Remittance Setup";
                        }
                        action("Agencies")
                        {
                            ApplicationArea = All;
                            RunObject = page "Agency List";
                        }
                    }
                }
                group(ExitManagement)
                {
                    Caption = 'Exit Management';
                    group(ExitProcessing)
                    {
                        Caption = 'Exit Processing';
                        action("New Member Exit")
                        {
                            ApplicationArea = All;
                            RunObject = page "Member Exit List";

                        }
                        action("Pending Member Exit")
                        {
                            ApplicationArea = All;
                            RunObject = page "Pending Member Exit List";

                        }
                        action("Approved Member Exit")
                        {
                            ApplicationArea = All;
                            RunObject = page "Approved Member Exit List";

                        }
                        action("Rejected Member Exit")
                        {
                            ApplicationArea = All;
                            RunObject = page "Rejected Member Exit List";

                        }
                    }
                    group(RefundProcessing)
                    {
                        Caption = 'Refund Processing';
                        action("New Member Refund")
                        {
                            ApplicationArea = All;
                            RunObject = page "Member Refund List";

                        }
                        action("Pending Member Refund")
                        {
                            ApplicationArea = All;
                            RunObject = page "Pending Member Refund List";

                        }
                        action("Approved Member Refund")
                        {
                            ApplicationArea = All;
                            RunObject = page "Approved Member Refund List";

                        }
                        action("Posted Member Refund")
                        {
                            ApplicationArea = All;
                            RunObject = page "Posted Member Refund List";

                        }

                    }
                    group(ClaimProcessing)
                    {
                        Caption = 'Claim Processing';
                        action("New Member Claim")
                        {
                            ApplicationArea = All;
                            RunObject = page "Member Claim List";

                        }
                        action("Pending Member Claim")
                        {
                            ApplicationArea = All;
                            RunObject = page "Pending Member Claim List";

                        }
                        action("Approved Member Claim")
                        {
                            ApplicationArea = All;
                            RunObject = page "Approved Member Claim List";

                        }
                        action("Posted Member Claim")
                        {
                            ApplicationArea = All;
                            RunObject = page "Posted Member Claim List";

                        }

                    }
                    group(ExitSetup)
                    {
                        Caption = 'Setup';
                        action("Exit Fees")
                        {
                            ApplicationArea = All;
                            RunObject = page "Exit Fees";
                        }
                        action("Exit Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Exit Setup";
                        }
                    }
                }
                group(DividendProcessing)
                {
                    Caption = 'Dividend Processing';
                    action("New Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Dividend List";
                    }
                    action("Pending Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Pending Dividend List";
                    }
                    action("Approved Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Approved Dividend List";
                    }
                    action("Posted Dividend")
                    {
                        ApplicationArea = All;
                        RunObject = page "Posted Dividend List";
                    }
                    group(DividendSetup)
                    {
                        Caption = 'Setup';
                        action("Dividend Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Dividend Setup";
                        }
                        action("Dividend Loan Products")
                        {
                            ApplicationArea = All;
                            RunObject = page "Dividend Loan Products";
                        }
                    }
                }
                group(DefaultManagement)
                {
                    Caption = 'Default Management';
                    action("Default Loan Entries")
                    {
                        ApplicationArea = All;
                        RunObject = page "Defaulted Loan Entries";
                    }
                    action("Generate Defaulted Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Generate Defaulted Loans";
                    }
                    action("Send Default Notice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Send Default Notice";
                    }
                    action("Attach Loan to Guarantor")
                    {
                        ApplicationArea = All;
                        RunObject = report "Attach Loan to Guarantor";
                    }
                    action("Reverse Attached Loan")
                    {
                        ApplicationArea = All;
                        RunObject = report "Reverse Attached Loan";
                    }
                    group(LoanDefaultSetup)
                    {
                        Caption = 'Setup';
                        action("Loan Default Setup")
                        {
                            ApplicationArea = All;
                            RunObject = page "Loan Default Setup";
                        }
                    }
                }
                group(PeriodicActivities)
                {
                    Caption = 'Periodic Activities';
                    action("Capitalize Interest")
                    {
                        ApplicationArea = All;
                        RunObject = report "Capitalize Interest";
                    }
                    action("Run Standing Order")
                    {
                        ApplicationArea = All;
                        RunObject = report "Run Standing Order";
                    }
                    action("Run Loan Recovery")
                    {
                        ApplicationArea = All;
                        RunObject = report "Run Loan Recovery";
                    }
                }
                group(Notification)
                {
                    action("SMS Entries")
                    {
                        ApplicationArea = All;
                        RunObject = page "SMS Entries";
                    }
                }
                group(BOSAReports)
                {
                    Caption = 'Reports';
                    action("Loan Repayment Schedule")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Repament Schedule";
                    }
                    action("Branch Performance")
                    {
                        ApplicationArea = All;
                        RunObject = report "Branch Performance";
                    }
                    action("Branch Portfolio")
                    {
                        ApplicationArea = All;
                        RunObject = report "Branch Portfolio Report";
                    }
                    action("Loan Securities")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Securities";
                    }
                    action("Loan Provisioning")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Provisioning Report";
                    }
                    action("Loan Classification")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Classification Report";
                    }
                    action("Disbursed Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Disbursed Loans";
                    }
                    action("Defaulted Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Defaulters";
                    }
                    action("Classification Summary")
                    {
                        ApplicationArea = All;
                        RunObject = report "Classification Summary";
                    }
                    action("Classification Summary-Per Branch")
                    {
                        ApplicationArea = All;
                        RunObject = report "Classification Summary- Branch";
                    }
                    action("Loan Arrears")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Arrears";
                    }
                    action("NWDs vs Loan Book")
                    {
                        ApplicationArea = All;
                        RunObject = report "NWDs vs Loan Book";
                    }
                    action("Loan Status")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Status";
                    }
                    action("Loan Statement")
                    {
                        ApplicationArea = All;
                        RunObject = report "Member Loan Statement";
                    }
                    action("Member Statement")
                    {
                        ApplicationArea = All;
                        RunObject = report "Member Statement";
                    }
                    action("Loan Movement")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Movement";
                    }
                    action("G/L vs MPA per Branch")
                    {
                        ApplicationArea = All;
                        RunObject = report "G/L vs MPA By Branch";
                    }
                    action("G/L vs MPA per Product")
                    {
                        ApplicationArea = All;
                        RunObject = report "G/L vs MPA By Product";
                    }
                    action("Loan Securities2")
                    {
                        ApplicationArea = All;
                        RunObject = report "Loan Securities";
                    }
                    action("CRB Report")
                    {
                        ApplicationArea = All;
                        RunObject = report "CRB Report";
                    }
                    action("Demand Letter")
                    {
                        ApplicationArea = All;
                        RunObject = report "Demand Letter";
                    }
                    action("Account Types Listing")
                    {
                        ApplicationArea = All;
                        RunObject = report "Account Types Listing";
                    }
                    action("Share Certificate")
                    {
                        ApplicationArea = All;
                        RunObject = report "Share Certificate";
                    }
                    action("Product Matrix")
                    {
                        ApplicationArea = All;
                        RunObject = report "Products Matrix";
                    }
                    action("Yield Analysis")
                    {
                        ApplicationArea = All;
                        RunObject = report "Yield Analysis";
                    }
                    action("Accounts Movement")
                    {
                        ApplicationArea = All;
                        RunObject = report "Accounts Movement";
                    }
                    action("Rescheduled Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Rescheduled Loans";
                    }
                    action("Sold Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Sold Loans";
                    }
                    action("Guarantor Substitution Entries")
                    {
                        ApplicationArea = All;
                        RunObject = report "Guarantor Substitution Entries";
                    }
                    action("Standing Orders")
                    {
                        ApplicationArea = All;
                        RunObject = report "Standing Orders";
                    }
                    action("Payout Report")
                    {
                        ApplicationArea = All;
                        RunObject = report "Payout Report";
                    }
                    action("Dividend Report")
                    {
                        ApplicationArea = All;
                        RunObject = report "Dividends Report";
                    }
                    action("Member Remittance Advice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Member Remittance Advice";
                    }
                    action("Agency Remittance Advice")
                    {
                        ApplicationArea = All;
                        RunObject = report "Agency Remittance Advice";
                    }
                    action("Member Refunds")
                    {
                        ApplicationArea = All;
                        RunObject = report "Member Refund";
                    }
                    action("Exit Requests")
                    {
                        ApplicationArea = All;
                        RunObject = report "Exit Request";
                    }
                    action("Member Claims")
                    {
                        ApplicationArea = All;
                        RunObject = report "Member Claim";
                    }
                    action("Written off Loans")
                    {
                        ApplicationArea = All;
                        RunObject = report "Written off Loans";
                    }
                    action("Members & Accounts Summary per Branch")
                    {
                        ApplicationArea = All;
                        RunObject = report "Members & Accounts Summary";
                    }

                }
                group(BOSASetup)
                {
                    Caption = 'Setup';
                    action("CBS Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "CBS Setup";
                    }
                    action("Loan Product Types")
                    {
                        ApplicationArea = All;
                        RunObject = page "Loan Product Type List";
                    }
                    action("Source Codes")
                    {
                        ApplicationArea = All;
                        RunObject = page "Source Code List";
                    }
                    action("Source Code Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Source Code Setup";
                    }

                }

            }
            group("MicroCredit Management")
            {
                group(GroupAttendance)
                {
                    Caption = 'Group Attendance';
                    action(NewGroupAttenance)
                    {
                        Caption = 'New Group Attendance';
                        RunObject = Page "Group Attendance List";
                        ApplicationArea = All;

                    }
                    action(ValidatedGroupAttenance)
                    {
                        Caption = 'Validated Group Attendance';
                        RunObject = Page "Validated Grp Attendance List";
                        ApplicationArea = All;

                    }
                }
                group(GroupCollection)
                {
                    Caption = 'Group Collection';
                    action(GroupCollectionEntry)
                    {
                        Caption = 'Group Collection Entries';
                        RunObject = Page "Group Collection Entries";
                        ApplicationArea = All;

                    }
                }

                group(GroupAllocation)
                {
                    Caption = 'Group Allocation';
                    action(NewGroupAllocation)
                    {
                        Caption = 'New Group Allocations';
                        RunObject = Page "Group Allocations List";
                        ApplicationArea = All;

                    }
                    action(PendingGroupAllocation)
                    {
                        Caption = 'Pending Group Allocations';
                        RunObject = Page "Pending GP Allocations List";
                        ApplicationArea = All;

                    }
                    action(ApprovedGroupAllocation)
                    {
                        Caption = 'Approved Group Allocations';
                        RunObject = Page "Approved GP Allocations List";
                        ApplicationArea = All;

                    }
                    action(RejectedGroupAllocation)
                    {
                        Caption = 'Rejected Group Allocations';
                        RunObject = Page "Rejected GP Allocations List";
                        ApplicationArea = All;

                    }
                    action(PostedGroupAllocation)
                    {
                        Caption = 'Posted Group Allocations';
                        RunObject = Page "Posted GP Allocations List";
                        ApplicationArea = All;

                    }
                }
                group(PortfolioTransfer)
                {
                    Caption = 'Portfolio Transfer';
                    action(NewPortfolioTransfer)
                    {
                        Caption = 'New Portfolio Transfer';
                        RunObject = Page "Portfolio Transfer List";
                        ApplicationArea = All;

                    }
                    action(PendingPortfolioTransfer)
                    {
                        Caption = 'Pending Portfolio Transfer';
                        RunObject = Page "Pending Portfolio Transfer";
                        ApplicationArea = All;

                    }
                    action(ApprovedPortfolioTransfer)
                    {
                        Caption = 'Approved Portfolio Transfer';
                        RunObject = Page "Approved Portfolio Transfer";
                        ApplicationArea = All;

                    }
                    action(RejectedPortfolioTransfer)
                    {
                        Caption = 'Rejected Portfolio Transfer';
                        RunObject = Page "Rejected Portfolio Transfer";
                        ApplicationArea = All;

                    }
                    group(History)
                    {
                        action(PortfolioTransferEntry)
                        {
                            Caption = 'Portfolio Transfer Entries';
                            RunObject = Page "Portfolio Transfer Entries";
                            ApplicationArea = All;

                        }
                    }
                }
            }
            group("HR Management")
            {
                group("Employee Management")
                {
                    action("Employee List")
                    {
                        RunObject = page "Employee List";
                        ApplicationArea = all;

                    }
                    action("Employee Relatives")
                    {
                        RunObject = page "Employee Relatives";
                        ApplicationArea = all;
                    }
                    group("Employee Reports")
                    {
                        action("Employee Report")
                        {
                            RunObject = report "Employee Report";
                            ApplicationArea = all;
                        }
                        action("Report Per Employee")
                        {
                            RunObject = report "Report Per Employee";
                            ApplicationArea = all;
                        }
                    }
                }
                group("Probation Management")
                {
                    action("Employees On Probation")
                    {
                        RunObject = page "Employees On Probation";
                        ApplicationArea = all;

                    }
                    action("Employees Due For Confirmation")
                    {
                        RunObject = page "Employees Due For Confirmation";
                        ApplicationArea = all;
                    }

                    action("Confirmed Employees")
                    {
                        RunObject = page "Confirmed Employees";
                        ApplicationArea = all;
                    }
                    group("Probation Reports")
                    {
                        action("Reference Check Report")
                        {
                            RunObject = report "Reference Check Report";
                            ApplicationArea = all;
                        }
                        action("Confirmed Employee Report")
                        {
                            RunObject = report "Confirmed Employee Report";
                            ApplicationArea = all;
                        }
                    }
                }
                group("Leave Management")
                {
                    group("Leave Applications")
                    {
                        action("Leave Application List")
                        {
                            RunObject = Page "Leave Application List";
                            ApplicationArea = all;
                        }
                        action("Leave Application Pending Approval")
                        {
                            RunObject = page "Leave App. Pending Approval";
                            ApplicationArea = all;
                        }
                        action("Approved Leave")
                        {
                            RunObject = Page "Approved Leave Application";
                            ApplicationArea = all;
                        }
                        action("Rejected Leave")
                        {
                            RunObject = Page "Rejected  Leave Application";
                            ApplicationArea = all;
                        }
                        action("Leave Ledger Entry")
                        {
                            RunObject = page "Leave Ledger Entry";
                            ApplicationArea = all;
                        }
                    }
                    group("Employee Leave Plan")
                    {
                        action("Create Leave Plan")
                        {
                            RunObject = Page "Employee Leave Plan List";
                            ApplicationArea = all;
                        }
                        action("Submitted Leave Plan")
                        {
                            RunObject = page "Submitted Leave Plan";
                            ApplicationArea = all;
                        }

                    }
                    group("Leave Recalls")
                    {
                        action("Leave Recall")
                        {
                            RunObject = Page "Leave Recalls List";
                            ApplicationArea = all;
                        }
                        action("Submitted Leave Recall")
                        {
                            RunObject = page "Submitted Leave Recalls";
                            ApplicationArea = all;
                        }

                    }

                    group("Leave Reports")
                    {
                        action("Leave Balance Report")
                        {
                            RunObject = report "Leave Balance";
                            ApplicationArea = all;
                        }

                        action("Leave Balance Quarterly")
                        {
                            RunObject = report "Leave Balance Quarterly";
                            ApplicationArea = all;
                        }

                        action("Leave Recall Report")
                        {
                            RunObject = report "Leave Recall Report";
                            ApplicationArea = all;
                        }

                        action("Leave Calender Plan Report")
                        {
                            RunObject = report "Leave Calendar Plan";
                            ApplicationArea = all;
                        }

                        action("Leave Utilization Report")
                        {
                            RunObject = report "Leave Utilization Report";
                            ApplicationArea = all;
                        }

                    }
                }

                group("Staff Movements")
                {
                    action("Staff Movement")
                    {
                        RunObject = page "Employee Movement List";
                        ApplicationArea = all;
                    }
                    action("Posted Staff Movement")
                    {
                        RunObject = page "Posted Employee Movement";
                        ApplicationArea = all;
                    }
                    group("Staff Movement Reports")
                    {
                        action("Staff Posting")
                        {
                            RunObject = report "Staff Postings";
                            ApplicationArea = all;
                        }
                        action("Staff Transfer")
                        {
                            RunObject = report "Staff Transfers";
                            ApplicationArea = all;
                        }
                        action("Staff Promotions")
                        {
                            RunObject = report "Staff Promotions";
                            ApplicationArea = all;
                        }

                    }
                }
                group("Job Management")
                {
                    action("Job List")
                    {
                        RunObject = page "Position List";
                        ApplicationArea = all;
                    }

                    action("Job Report")
                    {
                        RunObject = report Positions;
                        ApplicationArea = all;
                    }
                    action("Job Description")
                    {
                        RunObject = report "Job Description";
                        ApplicationArea = all;
                    }
                }
                group("Training Management")
                {
                    group("Training Requests")
                    {
                        action("Employee Training Requests")
                        {
                            RunObject = page "Training Request List";
                            ApplicationArea = all;
                        }
                        action("Submitted Training Requests")
                        {
                            RunObject = page "Submitted Training Requests";
                            ApplicationArea = all;
                        }
                        action("Training Calendar")
                        {
                            RunObject = page "Training Calendar";
                            ApplicationArea = all;
                        }
                        action("Training Requests Pending Approval")
                        {
                            RunObject = page "Training Req. Pending Approval";
                            ApplicationArea = all;
                        }
                        action("Approved Training Requests")
                        {
                            RunObject = page "Approved Training Requests";
                            ApplicationArea = all;
                        }
                    }
                    group("Training Evaluation")
                    {
                        action("Employee Training Evaluation")
                        {
                            RunObject = page "Employee Training Eval. List";
                            ApplicationArea = all;
                        }
                        action("Submitted Training Evaluation")
                        {
                            RunObject = page "Submitted Employee Eval.";
                            ApplicationArea = all;
                        }
                    }
                    group("Training Reports")
                    {
                        action("Training Needs Report")
                        {
                            RunObject = report "Training Needs";
                            ApplicationArea = all;
                        }
                        action("Staff Trained Report")
                        {
                            RunObject = report "Staff Trained";
                            ApplicationArea = all;
                        }
                        action("Employee Training Report")
                        {
                            RunObject = report "Employee Training Report";
                            ApplicationArea = all;
                        }
                        action("Monthly Staff Training Report")
                        {
                            RunObject = report "Monthly Staff Training Report";
                            ApplicationArea = all;
                        }
                        action("Annual Staff Training Report")
                        {
                            RunObject = report "Annual Staff Training Report";
                            ApplicationArea = all;
                        }
                    }
                }
                group("Separation Management")
                {
                    action("Separation Application")
                    {
                        RunObject = page "Separation List";
                        ApplicationArea = all;
                    }
                    action("Processed Separations")
                    {
                        RunObject = page "Approved Separation List";
                        ApplicationArea = all;
                    }
                    action("Separation Types Setup")
                    {
                        RunObject = page "Separation Type Setup";
                        ApplicationArea = all;
                    }
                }
                group("Recruitment & Selection")
                {
                    group("Recruitement Request")
                    {
                        action("Recruitment Request")
                        {
                            RunObject = page "Recruitment List";
                            ApplicationArea = all;
                        }
                        action("Recruitment Request Pending Approval")
                        {
                            RunObject = page "Recruitment Pending Approval";
                            ApplicationArea = all;
                        }
                        action("Recruitment Request Approved")
                        {
                            RunObject = page RecruitmentApproved;
                            ApplicationArea = all;
                        }
                        action("Recruitment Request Rejected")
                        {
                            RunObject = page "Recruitment Rejected";
                            ApplicationArea = all;
                        }
                    }
                    group("Job Applications")
                    {
                        action("Job Application List")
                        {
                            RunObject = page "Job Application List";
                            ApplicationArea = all;
                        }
                        action("Shortlisted Job Applications")
                        {
                            RunObject = page "Short Listed Job Application";
                            ApplicationArea = all;
                        }
                        action("Recruitment Report")
                        {
                            RunObject = report "Recruitment Report";
                            ApplicationArea = all;
                        }
                    }
                }
                group("Performance Management")
                {
                    action("Performance Competency")
                    {
                        RunObject = page "Performance Competency";
                        ApplicationArea = all;
                    }
                    action("Job Competency")
                    {
                        RunObject = page "Job Competency List";
                        ApplicationArea = all;
                    }
                    action("Performance Review")
                    {
                        RunObject = page "Performance Review List";
                        ApplicationArea = all;
                    }
                    action("Appraiser's Review List")
                    {
                        RunObject = page "Appraiser's Review List";
                        ApplicationArea = all;
                    }
                    action("Performance Review HR")
                    {
                        RunObject = page "Performance Review HR List";
                        ApplicationArea = all;
                    }
                }
                group("Disciplinary Management")
                {
                    action("Disciplinary Cases")
                    {
                        RunObject = page "Disciplinary Case List";
                        ApplicationArea = all;
                    }

                    action("Current Cases")
                    {
                        RunObject = page "Current Cases";
                        ApplicationArea = all;
                    }

                    action("Legal Cases")
                    {
                        RunObject = page "Legal Cases";
                        ApplicationArea = all;
                    }

                    action("Closed Cases")
                    {
                        RunObject = page "Closed Cases";
                        ApplicationArea = all;
                    }
                    action("Appealed Cases")
                    {
                        RunObject = page "Appealed Cases";
                        ApplicationArea = all;
                    }
                }
                /*    group(Audit)
                    {
                        group("HR Audit")
                        {
                            action("Employee Data Change Request")
                            {
                                RunObject = page "Employee Data Change Request";
                              //  ApplicationArea = all;
                            }
                            action("Employee Data View")
                            {
                                RunObject = page "Employee Data View List";
                                ApplicationArea = all;
                            }
                            action("Employee Data Changes")
                            {
                                RunObject = page "Employee Data Changes";
                                ApplicationArea = all;
                            }
                        }
                        group("Audit Reports")
                        {
                            action("Employee Data Change Report")
                            {
                                RunObject = report "Employee Data Change Report";
                                ApplicationArea = all;
                            }
                        }
                        action("Employee Data Changes Approval")
                        {
                            RunObject = report "Employee Data Changes Approval";
                            ApplicationArea = all;
                        }
                    }*/
                group("HR Documents")
                {
                    action("Documents")
                    {
                        RunObject = page "Human Resource Doc";
                        ApplicationArea = all;
                    }
                    group("HR Reports")
                    {
                        action("HR Uploaded Documents")
                        {
                            RunObject = report "HR Documents Report";
                            ApplicationArea = all;
                        }
                        action("HR Documents View")
                        {
                            RunObject = report "HR Documents View";
                            ApplicationArea = all;
                        }
                    }
                }
                group(Setups)
                {
                    action("Human Resources Setup")
                    {
                        RunObject = page "Human Resources Setup";
                        ApplicationArea = all;
                    }
                    action("Leave Types Setup")
                    {
                        RunObject = page "Leave Types";
                        ApplicationArea = all;
                    }
                    action("Training Evaluation Question")
                    {
                        RunObject = page "Select Evaluation Questions";
                        ApplicationArea = all;
                    }

                }

            }
            group("Payroll Management")
            {
            }
            group("File Managemtnt")
            {
            }
        }
        area(Embedding)
        {
            action(Members)
            {
                Caption = 'Members';
                RunObject = Page "Member List";
                ApplicationArea = All;

            }
            action(MembersSDAccounts)
            {
                Caption = 'Savings Accounts';
                RunObject = Page "Member S/Dep. Account List";
                ApplicationArea = All;

            }
            action(MemberLoanAccount)
            {
                Caption = 'Loan Accounts';
                RunObject = Page "Member Loan Account List";
                ApplicationArea = All;

            }
            action(AccountTypes)
            {
                Caption = 'Account Types';
                RunObject = Page "Account Type List";
                ApplicationArea = All;

            }
            action(LoanProductTypes)
            {
                Caption = 'Loan Product Types';
                RunObject = Page "Loan Product Type List";
                ApplicationArea = All;
            }
            action(CBSSetup)
            {
                Caption = 'CBS Setup';
                RunObject = Page "CBS Setup";
                ApplicationArea = All;
            }
            action(LoanOfficerSetup)
            {
                Caption = 'Loan Officer Setup';
                RunObject = Page "Loan Officer Setup";
                ApplicationArea = All;
            }

        }
        area(Processing)
        {
            group(PeriodActivities)
            {
                Caption = 'Periodic Activities';
                action(CapitalizeInterest)
                {
                    Caption = 'Capitalize Interest';
                    RunObject = report "Capitalize Interest";
                    ApplicationArea = All;
                }
                action(RunStaningOrder)
                {
                    Caption = 'Run Standing Order';
                    RunObject = report "Run Standing Order";
                    ApplicationArea = All;
                }
                action(RunLoanRecovery)
                {
                    Caption = 'Run Loan Recovery';
                    RunObject = report "Run Loan Recovery";
                    ApplicationArea = All;
                }
            }
            group(Reports)
            {
                action(LoanSecurities2)
                {
                    Caption = 'Loan Securities';
                    Image = "Report";
                    RunObject = Report "Loan Securities";
                    ApplicationArea = All;
                }
                action(BranchPortfolio2)
                {
                    Caption = 'Branch Portfolio';
                    Image = "Report";
                    RunObject = Report "Branch Portfolio Report";
                    ApplicationArea = All;
                }
            }
        }
        area(Creation)
        {
            action(NewMemberApplication)
            {
                Caption = 'New Member Application';
                Image = NewInvoice;
                RunObject = Page "Member Application Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanApplication)
            {
                Caption = 'New Loan Application';
                RunObject = page "Loan Application Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewStandingOrder)
            {
                Caption = 'New Standing Order';
                RunObject = page "Standing Order Card";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewFundTransfer)
            {
                Caption = 'New Fund Transfer';
                RunObject = page "Fund Transfer";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanRescheduling)
            {
                Caption = 'New Loan Rescheduling';
                RunObject = page "Loan Rescheduling";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewPayout)
            {
                Caption = 'New Payout';
                RunObject = page Payout;
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewDividend)
            {
                Caption = 'New Dividend';
                RunObject = page Dividend;
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewGuarantorSubstitution)
            {
                Caption = 'New Guarantor Substitution';
                RunObject = page "Guarantor Substitution";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanSelloff)
            {
                Caption = 'New Loan Selloff';
                RunObject = page "Loan Selloff";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewLoanWriteoff)
            {
                Caption = 'New Loan Writeoff';
                RunObject = page "Loan Writeoff";
                RunPageMode = Create;
                ApplicationArea = All;
            }
            action(NewExitRequest)
            {
                Caption = 'New Exit Request';
                RunObject = page "Member Exit";
                RunPageMode = Create;
                ApplicationArea = All;
            }
        }
        area(Reporting)
        {
            action(LoanSecurities)
            {
                Caption = 'Loan Securities';
                Image = "Report";
                RunObject = Report "Loan Securities";
                ApplicationArea = All;
            }
            action(BranchPortfolio)
            {
                Caption = 'Branch Portfolio';
                Image = "Report";
                RunObject = Report "Branch Portfolio Report";
                ApplicationArea = All;
            }
        }
    }




}
// Creates a profile that uses the Role Center
profile BOSAProfile
{
    ProfileDescription = 'BOSA Profile';
    RoleCenter = "BOSA RoleCenter";
    Caption = 'BOSA';
}

