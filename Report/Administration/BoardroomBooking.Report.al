report 50558 "Boardroom Booking"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\BoardroomBooking.rdlc';

    dataset
    {
        dataitem("Booking Process"; "Booking Process")
        {
            RequestFilterFields = "Boardroom Name";
            column(User_BookingProcess; "Booking Process".User)
            {
            }
            column(BoardroomName_BookingProcess; "Booking Process"."Boardroom Name")
            {
            }
            column(BookingTime_BookingProcess; "Booking Process"."Booking Time")
            {
            }
            column(Duration_BookingProcess; "Booking Process".Duration)
            {
            }
            column(Resources_BookingProcess; "Booking Process".Resources)
            {
            }
            column(BookingDate_BookingProcess; "Booking Process"."Booking Date")
            {
            }
            column(Book_BookingProcess; "Booking Process".Book)
            {
            }
            column(Status_BookingProcess; "Booking Process".Status)
            {
            }
            column(No_BookingProcess; "Booking Process"."No.")
            {
            }
            column(ApprovalRemarks_BookingProcess; "Booking Process"."Approval Remarks")
            {
            }
            column(comapny_name; companyinfo.Name)
            {
            }
            column(company_address; companyinfo.Address)
            {
            }
            column(company_postcode; companyinfo."Post Code")
            {
            }
            column(Specifictimeofuse_BookingProcess; "Booking Process"."Specific time of use")
            {
            }
            column(RequiredDate_BookingProcess; "Booking Process"."Required Date")
            {
            }
            column(MeetingEndDate_BookingProcess; "Booking Process"."Meeting End Date")
            {
            }
            column(TypeofMeeting_BookingProcess; "Booking Process"."Type of Meeting")
            {
            }
            column(Attendees_BookingProcess; "Booking Process".Attendees)
            {
            }
            column(NoofAttendees_BookingProcess; "Booking Process"."No of Attendees")
            {
            }
            column(EndTime_BookingProcess; "Booking Process"."End Time")
            {
            }
            column(company_city; companyinfo.City)
            {
            }
            column(Agenda_BookingProcess; "Booking Process".Agenda)
            {
            }
            column(Picture; companyinfo.Picture)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        companyinfo.GET;
        companyinfo.CALCFIELDS(Picture);
    end;

    var
        companyinfo: Record "Company Information";
}

