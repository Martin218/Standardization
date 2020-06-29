page 50118 "Posted Close Till Requests"
{
    // version TL2.0

    CardPageID = "Close Till";
    Editable = true;
    PageType = List;
    SourceTable = "Treasury Transaction";
    SourceTableView = WHERE(Posted = CONST(true),
                            "Transaction Type" = FILTER("Close Till"));

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
                {
                    Editable = false;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Teller Account"; "Teller Account")
                {ApplicationArea=All;
                }
                field("Treasury Account"; "Treasury Account")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field("Date Posted"; "Date Posted")
                {ApplicationArea=All;
                }
                field("Time Posted"; "Time Posted")
                {ApplicationArea=All;
                }
                field("Posted By"; "Posted By")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

