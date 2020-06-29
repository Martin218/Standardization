page 50604 "KRA Tax Codes"
{
    // version TL2.0

    PageType = List;
    SourceTable = "KRA Tax Codes";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Tax Code";"Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Tax Description";"Tax Description")
                {
                    ApplicationArea = All;
                }
                field(Percentage;Percentage)
                {
                    ApplicationArea = All;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No.";"Account No.")
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

