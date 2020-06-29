page 50067 "Request From Treasury List"
{
    // version TL2.0

    CardPageID = "Request From Treasury Card";
    PageType = List;
    SourceTable = "Treasury Transaction";
    SourceTableView = WHERE(Posted = CONST(false),
                            "Transaction Type" = FILTER("Request From Treasury"),
                            "Request Sent" = FILTER(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Type"; "Transaction Type")
                {ApplicationArea=All;
                }
                field("Treasury Account"; "Treasury Account")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

