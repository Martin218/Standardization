page 50507 "Payroll Role Center"
{
    PageType = RoleCenter;
    Caption = 'Payroll Role Center', Comment = '{Dependency=Match,"ProfileDescription_PAYROLLMANAGER"}';
    ;
    layout
    {
        area(rolecenter)
        {
            part(Control104; "Headline RC Order Processor")
            {
                ApplicationArea = Basic, Suite;
            }


        }
    }
    actions
    {
        area(Sections)
        {
            group("Payroll Management")
            {
                Caption = 'Payroll Management';
                Image = Payroll;
                group(EmployeeList)
                {
                    Caption = 'Employee List';
                    action("Employee List")
                    {
                        RunObject = page "Employee List";
                        ApplicationArea = All;
                    }
                }
                group(PayPeriodSetup)
                {
                    Caption = 'Payroll Period Setup';
                    action("Pay Period Setup")
                    {
                        RunObject = page "Pay Period Setup";
                        ApplicationArea = All;
                    }
                }
                group("&Tasks and &Processes")
                {
                    Caption = '&Tasks and &Processes';
                    action("Running Payroll")
                    {
                        Caption = 'Running Payroll';
                        RunObject = report 50402;
                        ApplicationArea = All;
                    }
                    action("Transfer Payroll To Journal")
                    {
                        Caption = 'Transfer Payroll To Journal';
                        RunObject = report 50402;
                        ApplicationArea = All;
                    }

                }
                group(Reports)
                {
                    Caption = '&Payroll Reports';
                    action("Earnings Report")
                    {
                        Caption = 'Earnings Report';
                        RunObject = report 50413;
                        ApplicationArea = All;
                    }
                    action("Deductions Report")
                    {
                        Caption = 'Deductions Report';
                        RunObject = report 50414;
                        ApplicationArea = All;
                    }
                    action("Payroll Variance Report")
                    {
                        Caption = 'Payroll Variance Report';
                        RunObject = report 50409;
                        ApplicationArea = All;
                    }
                    action("Non Cash Report")
                    {
                        Caption = 'Payroll Variance Report ';
                        RunObject = report 50410;
                        ApplicationArea = All;
                    }
                    action("Loan Report")
                    {
                        Caption = 'Loan Report';
                        RunObject = report 50411;
                        ApplicationArea = All;
                    }
                    action("Provident Fund")
                    {
                        Caption = 'Provident Fund';
                        RunObject = report 50416;
                        ApplicationArea = All;
                    }
                    action("P9A Report")
                    {
                        Caption = 'P9A Report';
                        RunObject = report 50405;
                        ApplicationArea = All;
                    }
                    action("P10 Report")
                    {
                        Caption = 'P10 Report';
                        RunObject = report 50405;
                        ApplicationArea = All;
                    }
                    action("P10A Report")
                    {
                        Caption = 'P9A Report';
                        RunObject = report 50406;
                        ApplicationArea = All;
                    }
                    action("NSSF Report")
                    {
                        Caption = 'NSSF Report';
                        RunObject = report 50407;
                        ApplicationArea = All;
                    }
                    action("NHIF Report")
                    {
                        Caption = 'NHIF Report';
                        RunObject = report 50408;
                        ApplicationArea = All;
                    }
                    action("PAYE Report")
                    {
                        Caption = 'NHIF Report';
                        RunObject = report 50417;
                        ApplicationArea = All;
                    }
                    action("HELB Report")
                    {
                        Caption = 'HELB Report';
                        RunObject = report 50418;
                        ApplicationArea = All;
                    }
                }
            }
        }
        area(Embedding)
        {
            action("Employee Details")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Employee Details';
                Image = Employee;
                RunObject = Page "Employee Payroll List";
                ToolTip = 'Open the Employee Details';
            }
        }
        area(Creation)
        {
            action("Earnings Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Earnings Setup';
                Image = EmployeeAgreement;
                Promoted = false;
                RunObject = Page "Earnings Setup";
                RunPageMode = Create;
                ToolTip = 'Create a new Earnings Setup';
            }
        }
        area(Processing)
        {
            group(Setup)
            {
                Caption = 'Payroll Setup';
                action("Payroll Period Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Pay Period Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Pay Period Setup";
                    ToolTip = 'Set up core functionality such as Pay Period Setup';
                }
                action("Payroll Earnings Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Earnings Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Earnings Setup";
                    ToolTip = 'Set up core functionality such as Earning Setup';
                }
                action("Deductions Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Deductions Setup';
                    Image = QuestionaireSetup;
                    RunObject = Page "Deductions Setup";
                    ToolTip = 'Set up core functionality such as Deductions Setup';
                }
                action("Bracket Table Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bracket Table Setup';
                    Image = TaxPayment;
                    RunObject = Page "Bracket Table Setup";
                    ToolTip = 'Set up core functionality such as Bracket Table Setup';
                }
                action("Payroll Setup")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Payroll Setup';
                    Image = Payroll;
                    RunObject = Page "Payroll Setup";
                    ToolTip = 'Set up core functionality such as Payroll Setup';
                }
            }
        }
    }
}
profile PayrollProfile
{
    ProfileDescription = 'Payroll Role Center';
    RoleCenter = "Payroll Role Center";
    Caption = 'PAYROLL';
}