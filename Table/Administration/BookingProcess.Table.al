table 50489 "Booking Process"
{
    // version TL2.0


    fields
    {
        field(1; User; Text[30])
        {
        }
        field(2; "Boardroom Name"; Text[100])
        {
            TableRelation = "Boardroom Detail"."Boardroom Name";
        }
        field(3; "Booking Time"; Time)
        {
        }
        field(4; Duration; Code[50])
        {
        }
        field(5; Resources; Code[30])
        {
        }
        field(6; "Booking Date"; Date)
        {
            Editable = false;
        }
        field(7; Book; Boolean)
        {
            Editable = true;
        }
        field(8; Status; Option)
        {
            OptionMembers = New,Pending,Booked,Rescheduled;
        }
        field(9; "No."; Code[40])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    NoSetup.GET();
                    NoSeriesMgt.TestManual(NoSetup.Duration);
                    "No.Series" := '';
                END;
            end;
        }
        field(10; "Approval Remarks"; Text[80])
        {
        }
        field(11; "No.Series"; Code[30])
        {
        }
        field(12; "Specific time of use"; Time)
        {

            trigger OnValidate();
            begin
                BookingProcess.RESET;
                BookingProcess.SETRANGE("Required Date", "Required Date");
                BookingProcess.SETRANGE("Boardroom Name", "Boardroom Name");
                BookingProcess.SETRANGE(Status, BookingProcess.Status::Booked);
                IF BookingProcess.FINDSET THEN BEGIN
                    REPEAT
                        IF "Specific time of use" = BookingProcess."Specific time of use" THEN BEGIN
                            ERROR('Another meeting has been booked for this time. Please select another time!');
                        END;
                        IF ("Specific time of use" > BookingProcess."Specific time of use") AND ("Specific time of use" < BookingProcess."End Time") THEN BEGIN
                            ERROR('Another meeting has been scheduled during this time. Please select another time!');
                        END;
                    UNTIL BookingProcess.NEXT = 0;
                    // MESSAGE('p');
                END;
            end;
        }
        field(13; "Required Date"; Date)
        {
        }
        field(14; "Meeting End Date"; Date)
        {
        }
        field(15; "Type of Meeting"; Option)
        {
            OptionMembers = ,Internal,External;
        }
        field(16; Attendees; Option)
        {
            OptionMembers = ,"Staff Only",Board,"Staff and Board","External Stakeholders";
        }
        field(17; "No of Attendees"; Integer)
        {
        }
        field(18; "Meeting Agenda"; Text[250])
        {
        }
        field(19; "End Time"; Time)
        {

            trigger OnValidate();
            begin
                IF "End Time" < "Specific time of use" THEN BEGIN
                    ERROR('End Time cannot be ealier than Start Time!');
                END;

                hrs := "End Time" - "Specific time of use";
                hrs2 := hrs / 3600000;
                Duration := FORMAT(hrs2);
                Duration := PADSTR(Duration, 3) + ' HRS';
            end;
        }
        field(20; Agenda; Text[250])
        {
        }
        field(21; "Attendee Names"; Text[70])
        {
        }
        field(22; Remarks; Text[100])
        {
        }
        field(23; Item; Code[10])
        {
        }
        field(24; Quantity; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        User := USERID;
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD(Duration);
            NoSeriesMgt.InitSeries(NoSetup.Duration, xRec."No.Series", 0D, "No.", "No.Series");
        END;
        "Booking Date" := TODAY;
        "Booking Time" := TIME;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
        instr: InStream;
        agenda: Text;
        hrs: Integer;
        hrs2: Decimal;
        outstr: OutStream;
        BookingProcess: Record "Booking Process";
}

