page 50061 "Fixed Deposit Rate List"
{
    // version TL2.0

    CardPageID = "Fixed Deposit Rate Card";
    PageType = List;
    SourceTable = "Fixed Deposit Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount"; "Minimum Amount")
                {ApplicationArea=All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {ApplicationArea=All;
                }
                field(Period; Period)
                {ApplicationArea=All;
                }
                field("Interest Rate"; "Interest Rate")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

