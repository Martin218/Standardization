report 50414 "Deductions Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Deductions Report.rdlc';
    Caption = 'Deductions Report';

    dataset
    {
        dataitem("Deductions Setup"; "Deductions Setup")
        {
            RequestFilterFields = "Code";
            column(P_Code; "Deductions Setup".Code)
            {
            }
            column(P_Description; "Deductions Setup".Description)
            {
            }
            column(PayPeriond; TitleReport + '' + UPPERCASE(FORMAT(PayPeriond, 0, '<month text> <year4>')))
            {
            }
            column(Name; CompInfo.Name)
            {
            }
            column(Address; CompInfo.Address)
            {
            }
            column(Address_2; CompInfo."Address 2")
            {
            }
            column(Picture; CompInfo.Picture)
            {
            }
            dataitem("Payroll Entries"; "Payroll Entries")
            {
                DataItemLink = Code = FIELD(Code);
                column(Employee_No; "Payroll Entries"."Employee No")
                {
                }
                column(Code_; "Payroll Entries".Code)
                {
                }
                column(P_Amount; ABS("Payroll Entries".Amount))
                {
                }
                column(Description; "Payroll Entries".Description)
                {
                }
                column(EmployeeName; EmployeeName)
                {
                }
                column(i; i)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    EmployeeName := '';
                    TotalsDed := 0;
                    Employee.RESET;
                    IF Employee.GET("Payroll Entries"."Employee No") THEN BEGIN
                        EmployeeName := Employee.FullName;
                    END;
                    IF "Payroll Entries"."Payroll Period" <> PayPeriond THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    i += 1;
                end;

                trigger OnPreDataItem();
                begin
                    i := 0;
                end;
            }

            trigger OnAfterGetRecord();
            begin
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Code, "Deductions Setup".Code);
                TLPayrollEntries.SETRANGE("Payroll Period", PayPeriond);
                IF NOT TLPayrollEntries.FINDFIRST THEN BEGIN
                    CurrReport.SKIP;
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
                field("Pay Period"; PayPeriond)
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
        IF PayPeriond = 0D THEN BEGIN
            ERROR('Please Provide Payroll Month!');
        END;
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        PayPeriond: Date;
        TLPayrollEntries: Record "Payroll Entries";
        Employee: Record Employee;
        EmployeeName: Text;
        CompInfo: Record "Company Information";
        TitleReport: Label '"DEDUCTIONS REPORT FOR PAY PERIOND: "';
        TotalsDed: Decimal;
        Counting: Integer;
        i: Integer;
}

