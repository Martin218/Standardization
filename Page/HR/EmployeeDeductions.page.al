page 50510 "Employee Deductions"
{
    // version TL2.0

    DataCaptionFields = "Employee No", "Employee Name";
    PageType = Card;
    SourceTable = 50273;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field(Department; Department)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                part("Employee Deduction Lines"; 50511)
                {
                    SubPageLink = "Employee No" = FIELD("Employee No");
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

