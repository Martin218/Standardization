page 50196 "Loan Statistics FactBox"
{
    // version TL2.0

    Caption = 'Loan Statistics';
    PageType = CardPart;
    SourceTable = "Loan Application";

    layout
    {
        area(content)
        {
            field("Principal Arrears Amount"; "Principal Arrears Amount")
            {
                ApplicationArea = All;
            }
            field("Interest Arrears Amount"; "Interest Arrears Amount")
            {
                ApplicationArea = All;
            }
            field("Total Arrears Amount"; "Total Arrears Amount")
            {
                ApplicationArea = All;
            }
            field("Principal Overpayment"; "Principal Overpayment")
            {
                ApplicationArea = All;
            }
            field("Interest Overpayment"; "Interest Overpayment")
            {
                ApplicationArea = All;
            }
            field("Outstanding Balance"; "Outstanding Balance")
            {
                ApplicationArea = All;
            }
            field("Approved Amount"; "Approved Amount")
            {
                ApplicationArea = All;
            }
            field("Notice Category"; "Notice Category")
{ApplicationArea = All;
                }
            field("Notice Date"; "Notice Date")
{ApplicationArea = All;
                }
            field("Attach Due Date"; "Attach Due Date")
            {
                ApplicationArea = All;
            }
            field("Attach Status"; "Attach Status")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

