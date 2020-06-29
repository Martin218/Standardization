page 50216 "Loan Charge Setup"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Loan Charge Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {ApplicationArea = All;
                }
                field("Charge Description"; "Charge Description")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

