page 50197 "Loan Selloff Charges"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Selloff Charge";
    UsageCategory = Administration;
    ApplicationArea = All;
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
                field("Calculation Method"; "Calculation Method")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
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

