page 50031 "Cheque Types"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Cheque Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Clearing Days"; "Clearing Days")
                {
                    ApplicationArea = All;
                }
                field(CDays; CDays)
                {
                    Visible = false;
                }
                field("Clearing Charges"; "Clearing Charges")
                {
                    ApplicationArea = All;
                }
                field("Clearing Charges GL Account"; "Clearing Charges GL Account")
                {
                    ApplicationArea = All;
                }
                field("Clearing Bank Account"; "Clearing Bank Account")
                {
                    Visible = false;
                }
                field("Special Clearing Days"; "Special Clearing Days")
                {
                    Visible = false;
                }
                field("Special Clearing Charges"; "Special Clearing Charges")
                {
                    ApplicationArea = All;
                }
                field("Bounced Cheque Charges"; "Bounced Cheque Charges")
                {
                    ApplicationArea = All;
                }
                field("Bounced Cheque GL Account"; "Bounced Cheque GL Account")
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

