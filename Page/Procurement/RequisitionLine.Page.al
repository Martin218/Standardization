page 50719 "Requisition Line"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Requisition Header Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Procurement Plan"; "Procurement Plan")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan Item"; "Procurement Plan Item")
                {
                    ApplicationArea = All;
                }
                field("Budget Link"; "Budget Link")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(No; No)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Quantity in Store"; "Quantity in Store")
                {
                    ApplicationArea = All;
                }
                field("Approved Budget Amount"; "Approved Budget Amount")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Commitment Amount"; "Commitment Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Expense"; "Actual Expense")
                {
                    ApplicationArea = All;
                }
                field("Procurement Method"; "Procurement Method")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        GeneralLedgerSetup.GET;
        "Procurement Plan" := GeneralLedgerSetup."Current Bugdet";
    end;

    var
        GeneralLedgerSetup: Record "General Ledger Setup";
}

