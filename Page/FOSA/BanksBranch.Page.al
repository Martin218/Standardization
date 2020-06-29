page 50092 "Banks Branch"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Bank Branch";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Code"; "Bank Code")
                {
                    ApplicationArea = All;
                }
                field("Bank Name"; "Bank Name")
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

