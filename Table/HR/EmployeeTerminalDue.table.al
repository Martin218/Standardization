table 50243 "Employee Terminal Due"
{
    // version TL2.0


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No"; Code[20])
        {
        }
        field(3; "Separation Application No"; Code[10])
        {
        }
        field(4; "Leave Days Last Accrual Date"; Date)
        {
        }
        field(5; "Leave Days Earned to Date"; Decimal)
        {
        }
        field(6; "Leave Days in Notice"; Decimal)
        {

            trigger OnValidate();
            begin
                "Outstanding Leave Days" := "Leave Days Earned to Date" - "Leave Days in Notice";
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
                "Days In Lieu of Notice" := "Days In Lieu of Notice" - "Leave Days in Notice";
            end;
        }
        field(7; "Outstanding Leave Days"; Decimal)
        {

            trigger OnValidate();
            begin
                "Pay for Outstanding Leave Days" := ("Outstanding Leave Days" * "Basic Salary" * 12) / 365;
            end;
        }
        field(8; "Basic Salary"; Decimal)
        {
        }
        field(9; "Salary(Full Month)"; Decimal)
        {
        }
        field(10; "Salary(Extra Days)"; Decimal)
        {
        }
        field(11; "Leave Alowance Paid"; Decimal)
        {
        }
        field(12; "Car Allowance"; Decimal)
        {
        }
        field(13; "Days In Lieu of Notice"; Decimal)
        {
        }
        field(14; "PAYE Due"; Decimal)
        {
        }
        field(15; "Staff Loans/Lost Items"; Decimal)
        {
        }
        field(16; "Medical Expenses"; Decimal)
        {
        }
        field(17; "No. of Months Salary"; Decimal)
        {

            trigger OnValidate();
            begin
                "Salary(Full Month)" := "No. of Months Salary" * "Basic Salary";
            end;
        }
        field(18; "Part Salary to be paid"; Decimal)
        {

            trigger OnValidate();
            begin
                HRSeparation.RESET;
                HRSeparation.SETRANGE("Employee No.", "Employee No");
                IF HRSeparation.FIND('-') THEN BEGIN
                    MonthNo := DATE2DMY(HRSeparation."Notification End Date", 2);
                    YearNo := DATE2DMY(HRSeparation."Notification End Date", 3);
                    MonthBegin := CALCDATE('-CM', DMY2DATE(1, MonthNo, YearNo));
                    MonthEnd := CALCDATE('CM', DMY2DATE(1, MonthNo, YearNo));
                    DaysInMonth := 0;
                    cDay := MonthBegin;

                    REPEAT
                        //   IF NOT CalMgt.CheckDateStatus(CalendarCode, cDay, DescriptionText) THEN
                        DaysInMonth += 1;
                        cDay := CALCDATE('+1D', cDay);
                    UNTIL (cDay > MonthEnd);
                END;

                //days:=DATE2DMY(HRSeparation."Last Working Date",1);
                //"Part Salary to be paid":=days;MESSAGE('%1,%2',days,DaysInMonth);
                "Salary(Extra Days)" := ("Part Salary to be paid" / DaysInMonth) * "Basic Salary";
            end;
        }
        field(19; "Pay for Outstanding Leave Days"; Decimal)
        {
        }
        field(20; "Pay Car Allowance"; Boolean)
        {
        }
        field(21; "No of Days for Car Allowance"; Decimal)
        {

            trigger OnValidate();
            begin
                Employee.RESET;
                Employee.SETRANGE("No.", "Employee No");
                IF Employee.FINDFIRST THEN BEGIN
                    HRSeparation.RESET;
                    HRSeparation.SETRANGE("Employee No.", "Employee No");
                    IF HRSeparation.FIND('-') THEN BEGIN
                        MonthNo := DATE2DMY(HRSeparation."Last Working Date", 2);
                        YearNo := DATE2DMY(HRSeparation."Last Working Date", 3);
                        MonthBegin := CALCDATE('-CM', DMY2DATE(1, MonthNo, YearNo));
                        MonthEnd := CALCDATE('CM', DMY2DATE(1, MonthNo, YearNo));
                        DaysInMonth := 0;
                        cDay := MonthBegin;

                        REPEAT
                            //    IF NOT CalMgt.CheckDateStatus(CalendarCode, cDay, DescriptionText) THEN
                            DaysInMonth += 1;
                            cDay := CALCDATE('+1D', cDay);
                        UNTIL (cDay > MonthEnd);
                    END;

                END;
            end;
        }
        field(22; "Pay Leave Allowance"; Boolean)
        {
        }
        field(23; "Total Deductions"; Decimal)
        {
            Editable = false;
            FieldClass = FlowField;
        }
        field(24; Total; Decimal)
        {
        }
        field(25; "Amount Payable"; Decimal)
        {
        }
        field(26; "Offset Leave Days"; Boolean)
        {

            trigger OnValidate();
            begin
                IF HRSeparation.GET("Employee No", "Separation No") THEN BEGIN
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
                    //"Amount In Lieu of Notice":=("Days In Lieu of Notice"*"Basic Salary"*12)/365;
                    "Amount In Lieu of Notice" := ("Days In Lieu of Notice" / days) * "Basic Salary";
                END ELSE BEGIN
                    "Amount In Lieu of Notice" := 0;
                END;
                VALIDATE("Outstanding Leave Days");
            end;
        }
        field(27; "Amount In Lieu of Notice"; Decimal)
        {
        }
        field(28; "Separation No"; Code[10])
        {
        }
        field(29; "Golden Handshake"; Decimal)
        {
        }
        field(30; "Transport Allowance"; Decimal)
        {
        }
        field(31; "Severence Pay"; Decimal)
        {
        }
        field(32; "No of Years Worked"; Integer)
        {
        }
        field(33; "No of Months Car Allowance"; Decimal)
        {
        }
        field(34; "Car Allowance(Months)"; Decimal)
        {
        }
        field(35; "Total after PAYE"; Decimal)
        {
        }
        field(36; "Leave Start Date"; Date)
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
        field(37; "Leave End Date"; Date)
        {
        }
        field(38; "Part Salary Start Date"; Date)
        {

            trigger OnValidate();
            begin
                "Part Salary End Date" := CALCDATE(FORMAT("Part Salary to be paid" - 1) + 'D', "Part Salary Start Date");
            end;
        }
        field(39; "Part Salary End Date"; Date)
        {
        }
        field(40; "Part Car Allowance Start Date"; Date)
        {
        }
        field(41; "Part CAr Allowance End Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; No, "Employee No", "Separation No")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MonthBegin: Date;
        MonthEnd: Date;
        DaysInMonth: Integer;
        cDay: Date;
        CalMgt: Codeunit 7600;
        CalendarCode: Code[10];
        DescriptionText: Text;
        MonthNo: Integer;
        YearNo: Integer;
        HRSeparation: Record 50237;
        days: Integer;
        Employee: Record 5200;
        year: Integer;
        BaseCalender: Record 2000000007;
        leavedays: Decimal;
        weekend: Decimal;
}

