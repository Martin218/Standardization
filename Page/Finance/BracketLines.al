page 50503 "Bracket Lines"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Bracket Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Table Code"; "Table Code")
                {
                     ApplicationArea=All;
                }
                field(Descripption; Descripption)
                {
                     ApplicationArea=All;
                }
                field("Lower Limit"; "Lower Limit")
                {
                     ApplicationArea=All;
                }
                field("Upper Limit"; "Upper Limit")
                {
                     ApplicationArea=All;
                }
                field("Taxable Pay"; "Taxable Pay")
                {
                    Editable = false;
                }
                field(Percentage; Percentage)
                {
                     ApplicationArea=All;
                }
                field("Amount Charged"; "Amount Charged")
                {
                     ApplicationArea=All;
                }
                field("From Date"; "From Date")
                {
                     ApplicationArea=All;
                }
                field("End Date"; "End Date")
                {
                     ApplicationArea=All;
                }
                field("Pay period"; "Pay period")
                {
                     ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

