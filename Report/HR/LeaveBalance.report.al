report 50257 "Leave Balance"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\Leave Balance.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1000000016; 5200)
        {
            RequestFilterFields = "No.", Status;
            column(No_Employee; "No.")
            {
            }
            column(Name; Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(DateFilter; STRSUBSTNO('AS AT %1', DateFilter))
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
            column(serialno; SNo)
            {
            }
            column(DateOfJoin2_Employee; "Employment Date")
            {
            }
            column(CompanyInfo_Name; CompanyInfo.Name)
            {
            }
            column(CompanyInfo_Address; CompanyInfo.Address)
            {
            }
            column(CompanyInfo_PostCode; CompanyInfo."Post Code")
            {
            }
            column(CompanyInfo_City; CompanyInfo.City)
            {
            }
            column(BalanceBroughtForward; LeaveDays[1])
            {
            }
            column(EarnedDays; LeaveDays[2])
            {
            }
            column(LostDays; LeaveDays[3])
            {
            }
            column(TotalTaken; LeaveDays[4])
            {
            }
            column(TotalRecall; LeaveDays[5])
            {
            }
            column(AddedDays; LeaveDays[6])
            {
            }
            column(Balance; LeaveDays[7])
            {
            }
            column(Provision; LeaveDays[8])
            {
            }

            trigger OnAfterGetRecord();
            begin
                Name := FullName;
                GetLeaveBalances("No.");
                SNo += 1;
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
                field(LeaveFilter; LeaveFilter)
                {
                    TableRelation = "Leave Type";
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
        // Label = 'Leave Balance Report';
    }

    trigger OnInitReport();
    begin
        SNo := 0;
        CompanyInfo.GET;
        LeaveFilter := 'ANNUAL';
    end;

    trigger OnPreReport();
    begin
        CompanyInfo.CALCFIELDS(Picture);

        IF DateFilter = 0D THEN BEGIN
            ERROR('Please specify a date filter!');
        END;
    end;

    var
        Name: Text[50];
        CompanyInfo: Record 79;
        ANNUAL_LEAVE_BALANCE_CaptionLbl: Label '"ANNUAL LEAVE BALANCE "';
        CurrReport_PAGENOCaptionLbl: Label 'Page';
        Staff_No_CaptionLbl: Label 'Staff No.';
        NameCaptionLbl: Label 'Name';
        Balance_B_FCaptionLbl: Label 'Balance B/F';
        BalanceCaptionLbl: Label 'Balance';
        EntitlmentCaptionLbl: Label 'Entitlment';
        Days_TakenCaptionLbl: Label 'Days Taken';
        Days_RecalledCaptionLbl: Label 'Days Recalled';
        Days_AbsentCaptionLbl: Label 'Days Absent';
        DateFilter: Date;
        StartDate: Date;
        EndDate: Date;
        LeaveDays: array[10] of Decimal;
        HRManagement: Codeunit 50050;
        SNo: Integer;
        LeaveFilter: Code[10];
        LeaveType: Record 50208;

    local procedure GetLeaveBalances(EmployeeNo: Code[10]);
    begin
        LeaveDays[1] := HRManagement.GetBalanceBroughtForward(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[2] := HRManagement.GetEarnedLeaveDays(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[3] := HRManagement.GetLostDays(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[4] := HRManagement.GetUsedLeaveDays(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[5] := HRManagement.GetRecalledDays(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[6] := HRManagement.GetAddedBackDays(EmployeeNo, LeaveFilter, DateFilter);
        LeaveDays[7] := LeaveDays[1] + LeaveDays[2] + LeaveDays[3] + LeaveDays[5] + LeaveDays[6] - LeaveDays[4];
    end;
}

