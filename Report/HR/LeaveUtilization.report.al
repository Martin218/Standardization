report 50259 "Leave Utilization Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Leave Utilization Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 5200)
        {
            column(No_Employee; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(BranchName_Employee; "Branch Name")
            {
            }
            column(DepartmentName_Employee; "Department Name")
            {
            }
            column(EmploymentDate_Employee; "Employment Date")
            {
            }
            column(Status_Employee; Status)
            {
            }
            column(JobTitle_Employee; "Job Title")
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
            column(SNo; SNo)
            {
            }
            column(BalanceBroughtForward; LeaveDays[1])
            {
            }
            column(AddedBackDays; LeaveDays[2])
            {
            }
            column(LeaveEntitlement; LeaveDays[3])
            {
            }
            column(TotalLeaveDays; LeaveDays[4])
            {
            }
            column(LeavePlan; LeaveDays[5])
            {
            }
            column(DaysTaken; LeaveDays[6])
            {
            }
            column(LeaveBalance; LeaveDays[7])
            {
            }
            column(Variance; LeaveDays[8])
            {
            }
            column(UtilizationStatus; UtilizationStatus)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Name := FullName;
                SNo += 1;
                GetLeaveEntitlement;
                GetLeaveBalances("No.");
                GetLeavePlanDays("No.");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Date Filter"; DateFilter)
                {
                    ApplicationArea = All;
                }
            }
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
        Name: Text;
        CompanyInformation: Record 79;
        SNo: Integer;
        LeaveDays: array[10] of Decimal;
        HRManagement: Codeunit 50050;
        DateFilter: Date;
        UtilizationStatus: Option Excess,Deficit;

    local procedure GetLeaveBalances(EmployeeNo: Code[20]);
    begin
        LeaveDays[1] := HRManagement.GetBalanceBroughtForward(EmployeeNo, 'ANNUAL', TODAY);
        LeaveDays[2] := HRManagement.GetAddedBackDays(EmployeeNo, 'ANNUAL', TODAY);
        LeaveDays[4] := LeaveDays[1] + LeaveDays[2] + LeaveDays[3];
        LeaveDays[6] := HRManagement.GetUsedLeaveDays(EmployeeNo, 'ANNUAL', DateFilter);
        LeaveDays[7] := LeaveDays[4] - LeaveDays[6];
        LeaveDays[8] := LeaveDays[5] - LeaveDays[7];
        IF LeaveDays[8] < 0 THEN
            UtilizationStatus := UtilizationStatus::Deficit
        ELSE
            UtilizationStatus := UtilizationStatus::Excess;
    end;

    local procedure GetLeavePlanDays(EmployeeNo: Code[20]);
    var
        LeavePlan: Record 50210;
        LeavePlanLines: Record 50213;
    begin
        LeavePlan.RESET;
        LeavePlan.SETRANGE(Year, DATE2DMY(TODAY, 3));
        LeavePlan.SETRANGE("Employee No", EmployeeNo);
        IF LeavePlan.FINDLAST THEN BEGIN
            LeavePlanLines.RESET;
            LeavePlanLines.SETRANGE("No.", LeavePlan."No.");
            LeavePlanLines.SETFILTER("Start Date", '<=%1', DateFilter);
            IF LeavePlanLines.FINDSET THEN BEGIN
                REPEAT
                    LeaveDays[5] += LeavePlanLines.Days;
                UNTIL LeavePlanLines.NEXT = 0;
            END;
        END;
    end;

    local procedure GetLeaveEntitlement();
    var
        LeaveType: Record 50208;
    begin
        LeaveType.RESET;
        LeaveType.SETRANGE("Annual Leave", TRUE);
        IF LeaveType.FINDFIRST THEN;
        LeaveDays[3] := LeaveType.Days;
    end;
}

