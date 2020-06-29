page 50289 "Payout Type Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Payout Loan Product";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
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

