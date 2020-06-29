page 50506 "HR Earnings & Deductions"
{
   PageType = List;
    SourceTable = "Payroll Entries";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                     ApplicationArea=All;
                }
                field("Payroll Period"; "Payroll Period")
                {
                     ApplicationArea=All;
                }
                field(Description; Description)
                {
                     ApplicationArea=All;
                }
                field(Amount; Amount)
                {
                     ApplicationArea=All;
                }
                field("Loan Principal"; "Loan Principal")
                {
                     ApplicationArea=All;
                }
                field("Loan Interest"; "Loan Interest")
                {
                     ApplicationArea=All;
                }
                field("Loan Insurance"; "Loan Insurance")
                {
                     ApplicationArea=All;
                }
                field("Employer Amount"; "Employer Amount")
                {
                     ApplicationArea=All;
                }
                field("Employee Voluntary"; "Employee Voluntary")
                {
                     ApplicationArea=All;
                }
                field("Taxable amount"; "Taxable amount")
                {
                    Editable = false;
                }
                field("Next Period Entry"; "Next Period Entry")
                {
                     ApplicationArea=All;
                }
                field("Tax Relief"; "Tax Relief")
                {
                     ApplicationArea=All;
                }
                field("Normal Earnings"; "Normal Earnings")
                {
                     ApplicationArea=All;
                }
                field("Reference No"; "Reference No")
                {
                     ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    var
    //  PayrollProcessing : Codeunit "50038";
}

