page 50226 "Fund Transfer Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Fund Transfer Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Recover Source Arrears"; "Recover Source Arrears")
                {
                    ApplicationArea = All;
                }
                field("Recover Destination Arrears"; "Recover Destination Arrears")
                {
                    ApplicationArea = All;
                }
                field("Allow Partial Deduction"; "Allow Partial Deduction")
                {
                    ApplicationArea = All;
                }
                field("Allow Overdrawing"; "Allow Overdrawing")
                {
                    ApplicationArea = All;
                }
                field("Overdraw/Partial Priority"; "Overdraw/Partial Priority")
                {
                    ApplicationArea = All;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                field("Notify Source Member"; "Notify Source Member")
                {
                    ApplicationArea = All;
                }
                field("Source SMS Template"; "Source SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Source Email Template"; "Source Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notify Destination Member"; "Notify Destination Member")
                {
                    ApplicationArea = All;
                }
                field("Destination SMS Template"; "Destination SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Destination Email Template"; "Destination Email Template")
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

