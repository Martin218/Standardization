pageextension 50501 "Payroll Setup Ext" extends "Payroll Setup"
{
    layout
    {
        addafter("General Journal Batch Name")
        {
            field("Payroll Roundoff";"Payroll Roundoff")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Tax Roundoff";"Tax Roundoff")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Pension Cap";"Pension Cap")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Insurance Relief Cap";"Insurance Relief Cap")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Owner Occupier";"Owner Occupier")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("NSSF Code";"NSSF Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("NHIF Code";"NHIF Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Employer NSSF No.";"Employer NSSF No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Employer NHIF No.";"Employer NHIF No.")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Provident Fund Code (Employee)";"Provident Fund Code (Employee)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Provident Fund Code (Employer)";"Provident Fund Code (Employer)")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Duty Allowance Code";"Duty Allowance Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Bonus Code";"Bonus Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Arrears Code";"Arrears Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("House Allowance Code";"House Allowance Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Transport Allowance Code";"Transport Allowance Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("HELB Code";"HELB Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Salary Advance Code";"Salary Advance Code")
                {
                    ApplicationArea = Basic,Suite;
                }
                field("Apply 1/3 Rule?";"Apply 1/3 Rule?")
                {
                    ApplicationArea = Basic,Suite;
                }
        }
    }
}