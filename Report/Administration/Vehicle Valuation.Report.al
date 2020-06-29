report 50563 "Vehicle Valuation Scheduling"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\Vehicle Valuation Scheduling.rdlc';

    dataset
    {
        dataitem("Vehicle Insurance Scheduling"; "Vehicle Insurance Scheduling")
        {
            column(No_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."No.")
            {
            }
            column(FixedAssetcarNo_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Fixed Asset car No.")
            {
            }
            column(VehicleNumberPlate_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Vehicle Number Plate")
            {
            }
            column(VehicleDescription_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Vehicle Description")
            {
            }
            column(DesignatedDriver_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Designated Driver")
            {
            }
            column(InsuranceCompany_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Insurance Company")
            {
            }
            column(ValuationDate_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Valuation Date")
            {
            }
            column(Comment_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling".Comment)
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
            column(TypeofInsurance_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Type of Insurance")
            {
            }
            column(LastValuationDate_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Last Valuation Date")
            {
            }
            column(LastValuationAmount_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Last Valuation Amount")
            {
            }
            column(LastValuerCompany_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Last Valuer Company")
            {
            }
            column(BranchCode_VehicleInsuranceScheduling; "Vehicle Insurance Scheduling"."Branch Code")
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

