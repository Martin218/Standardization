page 50288 "Payout Types List"
{
    // version TL2.0

    Caption = 'Payout Types';
    CardPageID = "Payout Type Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Payout Type";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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

