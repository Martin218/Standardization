page 50107 "Receive From Bank"
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
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                }
                field("Bank No"; "Bank No")
                {
                    ApplicationArea = All;
                }
                field("Treasury Account"; "Treasury Account")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Coinage Amount"; "Coinage Amount")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Treasury Balance"; "Treasury Balance")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                part("Treasury Coinage"; "Treasury Coinage")
                {
                    SubPageLink = "No." = FIELD("No.");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Receive From Bank")
            {
                ApplicationArea = All;
                Image = ReceiveLoaner;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        //TreasuryManagement.ReceiveFromBank(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Receive From Bank";
    end;

    var

        Text000: Label 'Are you sure you want to post this transaction?';
        Text001: Label 'Receive From Bank';

}

