page 50744 "Procurement Request Line"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Procurement Request Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("No."; "No.")
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
                field("Procurement Plan"; "Procurement Plan")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan Item"; "Procurement Plan Item")
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
                }
                field("Commitment Amount"; "Commitment Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Expense"; "Actual Expense")
                {
                    ApplicationArea = All;
                }
                field("Available amount"; "Available amount")
                {
                    ApplicationArea = All;
                }
                field("Item Category"; "Item Category")
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

