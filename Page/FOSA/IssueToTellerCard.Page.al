page 50112 "Issue To Teller Card"
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
                {ApplicationArea=All;
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
                part("Treasury Coinage"; "Treasury Coinage")
                {
                    SubPageLink = "No." = FIELD("No.");
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
            action(Receive)
            {
                Image = ReceiptLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Receive;

                trigger OnAction()
                begin
                    IF CONFIRM(Text002) THEN BEGIN
                        //TreasuryManagement.ReceiveFromTreasury(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action(Issue)
            {
                Image = IssueFinanceCharge;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Issue;

                trigger OnAction()
                begin
                    IF Amount <> "Coinage Amount" THEN BEGIN
                        ERROR(Error000);
                    END;
                    IF CONFIRM(Text000) THEN BEGIN
                        //TreasuryManagement.IssueRequestFromTreasury(Rec);
                        MESSAGE(Text001);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Issue To Teller";
    end;

    trigger OnOpenPage()
    begin
        IF Issued = Issued::No THEN BEGIN
            Receive := FALSE;
            Issue := TRUE;
        END ELSE BEGIN
            Issue := FALSE;
            Receive := TRUE;
        END;
    end;

    var
        Text000: Label 'Are you sure you want to issue to this teller?';
        Text001: Label 'Money has been issued successfully.';
        Text002: Label 'Are you sure you want to proceed?';
        Text003: Label 'Money has been received successfully. Your teller balance is now %1.';

        Text004: Label 'Issue to Teller';
        Issue: Boolean;
        Receive: Boolean;
        Error000: Label 'Amount should be equal to the coinage amount!';

}

