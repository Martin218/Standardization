page 50605 "Kenya Bankers Association Code"
{
    // version TL2.0

    DataCaptionFields = "KBA Code","KBA Name";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "KBA Codes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("KBA Code";"KBA Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bank Code";"Bank Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("KBA Branch Code";"KBA Branch Code")
                {
                    ApplicationArea = All;
                }
                field("KBA Name";"KBA Name")
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

