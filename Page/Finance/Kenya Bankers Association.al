page 50606 "Kenya Bankers Association"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Bank Name";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = All;
                }
                field("BAnk Name";"BAnk Name")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
           
            group(Main)
            {
                action("KBA Names")
                {
                    Image = Bank;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Kenya Bankers Association Code";
                    RunPageLink = "Bank Code"=FIELD("Bank Code");
                }
            }
        }
    }
}

