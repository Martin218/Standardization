page 50193 "Source Code List"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Source Code";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                /*                 field("Reason Code";"Reason Code")
                                {
                                } */
                field(Code; Code)
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

