table 50206 "Leave Application"
{
    // version TL2.0


    fields
    {
        field(1; "Application No"; Code[20])
        {
            Editable = false;
            NotBlank = false;
        }
        field(2; "Employee No"; Code[20])
        {
            NotBlank = false;
            TableRelation = Employee."No.";

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee.FullName();
                    Branch := Employee."Branch Name";
                    "Job Title" := Employee."Job Title";
                    Department := Employee."Department Name";
                    "Employment Date" := Employee."Employment Date";
                    "Mobile No" := Employee."Mobile Phone No.";
                END;
            end;
        }
        field(3; "Start Date"; Date)
        {
        }
        field(4; "End Date"; Date)
        {

            trigger OnValidate();
            begin
                HRManagement.CalculateResumptionDate(Rec);
            end;
        }
        field(5; "Application Date"; Date)
        {
            Editable = false;
        }
        field(7; "Leave balance"; Decimal)
        {
            Editable = false;

            trigger OnValidate();
            begin
                "Leave balance" := "Balance brought forward" + "Leave Earned to Date" + "Recalled Days" + "Added Back Days" - "Total Leave Days Taken";
            end;
        }
        field(8; "Employee Name"; Text[50])
        {
            Editable = false;
        }
        field(9; "Total Leave Days Taken"; Decimal)
        {
            Editable = false;
        }
        field(10; "Duties Taken Over By"; Code[30])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Duties Taken Over By") THEN BEGIN
                    "Substitute Name" := Employee.FullName();
                    Branch := Employee."Branch Name";
                    "Job Title" := Employee."Job Title";
                END;
            end;
        }
        field(11; Name; Text[50])
        {
        }
        field(12; "Mobile No"; Code[20])
        {
            Editable = false;
        }
        field(13; "Balance brought forward"; Decimal)
        {
            Editable = false;
        }
        field(14; "Leave Earned to Date"; Decimal)
        {
            Editable = false;
        }
        field(16; "Recalled Days"; Decimal)
        {
            Editable = false;
        }
        field(17; "User ID"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(18; Branch; Text[50])
        {
            Editable = false;
        }
        field(19; "Job Title"; Text[70])
        {
            Editable = false;
        }
        field(20; "Lost Days"; Decimal)
        {
            Editable = false;
        }
        field(21; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(23; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type" WHERE(Status = FILTER(Active));

            trigger OnValidate();
            begin
                IF xRec.Status <> Status::Open THEN
                    ERROR(Error000);

                IF LeaveType.GET("Leave Code") THEN BEGIN
                    "Leave Entitlment" := LeaveType.Days;
                END;

                HRManagement.ValidateLeaveTypeByGender(Rec);
                HRManagement.ValidateLeaveTypeByEmployeeType(Rec);
                HRManagement.ValidateLeaveTypeByConfirmationStatus(Rec);

                "Total Leave Days Taken" := HRManagement.GetUsedLeaveDays("Employee No", "Leave Code", TODAY);
                "Leave Earned to Date" := HRManagement.GetEarnedLeaveDays("Employee No", "Leave Code", TODAY);
                "Recalled Days" := HRManagement.GetRecalledDays("Employee No", "Leave Code", TODAY);
                "Lost Days" := HRManagement.GetLostDays("Employee No", "Leave Code", TODAY);
                "Added Back Days" := HRManagement.GetAddedBackDays("Employee No", "Leave Code", TODAY);
                "Balance brought forward" := HRManagement.GetBalanceBroughtForward("Employee No", "Leave Code", TODAY);

                VALIDATE("Leave balance");
            end;
        }
        field(24; "Days Applied"; Decimal)
        {

            trigger OnValidate();
            begin
                IF "Days Applied" = 0 THEN BEGIN
                    VALIDATE("Leave balance");
                END ELSE BEGIN
                    "Leave balance" := "Leave balance" - "Days Applied";
                    IF LeaveType.GET("Leave Code") THEN BEGIN
                        IF LeaveType.Weekdays THEN BEGIN
                            "End Date" := HRManagement.CalculateLeaveEndDate("Days Applied", "Start Date");
                        END;
                        IF LeaveType."Calendar Days" THEN BEGIN
                            IF "Days Applied" MOD 1 = 0 THEN BEGIN
                                "End Date" := CALCDATE(FORMAT("Days Applied" - 1) + 'D', "Start Date");
                            END ELSE BEGIN
                                "End Date" := CALCDATE(FORMAT("Days Applied" DIV 1) + 'D', "Start Date");
                            END;
                        END;
                    END;
                    VALIDATE("End Date");
                END;
            END;
        }
        field(25; "Resumption Date"; Date)
        {
        }
        field(26; Status; Option)
        {
            Editable = true;
            OptionCaption = 'Open,Pending Approval,Released,Rejected';
            OptionMembers = Open,"Pending Approval",Released,Rejected;
        }
        field(27; Department; Text[50])
        {
            Editable = false;
        }
        field(28; "Reason for Cancelling"; Text[250])
        {
        }
        field(29; "Reason for Leave"; Text[250])
        {
        }
        field(31; "Leave Entitlment"; Decimal)
        {
            Editable = false;
        }
        field(32; "Off Days"; Decimal)
        {
            DecimalPlaces = 0 : 0;
            Editable = false;
        }
        field(33; "Added Back Days"; Decimal)
        {
            Editable = false;
        }
        field(36; "Substitute Name"; Text[50])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Application No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Application No", "Leave Code", "Employee No", "Employee Name", "Start Date", "End Date", "Days Applied")
        {
        }
    }

    trigger OnInsert();
    begin

        HumanResourcesSetup.GET;
        "Application No" := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Leave Nos.", TODAY, TRUE);
        "Application Date" := TODAY;
        "User ID" := USERID;
        IF UserSetup.GET(USERID) THEN BEGIN
            // "Employee No" := UserSetup."Employee No.";
            VALIDATE("Employee No");
        END;
    end;

    var
        Employee: Record 5200;
        NoSeriesManagement: Codeunit 396;
        UserSetup: Record 91;
        HumanResourcesSetup: Record 5218;
        LeaveLedgerEntry: Record 50209;
        LeaveType: Record 50208;
        NoofMonthsWorked: Integer;
        FiscalStart: Date;
        Nextmonth: Date;
        EmployeeLeavePlan1: Record 50213;
        annualdays: Decimal;
        bfdays: Decimal;
        entitleddays: Decimal;
        HRManagement: Codeunit 50050;
        Error000: Label 'You cannot change an already approved document';
}

