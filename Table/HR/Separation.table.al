table 50237 Separation
{
    // version TL2.0


    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            var
                Employee: Record 5200;
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    Department := Employee.Department;
                    Branch := Employee."Global Dimension 1 Code";
                    "Job Title" := Employee."Job Title";
                    "Employment Date" := Employee."Employment Date";
                    "Department Name" := Employee."Department Name";
                    "Basic Salary" := Employee."Basic Pay";
                    "Leave Days Earned to Date" := HRManagement.GetLeaveBalance("Employee No.", 'ANNUAL', TODAY);
                    //InsertClearanceLines;
                    // InsertExitInterviewQuestions;
                END ELSE BEGIN
                    "Employee Name" := '';
                    Department := '';
                END;
            end;
        }
        field(2; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(3; "Separation Date"; Date)
        {
            trigger OnValidate();
            begin
                "Last Working Date" := "Separation Date";
            end;
        }
        field(4; "Grounds for Separation"; Code[20])
        {
            TableRelation = "Grounds for Termination".Code;
        }
        field(5; "Last Working Date"; Date)
        {
            trigger OnValidate();
            begin
                HRManagement.GetLeaveBalance("Employee No.", 'ANNUAL', "Last Working Date");
                IF "Last Working Date" < "Notification End Date" THEN
                    "Days In Lieu of Notice" := "Notification End Date" - "Last Working Date"
                ELSE
                    "Days In Lieu of Notice" := 0;
            end;
        }
        field(6; Department; Code[20])
        {
            Editable = false;
        }
        field(20; Completed; Boolean)
        {

            trigger OnValidate();
            begin
                Total := "Pay for Outstanding Leave Days" + "Salary(Full Month)" + "Part Salary to be paid" + "Leave Alowance Paid" + "Car Allowance" + "Golden Handshake" + "Transport Allowance" + "Severence Pay" + "Car Allowance(Months)";
                "PAYE Due" := 0;

                LookupTableLine.RESET;
                LookupTableLine.SETRANGE("Table Code", 'PAYE');
                LookupTableLine.SETFILTER("Lower Limit", '<%1', Total);
                IF LookupTableLine.FINDSET THEN BEGIN
                    REPEAT
                        IF LookupTableLine."Upper Limit" < Total THEN BEGIN

                            //       "PAYE Due" += LookupTableLine."Relief Amount";

                        END;
                        IF LookupTableLine."Upper Limit" > Total THEN BEGIN
                            "PAYE Due" := "PAYE Due" + (((Total - LookupTableLine."Lower Limit") * LookupTableLine.Percentage) / 100);
                        END;
                    UNTIL LookupTableLine.NEXT = 0;
                END;
                LookupTableLine.RESET;
                LookupTableLine.SETRANGE("Table Code", 'RELIEF');
                IF LookupTableLine.FINDFIRST THEN BEGIN
                    "PAYE Due" := "PAYE Due" - LookupTableLine."Amount Charged";
                END;

                "Total after PAYE" := Total - "PAYE Due";
                "Amount Payable" := "Total after PAYE" - "Amount In Lieu of Notice" - "Total Deductions";
            end;
        }
        field(21; "Separation Type"; Text[100])
        {
            TableRelation = "Separation Type";

            trigger OnValidate();
            begin
                IF SeperationTypes.GET("Separation Type") THEN BEGIN
                    EVALUATE("Notice Period", FORMAT(FORMAT(SeperationTypes."Notice Period") + FORMAT('D')));
                    "Golden Handshake" := SeperationTypes."Golden Handshake";
                    "Transport Allowance" := SeperationTypes."Transport Allowance";
                END;
            end;
        }
        field(22; "Notification Start Date"; Date)
        {

            trigger OnValidate();
            begin
                VALIDATE("Notice Period");
                "Last Working Date" := "Notification End Date";
            end;
        }
        field(23; "Notification End Date"; Date)
        {
            Editable = false;
        }
        field(24; "Last Working Day"; Date)
        {
        }
        field(25; "In Lieu of Notice"; Decimal)
        {
        }
        field(26; "Notice Period"; DateFormula)
        {

            trigger OnValidate();
            begin
                "Notification End Date" := CALCDATE("Notice Period", "Notification Start Date");
            end;
        }
        field(27; "Golden Handshake"; Decimal)
        {
        }
        field(28; "Transport Allowance"; Decimal)
        {
        }
        field(29; "Service Pay"; Option)
        {
            OptionCaption = 'Yes,No';
            OptionMembers = Yes,No;
        }
        field(30; "No. Of Months Salary"; Integer)
        {

            trigger OnValidate();
            begin
                "Salary(Full Month)" := "No. Of Months Salary" * "Basic Salary";
            end;
        }
        field(31; "Notification Procedure"; Text[100])
        {
        }
        field(32; "Salary of Staff"; Decimal)
        {
        }
        field(33; "Leave balance"; Decimal)
        {
        }
        field(34; "Leave Allowance"; Decimal)
        {
        }
        field(35; "Staff Loans"; Decimal)
        {
        }
        field(36; "Leave Accrual End Date"; Date)
        {
        }
        field(37; "Reason for Separation"; Text[250])
        {
        }
        field(38; Status; Option)
        {
            OptionCaption = 'Open,Approved,Closed,Pending Approval';
            OptionMembers = Open,Approved,Closed,"Pending Approval";
        }
        field(39; "Clearance Form"; Text[250])
        {
        }
        field(40; "Separation Form"; Text[250])
        {
        }
        field(41; "Separation No"; Code[10])
        {
            Editable = false;
        }
        field(42; "Separation Status"; Option)
        {
            OptionCaption = 'New,Processing,Processed';
            OptionMembers = New,Processing,Processed;
        }
        field(44; "Employment Date"; Date)
        {
        }
        field(45; Branch; Text[50])
        {
        }
        field(47; "Job Title"; Text[100])
        {
        }
        field(48; "No. Series"; Code[10])
        {
        }
        field(49; "Department Name"; Text[100])
        {
        }
        field(50; "Leave Days Last Accrual Date"; Date)
        {
        }
        field(51; "Leave Days Earned to Date"; Decimal)
        {
        }
        field(52; "Leave Days in Notice"; Decimal)
        {

            trigger OnValidate();
            begin
                "Outstanding Leave Days" := "Leave Days Earned to Date" - "Leave Days in Notice";
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
                //"Days In Lieu of Notice":="Days In Lieu of Notice"-"Leave Days in Notice";
            end;
        }
        field(53; "Outstanding Leave Days"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
            end;
        }
        field(54; "Basic Salary"; Decimal)
        {
        }
        field(55; "Salary(Full Month)"; Decimal)
        {
        }
        field(56; "Salary(Extra Days)"; Decimal)
        {

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN
                    "Part Salary to be paid" := "Salary(Extra Days)" * ("Basic Salary" / 30);
            end;
        }
        field(57; "Leave Alowance Paid"; Decimal)
        {
        }
        field(58; "Car Allowance"; Decimal)
        {
        }
        field(59; "Days In Lieu of Notice"; Decimal)
        {
        }
        field(60; "PAYE Due"; Decimal)
        {
        }
        field(61; "Staff Loans/Lost Items"; Decimal)
        {
        }
        field(62; "Medical Expenses"; Decimal)
        {
        }
        field(64; "Part Salary to be paid"; Decimal)
        {

            trigger OnValidate();
            begin
                HRSeparation.RESET;
                HRSeparation.SETRANGE("Employee No.", "Employee No.");
                IF HRSeparation.FIND('-') THEN BEGIN
                    MonthNo := DATE2DMY("Notification End Date", 2);
                    YearNo := DATE2DMY("Notification End Date", 3);
                    MonthBegin := CALCDATE('-CM', DMY2DATE(1, MonthNo, YearNo));
                    MonthEnd := CALCDATE('CM', DMY2DATE(1, MonthNo, YearNo));
                    DaysInMonth := 0;
                    cDay := MonthBegin;

                    REPEAT
                        //     IF NOT CalMgt.CheckDateStatus(CalendarCode, cDay, DescriptionText) THEN
                        DaysInMonth += 1;
                        cDay := CALCDATE('+1D', cDay);
                    UNTIL (cDay > MonthEnd);
                END;
                //END;
            end;
        }
        field(65; "Pay for Outstanding Leave Days"; Decimal)
        {
        }
        field(66; "Pay Car Allowance"; Boolean)
        {
        }
        field(67; "No of Days for Car Allowance"; Decimal)
        {

            trigger OnValidate();
            begin
                Employee.RESET;
                Employee.SETRANGE("No.", "Employee No.");
                IF Employee.FINDFIRST THEN BEGIN
                    HRSeparation.RESET;
                    HRSeparation.SETRANGE("Employee No.", "Employee No.");
                    IF HRSeparation.FIND('-') THEN BEGIN
                        MonthNo := DATE2DMY(HRSeparation."Last Working Date", 2);
                        YearNo := DATE2DMY(HRSeparation."Last Working Date", 3);
                        MonthBegin := CALCDATE('-CM', DMY2DATE(1, MonthNo, YearNo));
                        MonthEnd := CALCDATE('CM', DMY2DATE(1, MonthNo, YearNo));
                        DaysInMonth := 0;
                        cDay := MonthBegin;

                        REPEAT
                            //     IF NOT CalMgt.CheckDateStatus(CalendarCode, cDay, DescriptionText) THEN
                            DaysInMonth += 1;
                            cDay := CALCDATE('+1D', cDay);
                        UNTIL (cDay > MonthEnd);
                    END;

                END;
            end;
        }
        field(68; "Pay Leave Allowance"; Boolean)
        {
        }
        field(69; "Total Deductions"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Employee Deduction Line".Amount WHERE("Employee No" = FIELD("Employee No.")));
            Editable = false;

        }
        field(70; Total; Decimal)
        {
        }
        field(71; "Amount Payable"; Decimal)
        {
        }
        field(72; "Offset Leave Days"; Boolean)
        {

            trigger OnValidate();
            begin
                IF HRSeparation.GET("Employee No.", "Separation No") THEN BEGIN
                    days := 0;
                    days := HRSeparation."Notification End Date" - HRSeparation."Notification Start Date";
                    days += 1;
                END;

                IF "Offset Leave Days" = TRUE THEN BEGIN
                    IF "Days In Lieu of Notice" < "Outstanding Leave Days" THEN BEGIN
                        "Outstanding Leave Days" := "Outstanding Leave Days" - "Days In Lieu of Notice";
                        "Days In Lieu of Notice" := 0;
                    END ELSE BEGIN
                        "Days In Lieu of Notice" := "Days In Lieu of Notice" - "Outstanding Leave Days";
                        "Outstanding Leave Days" := 0;
                    END;
                    "Amount In Lieu of Notice" := ("Days In Lieu of Notice" * "Basic Salary" * 12) / 365;
                    // "Amount In Lieu of Notice":=("Days In Lieu of Notice"/days)*"Basic Salary";
                END ELSE BEGIN
                    "Amount In Lieu of Notice" := 0;
                END;
                VALIDATE("Outstanding Leave Days");
            end;
        }
        field(73; "Amount In Lieu of Notice"; Decimal)
        {
        }
        field(77; "Severence Pay"; Decimal)
        {
        }
        field(78; "No of Years Worked"; Integer)
        {
        }
        field(79; "No of Months Car Allowance"; Decimal)
        {
        }
        field(80; "Car Allowance(Months)"; Decimal)
        {
        }
        field(81; "Total after PAYE"; Decimal)
        {
        }
        field(82; "Leave Start Date"; Date)
        {

            trigger OnValidate();
            begin
                leavedays := 0;
                weekend := 0;
                "Leave End Date" := CALCDATE('1D', "Leave Start Date");
                REPEAT
                    BaseCalender.RESET;
                    BaseCalender.SETRANGE(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                    BaseCalender.SETRANGE(BaseCalender."Period Start", "Leave End Date");
                    BaseCalender.SETRANGE(BaseCalender."Period No.", 6);
                    IF BaseCalender.FIND('-') THEN BEGIN
                        weekend += 1;
                    END;
                    BaseCalender.RESET;
                    BaseCalender.SETRANGE(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                    BaseCalender.SETRANGE(BaseCalender."Period Start", "Leave End Date");
                    BaseCalender.SETRANGE(BaseCalender."Period No.", 7);
                    IF BaseCalender.FIND('-') THEN BEGIN
                        weekend += 1;
                    END;
                    "Leave End Date" := CALCDATE('1D', "Leave End Date");
                    leavedays += 1;
                UNTIL leavedays = "Leave Days in Notice" - 1;
                "Leave End Date" := CALCDATE(FORMAT(leavedays + weekend) + 'D', "Leave Start Date");

                BaseCalender.RESET;
                BaseCalender.SETRANGE(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                BaseCalender.SETRANGE(BaseCalender."Period Start", "Leave End Date");
                BaseCalender.SETRANGE(BaseCalender."Period No.", 6);
                IF BaseCalender.FIND('-') THEN BEGIN
                    "Leave End Date" := CALCDATE('1D', "Leave End Date");
                END;
                BaseCalender.RESET;
                BaseCalender.SETRANGE(BaseCalender."Period Type", BaseCalender."Period Type"::Date);
                BaseCalender.SETRANGE(BaseCalender."Period Start", "Leave End Date");
                BaseCalender.SETRANGE(BaseCalender."Period No.", 7);
                IF BaseCalender.FIND('-') THEN BEGIN
                    "Leave End Date" := CALCDATE('1D', "Leave End Date");
                END;
            end;
        }
        field(83; "Leave End Date"; Date)
        {
        }
        field(84; "Part Salary Start Date"; Date)
        {

            trigger OnValidate();
            begin
                "Part Salary End Date" := CALCDATE(FORMAT("Salary(Extra Days)" - 1) + 'D', "Part Salary Start Date");
            end;
        }
        field(85; "Part Salary End Date"; Date)
        {
        }
        field(86; "Part Car Allowance Start Date"; Date)
        {
        }
        field(87; "Part Car Allowance End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Separation No")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        HumanResSetup.GET;
        "Separation No" := NoSeriesMgt.GetNextNo(HumanResSetup."Separation No", 0D, TRUE);
    end;

    var
        NoSeriesMgt: Codeunit 396;
        CalMgt: Codeunit 7600;
        HRManagement: Codeunit 50050;
        lieudays: Integer;
        SeperationTypes: Record 50238;
        HumanResSetup: Record 5218;

        HRSeparation: Record 50237;
        MonthBegin: Date;
        MonthEnd: Date;
        DaysInMonth: Integer;
        cDay: Date;

        CalendarCode: Code[10];
        DescriptionText: Text;
        MonthNo: Integer;
        YearNo: Integer;
        days: Integer;
        year: Integer;
        BaseCalender: Record 2000000007;
        leavedays: Decimal;
        weekend: Decimal;
        Employee: Record 5200;
        LookupTableLine: Record "Bracket Line";
        EmployeeDeductionLine: Record 50258;


    local procedure InsertClearanceLines();
    begin
    end;

    local procedure InsertExitInterviewQuestions();
    begin
    end;
}

