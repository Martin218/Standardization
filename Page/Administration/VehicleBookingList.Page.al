page 51002 "Vehicle Booking List"
{
    // version TL2.0

    CardPageID = "Vehicle Booking Card";
    PageType = List;
    SourceTable = "Vehicle Booking";

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
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Period of Use"; "Period of Use")
                {
                    ApplicationArea = All;
                }
                field("Booking Time"; "Booking Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Available Car"; "Available Car")
                {
                    ApplicationArea = All;
                }
                field("Booking Date"; "Booking Date")
                {
                    ApplicationArea = All;
                }
                field(Booked; Booked)
                {
                    ApplicationArea = All;
                }
                field("Required Date"; "Required Date")
                {
                    ApplicationArea = All;
                }
                field("Time of Use"; "Time of Use")
                {
                    ApplicationArea = All;
                    Caption = 'Specific time';
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
        area(creation)
        {
        }
    }

    var
        "Vehicle Booking1": Record "Vehicle Booking";
    //User : Record "91";
}

