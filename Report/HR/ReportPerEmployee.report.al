report 50252 "Report Per Employee"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Report Per Employee.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 5200)
        {
            RequestFilterFields = "No.";
            column(No_Employee; "No.")
            {
            }
            column(FirstName_Employee; "First Name")
            {
            }
            column(MiddleName_Employee; "Middle Name")
            {
            }
            column(LastName_Employee; "Last Name")
            {
            }
            column(CountryRegionCode_Employee; "Country/Region Code")
            {
            }
            column(SearchName_Employee; "Search Name")
            {
            }
            column(Disability_Employee; Disability)
            {
            }
            column(DisabilityDescription_Employee; Disability)
            {
            }
            column(Age_Employee; Age)
            {
            }
            column(MaritalStatus_Employee; "Marital Status")
            {
            }
            column(EmploymentDate; "Employment Date")
            {
            }
            column(Status_Employee; Status)
            {
            }
            column(JobTitle_Employee; "Job Title")
            {
            }
            /*    column(BranchName_Employee;Employee."Branch Name")
                {
                }
                column(DepartmentName_Employee;Employee."Department Name")
                {
                }*/
            column(Extension_Employee; Extension)
            {
            }
            column(CompanyEMail_Employee; "Company E-Mail")
            {
            }
            /*            column(BloodType_Employee;Employee."Blood Type")
                        {
                        }
                        column(MobilePhoneNo_Employee;Employee."Mobile Phone No.")
                        {
                        }*/
            column(BirthDate_Employee; "Birth Date")
            {
            }
            /*
            column(IDNumber_Employee;Employee."ID Number")
            {
            }
            column(PINNumber_Employee;Employee."PIN Number")
            {
            }
            column(NSSFNo_Employee;Employee.NSSF)
            {
            }
            column(NHIFNo_Employee;Employee.NHIF)
            {
            }
            column(HELBNo_Employee;Employee."HELB No")
            {
            }
            column(CountyCode_Employee;Employee."County Code")
            {
            }*/
            column(Address2_Employee; "Address 2")
            {
            }
            column(PostCode_Employee; "Post Code")
            {
            }
            column(PhoneNo_Employee; "Phone No.")
            {
            }
            column(Gender_Employee; Gender)
            {
            }
            column(EMail_Employee; "E-Mail")
            {
            }
            column(Picture_Employee; Image)
            {
            }
            column(Image_Employee; Image)
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }

            trigger OnAfterGetRecord();
            begin
                VALIDATE(Image);
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
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
        /*    empno:='';
            empno:=GETFILTER("No.");
            IF empno='' THEN BEGIN
               ERROR('You must specify an employee!');
            END;
            Employee.CALCFIELDS(Picture);*/
    end;

    var
        UserSetup: Record 91;
        // EmployeeExt: Record 50290;
        CompanyInformation: Record 79;
        empno: Text;


}

