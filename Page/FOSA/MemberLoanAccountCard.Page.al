page 50201 "Member Loan Account Card"
{
    // version TL2.0

    Caption = 'Member Loan Account Card';
    PageType = Card;
    SourceTable = Customer;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {ApplicationArea = All;
                }
                field(Name; Name)
                {ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {ApplicationArea = All;
                }
                /* field("Member Name";"Member Name")
                {ApplicationArea = All;
                } */
                field("Phone No."; "Phone No.")
                {ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {ApplicationArea = All;
                }
                field(Status; Status)
                {ApplicationArea = All;
                }
                field("Customer Posting Group"; "Customer Posting Group")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

