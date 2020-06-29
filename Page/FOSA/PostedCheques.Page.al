page 50094 "Posted Cheques"
{
    // version TL2.0

    CardPageID = "Teller Transaction";
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(Cheque = FILTER(true),
                            "Cheque Processed" = FILTER(true),
                            Posted = FILTER(true),
                            "Cheque Status" = FILTER(Honoured));

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
                field("Cheque Type"; "Cheque Type")
                {ApplicationArea=All;
                }
                field("Cheque No"; "Cheque No")
                {ApplicationArea=All;
                }
                field("Cheque Date"; "Cheque Date")
                {ApplicationArea=All;
                }
                field(Payee; Payee)
                {ApplicationArea=All;
                }
                field("Bank No"; "Bank No")
                {ApplicationArea=All;
                }
                field("Bank Name"; "Bank Name")
                {ApplicationArea=All;
                }
                field("Bank Branch No."; "Bank Branch No.")
                {ApplicationArea=All;
                }
                field("Branch Name"; "Branch Name")
                {ApplicationArea=All;
                }
                field("Cheque Status"; "Cheque Status")
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

    var
        Error000: Label 'You cannot delete this record!';
}

