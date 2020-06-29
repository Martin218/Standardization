page 50985 "Booking Process Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Booking Process";

    layout
    {
        area(content)
        {
            group("Book boordroom")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;

                }
                field(User; User)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    TableRelation = "Boardroom Detail";
                    ApplicationArea = All;

                }
                field("Booking Date"; "Booking Date")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Booking Time"; "Booking Time")
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field("Required Date"; "Required Date")
                {
                    Caption = 'Meeting Start Date';
                    ApplicationArea = All;

                }
                field("Meeting End Date"; "Meeting End Date")
                {
                    ApplicationArea = All;

                }
                field(Resources; Resources)
                {
                    Enabled = false;
                    Visible = false;
                    ApplicationArea = All;

                }
                field("Specific time of use"; "Specific time of use")
                {
                    Caption = 'Meeting Start Time';
                    ApplicationArea = All;

                }
                field("End Time"; "End Time")
                {
                    Caption = 'Meeting End Time';
                    ApplicationArea = All;

                }
                field(Duration; Duration)
                {
                    ShowMandatory = true;
                    ApplicationArea = All;

                }
                field(Agenda; Agenda)
                {
                    Caption = 'Meeting Agenda';
                    MultiLine = true;
                    ApplicationArea = All;

                }
                field("Type of Meeting"; "Type of Meeting")
                {
                    ApplicationArea = All;

                }
                field("In Attendance"; Attendees)
                {
                    Caption = 'In Attendance';
                    ApplicationArea = All;

                }
                field("No of Attendees"; "No of Attendees")
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Book; Book)
                {
                    ApplicationArea = All;

                }
            }
            part("Attendees Subform"; "Attendees Subform")
            {
                Caption = 'Attendees Subform';
            }
            part("Boardroom Items Subform"; "Boardroom Items Subform")
            {
                Caption = 'Boardroom Items Subform';
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Book Boardroom")
            {
                Image = BookingsLogo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.BookBoardroom(xRec);
                    CurrPage.CLOSE;
                end;
            }
            action("View Booked Rooms")
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.ViewBookedBoardrooms(Rec);
                end;
            }
        }
    }

    trigger OnInit();
    begin
        "Booking Date" := TODAY;
    end;

    var
        Agenda: Text;
        instr: InStream;
        BookingProcess: Record "Booking Process";
        AdminNoseries: Record "Admin Numbering Setup";
        RegistryManagement: Codeunit "Registry Management2";
}

