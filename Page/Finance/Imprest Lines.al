page 50611 "Imprest Lines"
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
                field("Activity Name";"Activity Name")
                {
                    ApplicationArea = All;
                }
                field("Account Type";"Account Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Account No.";"Account No.")
                {
                    ApplicationArea = All;
                    Editable = false;
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
                }
                field("Unit Price";"Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount;Amount)
                {
                    ApplicationArea = All;
                }
                field("Budgetted Amount";"Budgetted Amount")
                {
                    ApplicationArea = All;
                }
                field("Budget  Spent";"Budget  Spent")
                {
                    ApplicationArea = All;
                }
                field("Committed Amount";"Committed Amount")
                {
                    ApplicationArea = All;
                }
                field("Available Amount";"Available Amount")
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
    }

    trigger OnOpenPage();
    begin
        IF CashManagement.EditImprestLines(Rec)=FALSE THEN BEGIN
          CurrPage.EDITABLE(FALSE);
        END;
    end;

    var
        CashManagement : Codeunit "Cash Management";
        BudgetManagement : Codeunit "Budget Management";
}

