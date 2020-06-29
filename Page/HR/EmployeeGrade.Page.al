page 50458 "Employee Grades"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50231;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Salary Scale Minimum"; "Salary Scale Minimum")
                {
                    ApplicationArea = All;
                }
                field("Salary Scale Maximum"; "Salary Scale Maximum")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

