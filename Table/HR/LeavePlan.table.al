table 50210 "Leave Plan Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;
        }
        field(2; "Employee No"; Code[30])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee.FullName();
                    "Branch Code" := Employee."Global Dimension 1 Code";
                    "Branch Name" := Employee."Branch Name";
                    "Job Title" := Employee."Job Title";
                    "Employment Date" := Employee."Employment Date";
                    "Department Code" := Employee."Global Dimension 2 Code";
                    "Department Name" := Employee."Department Name";
                    "Leave Code" := 'ANNUAL';
                    "Application Date" := TODAY;
                    CALCFIELDS("Leave Entitlement", "Balance Brought Forward", "Added Back Days");
                    "Total Leave Days" := "Leave Entitlement" + "Balance Brought Forward" + "Added Back Days";
                    LeavePlanLines.INIT;
                    LeavePlanLines."No." := "No.";
                    LeavePlanLines.Balance := "Total Leave Days";
                    LeavePlanLines.INSERT;
                END;
            end;
        }
        field(3; "Employee Name"; Text[40])
        {
            Editable = false;
        }
        field(4; "Leave Code"; Code[20])
        {
            TableRelation = "Leave Type";
        }
        field(5; "Leave Balance"; Decimal)
        {
            Editable = false;
        }
        field(6; "User ID"; Code[80])
        {
            Editable = false;
        }
        field(7; "Department Code"; Code[30])
        {
            Editable = false;
        }
        field(8; "Leave Entitlement"; Decimal)
        {
            CalcFormula = Lookup ("Leave Type".Days WHERE(Code = FIELD("Leave Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(10; "Application Date"; Date)
        {
            Editable = false;
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(13; "Days in Plan"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Plan Line".Days WHERE("No." = FIELD("No.")));
            Editable = false;

        }
        field(14; "Leave Earned to Date"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Ledger Entry".Days WHERE(Closed = FILTER('No'),
                                                               "Leave Code" = FIELD("Leave Code"),
                                                               "Employee No." = FIELD("Employee No"),
                                                               "Earned Leave Days" = FILTER('Yes')));
            Editable = false;

        }
        field(16; "Recalled Days"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Ledger Entry".Days WHERE(Closed = FILTER('No'),
                                                               "Leave Code" = FIELD("Leave Code"),
                                                               "Employee No." = FIELD("Employee No"),
                                                               Recall = FILTER('Yes')));
            Editable = false;

        }
        field(17; "Off Days"; Decimal)
        {
            Editable = false;
        }
        field(18; "Total Leave Days"; Decimal)
        {
            Editable = false;
        }
        field(19; "Department Name"; Text[70])
        {
            Editable = false;
        }
        field(20; "Branch Name"; Text[70])
        {
            Editable = false;
        }
        field(21; "Job Title"; Text[70])
        {
            Editable = false;
        }
        field(22; "Balance Brought Forward"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Ledger Entry".Days WHERE("Employee No." = FIELD("Employee No"),
                                                               "Leave Code" = FILTER('ANNUAL'),
                                                               Days = FILTER(> 0),
                                                               Closed = filter('No'),
                                                               "Balance Brought Forward" = FILTER('Yes')));
            Editable = false;

        }
        field(24; "Total Leave Days Taken"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Ledger Entry".Days WHERE(Closed = FILTER('No'),
                                                               "Leave Code" = FIELD("Leave Code"),
                                                               "Employee No." = FIELD("Employee No")));
            Editable = false;

        }
        field(25; "Branch Code"; Code[20])
        {
        }
        field(26; "Added Back Days"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Leave Ledger Entry".Days WHERE(Closed = filter('No'),
                                                               "Added Back Days" = filter('Yes'),
                                                               "Employee No." = FIELD("Employee No")));
            Editable = false;

        }
        field(27; Year; Integer)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResSetup.GET;
        "No." := NoSeriesMgt.GetNextNo(HumanResSetup."Leave Plan Nos.", TODAY, TRUE);
        IF UserSetup.GET(USERID) THEN BEGIN
            //   "Employee No" := UserSetup."Employee No.";
            VALIDATE("Employee No");
            "User ID" := USERID;
        END ELSE BEGIN
        END;

        Year := DATE2DMY(TODAY, 3)
    end;

    var
        UserSetup: Record 91;
        Employee: Record 5200;
        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        LeaveTypes: Record 50208;
        LeavePlanLines: Record 50213;
}

