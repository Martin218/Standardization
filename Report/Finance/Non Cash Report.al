report 50410 "Non Cash Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Non Cash Report.rdlc';
    Caption = 'Non Cash Report';

    dataset
    {
        dataitem("Earnings Setup"; "Earnings Setup")
        {
            DataItemTableView = SORTING(Code)
                                ORDER(Ascending)
                                WHERE("Non-Cash Benefit" = CONST(true));
            RequestFilterFields = "Code";
            column(P_Code; "Earnings Setup".Code)
            {
            }
            column(P_Description; "Earnings Setup".Description)
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
                column(P_Amount; "Payroll Entries".Amount)
                {
                }
                column(Description; "Payroll Entries".Description)
                {
                }
                column(EmployeeName; EmployeeName)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    EmployeeName := '';
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
                TLPayrollEntries.SETRANGE(Code, "Earnings Setup".Code);
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
        IF PayPeriond = 0D THEN
            ERROR('Please Provide Payroll Month!');
        CompInfo.GET;
        CompInfo.CALCFIELDS(Picture);
    end;

    var
        PayPeriond: Date;
        TLPayrollEntries: Record "Payroll Entries";
        Employee: Record Employee;
        EmployeeName: Text;
        CompInfo: Record "Company Information";
        TitleReport: Label '"NON CASH REPORT FOR PAY PERIOND: "';
}

