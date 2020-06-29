page 50225 "Loan Refinance Charges"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Refinance Charge";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount Paid %"; "Minimum Amount Paid %")
                {ApplicationArea = All;
                }
                field("Maximum Amount Paid %"; "Maximum Amount Paid %")
                {ApplicationArea = All;
                }
                field("Refinance Rate %"; "Refinance Rate %")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

