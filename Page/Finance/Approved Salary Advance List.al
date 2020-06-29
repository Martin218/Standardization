page 50637 "Approved Salary Advance List"
{
    // version TL2.0

    CardPageID = "Salary Advance Card";
    PageType = List;
    SourceTable = "Imprest Management";
    SourceTableView = SORTING("Imprest No.")
                      ORDER(Ascending)
                      WHERE("Transaction Type"=CONST("Salary Advance"),
                            Status=CONST(Released),
                            Cleared=CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Imprest No.";"Imprest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
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
                    Caption = 'Reason For Request';
                    ShowMandatory = true;
                }
                field(Status;Status)
                {
                    ApplicationArea = All;
                }
                field(Posted;Posted)
                {
                    ApplicationArea = All;
                }
                field("Requested Amount";"Requested Amount")
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

