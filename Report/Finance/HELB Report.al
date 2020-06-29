report 50418 "HELB Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\HELB Report.rdlc';
    Caption = 'HELB Report';

    dataset
    {
        dataitem(Employee; Employee)
        {
            column(Employee_No; Employee."No.")
            {
            }
            column(Employee_Name; Employee.FullName)
            {
            }
            column(ID_Number; Employee."ID Number")
            {
            }
            column(Amount; Amount)
            {
            }
            column(I; I)
            {
            }
            column(Payperiod_0___Month_Text___year4____; UPPERCASE(FORMAT(Payperiod, 0, '<Month Text> <year4>')))
            {
            }
            column(TotalCaptionLbl; TotalCaptionLbl)
            {
            }

            trigger OnAfterGetRecord();
            begin
                Amount := 0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type, TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Payroll Period", Payperiod);
                TLPayrollEntries.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntries.SETRANGE(Code, PayrollSetup."HELB Code");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                    Amount := ABS(TLPayrollEntries.Amount);
                END;
                IF Amount = 0 THEN BEGIN
                    CurrReport.SKIP;
                END;
                I += 1;
            end;

            trigger OnPreDataItem();
            begin
                I := 0;
                PayrollSetup.RESET;
                PayrollSetup.GET;
                PayrollSetup.TESTFIELD("HELB Code");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Pay Period"; Payperiod)
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
        IF Payperiod = 0D THEN BEGIN
            ERROR('Please Enter Payroll Peeriod!');
        END;
    end;

    var
        TLPayrollEntries: Record "Payroll Entries";
        Amount: Decimal;
        Payperiod: Date;
        I: Integer;
        TotalCaptionLbl: Label 'Total';
        PayrollSetup: Record "Payroll Setup";
}

