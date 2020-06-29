report 50256 "Leave Recall Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Leave Recall Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50222)
        {
            column(EmployeeNo_OffDay; "Employee No")
            {
            }
            column(LeaveApplication_OffDay; "Leave Application")
            {
            }
            column(RecallDate_OffDay; "Recall Date")
            {
            }
            column(NoofOffDays_OffDay; "Recalled Days")
            {
            }
            column(LeaveEndingDate_OffDay; "Leave Ending Date")
            {
            }
            column(ReasonforRecall_OffDay; "Reason for Recall")
            {
            }
            column(RecalledFrom_OffDay; "Recalled From")
            {
            }
            column(RecalledTo_OffDay; "Recalled To")
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(EmployeeName_OffDay; "Employee Name")
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(EmployeeNo_LeaveRecall; "Employee No")
            {
            }
            column(EmployeeDepartment_LeaveRecall; "Employee Department")
            {
            }
            column(EmployeeBranch_LeaveRecall; "Employee Branch")
            {
            }
            column(LeaveStartDate_LeaveRecall; "Leave Start Date")
            {
            }
            column(DaysApplied_LeaveRecall; "Days Applied")
            {
            }
            column(RecallDepartment_LeaveRecall; "Recall Department")
            {
            }
            column(RecallBranch_LeaveRecall; "Recall Branch")
            {
            }
            column(EmployeeJobTitle_LeaveRecall; "Employee Job Title")
            {
            }
            column(LeaveCode_LeaveRecall; "Leave Code")
            {
            }
            column(Name_LeaveRecall; Name)
            {
            }

            trigger OnPreDataItem();
            begin
                CompanyInformation.GET;
                CompanyInformation.CALCFIELDS(Picture);


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

    var
        CompanyInformation: Record 79;
        Employee: Record 5200;
        EmpName: Code[80];
}

