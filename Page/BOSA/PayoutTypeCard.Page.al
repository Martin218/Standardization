page 50287 "Payout Type Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Payout Type";

    layout
    {
        area(content)
        {
            group(General)
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
            part(Page; 50289)
            {
                ApplicationArea = All;
                SubPageLink = "Payout Code" = FIELD(Code);
            }
        }
    }

    actions
    {
    }
}

