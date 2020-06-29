report 50254 "End Year Leave Balance"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\End Year Leave Balance.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 5200)
        {
            RequestFilterFields = "No.";
            column(No_Employee; "No.")
            {
            }
            column(Name_Employee; Name)
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
            column(CompanyInformation_Name; CompanyInformation.Name)
            {
            }
            column(CompanyInformation_Address; CompanyInformation.Address)
            {
            }
            column(CompanyInformation_City; CompanyInformation.City)
            {
            }
            column(CompanyInformation_PostCode; CompanyInformation."Post Code")
            {
            }
            column(CompanyInformation_Picture; CompanyInformation.Picture)
            {
            }
            column(BalanceBF; LeaveDays[1])
            {
            }
            column(DaysEarnedCurrentYear; LeaveDays[2])
            {
            }
            column(DaysUsedCurrentYear; LeaveDays[3])
            {
            }
            column(BalanceAtCloseOfYear; LeaveDays[4])
            {
            }
            column(BalanceToBeCarriedForward; LeaveDays[5])
            {
            }
            column(LostDays; LeaveDays[6])
            {
            }
            column(SerialNo; SerialNo)
            {
            }
            column(ClosedYear; ClosedYear)
            {
            }
            column(Header; Header)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CalculateBalances("No.");
                SerialNo += 1;
                Name := FullName;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Year; ClosedYear)
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
        Header := headertxt + FORMAT(ClosedYear);
        IF ClosedYear = '' THEN
            ERROR(Error000);
        EVALUATE(LastDate, '01/01/' + ClosedYear);
        LastDate := CALCDATE('CY', LastDate);
    end;

    var
        CompanyInformation: Record 79;
        LeavePeriod: Record 50212;
        ClosedYear: Code[10];
        LeaveLedgerEntry: Record 50209;
        LeaveTypes: Record 50208;
        LeaveDays: array[9] of Decimal;
        LeaveApplication: Record 50206;
        SerialNo: Integer;
        headertxt: Label 'End Year Leave Balance for ';
        Header: Text;
        HRManagement: Codeunit 50050;
        Name: Text;
        LastDate: Date;
        Error000: label 'Kindly specify the year!';

    procedure CalculateBalances(EmpNo: Code[20]);
    begin
        LeaveTypes.RESET;
        LeaveTypes.SETFILTER("Max Carry Forward Days", '<>%1', 0);
        IF LeaveTypes.FINDFIRST THEN BEGIN
            LeaveDays[1] := HRManagement.GetBalanceBroughtForward(EmpNo, LeaveTypes.Code, LastDate);
            LeaveDays[2] := HRManagement.GetEarnedLeaveDays(EmpNo, LeaveTypes.Code, LastDate);
            LeaveDays[3] := HRManagement.GetUsedLeaveDays(EmpNo, LeaveTypes.Code, LastDate) * -1;
            LeaveDays[4] := HRManagement.GetLeaveBalance(EmpNo, LeaveTypes.Code, LastDate);
            IF LeaveTypes."Max Carry Forward Days" <= LeaveDays[4] THEN BEGIN
                LeaveDays[5] := LeaveTypes."Max Carry Forward Days";
                LeaveDays[6] := LeaveDays[4] - LeaveTypes."Max Carry Forward Days";
            END ELSE BEGIN
                LeaveDays[5] := LeaveDays[4];
                LeaveDays[6] := 0;
            END;
        END;
    end;
}

