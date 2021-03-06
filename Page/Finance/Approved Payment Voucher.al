page 50608 "Approved Payment Voucher"
{
    // version TL2.0

    CardPageID = "Payment Voucher";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Payment/Receipt Voucher";
    SourceTableView = WHERE(Status=CONST(Released),
                            Posted=CONST(false),
                           "Line type"=CONST(Payment));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Code.";"Paying Code.")
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    Caption = 'Payment Description';
                }
                field("Payment Date";"Payment Date")
                {
                    ApplicationArea = All;
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = All;
                }
                field("Paying Bank";"Paying Bank")
                {
                    ApplicationArea = All;
                }
                field("Paying/Receiving Bank Name";"Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Paying Bank Name';
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field("Created By";"Created By")
                {
                    ApplicationArea = All;
                }
                field(Balance;Balance)
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
        CurrPage.EDITABLE(FALSE);
    end;
}

