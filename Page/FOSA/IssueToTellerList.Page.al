page 50111 "Issue To Teller List"
{
    // version TL2.0

    CardPageID = "Issue To Teller Card";
    PageType = List;
    SourceTable = "Treasury Transaction";
    SourceTableView = WHERE(Posted = CONST(false),
                            "Transaction Type" = FILTER("Issue To Teller"),
                            Issued = FILTER(false));

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

