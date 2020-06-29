page 50327 "Loan Writeoff Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Loan Writeoff Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears Amount"; "Total Arrears Amount")
                {
                    ApplicationArea = All;
                }
                field("No. of Days in Arrears"; "No. of Days in Arrears")
                {
                    ApplicationArea = All;
                }
                field("No. of Installment Defaulted"; "No. of Installment Defaulted")
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

