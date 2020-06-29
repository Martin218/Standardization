page 50296 "Remittance Codes"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Remittance Code";
    UsageCategory = Administration;
    ApplicationArea = All;

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
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Contribution Type"; "Contribution Type")
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

