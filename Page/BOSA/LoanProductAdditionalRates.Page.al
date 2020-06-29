page 50215 "Loan Product Additional Rates"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Additional Rates';
    PageType = List;
    SourceTable = "Loan Product Additional Rate";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Minimum Amount"; "Minimum Amount")
                {
                    ApplicationArea = All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

