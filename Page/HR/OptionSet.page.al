page 50521 "Option Set"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50278;
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field(Value; Value)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Option Set Values")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50522;
                RunPageLink = Code = FIELD(Code);
                ApplicationArea = All;

            }
        }
    }
}

