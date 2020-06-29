page 50286 "Posted Payout List"
{
    // version TL2.0

    Caption = 'Posted Payouts';
    CardPageID = Payout;
    PageType = List;
    SourceTable = "Payout Header";
    SourceTableView = WHERE(Status = FILTER(Approved),
                            Posted = FILTER(true));
    UsageCategory = History;
    ApplicationArea = All;

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
                field("Payout Type"; "Payout Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Agency Name"; "Agency Name")
                {
                    ApplicationArea = All;
                }
                field("Total Payout Amount"; "Total Payout Amount")
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

