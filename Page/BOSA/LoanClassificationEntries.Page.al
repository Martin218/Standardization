page 50300 "Loan Classification Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "Loan Classification Entry";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Classification Date"; "Classification Date")
                {
                    ApplicationArea = All;
                }
                field("Classification Time"; "Classification Time")
                {
                    ApplicationArea = All;
                }
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
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Approved Amount"; "Approved Amount")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Remaining Period"; "Remaining Period")
                {
                    ApplicationArea = All;
                }
                field("Remaining Principal Amount"; "Remaining Principal Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Interest Amount"; "Remaining Interest Amount")
                {
                    ApplicationArea = All;
                }
                field("Principal Installment"; "Principal Installment")
                {
                    ApplicationArea = All;
                }
                field("Interest Installment"; "Interest Installment")
                {
                    ApplicationArea = All;
                }
                field("Total Installment"; "Total Installment")
                {
                    ApplicationArea = All;
                }
                field("Principal Overpayment"; "Principal Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Interest Overpayment"; "Interest Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Total Overpayment"; "Total Overpayment")
                {
                    ApplicationArea = All;
                }
                field("Principal Arrears Amount"; "Principal Arrears Amount")
                {
                    ApplicationArea = All;
                }
                field("Interest Arrears Amount"; "Interest Arrears Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears Amount"; "Total Arrears Amount")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Provisioning Amount"; "Provisioning Amount")
                {
                    ApplicationArea = All;
                }
                field("Classification Class"; "Classification Class")
                {
                    ApplicationArea = All;
                }
                field("No. of Days in Arrears"; "No. of Days in Arrears")
                {
                    ApplicationArea = All;
                }
                field("No. of Defaulted Installment"; "No. of Defaulted Installment")
                {
                    ApplicationArea = All;
                }
                field("Last Payment Date"; "Last Payment Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(reporting)
        {
            action(Print)
            {
                Image = BankAccountStatement;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    //REPORT.RUN(REPORT::"Loan Classification Report",TRUE,FALSE);
                end;
            }
        }
    }
}

