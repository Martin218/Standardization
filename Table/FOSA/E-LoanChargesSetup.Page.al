page 50304 "E-Loan Charges Setup"
{
    PageType = List;
    SourceTable = "E-Loan Charges Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Min; Min)
                {
                    ApplicationArea = All;
                }
                field(Max; Max)
                {
                    ApplicationArea = All;
                }
                field("Safaricom Charge"; "Safaricom Charge")
                {
                    ApplicationArea = All;
                }
                field("TL Charge"; "TL Charge")
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

