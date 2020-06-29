report 50266 "Reference Check Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Reference Check Report.rdlc';


    dataset
    {
        dataitem(DataItem1; 5200)
        {
            RequestFilterFields = "No.";
            column(No_Employee; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(IDNumber_Employee; "ID Number")
            {
            }
            column(BranchName_Employee; "Branch Name")
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
            column(Status_Employee; Status)
            {
            }
            column(CertificateNo_Employee; "Certificate No.")
            {
            }
            column(ReferenceNo_Employee; "Reference No.")
            {
            }
            column(DateofCertificate_Employee; "Date of Certificate")
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
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(HeaderTxt000; HeaderTxt000)
            {
            }
            column(HeaderTxt001; HeaderTxt001)
            {
            }
            column(HeaderTxt002; HeaderTxt002)
            {
            }
            column(HeaderTxt003; HeaderTxt003)
            {
            }
            dataitem(DataItem18; 50211)
            {
                DataItemLink = "Employee No." = FIELD("No.");
                column(EmployeeNo_HRReferenceCheck; "Employee No.")
                {
                }
                column(RefereeName_HRReferenceCheck; "Referee Name")
                {
                }
                column(PhoneNo_HRReferenceCheck; "Phone No")
                {
                }
                column(Email_HRReferenceCheck; Email)
                {
                }
                column(CompanyName_HRReferenceCheck; "Company Name")
                {
                }
                column(YearsofEngagement_HRReferenceCheck; "Years of Engagement")
                {
                }
                column(Recommendation_HRReferenceCheck; Recommendation)
                {
                }
                column(Recommend_HRReferenceCheck; Recommend)
                {
                }
                column(Remarks_HRReferenceCheck; Remarks)
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
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
        CompanyInformation.GET
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        Name: Text;
        CompanyInformation: Record 79;
        HeaderTxt000: Label 'Reference Check Report';
        HeaderTxt001: Label 'Employee Details';
        HeaderTxt002: Label 'Police Clearance Certificate';
        HeaderTxt003: Label 'Reference Details';
}

