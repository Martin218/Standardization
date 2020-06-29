page 50095 "Pending Teller Transactions"
{
    // version TL2.0

    CardPageID = "Teller Transaction";
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(Posted = FILTER(false),
                            "Needs Approval" = FILTER(true));

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
}

