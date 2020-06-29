table 50213 "Leave Plan Line"
{
    // version TL2.0

    Permissions = TableData 7601 = rimd;

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate();
            begin
                UpdateBalance;
            end;
        }
        field(2; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(3; Days; Decimal)
        {

            trigger OnValidate();
            begin
                Balance -= Days;
                IF Balance < 0 THEN
                    ERROR(Error000);
            end;
        }
        field(4; "Start Date"; Date)
        {

            trigger OnValidate();
            begin
                ValidateStartDate;
                 "End Date":=HRManagement.CalculateLeaveEndDate(Days,"Start Date");
            end;
        }
        field(5; "End Date"; Date)
        {
            Editable = false;
        }
        field(6; Balance; Decimal)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRManagement: Codeunit 50050;
        LeavePlanLines: Record 50213;

        Error000: Label 'Your leave balance cannot be negative!';
        Error001: Label 'Start date has already been captured!';
        Error002: Label 'You have exhausted all your leave days!';

    local procedure UpdateBalance();
    begin
        LeavePlanLines.RESET;
        LeavePlanLines.SETRANGE("No.", "No.");
        IF LeavePlanLines.FINDLAST THEN BEGIN
            IF LeavePlanLines.Balance <> 0 THEN
                Balance := LeavePlanLines.Balance
            ELSE
                ERROR(Error002);
        END;
    end;

    local procedure ValidateStartDate();
    begin
        LeavePlanLines.RESET;
        LeavePlanLines.SETRANGE("No.", "No.");
        LeavePlanLines.SETFILTER("Line No.", '<>%1', Rec."Line No.");
        IF LeavePlanLines.FINDSET THEN BEGIN
            REPEAT
                IF (LeavePlanLines."Start Date" <= Rec."Start Date") AND (LeavePlanLines."End Date" > Rec."Start Date") THEN BEGIN
                    ERROR(Error001);
                END;
            UNTIL LeavePlanLines.NEXT = 0;
        END;
    end;

    procedure ResetLines(PlanNo: Code[10]);
    var
        LeavePlan: Record 50210;
    begin
        LeavePlanLines.RESET;
        LeavePlanLines.SETRANGE("No.", PlanNo);
        IF LeavePlanLines.FINDSET THEN
            LeavePlanLines.DELETEALL;

        IF LeavePlan.GET(PlanNo) THEN BEGIN
            LeavePlanLines.INIT;
            LeavePlanLines."No." := PlanNo;
            LeavePlanLines.Balance := LeavePlan."Total Leave Days";
            LeavePlanLines.INSERT;
        END;
    end;
}

