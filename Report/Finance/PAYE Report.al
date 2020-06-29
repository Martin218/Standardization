report 50417 "PAYE Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\PAYE Report.rdlc';
    Caption = 'PAYE Report';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(EmployeeNo_PayrollLines;Employee."No.")
            {
            }
            column(KraPin;KraPin)
            {
            }
            column(EmpName;EmpName)
            {
            }
            column(BasicPay;BasicPay)
            {
            }
            column(HouseAllowance;HouseAllowance)
            {
            }
            column(TransportAllowance;TransportAllowance)
            {
            }
            column(LeaveAllowance;LeaveAllowance)
            {
            }
            column(OverTimeAllowance;OverTimeAllowance)
            {
            }
            column(DirectorFee;DirectorFee)
            {
            }
            column(OtherAllowance;OtherAllowance)
            {
            }
            column(Paye;Paye)
            {
            }
            column(ValueCar;ValueCar)
            {
            }
            column(LumpSumAllowance;LumpSumAllowance)
            {
            }
            column(OtherNonCash;OtherNonCash )
            {
            }
            column(TypeHousing;TypeHousing)
            {
            }
            column(columnY;columnY)
            {
            }
            column(relief;relief)
            {
            }
            column(personalrelief;personalrelief)
            {
            }
            column(InsuranceRelief;InsuranceRelief)
            {
            }
            column(otherall;otherall)
            {
            }
            column(ColmnL;ColmnL)
            {
            }

            trigger OnAfterGetRecord();
            begin
                TransportAllowance:=0;
                BasicPay:=0;
                LeaveAllowance:=0;
                KraPin:=Employee."PIN Number";
                EmpName:=Employee."First Name"+ ' ' +Employee."Middle Name"+' '+Employee."Last Name";
                EmployeeNo:='';
                EmployeeNo:=Employee."No.";
                GetBasicPay();
                IF BasicPay=0 THEN BEGIN
                CurrReport.SKIP;
                END;
                actingallo:=0;
                GetActingAllowance();
                dutyal:=0;
                GetDutyAllowance();
                transferAll:=0;
                GetTransferAllowance();
                Bonus:=0;
                GetBonus();
                Arrears:=0;
                GetArrears();
                otherall:=0;
                otherall:=actingallo+dutyal+transferAll+Bonus+Arrears;
                HouseAllowance:=0;
                GetHouseAllowance();
                TransportAllowance:=0;
                GetTransportAllowance();
                LeaveAllowance:=0;
                GetLeaveAllowance();
                NSSFAmount:=0;
                GetNSSF();
                pfemployee:=0;
                GetProvidentFund();
                columnY:=0;
                columnY:=NSSFAmount+pfemployee;
                Paye:=0;
                GetPAYE();
                InsuranceRelief:=0;
                GetInsuranceRelief();
                personalrelief:=0;
                GetPersonalRelief();
            end;

            trigger OnPreDataItem();
            begin
                PayrollSetup.RESET;
                PayrollSetup.GET;
                PayrollSetup.TESTFIELD("House Allowance Code");
                PayrollSetup.TESTFIELD("Duty Allowance Code");
                PayrollSetup.TESTFIELD("Bonus Code");
                PayrollSetup.TESTFIELD("Transport Allowance Code");
                PayrollSetup.TESTFIELD("NSSF Code");
                PayrollSetup.TESTFIELD("Arrears Code");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payroll Period";PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
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

    trigger OnPreReport();
    begin
        IF PayrollPeriod=0D THEN BEGIN
        ERROR('Please Select Payroll Period!');
        END;
    end;

    var
        Emp : Record Employee;
        KraPin : Code[20];
        EmpName : Code[100];
        BasicPay : Decimal;
        HouseAllowance : Decimal;
        TransportAllowance : Decimal;
        LeaveAllowance : Decimal;
        OverTimeAllowance : Decimal;
        DirectorFee : Decimal;
        OtherAllowance : Decimal;
        Paye : Decimal;
        LumpSumAllowance : Decimal;
        ValueCar : Decimal;
        OtherNonCash : Decimal;
        TypeHousing : Code[30];
        allowance : Decimal;
        earnings : Decimal;
        EmpStr : Text;
        InsuranceRelief : Decimal;
        monthlyrelief : Decimal;
        NSSFAmount : Decimal;
        pfemployee : Decimal;
        personalrelief : Decimal;
        insura : Decimal;
        columnY : Decimal;
        relief : Decimal;
        EmpStr1 : Text;
        actingallo : Decimal;
        dutyal : Decimal;
        otherall : Decimal;
        transferAll : Decimal;
        ColmnL : Decimal;
        Bonus : Decimal;
        Arrears : Decimal;
        TLPayrollEntries : Record "Payroll Entries";
        TLEarning : Record "Earnings Setup";
        TLDeduction : Record "Deductions Setup";
        TLPayrollPeriod : Record "Payroll Period";
        PayrollPeriod : Date;
        PayrollSetup : Record "Payroll Setup";
        EmployeeNo : Code[20];

    procedure GetBasicPay();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Basic Salary Code",TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
          TLPayrollEntries.RESET;
          TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
          TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
          TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
          TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
          IF TLPayrollEntries.FINDFIRST THEN BEGIN
            BasicPay:=TLPayrollEntries.Amount;
            END;
        END;
    end;

    procedure GetActingAllowance();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Acting Allowance Code",TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
          TLPayrollEntries.RESET;
          TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
          TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
          TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
          TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
          IF TLPayrollEntries.FINDFIRST THEN BEGIN
            actingallo:=TLPayrollEntries.Amount;
            END;
        END;
    end;

    procedure GetDutyAllowance();
    begin
        TLPayrollEntries.RESET;
          TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
          TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
          TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
          TLPayrollEntries.SETRANGE(Code,PayrollSetup."Duty Allowance Code");
          IF TLPayrollEntries.FINDFIRST THEN BEGIN
          dutyal:=TLPayrollEntries.Amount;
          END;
    end;

    procedure GetTransferAllowance();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Transfer Allowance Code",TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
          TLPayrollEntries.RESET;
          TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
          TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
          TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
          TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
          IF TLPayrollEntries.FINDFIRST THEN BEGIN
          transferAll:=TLPayrollEntries.Amount;
          END;
        END;
    end;

    procedure GetBonus();
    begin
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,PayrollSetup."Bonus Code");
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        Bonus:=TLPayrollEntries.Amount;
        END;
    end;

    procedure GetArrears();
    begin
          TLPayrollEntries.RESET;
          TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
          TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
          TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
          TLPayrollEntries.SETRANGE(Code,PayrollSetup."Arrears Code");
          IF TLPayrollEntries.FINDFIRST THEN BEGIN
          Arrears:=TLPayrollEntries.Amount;
          END;
    end;

    procedure GetHouseAllowance();
    begin
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,PayrollSetup."House Allowance Code");
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        HouseAllowance:=TLPayrollEntries.Amount;
        END;
    end;

    procedure GetTransportAllowance();
    begin
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,PayrollSetup."Transport Allowance Code");
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        TransportAllowance:=TLPayrollEntries.Amount;
        END;
    end;

    procedure GetLeaveAllowance();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Leave Code",TRUE);
        IF TLEarning.FINDFIRST THEN BEGIN
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        LeaveAllowance:=TLPayrollEntries.Amount;
        END;
        END;
    end;

    procedure GetNSSF();
    begin
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,PayrollSetup."NSSF Code");
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        NSSFAmount:=ABS(TLPayrollEntries.Amount);
        END;
    end;

    procedure GetProvidentFund();
    begin
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,PayrollSetup."Provident Fund Code (Employee)");
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        pfemployee:=ABS(TLPayrollEntries.Amount);
        END;
    end;

    procedure GetPAYE();
    begin
        TLDeduction.RESET;
        TLDeduction.SETRANGE("PAYE Code",TRUE);
        IF TLDeduction.FINDFIRST THEN BEGIN
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,TLDeduction.Code);
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        Paye:=ABS(TLPayrollEntries.Amount);
        END;
        END;
    end;

    procedure GetInsuranceRelief();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type",TLEarning."Earning Type"::"Insurance Relief");
        IF TLEarning.FINDFIRST THEN BEGIN
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        InsuranceRelief:=TLPayrollEntries.Amount;
        END;
        END;
    end;

    procedure GetPersonalRelief();
    begin
        TLEarning.RESET;
        TLEarning.SETRANGE("Earning Type",TLEarning."Earning Type"::"Tax Relief");
        IF TLEarning.FINDFIRST THEN BEGIN
        TLPayrollEntries.RESET;
        TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
        TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
        TLPayrollEntries.SETRANGE("Employee No",EmployeeNo);
        TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
        IF TLPayrollEntries.FINDFIRST THEN BEGIN
        personalrelief:=TLPayrollEntries.Amount;
        END;
        END;
    end;
}

