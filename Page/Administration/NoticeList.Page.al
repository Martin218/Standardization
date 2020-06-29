page 50993 "Notice List"
{
    // version TL2.0

    CardPageID = "Notice Card";
    PageType = List;
    SourceTable = Notice;

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
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field(Agenda; Agenda)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(User; User)
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

