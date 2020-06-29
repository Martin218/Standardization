page 50116 "Close Till"
{
    // version TL2.0

    Editable = true;
    PageType = Card;
    SourceTable = "Treasury Transaction";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    Editable = false;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    Editable = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                }
                field("Teller Account"; "Teller Account")
                {
                    Editable = false;
                }
                field("Till Owner"; "Till Owner")
                {
                    Editable = false;
                }
                field("Till Balance"; "Till Balance")
                {
                    Editable = false;
                }
                field("Treasury Account"; "Treasury Account")
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field("Cheque Amount"; "Cheque Amount")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {
                    Caption = 'Cash Amount';
                }
                field("Coinage Amount"; "Coinage Amount")
                {
                    Editable = false;
                }
                part("Treasury Coinage"; "Treasury Coinage")
                {
                    //SubPageLink = "No." = FIELD("No.");
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = CanPost;

                trigger OnAction()
                begin
                    IF CONFIRM(Text003) THEN BEGIN
                        //TreasuryManagement.CloseTill(Rec);
                        CurrPage.CLOSE;
                    END;
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SendRequest;

                trigger OnAction()
                begin
                    TESTFIELD("Treasury Account");
                    TESTFIELD(Amount);

                    IF Amount <> "Coinage Amount" THEN
                        ERROR(Error000);

                    IF (Amount + "Cheque Amount") < "Till Balance" THEN BEGIN
                        IF CONFIRM(Text000 + FORMAT("Till Balance" - (Amount + "Cheque Amount")) + Text001) THEN BEGIN
                            // IF ApprovalsMgmt.CheckCloseTillApprovalPossible(Rec) THEN
                            //     ApprovalsMgmt.OnSendCloseTillForApproval(Rec);
                        END;
                    END ELSE BEGIN
                        IF (Amount + "Cheque Amount") > "Till Balance" THEN BEGIN
                            IF CONFIRM(Text002 + FORMAT((Amount + "Cheque Amount") - "Till Balance") + Text001) THEN BEGIN
                                // IF ApprovalsMgmt.CheckCloseTillApprovalPossible(Rec) THEN
                                //     ApprovalsMgmt.OnSendCloseTillForApproval(Rec);
                            END;
                        END ELSE BEGIN
                            // IF ApprovalsMgmt.CheckCloseTillApprovalPossible(Rec) THEN
                            //     ApprovalsMgmt.OnSendCloseTillForApproval(Rec);
                        END;
                    END;

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
                Visible = CancelRequest;

                trigger OnAction()
                begin
                    // IF ApprovalsMgmt.CheckCloseTillApprovalPossible(Rec) THEN
                    //     ApprovalsMgmt.OnCancelCloseTillApprovalRequest(Rec);

                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Description := 'Close Till';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Close Till";
    end;

    trigger OnOpenPage()
    begin
        IF Status = Status::Approved THEN BEGIN
            CanPost := TRUE;
        END;
        IF Status = Status::New THEN BEGIN
            SendRequest := TRUE;
            CancelRequest := FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            CancelRequest := TRUE;
            SendRequest := FALSE;
        END;
    end;

    var

        Error000: Label 'The amount does not match the coinage!';
        Text000: Label 'You have a shortage of ';
        BankAccount: Record "Bank Account";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanPost: Boolean;
        SendRequest: Boolean;
        CancelRequest: Boolean;
        GenJournalBatch: Record "Gen. Journal Batch";
        AccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        BalAccountType: Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner",Employee;
        PaymentType: Option " ",Cheque,Cash;
        LineNo: Integer;
        TellerShortageExcessAccount: Record "Teller Shortage/Excess Account";
        Text001: Label '. Do you wish to proceed?';
        Text002: Label 'You have an excess of ';
        //TreasuryManagement: Codeunit "50014";
        Text003: Label 'Are you sure you want to proceed?';
}

