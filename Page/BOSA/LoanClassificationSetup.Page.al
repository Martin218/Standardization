page 50301 "Classification Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Classification Setup";
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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Min. Defaulted Days"; "Min. Defaulted Days")
                {
                    ApplicationArea = All;
                }
                field("Max. Defaulted Days"; "Max. Defaulted Days")
                {
                    ApplicationArea = All;
                }
                field("Provisioning %"; "Provisioning %")
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

