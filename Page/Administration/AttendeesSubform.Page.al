page 50987 "Attendees Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = Attendance;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Attendee Names"; "Attendee Names")
                {
                    ApplicationArea = All;

                }
                field("Meeting Agenda"; "Meeting Agenda")
                {
                    ApplicationArea = All;
                    Visible = false;

                }
                field("Email Address"; Remarks)
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

