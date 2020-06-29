page 50624 "Receipt Voucher List"
{
    // version TL2.0

    CardPageID = "Receipt Voucher";
    PageType = List;
    SourceTable = "Payment/Receipt Voucher";
    SourceTableView = WHERE(Status=FILTER(Open|"Pending Approval"),
                            "Line type"=FILTER(Receipt),
                            Posted=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Paying Code.";"Paying Code.")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt No.';
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Description';
                }
                field("Payment Date";"Payment Date")
                {
                    ApplicationArea = All;
                    Caption = 'Receiptt Date';
                }
                field(Type;Type)
                {
                    ApplicationArea = All;
                }
                field("Payment Mode";"Payment Mode")
                {
                    ApplicationArea = All;
                    Caption = 'Receipt Mode';
                }
                field("Paying Bank";"Paying Bank")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank';
                }
                field("Paying/Receiving Bank Name";"Paying/Receiving Bank Name")
                {
                    ApplicationArea = All;
                    Caption = 'Receiving Bank Name';
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
}

