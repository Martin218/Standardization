report 50561 "Vehicle Maintenance Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\VehicleMaintenanceReport.rdlc';

    dataset
    {
        dataitem("Vehicle Maintenance"; "Vehicle Maintenance")
        {
            column(VehicleNumberPlate_VehicleMaintenance; "Vehicle Maintenance"."Vehicle Number Plate")
            {
            }
            column(FixedAssetCarNo_VehicleMaintenance; "Vehicle Maintenance"."Fixed Asset Car No.")
            {
            }
            column(ResponsibleDriver_VehicleMaintenance; "Vehicle Maintenance"."Responsible Driver")
            {
            }
            column(BranchCode_VehicleMaintenance; "Vehicle Maintenance"."Branch Code")
            {
            }
            column(ServiceDate_VehicleMaintenance; "Vehicle Maintenance"."Service Date")
            {
            }
            column(ServiceAgentName_VehicleMaintenance; "Vehicle Maintenance"."Service Agent Name")
            {
            }
            column(Comment_VehicleMaintenance; "Vehicle Maintenance".Comment)
            {
            }
            column(Scheduled_VehicleMaintenance; "Vehicle Maintenance".Scheduled)
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
            column(company_logo; companyinfo.Picture)
            {
            }
            column(company_city; companyinfo.City)
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
    end;

    trigger OnPreReport();
    begin
        companyinfo.CALCFIELDS(Picture);
    end;

    var
        companyinfo: Record "Company Information";
}

