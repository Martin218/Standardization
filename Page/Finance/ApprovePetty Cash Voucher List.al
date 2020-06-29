page 50632 "ApprovePetty Cash Voucher List"
{
    // version TL2.0

    Caption = 'Approved Petty Cash Voucher List';
    CardPageID = "Petty Cash Voucher Card";
    PageType = List;
    SourceTable = "Imprest Management";
    SourceTableView = SORTING("Imprest No.")
                      ORDER(Descending)
                      WHERE("Transaction Type"=FILTER("Petty Cash"),
                            Status=FILTER(Released),
                            Posted=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Imprest No.";"Imprest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Petty Cash No.';
                }
                field("Request Date";"Request Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No";"Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name";"Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code";"Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field(Description;Description)
                {
                    ApplicationArea = All;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code";"Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Imprest Amount";"Imprest Amount")
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

