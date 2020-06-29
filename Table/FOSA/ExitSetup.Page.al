page 50237 "Exit Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Exit Setup";
    UsageCategory = Administration;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                field("Attachment Mandatory"; "Attachment Mandatory")
                {
                    ApplicationArea = All;
                }
                field("Refund Shares to Shares"; "Refund Shares to Shares")
                {
                    ApplicationArea = All;
                }
                field("Insurance G/L Account"; "Insurance G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Expense G/L Account"; "Expense G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Income G/L Account"; "Income G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Debit FOSA Account Type"; "Debit FOSA Account Type")
                {
                    ApplicationArea = All;
                }
                field("Credit FOSA Account Type"; "Credit FOSA Account Type")
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

