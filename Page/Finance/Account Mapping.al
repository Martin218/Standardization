page 50613 "Account Mapping"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Account Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Staff A/C"; "Staff A/C")
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

