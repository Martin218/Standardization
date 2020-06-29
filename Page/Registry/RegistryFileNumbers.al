page 50957 "Registry File Numbers"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Registry File Number";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("File Status"; "File Status")
                {
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Changed By"; "Changed By")
                {
                    ApplicationArea = All;
                }
                field("Previous File Number"; "Previous File Number")
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

