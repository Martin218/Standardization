page 50065 "Authorise Withdrawal"
{
    // version TL2.0

    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE("Supervisor Checked" = CONST(false));
    // "Transaction Category"=CONST(CASH TRANSACTIONS),
    // Field27 = CONST(Withdrawal),
    // "Needs Approval"=CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                // field(Select; Select)
                // {
                // }
                field(Authorised; Authorised)
                {ApplicationArea=All;
                }
                // field(Remarks; Remarks)
                // {
                // }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Account No."; "Account No.")
                {
                    Editable = false;
                }
                field("Member Name"; "Member Name")
                {
                    Editable = false;
                }
                field("Account Name"; "Account Name")
                {
                    Caption = 'Account Type';
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Editable = false;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    Editable = false;
                }
                field(Cashier; Cashier)
                {
                    Caption = 'Teller';
                    Editable = false;
                }
                // field("Overdraft Code"; "Overdraft Code")
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
                field("Checked By"; "Checked By")
                {
                    Editable = false;
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

                end;
            }
        }
    }

    trigger OnOpenPage()
    begin

    end;

    var
        AccountAmount: Decimal;
        Customer: Record Customer;
}

