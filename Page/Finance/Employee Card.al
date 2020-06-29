page 50508 "Employee Payroll Card"
{
    Caption = 'Employee Payroll Card';
    CardPageID = "Employee Payroll Card";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = Employee;
    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Employee No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }

                field("Last Date Modified"; "Last Date Modified")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

            }
            group(Payroll)
            {
                field("Basic Pay"; "Basic Pay")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(FactBoxes)
        {
            systempart(Link; Links)
            {

            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Assign Earning")
            {
                Caption = 'Assign Earning';
                Image = Cost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "HR Earnings & Deductions";
                RunPageLink = "Employee No" = field("No."), Type = const(Payment), Closed = const(false);
                ApplicationArea = All;

            }
            action("Assign Deductions")
            {
                Caption = 'Assign Deductions';
                Image = CostCenter;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = page "HR Earnings & Deductions";
                RunPageLink = "Employee No" = field("No."), Type = const(Deduction), Closed = const(false);
                ApplicationArea = All;

            }
            action(Imprest)
            {
                Caption = 'Create Imprest A/C';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CashManagement.CreateCustomer(Rec, AccountType::Imprest);
                end;

            }
            action(Salary)
            {
                Caption = 'Create Salary Advance A/C';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    CashManagement.CreateCustomer(Rec, AccountType::"Salary Advance");
                end;
            }
        }

    }
    var
        AccountType: Option Imprest,"Salary Advance";
        CashManagement: Codeunit "Cash Management";
}

