page 50060 "Fixed Deposit Rate Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Fixed Deposit Rate";

    layout
    {
        area(content)
        {
            group("Fixed Deposit")
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

