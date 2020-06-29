page 50342 "Member Agencies"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Member Agency";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Agency Name"; "Agency Name")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Agency No."; "Member Agency No.")
                {
                    ApplicationArea = All;
                }
                field("Payroll No."; "Payroll No.")
                {
                    ApplicationArea = All;
                }
                field("Pay To Account No."; "Pay To Account No.")
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

