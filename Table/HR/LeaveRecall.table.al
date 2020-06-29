table 50222 "Leave Recall"
{
    // version TL2.0

    //DrillDownPageID = 84059;
    //LookupPageID = 84059;

    fields
    {
        field(1; "Employee No"; Code[20])
        {
            TableRelation = Employee;
        }
        field(3; Date; Date)
        {

        }
        field(4; Approved; Boolean)
        {
        }
        field(5; "Leave Application"; Code[20])
        {
            TableRelation = "Leave Application" WHERE(Status = filter('Released'),
                                                       "Leave Code" = FILTER('<>SICK' | '<>MATERNITY'));

            trigger OnValidate();
            begin
                IF LeaveApplication.GET("Leave Application") THEN BEGIN
                    "Employee No" := LeaveApplication."Employee No";
                    "Employee Name" := LeaveApplication."Employee Name";
                    "Employee Job Title" := LeaveApplication."Job Title";
                    "Employee Branch" := LeaveApplication.Branch;
                    "Employee Department" := LeaveApplication.Department;
                    "Leave Start Date" := LeaveApplication."Start Date";
                    "Leave Ending Date" := LeaveApplication."End Date";
                    "Days Applied" := LeaveApplication."Days Applied";
                    "Leave Code" := LeaveApplication."Leave Code";
                    "Remaining Days" := LeaveApplication."End Date" - TODAY;
                END;
            end;
        }
        field(6; "Recall Date"; Date)
        {
        }
        field(7; "Recalled Days"; Decimal)
        {
            Editable = true;

            trigger OnValidate();
            begin
                IF "Recalled Days" > "Remaining Days" THEN
                    ERROR(ERROR000);

                IF "Recalled From" <> 0D THEN
                    "Recalled To" := HRManagement.CalculateLeaveEndDate("Recalled Days", "Recalled From");
            end;
        }
        field(8; "Leave Ending Date"; Date)
        {
        }
        field(10; "No. Series"; Code[10])
        {
        }
        field(11; "Employee Name"; Text[50])
        {
        }
        field(12; "No."; Code[20])
        {
        }
        field(13; Status; Option)
        {
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released;
        }
        field(15; "Recalled By"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Recalled By") THEN BEGIN
                    Name := Employee.FullName;
                    "Recall Branch" := Employee."Branch Name";
                    "Recall Department" := Employee."Department Name";
                    "Job Title" := Employee."Job Title";
                END;
            end;
        }
        field(16; Name; Text[50])
        {
            Editable = false;
        }
        field(17; "Reason for Recall"; Text[130])
        {
        }
        field(20; "Recalled From"; Date)
        {
            NotBlank = false;

            trigger OnValidate();
            begin
                "Recalled To" := HRManagement.CalculateLeaveEndDate("Recalled Days", "Recalled From");
            end;
        }
        field(21; "Recalled To"; Date)
        {
            NotBlank = false;
        }
        field(22; "Department Name"; Text[80])
        {
        }
        field(26; "Employee Department"; Text[50])
        {
        }
        field(27; "Employee Branch"; Text[50])
        {
        }
        field(28; "Leave Start Date"; Date)
        {
        }
        field(29; "Days Applied"; Decimal)
        {
        }
        field(30; "Recall Department"; Text[50])
        {
        }
        field(31; "Recall Branch"; Text[50])
        {
        }
        field(32; "Employee Job Title"; Text[70])
        {
        }
        field(33; "Job Title"; Text[70])
        {
        }
        field(34; "Leave Code"; Code[30])
        {
        }
        field(35; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(36; "Remaining Days"; Decimal)
        {
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
        IF "No." = '' THEN BEGIN
            HumanResSetup.GET;
            HumanResSetup.TESTFIELD(HumanResSetup."Leave Recall Nos.");
            NoSeriesMgt.InitSeries(HumanResSetup."Leave Recall Nos.", xRec."No. Series", 0D, "No.", "No. Series");
        END;

        Date := TODAY;
        "Recall Date" := TODAY;
    end;

    var

        HumanResSetup: Record 5218;
        NoSeriesMgt: Codeunit 396;
        UserSetup: Record 91;
        Employee: Record 5200;
        LeaveApplication: Record 50206;
        TEXT001: Label 'You are modifying leave recall data for %1 are you sure you want to do this.';
        TEXT002: Label 'The days you are trying to recall for %1 are more than the leave days applied they for.';
        HRManagement: Codeunit 50050;
        ERROR000: Label 'No. of days recalled cannot be greater than the remaining leave days!';

    procedure FindMaturityDate();
    var
        AccPeriod: Record 50;
    begin
    end;

    procedure ValidateFields();
    begin
        TESTFIELD("Leave Application");
        TESTFIELD("Employee No");
        TESTFIELD(Name);
        TESTFIELD("Leave Ending Date");
        TESTFIELD("Recalled From");
        TESTFIELD("Recalled To");
        TESTFIELD("Recalled By");
        TESTFIELD("Reason for Recall");
        TESTFIELD("Recall Date");

    end;
}

