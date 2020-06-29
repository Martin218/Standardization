page 50950 "Registry Numbers Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Registry Number";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("RegFile Status"; "RegFile Status")
                {
                    ApplicationArea = All;
                }
                field("No. Series"; "No. Series")
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

