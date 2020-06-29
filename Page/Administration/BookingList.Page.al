page 50990 "Booking List"
{
    // version TL2.0

    CardPageID = "Booking Process Card";
    PageType = List;
    SourceTable = "Booking Process";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(User; User)
                {
                    ApplicationArea = All;

                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    ApplicationArea = All;

                }
                field("Booking Time"; "Booking Time")
                {
                    ApplicationArea = All;

                }
                field(Duration; Duration)
                {
                    ApplicationArea = All;

                }
                field(Resources; Resources)
                {
                    ApplicationArea = All;

                }
                field("Booking Date"; "Booking Date")
                {
                    ApplicationArea = All;

                }
                field(Book; Book)
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field("Required Date"; "Required Date")
                {
                    ApplicationArea = All;

                }
                field("Type of Meeting"; "Type of Meeting")
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

