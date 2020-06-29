report 50272 "Recruitment Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Recruitment Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50246)
        {
            RequestFilterFields = "Job ID", "Request Done By", "Department Requested", Branch, "Employee Type";
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(serialno; serialno)
            {
            }
            column(RecruitmentNo_Recruitment; "Recruitment Needs Code")
            {
            }
            column(RequestedPositions_Recruitment; "Requested Positions")
            {
            }
            column(RequestedBy_Recruitment; "Requested By")
            {
            }
            column(Name_Recruitment; Name)
            {
            }
            column(Branch_Recruitment; Branch)
            {
            }
            column(JobTitle_Recruitment; "Job Title")
            {
            }
            column(RequestDoneBy_Recruitment; "Request Done By")
            {
            }
            column(RecruitmentType_Recruitment; "Recruitment Type")
            {
            }
            column(RequestDate_Recruitment; "Request Date")
            {
            }
            column(Department_Recruitment; "Department Code")
            {
            }
            column(RequiredQualifications_Recruitment; "Required Qualifications")
            {
            }
            column(ExpectedResponsibilities_Recruitment; "Expected Responsibilities")
            {
            }
            column(HRRecommendation1_Recruitment; "HR Recommendation1")
            {
            }
            column(CEORecommendation_Recruitment; "CEO Recommendation")
            {
            }
            column(EmployeeType_Recruitment; "Employee Type")
            {
            }
            column(RecruitmentDate_Recruitment; "Recruitment Date")
            {
            }
            column(Status_Recruitment; Status)
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
        CompanyInformation.GET;
    end;

    trigger OnPreReport();
    begin
        CompanyInformation.CALCFIELDS(Picture);
    end;

    var
        serialno: Integer;
        CompanyInformation: Record 79;
}

