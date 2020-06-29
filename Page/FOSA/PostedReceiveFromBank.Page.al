page 50109 "Posted Receive From Bank"
{
    // version TL2.0

    CardPageID = "Receive From Bank";
    PageType = List;
    SourceTable = "Treasury Transaction";
    SourceTableView = WHERE("Transaction Type" = FILTER("Receive From Bank"),
                            Posted = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
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
            }
        }
    }

    actions
    {
    }
}

