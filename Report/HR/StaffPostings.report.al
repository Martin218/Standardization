report 50268 "Staff Postings"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Staff Postings.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50229)
        {
            DataItemTableView = WHERE(Status = FILTER(Posted),
                                      Type = FILTER(Posting));
            column(No_EmployeeMovement; "No.")
            {
            }
            column(EmployeeNo_EmployeeMovement; "Employee No.")
            {
            }
            column(EmployeeName_EmployeeMovement; "Employee Name")
            {
            }
            column(IDNumber_EmployeeMovement; "ID Number")
            {
            }
            column(Gender_EmployeeMovement; Gender)
            {
            }
            column(EmploymentDate_EmployeeMovement; "Employment Date")
            {
            }
            column(CurrentBranch_EmployeeMovement; "Current Branch")
            {
            }
            column(CurrentDepartment_EmployeeMovement; "Current Department")
            {
            }
            column(CurrentJobTiltle_EmployeeMovement; "Current Job Tiltle")
            {
            }
            column(CurrentGrade_EmployeeMovement; "Current Grade")
            {
            }
            column(NewBranchCode_EmployeeMovement; "New Branch Code")
            {
            }
            column(NewBranchName_EmployeeMovement; "New Branch Name")
            {
            }
            column(NewDepartmentCode_EmployeeMovement; "New Department Code")
            {
            }
            column(NewDepartmentName_EmployeeMovement; "New Department Name")
            {
            }
            column(NewJobTitle_EmployeeMovement; "New Job Title")
            {
            }
            column(NewGrade_EmployeeMovement; "New Grade")
            {
            }
            column(NewSalary_EmployeeMovement; "New Salary")
            {
            }
            column(TransferDate_EmployeeMovement; Date)
            {
            }
            column(Status_EmployeeMovement; Status)
            {
            }
            column(CreatedBy_EmployeeMovement; "Created By")
            {
            }
            column(CreatedDate_EmployeeMovement; "Created Date")
            {
            }
            column(CreatedTime_EmployeeMovement; "Created Time")
            {
            }
            column(PostedBy_EmployeeMovement; "Posted By")
            {
            }
            column(PostedDate_EmployeeMovement; "Posted Date")
            {
            }
            column(PostedTime_EmployeeMovement; "Posted Time")
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
            column(HeaderText; HeaderText)
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
        CompanyInformation: Record 79;
        HeaderText: Label 'Staff Postings Report';
}

