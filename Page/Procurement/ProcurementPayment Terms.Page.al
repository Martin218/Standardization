page 50793 "Payment Terms List"
{
    PageType = ListPart;
    SourceTable = "Procurement Payment Terms";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Process No."; "Process No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Payment Type"; "Payment Type")
                {
                    ApplicationArea = All;
                }
                field("Payment Option"; "Payment Option")
                {
                    ApplicationArea = All;
                }
                field("Fixed Amount"; "Fixed Amount")
                {
                    ApplicationArea = All;
                }
                field("Percentage On Cost"; "Percentage On Cost")
                {
                    ApplicationArea = All;
                }
                field("Percentage Amount"; "Percentage Amount")
                {
                    ApplicationArea = All;
                }
                field("LPO Generated"; "LPO Generated")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("LPO No."; "LPO No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate LPO")
            {
                Image = "Order";
                Promoted = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    //CurrPage.SETSELECTIONFILTER(Rec);
                    //Rec.MARKEDONLY(TRUE);
                    ProcurementManagement.GenerateLPO(Rec);
                    //Rec. CLEARMARKS;
                end;
            }
        }
    }

    var
        ProcurementManagement: Codeunit "Procurement Management";
}

