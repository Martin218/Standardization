page 50026 "Transaction Types List"
{
    // version TL2.0

    CardPageID = "Transaction Types Card";
    PageType = List;
    SourceTable = "Transaction -Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                // field(Type; Type)
                // {
                // }
                field("Service ID"; "Service ID")
                {ApplicationArea=All;
                }
                field("Application Area"; "Application Area")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

