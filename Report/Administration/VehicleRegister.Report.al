report 50564 "Vehicle Register"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Administration\VehicleRegister.rdlc';

    dataset
    {
        dataitem("Vehicle Register"; "Vehicle Register")
        {
            column(No_VehicleRegister; "Vehicle Register"."No.")
            {
            }
            column(Description_VehicleRegister; "Vehicle Register".Description)
            {
            }
            column(ResponsibleDriver_VehicleRegister; "Vehicle Register"."Responsible Driver")
            {
            }
            column(Insured_VehicleRegister; "Vehicle Register".Insured)
            {
            }
            column(NoSeries_VehicleRegister; "Vehicle Register"."No.Series")
            {
            }
            column(NumberPlate_VehicleRegister; "Vehicle Register"."Number Plate")
            {
            }
            column(ChassisNo_VehicleRegister; "Vehicle Register"."Chassis No")
            {
            }
            column(BodyType_VehicleRegister; "Vehicle Register"."Body Type")
            {
            }
            column(Colour_VehicleRegister; "Vehicle Register".Colour)
            {
            }
            column(Model_VehicleRegister; "Vehicle Register".Model)
            {
            }
            column(EngineNo_VehicleRegister; "Vehicle Register"."Engine No")
            {
            }
            column(YOM_VehicleRegister; "Vehicle Register".YOM)
            {
            }
            column(Registered_VehicleRegister; "Vehicle Register".Registered)
            {
            }
            column(Booked_VehicleRegister; "Vehicle Register".Booked)
            {
            }
            column(FixedAssetCarNo_VehicleRegister; "Vehicle Register"."Fixed Asset Car No.")
            {
            }
            column(DateofInsurance_VehicleRegister; "Vehicle Register"."Date of Insurance")
            {
            }
            column(Months_VehicleRegister; "Vehicle Register".Months)
            {
            }
            column(InsuranceExpiryDate_VehicleRegister; "Vehicle Register"."Insurance Expiry Date")
            {
            }
            column(Days_VehicleRegister; "Vehicle Register".Days)
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
            column(Color_VehicleRegister; "Vehicle Register".Color)
            {
            }
            column(BranchCode_VehicleRegister; "Vehicle Register"."Branch Code")
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

