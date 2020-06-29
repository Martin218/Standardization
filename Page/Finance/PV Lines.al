page 50603 "PV Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Payment/Receipt Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Type";"Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name";"Account Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field("Applies to Doc. No";"Applies to Doc. No")
                {
                    ApplicationArea = All;
                }
                field("External Document No";"External Document No")
                {
                    ApplicationArea = All;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = All;
                }
                field("VAT Withheld Amount";"VAT Withheld Amount")
                {
                    ApplicationArea = All;
                }
                field("W/Tax Amount";"W/Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount";"Net Amount")
                {
                    ApplicationArea = All;
                }
                field("KBA Code";"KBA Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("KBA Branch Code";"KBA Branch Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Branch Name";"Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Bank Account No.";"Bank Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Bank Name";"Bank Name")
                {
                    ApplicationArea = All;
                }
                field("W/Tax Code";"W/Tax Code")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount";"Gross Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT Amount";"VAT Amount")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("VAT WithHeld Code";"VAT WithHeld Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Remittance Advise")
            {
                Image = PrintDocument;

                trigger OnAction();
                begin

                    Rec.SETRANGE("Line No",Rec."Line No");
                   // PaymentRemittanceAdvise.GetPvLines(Rec);
                   // PaymentRemittanceAdvise.RUN;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
      //  IF PaymentReceiptProcessing.EditPVReceiptLines(Rec)=FALSE THEN BEGIN
        //  CurrPage.EDITABLE(FALSE);
      //  END;
    end;

    var
       // PaymentRemittanceAdvise : Report "50441";
       // PaymentReceiptProcessing : Codeunit "50039";
}

