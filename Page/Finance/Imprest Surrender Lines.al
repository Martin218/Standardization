page 50616 "Imprest Surrender Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Imprest Lines";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code;Code)
                {
                    ApplicationArea = All;
                    Visible = false;
                }
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
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = All;
                    Enabled = false;
                }
                field("Actual Spent";"Actual Spent")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount";"Remaining Amount")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        IF CashManagement.EditImprestLines(Rec)=FALSE THEN BEGIN
          CurrPage.EDITABLE(FALSE);
        END;
    end;

    var
        CashManagement : Codeunit "Cash Management";
}

