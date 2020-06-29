page 50178 "Banking Of Cheques"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(
                            "Banking Posted" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque No"; "Cheque No")
                {
                    ApplicationArea = All;
                }
                field("Cheque Date"; "Cheque Date")
                {
                    ApplicationArea = All;
                }
                field("Cheque Type"; "Cheque Type")
                {
                    ApplicationArea = All;
                }
                field("Expected Maturity Date"; "Expected Maturity Date")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(Cashier; Cashier)
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
                field("Cheque Custodian"; "Cheque Custodian")
                {
                    Enabled = true;
                }
                field("Destination Bank"; "Destination Bank")
                {
                    Caption = 'Destination Bank Account';
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Bank Cheques")
            {
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(Rec);
                        IF Rec.FINDSET THEN BEGIN
                            REPEAT
                                TESTFIELD("Destination Bank");
                            //TreasuryManagement.BankingCheques(Rec);
                            UNTIL Rec.NEXT = 0;
                        END;
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        Text000: Label 'Are you sure you want to bank the selected cheque(s)?';
    //TreasuryManagement: Codeunit "50014";
}

