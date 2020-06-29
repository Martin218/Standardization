page 50039 "Posted Teller Transactions"
{
    // version TL2.0

    CardPageID = "Teller Transaction";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(Posted = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Account Name"; "Account Name")
                {ApplicationArea=All;
                }
                field("Transaction Type"; "Transaction Type")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Time"; "Transaction Time")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        ERROR(Error000);
    end;

    trigger OnOpenPage()
    begin
        CurrPage.EDITABLE(FALSE);
    end;

    var
        BankAccount: Record "Bank Account";
        Error000: Label 'You cannot delete this record!';
}

