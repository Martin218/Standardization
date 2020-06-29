page 50323 "Dividend Loan Products"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Dividend Loan Product";
    UsageCategory = Administration;
    ApplicationArea = All;

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

