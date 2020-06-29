report 50562 "Fuel Management"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\Fuel Management.rdlc';

    dataset
    {
        dataitem("Fuel Tracking"; "Fuel Tracking")
        {
            column(No_FuelTracking; "Fuel Tracking"."No.")
            {
            }
            column(FuelReceiptDate_FuelTracking; "Fuel Tracking"."Fuel Receipt Date")
            {
            }
            column(FuelCost_FuelTracking; "Fuel Tracking"."Fuel Cost")
            {
            }
            column(Mileage_FuelTracking; "Fuel Tracking".Mileage)
            {
            }
            column(VehicleNumberPlate_FuelTracking; "Fuel Tracking"."Vehicle Number Plate")
            {
            }
            column(Driver_FuelTracking; "Fuel Tracking".Driver)
            {
            }
            column(company_name; companyinfo.Name)
            {
            }
            column(company_address; companyinfo.Address)
            {
            }
            column(company_postcode; companyinfo."Post Code")
            {
            }
            column(OpeningMileage_FuelTracking; "Fuel Tracking"."Opening Mileage")
            {
            }
            column(ClosingMileage_FuelTracking; "Fuel Tracking"."Closing Mileage")
            {
            }
            column(BranchCode_FuelTracking; "Fuel Tracking"."Branch Code")
            {
            }
            column(company_city; companyinfo.City)
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

