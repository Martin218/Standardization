page 50069 "Return To Bank Card"
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
                field("Bank No"; "Bank No")
                {ApplicationArea=All;
                }
                field("Treasury Account"; "Treasury Account")
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
                field("Treasury Balance"; "Treasury Balance")
                {
                    Editable = false;
                }
                field("External Document No."; "External Document No.")
                {
                    Visible = false;
                }
                field(Posted; Posted)
                {
                    Editable = false;
                }
                part(TellerShorttageExcess; "Teller Shortage/Excess Account")
                {
                    //SubPageLink = No = FIELD(No);
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
                    TESTFIELD("Bank No");
                    TESTFIELD("Treasury Account");
                    TESTFIELD(Amount);

                    IF Amount <> "Coinage Amount" THEN
                        ERROR(Error000);

                    IF CONFIRM(Text000) THEN BEGIN
                        //TreasuryManagement.ReturnToBank(Rec);
                    END;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Description := 'RETURN TO BANK';
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Transaction Type" := "Transaction Type"::"Return To Bank";
    end;

    var
        Text000: Label 'Are you sure you want to proceed?';
        BankAccount: Record "Bank Account";
        Error000: Label 'The amount does not match the coinage!';
    // TreasuryManagement: Codeunit "50014";
}

