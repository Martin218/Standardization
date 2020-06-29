page 50214 "Loan Product Charges"
{
    // version TL2.0

    Caption = 'Loan Product Charges';
    PageType = List;
    SourceTable = "Loan Product Charge";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Calculation Mode"; "Calculation Mode")
                {
                    ApplicationArea = All;
                }
                field(Value; Value)
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No"; "Account No")
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

