report 50407 "NSSF Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\NSSF Report.rdlc';
    Caption = 'NSSF Report';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(PayrollID_PayrollHeader; PayrollID)
            {
            }
            column(Employeeno_PayrollHeader; Employee."No.")
            {
            }
            column(PayrollYear_PayrollHeader; PayrollYear)
            {
            }
            column(NHIFAmountLCY_PayrollHeader; NHIFAmount)
            {
            }
            column(LastName_PayrollHeader; Employee."Last Name")
            {
            }
            column(FirstName_PayrollHeader; Employee."First Name")
            {
            }
            column(ALCY_PayrollHeader; TotalPayable)
            {
            }
            column(NSSFAmountLCY_PayrollHeader; NSSFAmount)
            {
            }
            column(nssf; NSSF)
            {
            }
            column(logo; companyinfo.Picture)
            {
            }
            column(IDNumber_Employee; Employee."ID Number")
            {
            }
            column(NHIFNo_Employee; Employee.NHIF)
            {
            }
            column(PIN_Employee; Employee."PIN Number")
            {
            }
            column(NSSFNo_Employee; Employee.NSSF)
            {
            }
            column(MiddleName_Employee; Employee."Middle Name")
            {
            }
            column(empnssf; PayrollSetups."Employer NSSF No.")
            {
            }
            column(name; companyinfo.Name)
            {
            }

            trigger OnAfterGetRecord();
            begin
                NSSFAmount := 0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriod);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, PayrollSetups."NSSF Code");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    NSSFAmount := ABS(TLPayrollEntries.Amount);
                END;
                IF NSSFAmount = 0 THEN BEGIN
                    CurrReport.SKIP;
                END;
                TotalPayable := 0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period", PayrollPeriod);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    REPEAT
                        TLEarning.RESET;
                        IF TLEarning.GET(TLPayrollEntries.Code) THEN BEGIN
                            IF (TLEarning."Non-Cash Benefit" = FALSE) AND (TLEarning."Earning Type" = TLEarning."Earning Type"::"Normal Earning") THEN BEGIN
                                TotalPayable += TLPayrollEntries.Amount;
                            END;
                        END;
                    UNTIL TLPayrollEntries.NEXT = 0;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payroll Period"; PayrollPeriod)
                {
                     ApplicationArea = All;
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
        IF PayrollPeriod = 0D THEN BEGIN
            ERROR('Please Select Payroll Period!');
        END;
        PayrollSetups.GET;
        PayrollSetups.TESTFIELD("NSSF Code");
        PayrollSetups.TESTFIELD("Employer NSSF No.");
        companyinfo.GET;
        companyinfo.CALCFIELDS(Picture);
        PayrollID := FORMAT(DATE2DMY(PayrollPeriod, 2)) + '-' + FORMAT(DATE2DMY(PayrollPeriod, 3));
    end;

    var
        NSSFAmount: Decimal;
        TotalPayable: Decimal;
        NHIFAmount: Decimal;
        PayrollYear: Integer;
        PayrollID: Code[20];
        PayrollSetups: Record "Payroll Setup";
        companyinfo: Record "Company Information";
        TLPayrollEntries: Record "Payroll Entries";
        TLEarning: Record "Earnings Setup";
        PayrollPeriod: Date;
}

