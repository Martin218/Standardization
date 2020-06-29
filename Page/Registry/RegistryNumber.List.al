page 50951 "Registry Number"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Registry Number";
    CardPageId = 50950;

    layout
    {
        area(content)
        {
            repeater(Group)
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

