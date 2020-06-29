report 50258 "Leave Calendar Plan"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Leave Calendar Plan.rdlc';
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
            column(Days_1; Days[1])
            {
            }
            column(Days_2; Days[2])
            {
            }
            column(Days_3; Days[3])
            {
            }
            column(Days_4; Days[4])
            {
            }
            column(Days_5; Days[5])
            {
            }
            column(Days_6; Days[6])
            {
            }
            column(Days_7; Days[7])
            {
            }
            column(Days_8; Days[8])
            {
            }
            column(Days_9; Days[9])
            {
            }
            column(Days_10; Days[10])
            {
            }
            column(Days_11; Days[11])
            {
            }
            column(Days_12; Days[12])
            {
            }
            column(Submitted; Submitted)
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
        LeaveDays: array[4] of Decimal;
        HRManagement: Codeunit 50050;
        Days: array[12] of Decimal;
        Submitted: Boolean;

    procedure GetLeaveBalances(EmployeeNo: Code[20]);
    begin
        LeaveDays[1] := HRManagement.GetBalanceBroughtForward(EmployeeNo, 'ANNUAL', TODAY);
        LeaveDays[2] := HRManagement.GetAddedBackDays(EmployeeNo, 'ANNUAL', TODAY);
        LeaveDays[4] := LeaveDays[1] + LeaveDays[2] + LeaveDays[3];
    end;

    local procedure GetLeavePlanDays(EmployeeNo: Code[20]);
    var
        LeavePlan: Record 50210;
        LeavePlanLines: Record 50213;
    begin
        CLEAR(Days);
        Submitted := FALSE;
        LeavePlan.RESET;
        LeavePlan.SETRANGE(Year, DATE2DMY(TODAY, 3));
        LeavePlan.SETRANGE("Employee No", EmployeeNo);
        IF LeavePlan.FINDLAST THEN BEGIN
            LeavePlanLines.RESET;
            LeavePlanLines.SETRANGE("No.", LeavePlan."No.");
            IF LeavePlanLines.FINDSET THEN BEGIN
                REPEAT
                    SumDays(DATE2DMY(LeavePlanLines."Start Date", 2), LeavePlanLines.Days);
                UNTIL LeavePlanLines.NEXT = 0;
            END;
            IF LeavePlan.Status = LeavePlan.Status::Released THEN BEGIN
                Submitted := TRUE;
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

    local procedure SumDays(Month: Integer; DaysInPlan: Decimal);
    begin
        CASE Month OF
            1:
                BEGIN
                    Days[1] += DaysInPlan;
                END;
            2:
                BEGIN
                    Days[2] += DaysInPlan;
                END;
            3:
                BEGIN
                    Days[3] += DaysInPlan;
                END;
            4:
                BEGIN
                    Days[4] += DaysInPlan;
                END;
            5:
                BEGIN
                    Days[5] += DaysInPlan;
                END;
            6:
                BEGIN
                    Days[6] += DaysInPlan;
                END;
            7:
                BEGIN
                    Days[7] += DaysInPlan;
                END;
            8:
                BEGIN
                    Days[8] += DaysInPlan;
                END;
            9:
                BEGIN
                    Days[9] += DaysInPlan;
                END;
            10:
                BEGIN
                    Days[10] += DaysInPlan;
                END;
            11:
                BEGIN
                    Days[11] += DaysInPlan;
                END;
            12:
                BEGIN
                    Days[12] += DaysInPlan;
                END;
        END;
    end;
}

