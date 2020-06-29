report 50265 "Staff Transfers"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Staff Transfers.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50229)
        {
            DataItemTableView = WHERE(Status = FILTER(Posted),
                                      Type = FILTER(Transfer));
            column(No_EmployeeTransfer; "No.")
            {
            }
            column(EmployeeNo_EmployeeTransfer; "Employee No.")
            {
            }
            column(EmployeeName_EmployeeTransfer; "Employee Name")
            {
            }
            column(IDNumber_EmployeeTransfer; "ID Number")
            {
            }
            column(Gender_EmployeeTransfer; Gender)
            {
            }
            column(EmploymentDate_EmployeeTransfer; "Employment Date")
            {
            }
            column(CurrentBranch_EmployeeTransfer; "Current Branch")
            {
            }
            column(CurrentDepartment_EmployeeTransfer; "Current Department")
            {
            }
            column(CurrentJobTiltle_EmployeeTransfer; "Current Job Tiltle")
            {
            }
            column(CurrentGrade_EmployeeTransfer; "Current Grade")
            {
            }
            column(NewBranchCode_EmployeeTransfer; "New Branch Code")
            {
            }
            column(NewBranchName_EmployeeTransfer; "New Branch Name")
            {
            }
            column(NewDepartmentCode_EmployeeTransfer; "New Department Code")
            {
            }
            column(NewDepartmentName_EmployeeTransfer; "New Department Name")
            {
            }
            column(NewJobTitle_EmployeeTransfer; "New Job Title")
            {
            }
            column(NewGrade_EmployeeTransfer; "New Grade")
            {
            }
            column(NewSalary_EmployeeTransfer; "New Salary")
            {
            }
            column(TransferDate_EmployeeTransfer; Date)
            {
            }
            column(Status_EmployeeTransfer; Status)
            {
            }
            column(CreatedBy_EmployeeTransfer; "Created By")
            {
            }
            column(CreatedDate_EmployeeTransfer; "Created Date")
            {
            }
            column(CreatedTime_EmployeeTransfer; "Created Time")
            {
            }
            column(PostedBy_EmployeeTransfer; "Posted By")
            {
            }
            column(PostedDate_EmployeeTransfer; "Posted Date")
            {
            }
            column(PostedTime_EmployeeTransfer; "Posted Time")
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
        HeaderText: Label 'Staff Transfers Report';
}

