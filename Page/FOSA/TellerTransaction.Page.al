page 50029 "Teller Transaction"
{
    // version TL2.0

    PageType = Card;
    SourceTable = Transaction;
    SourceTableView = where(Posted = filter('No'));

    layout
    {
        area(content)
        {
            field("Transaction Type"; "Transaction Type")
            {
                ApplicationArea = All;
                TableRelation = "Transaction -Type" WHERE("Deduct Excise Duty" = FILTER('Yes'));

                trigger OnValidate()
                begin
                    Visible;
                end;
            }
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Share Capital No."; "Share Capital No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Book Balance"; "Book Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Minimum Account Balance"; "Minimum Account Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Available Balance"; "Available Balance")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                group(G2)
                {
                    Visible = ShowCoinage;
                    field("Coinage Amount"; "Coinage Amount")
                    {
                        Editable = false;
                    }
                }
                field("Transacted By"; "Transacted By")
                {
                    ApplicationArea = All;
                }
                group(G1)
                {
                    Visible = SeeChequeDetails;
                    field("Cheque Type"; "Cheque Type")
                    {
                    }
                    field("Cheque No"; "Cheque No")
                    {
                    }
                    field("Cheque Date"; "Cheque Date")
                    {
                    }
                    field("Expected Maturity Date"; "Expected Maturity Date")
                    {
                        Editable = false;
                    }
                    field(Payee; Payee)
                    {
                    }
                    field("Bank No"; "Bank No")
                    {
                    }
                    field("Bank Name"; "Bank Name")
                    {
                        Editable = false;
                    }
                    field("Bank Branch No."; "Bank Branch No.")
                    {
                    }
                    field("Branch Name"; "Branch Name")
                    {
                        Editable = false;
                    }
                }
                part(TES; "Teller Shortage/Excess Account")
                {
                    ApplicationArea = All;
                    //SubPageLink = No = FIELD(No);
                    Visible = ShowCoinage;
                }
            }
            group(G3)
            {
                Visible = InterAccount;
                part("Inter Account Transfer Subform"; "Inter Account Transfer Subform")
                {
                    ApplicationArea = All;
                    SubPageLink = "Transaction ID" = FIELD("No.");
                }
            }
            group("Teller Details")
            {
                Editable = false;
                field(Cashier; Cashier)
                {
                    ApplicationArea = All;
                }
                field("Teller Balance"; "Teller Balance")
                {
                    ApplicationArea = All;
                }
                field("Teller Tills"; "Teller Tills")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Post Transaction")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeePost;

                trigger OnAction()
                begin
                    IF CONFIRM(Text003) THEN BEGIN
                        CBSSetup.GET;
                        IF CBSSetup."Coinage Mandatory" THEN BEGIN
                            IF NOT Cheque OR "Inter Account" THEN BEGIN
                                IF Amount <> "Coinage Amount" THEN BEGIN
                                    ERROR(Error010);
                                END;
                            END;
                        END;

                        IF "Needs Approval" = "Needs Approval"::Yes THEN BEGIN
                            IF Status <> Status::Approved THEN BEGIN
                                ERROR(Error007);
                            END;
                        END;

                        TellerManagement.GetTellerTransaction(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Print Receipt")
            {
                Image = PrintVoucher;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeReceipt;

                trigger OnAction()
                begin
                    Transactions.RESET;
                    Transactions.SETRANGE("No.", "No.");
                    IF Transactions.FINDFIRST THEN BEGIN
                        REPORT.RUN(50000, TRUE, FALSE, Transactions);
                    END;
                end;
            }
            action("Post InterAccount")
            {
                Visible = false;

                trigger OnAction()
                begin

                    //ClearLines("No.");
                    //CreateinterAccountJournalLines(No, FORMAT("Transaction Type") + FORMAT("Transacted By"), AccountType::Vendor, "Account No.", BalAccountType::Vendor, "Teller Tills", Amount, Vendor."Global Dimension 1 Code", PaymentType::Cash, LineNo);
                    Member.GET("Member No.");
                    // Post(No);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ShowCancel;

                trigger OnAction()
                begin
                    ApprovalsMgmt.OnCancelTellerTransactionApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        IF Cheque = TRUE THEN BEGIN
            ShowCoinage := FALSE;
        END;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        IF Posted THEN BEGIN
            ERROR(Error008);
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Needs Approval" := "Needs Approval"::No;
        IF CBSSetup."Coinage Mandatory" THEN BEGIN
            ShowCoinage := TRUE;
        END ELSE BEGIN
            ShowCoinage := FALSE;
        END;
    end;

    trigger OnOpenPage()
    begin
        Visible;
    end;

    var
        SeeChequeDetails: Boolean;
        InterAccount: Boolean;
        TransactionTypes: Record "Transaction -Type";
        Text000: Label 'You are almost reaching your replenishing level!';
        Text001: Label 'Transaction posted successfully';
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Vendor: Record Vendor;
        Error000: Label 'You are about to hit your maximum withholding amount of %1. Kindly return the excess funds back to treasury!';
        Error001: Label 'You have reached your maximum withholding level. Kindly return the excess funds back to registry before you can post this transaction!';
        TellerGeneralSetup: Record "Teller General Setup";
        Error002: Label 'You do not have enough funds to post this transaction!';
        Error003: Label 'Please specify the amount you wish to post!';
        Error004: Label 'Amount cannot be less than 0!';
        Transactions: Record "transaction";
        SeePost: Boolean;
        SeeReceipt: Boolean;
        Error005: Label 'This transaction has already been posted!';
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        PaymentType: Option " ",Cheque,Cash;
        TransactionCharge: Record "Transaction Charge";
        LineNo: Integer;
        Vendor2: Record "Vendor";
        AccountTypes: Record "Account Type";
        Member: Record Member;
        Error006: Label 'You cannot withdraw more than the available balance!';
        TellerSetup: Record "Teller Setup";
        Text002: Label 'This transaction will require approval. Do you wish to proceed?';
        SentForApproval: Integer;
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        Error007: Label 'Transaction has not yet been approved!';
        Ok: Boolean;
        AccountTransferLine: Record "Account Transfer Line";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ShowCoinage: Boolean;
        ShowCancel: Boolean;
        CBSSetup: Record "CBS Setup";
        Error008: Label 'You cannot delete this record!';
        TreasuryCoinage: Record "Treasury Coinage";
        Error009: Label 'Treasury Coinage must be filled in!';
        Success: Integer;
        Text003: Label 'Are you sure you want to proceed?';
        Error010: Label 'Coinage amount should tally to the transaction amount!';
        TellerManagement: Codeunit 50017;

    local procedure Visible()
    begin
        IF Posted THEN BEGIN
            CurrPage.EDITABLE(FALSE);
        END;

        ShowCoinage := TRUE;
        IF Status = Status::"Pending Approval" THEN BEGIN
            ShowCancel := TRUE;
        END;
        IF Status <> Status::New THEN BEGIN
            CurrPage.EDITABLE(FALSE);
        END;

        IF Posted = FALSE THEN BEGIN
            SeePost := TRUE;
            SeeReceipt := FALSE;
        END ELSE BEGIN
            SeeReceipt := TRUE;
            SeePost := FALSE;
        END;

        IF "Transaction Type" <> '' THEN BEGIN
            IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                IF TransactionTypes.Type = TransactionTypes.Type::"Teller Cheque Deposit" THEN BEGIN
                    SeeChequeDetails := TRUE;
                    ShowCoinage := FALSE;
                END;
                // IF TransactionTypes.Type = TransactionTypes.Type::PesaLink THEN BEGIN
                //     InterAccount := TRUE;
                //     ShowCoinage := FALSE;
                // END;
            END;
        END ELSE BEGIN
            SeeChequeDetails := FALSE;
            InterAccount := FALSE;
        END;

        CBSSetup.GET;
        IF CBSSetup."Coinage Mandatory" THEN BEGIN
            ShowCoinage := TRUE;
            SeeChequeDetails := FALSE;
            InterAccount := FALSE;
            IF TransactionTypes.GET("Transaction Type") THEN BEGIN
                IF TransactionTypes.Type = TransactionTypes.Type::"Teller Cheque Deposit" THEN BEGIN
                    SeeChequeDetails := TRUE;
                    ShowCoinage := FALSE;
                END ELSE
                    ShowCoinage := TRUE;
                // IF TransactionTypes.Type = TransactionTypes.Type::PesaLink THEN BEGIN
                //     InterAccount := TRUE;
                //     ShowCoinage := FALSE;
                // END;
            END;
        END ELSE BEGIN
            ShowCoinage := FALSE;
        END;
    end;
}

