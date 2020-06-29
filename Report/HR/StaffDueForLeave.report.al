report 50263 "Staff Due For Leave"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Staff Due For Leave.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50206)
        {
            DataItemTableView = WHERE(Status = FILTER(Released));
            column(EmployeeNo_LeaveApplication; "Employee No")
            {
            }
            column(StartDate_LeaveApplication; "Start Date")
            {
            }
            column(EndDate_LeaveApplication; "End Date")
            {
            }
            column(ApplicationDate_LeaveApplication; "Application Date")
            {
            }
            column(Leavebalance_LeaveApplication; "Leave balance")
            {
            }
            column(TotalLeaveDaysTaken_LeaveApplication; "Total Leave Days Taken")
            {
            }
            column(DutiesTakenOverBy_LeaveApplication; "Duties Taken Over By")
            {
            }
            column(MobileNo_LeaveApplication; "Mobile No")
            {
            }
            column(LeaveEarnedtoDate_LeaveApplication; "Leave Earned to Date")
            {
            }
            column(DateofJoiningCompany_LeaveApplication; "Employment Date")
            {
            }
            column(JobTitle_LeaveApplication; "Job Title")
            {
            }
            column(EmploymentDate_LeaveApplication; "Employment Date")
            {
            }
            column(DaysApplied_LeaveApplication; "Days Applied")
            {
            }
            column(ResumptionDate_LeaveApplication; "Resumption Date")
            {
            }
            column(ReasonforLeave_LeaveApplication; "Reason for Leave")
            {
            }
            column(SubstituteName_LeaveApplication; "Substitute Name")
            {
            }
            column(Picturse; CompanyInformation.Picture)
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(Status_LeaveApplication; Status)
            {
            }
            column(LeaveCode_LeaveApplication; "Leave Code")
            {
            }
            column(ApplicationNo_LeaveApplication; "Application No")
            {
            }
            column(EmployeeName_LeaveApplication; "Employee Name")
            {
            }
            column(Branch_LeaveApplication; Branch)
            {
            }
            column(Department_LeaveApplication; Department)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(HeaderText; HeaderText)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF "Start Date" < TODAY THEN
                    CurrReport.SKIP;
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
    end;

    var
        CompanyInformation: Record 79;
        LeaveApplication: Record 50206;
        HeaderText: Label 'Staff Due For Leave';
}

