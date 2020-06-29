page 50198 "Loan Application Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Loan Application Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(General)
            {
                field("Notify Member"; "Notify Member")
                {
                    ApplicationArea = All;
                }
                field("Email Template"; "Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("SMS Template"; "SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notification Option"; "Notification Option")
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

