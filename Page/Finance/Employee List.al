page 50509 "Employee Payroll List"
{


    Caption = 'Employee Payroll List';
    CardPageID = "Employee Payroll Card";
    Editable = true;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = Employee;
    layout
    {
        area(Content)
        {
            repeater(group)
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
                field("Job Title"; "Job Title")
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
}

