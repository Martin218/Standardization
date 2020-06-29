page 50312 "Loan Selloff Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Selloff Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Income G/L Account"; "Income G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Receiving Bank Account"; "Receiving Bank Account")
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

