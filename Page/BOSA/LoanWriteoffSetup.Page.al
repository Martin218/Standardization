page 50333 "Loan Writeoff Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Writeoff Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("LW G/L Control Account"; "LW G/L Control Account")
                {
                    ApplicationArea = All;
                }
                field("Attachment Mandatory"; "Attachment Mandatory")
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

