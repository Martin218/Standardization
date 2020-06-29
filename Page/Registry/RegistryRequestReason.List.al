page 50964 "Registry Request Reason"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Request File Reason";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Reason; Reason)
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

