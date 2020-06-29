page 50983 "Boardroom Information List"
{
    // version TL2.0

    CardPageID = "Boardroom Information Card";
    PageType = List;
    SourceTable = "Boardroom Detail";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Boardroom No"; "Boardroom No")
                {
                    ApplicationArea = All;

                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    ApplicationArea = All;

                }
                field(Location; Location)
                {
                    ApplicationArea = All;

                }
                field(Address; Address)
                {
                    ApplicationArea = All;

                }
                field(Register; Register)
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

