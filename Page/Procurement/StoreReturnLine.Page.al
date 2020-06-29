page 50737 "Store Return Line"
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
                field(Type; Type)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(No; No)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit of Measure"; "Unit of Measure")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Unit Price"; "Unit Price")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Quantity Returned"; "Quantity Returned")
                {
                    ApplicationArea = All;
                }
                field("Requisition Type"; "Requisition Type")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                }
                field("Item Category"; "Item Category")
                {
                    ApplicationArea = All;
                    Editable = false;
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

