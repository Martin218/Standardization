page 50998 "Schedule List"
{
    // version TL2.0

    CardPageID = "Schedule Card";
    PageType = List;
    SourceTable = "CEO Schedule";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("No of meetings"; "No of meetings")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Meeting Type"; "Meeting Type")
                {
                    ApplicationArea = All;
                }
                field("No of appointments"; "No of appointments")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Appointments type"; "Appointments type")
                {
                    ApplicationArea = All;
                }
                field("Appointments time"; "Appointments time")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(Schedule; Schedule)
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                    Editable = false;
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

