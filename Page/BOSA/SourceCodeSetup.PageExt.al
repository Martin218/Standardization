pageextension 50001 "PRE Source Code Setup" extends "Source Code Setup"
{
    layout
    {
        // Add changes to page layout here
        addafter("Cost Accounting")

        {
            group("FOSA Management")

            {
                field(CTS; CTS)
                {
                    ApplicationArea = All;
                }
            }
            group("BOSA Management")

            {
                // control with underlying datasource

                field(Loan; Loan)
                {
                    ApplicationArea = All;
                }
                field("Appraisal Fee"; "Appraisal Fee")
                {
                    ApplicationArea = All;
                }
                field("Insurance Fee"; "Insurance Fee")
                {
                    ApplicationArea = All;
                }
                field("Refinancing Fee"; "Refinancing Fee")
                {
                    ApplicationArea = All;
                }
                field("Standing Order"; "Standing Order")
                {
                    ApplicationArea = All;
                }
                field("Principal Paid"; "Principal Paid")
                {
                    ApplicationArea = All;
                }
                field("Interest Paid"; "Interest Due")
                {
                    ApplicationArea = All;
                }
                field("Interest Due"; "Interest Due")
                {
                    ApplicationArea = All;
                }
                field("Fund Transfer"; "Fund Transfer")
                {
                    ApplicationArea = All;
                }
                field(Payout; Payout)
                {
                    ApplicationArea = All;
                }
                field("Member Exit"; "Member Exit")
                {
                    ApplicationArea = All;
                }
                field("Loan Recovery"; "Loan Recovery")
                {
                    ApplicationArea = All;
                }
                field("Loan Selloff"; "Loan Selloff")
                {
                    ApplicationArea = All;
                }
                field("Loan Writeoff"; "Loan Writeoff")
                {
                    ApplicationArea = All;
                }
                field("Opening Balance"; "Opening Balance")
                {
                    ApplicationArea = All;
                }
                field(Remittance; Remittance)
                {
                    ApplicationArea = All;
                }
                field(Refund; Refund)
                {
                    ApplicationArea = All;
                }
                field(Default; Default)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}