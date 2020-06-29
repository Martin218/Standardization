report 50416 "Provident Fund"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Provident Fund.rdlc';
    Caption = 'Provident Fund';

    dataset
    {
        dataitem(Employee;Employee)
        {
            column(logo;companyinfo.Picture)
            {
            }
            column(name;companyinfo.Name)
            {
            }
            column(address;companyinfo.Address)
            {
            }
            column(Tiltes;Tiltes)
            {
            }
            column(Employee_No;Employee."No.")
            {
            }
            column(First_Name;Employee."First Name")
            {
            }
            column(ID_Number;Employee."ID Number")
            {
            }
            column(Last_Name;Employee."Last Name")
            {
            }
            column(Employer_Amount;EmployerA)
            {
            }
            column(Employee_Amount;EmployeeA)
            {
            }
            column(Total_Amount;TotalAmount)
            {
            }
            column(I;I)
            {
            }
            column(Payperiod_0___Month_Text___year4____;UPPERCASE(FORMAT(PayPeriod,0,'<Month Text> <year4>')))
            {
            }

            trigger OnAfterGetRecord();
            begin
                EmployeeA:=0;
                EmployerA:=0;
                TotalAmount:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Employee No",Employee."No.");
                TLPayrollEntries.SETRANGE("Payroll Period",PayPeriod);
                TLPayrollEntries.SETRANGE(Code,PayrollSetup."Provident Fund Code (Employer)");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                  EmployerA:=ABS(TLPayrollEntries.Amount);
                  END;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Employee No",Employee."No.");
                TLPayrollEntries.SETRANGE("Payroll Period",PayPeriod);
                TLPayrollEntries.SETRANGE(Code,PayrollSetup."Provident Fund Code (Employee)");
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                  EmployeeA:=ABS(TLPayrollEntries.Amount);
                END;
                TotalAmount:=EmployeeA+EmployerA;
                IF TotalAmount=0 THEN BEGIN
                  CurrReport.SKIP;
                  END;
                I+=1;
            end;

            trigger OnPreDataItem();
            begin
                I:=0;
                PayrollSetup.RESET;
                PayrollSetup.GET;
                PayrollSetup.TESTFIELD("Provident Fund Code (Employee)");
                PayrollSetup.TESTFIELD("Provident Fund Code (Employer)");
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("PAYROLL PERIOD";PayPeriod)
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
        companyinfo.GET;
        companyinfo.CALCFIELDS(Picture);
        IF PayPeriod=0D THEN BEGIN
          ERROR('KINDLY SELECT PAYROLL PERIOD!');
          END;
    end;

    var
        TLPayrollEntries : Record "Payroll Entries";
        EmployerA : Decimal;
        EmployeeA : Decimal;
        TotalAmount : Decimal;
        PayPeriod : Date;
        I : Integer;
        companyinfo : Record "Company Information";
        Tiltes : Label 'PROVIDENT CONTRIBUTIONS';
        PayrollSetup : Record "Payroll Setup";
}

