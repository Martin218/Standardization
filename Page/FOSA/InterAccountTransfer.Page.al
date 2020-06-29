page 50096 "Inter Account Transfer"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,4,5,6,7,Approval Request';
    SourceTable = Transaction;
    SourceTableView = WHERE(Posted = FILTER(false),
                            Cancelled = FILTER(false));
    // "Transaction Type" = FILTER("INTER ACCOUNT"));

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Withdrawal';
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    TableRelation = "Transaction -Type" WHERE("Deduct Excise Duty" = FILTER(true));
                }
                field("Account No."; "Account No.")
                {

                    trigger OnValidate()
                    begin
                        CalcAvailableBalance;
                    end;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field(DestinationType; DestinationType)
                {
                    ApplicationArea = All;
                }
                field("Destination Account No"; "Destination Account No")
                {
                    Visible = DestinationType = DestinationType::Single;
                }
                field("Destination Account Name"; "Destination Account Name")
                {
                    Visible = DestinationType = DestinationType::Single;
                }
                field("Destination Payee"; "Destination Payee")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {

                    trigger OnValidate()
                    begin

                        CalcAvailableBalance;
                    end;
                }
                // field("Transaction Description"; "Transaction Description")
                // {
                // }
                field("Transaction Date"; "Transaction Date")
                {
                    Editable = false;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Cashier)
                {
                    Editable = false;
                }
                field("Member Name"; "Member Name")
                {
                    Caption = 'Member';
                    Editable = false;
                }
                field("Book Balance"; "Book Balance")
                {
                    Editable = false;
                }
                field(AvailableBalance; AvailableBalance)
                {
                    Caption = 'Available Balance';
                    Editable = false;
                }
                field("Minimum Account Balance"; "Minimum Account Balance")
                {
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "MA Picture")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
            }
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    /*IF ApprovalsMgmt.CheckAccountTransferApprovalPossible(Rec) THEN
                      ApprovalsMgmt.OnSendAccountTransferForApproval(Rec);*/

                    // IF ApprovalsMgmt.CheckTellerTransactionApprovalPossible(Rec) THEN
                    //     ApprovalsMgmt.OnSendTellerTransactionForApproval(Rec);

                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    // ApprovalsMgmt.OnCancelAccountTransferForApproval(Rec);
                    // WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin


        LoanGuaranteed := 0;
        UnClearedBalance := 0;
        TotalGuaranted := 0;


        IF "Account No." <> '' THEN BEGIN

        END;


        CalcAvailableBalance;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin

        LoanGuaranteed := 0;
        UnClearedBalance := 0;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := 'INTER ACCOUNT';
        DestinationType := DestinationType::Single;
    end;

    var
        LoanBalance: Decimal;
        AvailableBalance: Decimal;
        UnClearedBalance: Decimal;
        LoanSecurity: Decimal;
        LoanGuaranteed: Decimal;

        TellerSetup: Record "Teller Setup";
        TransactionCoinage: Record "Treasury Coinage";
        TransactionTypes: Record "Transaction -Type";
        TransactionCharges: Record "Transaction Charge";
        TCharges: Decimal;
        LineNo: Integer;
        AccountTypes: Record "Account Type";
        GenLedgerSetup: Record "General Ledger Setup";
        MinAccBal: Decimal;
        FeeBelowMinBal: Decimal;
        AccountNo: Code[30];
        AccountOpening: Record "Account Opening";
        NewAccount: Boolean;
        TreasuryTellerSetup: Record "Teller General Setup";
        CurrentTellerAmount: Decimal;
        TellerTill: Record "Bank Account";
        TellerTiedTill: Record "Teller Setup";
        IntervalPenalty: Decimal;
        AccountAmount: Decimal;
        STODeduction: Decimal;
        Charges: Record Charge;
        "Total Deductions": Decimal;
        NoticeAmount: Decimal;
        Cust: Record Customer;
        ChargesOnFD: Decimal;
        TotalGuaranted: Decimal;
        VarAmtHolder: Decimal;
        TotalUnprocessed: Decimal;
        AmtAfterWithdrawal: Decimal;
        LoansTotal: Decimal;
        Interest: Decimal;
        InterestRate: Decimal;
        OBal: Decimal;
        Principal: Decimal;
        ATMTrans: Decimal;
        ATMBalance: Decimal;
        CoinageBalances: Record "Coinage Balance";
        TotalBal: Decimal;

        CoinageAdjDetails: Record Denomination;
        UserSetup: Record "User Setup";
        Ok: Boolean;

        AccountTransferLines: Record "Account Transfer Line";

        CBSSetup: Record "CBS Setup";

        OL001: Label 'Account Transfer %1 has been sent for approval.';
        OL002: Label 'Account Transfer %1 has been cancelled.';
        RecRef: RecordRef;
        MyFieldRef: FieldRef;

    procedure CalcAvailableBalance()
    begin
        //Get User
        Ok := UserSetup.GET(USERID);
        IF Ok THEN;
        //UserSetup.TESTFIELD("Global Dimension 1 Code")
        // ELSE
        // ERROR('User Setup for %1 Does Not Exist', USERID);
        ATMBalance := 0;
        TransactionCharges.RESET;
        TransactionCharges.SETRANGE(TransactionCharges."Transaction Type Code", "Transaction Type");


        TCharges := 0;
        AvailableBalance := 0;
        MinAccBal := 0;
        TotalUnprocessed := 0;

        Rec.CALCFIELDS("Book Balance");

        AccountTypes.RESET;
        AccountTypes.SETRANGE(AccountTypes.Code, "Account Type");


        IF AccountTypes.FIND('-') THEN BEGIN
            MinAccBal := AccountTypes."Minimum Balance";
            FeeBelowMinBal := AccountTypes."Minimum Balance";
        END;

        IF Posted = FALSE THEN BEGIN

            IF TransactionCharges.FIND('-') THEN
                REPEAT



                UNTIL TransactionCharges.NEXT = 0;

            TransactionCharges.RESET;

            ///// CHECK LAST WITHDRAWAL DATE AND FIND IF CHARGE IS APPLICABLE AND CHARGE
            IntervalPenalty := 0;



            LoanGuaranteed := 0;

            IF UnClearedBalance < 0 THEN
                UnClearedBalance := 0;

            AccountTypes.RESET;
            IF AccountTypes.GET("Account Type") THEN BEGIN

                IF AccountTypes.Type <> AccountTypes.Type::"Fixed Deposit" = FALSE THEN BEGIN

                    IF "Book Balance" < MinAccBal THEN BEGIN
                        //AvailableBalance := "Book Balance" - FeeBelowMinBal - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance - "Frozen Amount";
                    END
                    ELSE BEGIN
                        // AvailableBalance := "Book Balance" - TCharges - IntervalPenalty - MinAccBal - TotalUnprocessed - ATMBalance - "Frozen Amount";
                    END;

                END
                ELSE BEGIN

                END;
            END;
        end;
    end;

}
