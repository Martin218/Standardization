page 50066 "Request From Treasury Card"
{
    // version TL2.0

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
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                }
                field("Treasury Account"; "Treasury Account")
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
                field("Treasury Balance"; "Treasury Balance")
                {
                    Editable = false;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field("Coinage Amount"; "Coinage Amount")
                {
                    Editable = false;
                }
                field("Branch Code"; "Branch Code")
                {ApplicationArea=All;
                }
                part(TSEA; "Teller Shortage/Excess Account")
                {
                    // SubPageLink = n = FIELD("No.");
                }
            }
            group("Transaction Audit Trail")
            {
                Editable = false;
                field(Issued; Issued)
                {ApplicationArea=All;
                }
                field("Date Issued"; "Date Issued")
                {ApplicationArea=All;
                }
                field("Time Issued"; "Time Issued")
                {ApplicationArea=All;
                }
                field("Issued By"; "Issued By")
                {ApplicationArea=All;
                }
                field("Issue Received"; "Issue Received")
                {ApplicationArea=All;
                }
                field("Date Issue Received"; "Date Issue Received")
                {ApplicationArea=All;
                }
                field("Time Issue Received"; "Time Issue Received")
                {ApplicationArea=All;
                }
                field("Received By"; "Received By")
                {ApplicationArea=All;
                }
                field(Posted; Posted)
                {ApplicationArea=All;
                }
                field("Date Posted"; "Date Posted")
                {ApplicationArea=All;
                }
                field("Time Posted"; "Time Posted")
                {ApplicationArea=All;
                }
                field("Posted By"; "Posted By")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Request")
            {
                Image = ServiceTasks;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SendRequest;

                trigger OnAction()
                begin
                    IF "Coinage Amount" <> Amount THEN BEGIN
                        ERROR(Error000);
                    END;
                    IF CONFIRM(Text000) THEN BEGIN
                        //TreasuryManagement.SendRequestFromTreasury(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action(Receive)
            {
                Image = ReceiptLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = ReceiveRequest;

                trigger OnAction()
                begin
                    IF CONFIRM(Text004) THEN BEGIN
                        //TreasuryManagement.ReceiveFromTreasury(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Issue Request")
            {
                Image = IssueFinanceCharge;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IssueRequest;

                trigger OnAction()
                begin
                    IF Amount > "Treasury Balance" THEN BEGIN
                        ERROR(Error001);
                    END;
                    IF CONFIRM(Text002) THEN BEGIN
                        //TreasuryManagement.IssueRequestFromTreasury(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Request From Treasury";
    end;

    trigger OnOpenPage()
    begin
        IF NOT "Request Sent" THEN BEGIN
            SendRequest := TRUE;
            IssueRequest := FALSE;
            ReceiveRequest := FALSE;
        END;
        IF "Request Sent" THEN BEGIN
            SendRequest := FALSE;
            IssueRequest := TRUE;
            ReceiveRequest := FALSE;
        END;
        IF Issued = Issued::Yes THEN BEGIN
            SendRequest := FALSE;
            IssueRequest := FALSE;
            ReceiveRequest := TRUE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF Posted THEN BEGIN
            SendRequest := FALSE;
            IssueRequest := FALSE;
            ReceiveRequest := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
    end;

    var
        Text000: Label 'Are you sure you want to submit this request?';
        Text001: Label 'Request has been submitted succesfully.';
        Text002: Label 'Are you sure you want to issue this request?';
        Text003: Label 'Request issued successfully.';
        Text004: Label 'Are you sure you want to receive this request?';
        Text005: Label 'Receipt successful';
        GenJournalLine: Record "Gen. Journal Line";
        GenJournalBatch: Record "Gen. Journal Batch";
        Text006: Label 'Issue From Treasury';
        SendRequest: Boolean;
        ReceiveRequest: Boolean;
        IssueRequest: Boolean;
        Error000: Label 'Coinage amount should be equal to the amount requested!';
        Error001: Label 'You cannot issue more than the treasury balance!';
    // TreasuryManagement: Codeunit "50014";
}

