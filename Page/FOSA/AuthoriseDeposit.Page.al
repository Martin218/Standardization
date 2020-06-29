page 50064 "Authorise Deposit"
{
    // version TL2.0

    PageType = List;
    SourceTable = Transaction;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Authorised; Authorised)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Cashier; Cashier)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Checked By"; "Checked By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Bio data")
            {
                Image = Account;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
            }
            action("Print Statement")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Print No-Charge Statement';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'View a detail trial balance for selected vendors.';
            }
            action(Process)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin

                    IF CONFIRM('Are you sure you want to process the selected transactions?', FALSE) = TRUE THEN BEGIN

                        Transactions.RESET;
                        Transactions.SETRANGE(Transactions."Transaction Category", 'CASH TRANSACTIONS');
                        //Transactions.SETRANGE(Transactions.Select,TRUE);
                        Transactions.SETRANGE(Transactions."Supervisor Checked", FALSE);
                        Transactions.SETRANGE(Transactions."Needs Approval", Transactions."Needs Approval"::Yes);

                        IF Transactions.FIND('-') THEN
                            REPEAT

                                //AUTHORISE DEPOSITS
                                IF Transactions.Authorised <> Transactions.Authorised::No THEN BEGIN


                                    SupervisorApprovals.RESET;

                                    SupervisorApprovals.SETRANGE(SupervisorApprovals.SupervisorID, USERID);
                                    SupervisorApprovals.SETRANGE(SupervisorApprovals."Transaction Type", SupervisorApprovals."Transaction Type"::"Cash Deposits");
                                    IF SupervisorApprovals.FIND('-') THEN BEGIN
                                        IF Transactions.Amount > SupervisorApprovals."Maximum Approval Amount" THEN
                                            ERROR('You cannot approve the deposit because it is above your approval limit.');

                                    END
                                    ELSE BEGIN
                                        ERROR('You are not authorised to approve the selected deposits.');
                                    END;




                                    Transactions."Supervisor Checked" := TRUE;
                                    Transactions.Authorised := Transactions.Authorised::Yes;
                                    //Transactions."Status Date":=TODAY;
                                    //Transactions."Status Time":=TIME;
                                    Transactions."Checked By" := USERID;
                                    Transactions.MODIFY;
                                END;

                            UNTIL Transactions.NEXT = 0;

                        MESSAGE('The selected transactions have been processed.');

                    END;
                    //Reject Deposits
                    IF Transactions.Authorised <> Transactions.Authorised::Rejected THEN BEGIN


                        SupervisorApprovals.RESET;

                        SupervisorApprovals.SETRANGE(SupervisorApprovals.SupervisorID, USERID);
                        SupervisorApprovals.SETRANGE(SupervisorApprovals."Transaction Type", SupervisorApprovals."Transaction Type"::"Cash Deposits");
                    END;

                    Transactions."Supervisor Checked" := TRUE;
                    Transactions.Authorised := Transactions.Authorised::Rejected;
                    //Transactions."Status Date":=TODAY;
                    //Transactions."Status Time":=TIME;
                    Transactions."Checked By" := USERID;
                    Transactions.MODIFY;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ok := SupervisorsApprovalAmounts.GET(USERID, SupervisorsApprovalAmounts."Transaction Type"::"Cash Deposits");
        IF NOT ok THEN
            ERROR('The User %1 is Not set up as an approver for Cash Deposits', USERID)
        ELSE BEGIN
            IF NOT SupervisorsApprovalAmounts."Global Administrator" THEN BEGIN
                FILTERGROUP(2);
                SETFILTER("Global Dimension 1 Code", '=%1', SupervisorsApprovalAmounts.Branch);
                FILTERGROUP(0);
            END;
        END;
    end;

    var

        ChequeType: Record "Cheque Type";
        Transactions: Record "transaction";
        AccountAmount: Decimal;
        SupervisorApprovals: Record "Supervisor Approval Amount";
        TextAmount: Text[30];
        SupervisorsApprovalAmounts: Record "Supervisor Approval Amount";
        ok: Boolean;
        Acc: Record Vendor;
        Customer: Record Customer;
}

