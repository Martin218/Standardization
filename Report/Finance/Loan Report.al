report 50411 "Loan Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Loan Report.rdlc';
    Caption = 'Loan Report';

    dataset
    {
        dataitem("Deductions Setup"; "Deductions Setup")
        {
            DataItemTableView = SORTING(Code)
                                ORDER(Ascending)
                                WHERE(Loan = CONST(true));
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
                column(Loan_Interest; "Payroll Entries"."Loan Interest")
                {
                }
                column(Loan_Principal; "Payroll Entries"."Loan Principal")
                {
                }
                column(Loan_Insurance; "Payroll Entries"."Loan Insurance")
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
                end;
            }

            trigger OnAfterGetRecord();
            begin
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Code, "Payroll Entries".Code);
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
        TitleReport: Label '"LOANS REPORT FOR PAY PERIOND: "';
        TotalsDed: Decimal;
        Counting: Integer;
}

