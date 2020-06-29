page 50179 "Banked Cheques"
{
    // version TL2.0

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Transaction;
    // SourceTableView = WHERE("Transaction Type" = FILTER(TELLERCHEQUEDEPOSIT),
    //                         Deposited = CONST(Yes),
    //                         Reversed = CONST(No),
    //                         "Banking Posted" = FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cheque No"; "Cheque No")
                {ApplicationArea=All;
                }
                field("Drawer Name"; "Drawer Name")
                {ApplicationArea=All;
                }
                field("Cheque Date"; "Cheque Date")
                {ApplicationArea=All;
                }
                field("Cheque Type"; "Cheque Type")
                {ApplicationArea=All;
                }
                field("Expected Maturity Date"; "Expected Maturity Date")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Member No."; "Member No.")
                {ApplicationArea=All;
                }
                field("Account Type"; "Account Type")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field(Cashier; Cashier)
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Time"; "Transaction Time")
                {ApplicationArea=All;
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
    }
}

