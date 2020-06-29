report 50284 "Employees Recruited"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Employees Recruited.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50246)
        {
            DataItemTableView = WHERE(Status = FILTER(Released));
            column(RecruitmentNo_RecruitmentRequest; "Recruitment Needs Code")
            {
            }
            column(JobID_RecruitmentRequest; "Job ID")
            {
            }
            column(Description_RecruitmentRequest; Description)
            {
            }
            column(RecruitmentDate_RecruitmentRequest; "Recruitment Date")
            {
            }
            column(JobTitleRequest_RecruitmentRequest; "Job Title Request")
            {
            }
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            dataitem(DataItem6; 50247)
            {
                DataItemLink = "Recruitment Code" = FIELD("Recruitment Needs Code");
                column(EmployeeNo_EmployeeRecruited; "Employee No")
                {
                }
                column(EmployeeName_EmployeeRecruited; "Employee Name")
                {
                }
                column(Branch_EmployeeRecruited; Branch)
                {
                }
                column(Department_EmployeeRecruited; Department)
                {
                }
                column(JobTitle_EmployeeRecruited; "Job Title")
                {
                }
                column(EmploymentDate_EmployeeRecruited; "Employment Date")
                {
                }
                column(HeaderText; HeaderText)
                {
                }
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
        CompanyInformation: Record 79;
        HeaderText: Label 'Employees Recruited Report';
}

