page 50267 "Loan Rescheduling Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Rescheduling Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Rescheduling Option"; "Rescheduling Option")
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

