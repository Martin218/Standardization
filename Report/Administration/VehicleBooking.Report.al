report 50565 "Vehicle Booking Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\VehicleBookingReport.rdlc';

    dataset
    {
        dataitem("Vehicle Booking"; "Vehicle Booking")
        {
            column(AvailableCar_VehicleBooking1; "Vehicle Booking"."Available Car")
            {
            }
            column(User_VehicleBooking1; "Vehicle Booking".User)
            {
            }
            column(BranchCode_VehicleBooking1; "Vehicle Booking"."Branch Code")
            {
            }
            column(PeriodofUse_VehicleBooking1; "Vehicle Booking"."Period of Use")
            {
            }
            column(BookingDate_VehicleBooking1; "Vehicle Booking"."Booking Date")
            {
            }
            column(DriverRequired_VehicleBooking1; "Vehicle Booking"."Driver Required ?")
            {
            }
            column(AssignDriver_VehicleBooking1; "Vehicle Booking"."Assign Driver")
            {
            }
            column(company_name; companyinfo.Name)
            {
            }
            column(comapny_address; companyinfo.Address)
            {
            }
            column(company_postcode; companyinfo."Post Code")
            {
            }
            column(RequiredToDate_VehicleBooking1; "Vehicle Booking"."Required To Date")
            {
            }
            column(RequiredDate_VehicleBooking1; "Vehicle Booking"."Required Date")
            {
            }
            column(company_city; companyinfo.City)
            {
            }
            column(Picture; companyinfo.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                VehicleBooking.RESET;
                VehicleBooking.SETRANGE(Status, VehicleBooking.Status::Booked);
            end;
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
        VehicleBooking: Record "Vehicle Booking";
}

