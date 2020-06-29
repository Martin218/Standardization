page 50084 "Return To Treasury Card"
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
                    ApplicationArea = All;
                }
                field("Teller Account"; "Teller Account")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Till Owner"; "Till Owner")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Till Balance"; "Till Balance")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Treasury Account"; "Treasury Account")
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
            action(Post)
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Banks.GET("Teller Account");
                    IF Banks.Blocked THEN BEGIN
                        ERROR(Error001);
                    END;

                    TESTFIELD("Treasury Account");
                    TESTFIELD(Amount);

                    IF Amount <> "Coinage Amount" THEN
                        ERROR(Error000);

                    IF CONFIRM(Text000) THEN BEGIN
                        //TreasuryManagement.ReturnToTreasury(Rec);
                    END;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Description := 'Return To Treasury';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Return To Treasury";
    end;

    var

        TellerSetUp: Record "Teller Setup";
        TreasuryCoinage: Record "Treasury Coinage";
        TreasuryTellerSetup: Record "Teller General Setup";
        CurrentTellerAmount: Decimal;
        TellerTill: Record "Bank Account";
        IssueRequest: Record "Treasury Request";
        Banks: Record "Bank Account";
        Vend: Record "Vendor";
        BankBal: Decimal;
        CoinageBalances: Record "Treasury Coinage";
        TotalBal: Decimal;
        DenominationsRec: Record "Treasury Transaction";
        CoinageAdjDetails: Record "Treasury Coinage";
        Error000: Label 'The amount does not match the coinage!';
        Text000: Label 'Are you sure you want to proceed?';
        Error001: Label 'Till is closed!';
    // TreasuryManagement: Codeunit "50014";
}

