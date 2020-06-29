page 50753 "Procurement Committee Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Procurement Committee Setup";

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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Minimum Members"; "Minimum Members")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Process Type"; "Process Type")
                {
                    ApplicationArea = All;
                }
                field("Process Stage"; "Process Stage")
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

