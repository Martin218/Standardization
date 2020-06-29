page 50218 "Loan Graduation Schedule"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Loan Graduation Schedule";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Loan Amount"; "Minimum Loan Amount")
                {ApplicationArea = All;
                }
                field("Maximum Loan Amount"; "Maximum Loan Amount")
                {ApplicationArea = All;
                }
                field("Minimum Repayment Period"; "Minimum Repayment Period")
                {ApplicationArea = All;
                }
                field("Maximum Repayment Period"; "Maximum Repayment Period")
                {ApplicationArea = All;
                }
                field("Increment Amount"; "Increment Amount")
                {ApplicationArea = All;
                }
                field("Increment Factor"; "Increment Factor")
                {ApplicationArea = All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {ApplicationArea = All;
                }
                field("Incremental Method"; "Incremental Method")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

