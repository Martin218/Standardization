report 50250 "Employee Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Employee Report.rdlc';
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
            column(DepartmentName_Employee; "Department Name")
            {
            }
            column(JobTitle_Employee; "Job Title")
            {
            }
            column(EmploymentDate_Employee; "Employment Date")
            {
            }
            column(Name; Name)
            {
            }
            column(Status_Employee; Status)
            {
            }
            column(Gender_Employee; Gender)
            {
            }
            column(BirthDate_Employee; "Birth Date")
            {
            }
            column(Age_Employee; Age)
            {
            }
            column(MaritalStatus_Employee; "Marital Status")
            {
            }
            column(IDNumber_Employee; "ID Number")
            {
            }
            column(NSSF_Employee; NSSF)
            {
            }
            column(NHIF_Employee; NHIF)
            {
            }
            column(PINNumber_Employee; "PIN Number")
            {
            }
            column(ResidentialAddress_Employee; Address)
            {
            }
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
            {
            }
            column(PostCode_CompanyInformation; CompanyInformation."Post Code")
            {
            }
            column(City_CompanyInformation; CompanyInformation.City)
            {
            }
            column(Pic_CompanyInformation; CompanyInformation.Picture)
            {
            }
            column(Branch_Name; "Branch Name")
            {
            }
            column(serialno; serialno)
            {
            }
            column(HeaderTxt; HeaderTxt)
            {
            }

            trigger OnAfterGetRecord();
            begin
                serialno += 1;
                Name := FullName;
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
        CompanyInformation.CALCFIELDS(Picture);
    end;

    trigger OnPreReport();
    begin
        serialno := 0;
    end;

    var
        CompanyInformation: Record 79;
        serialno: Integer;
        Emp: Record 5200;
        BranchName: Text;
        DimensionValue: Record 349;
        Name: Text;
        HeaderTxt: Label 'Employees Report';
}

