page 50032 "Member S/Dep. Account Card"
{
    // version TL2.0

    Caption = 'Member Saving/Deposit Card';
    PageType = Card;
    SourceTable = Vendor;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Account Type"; "Account Type")
{ApplicationArea = All;
                }
                field("No."; "No.")
{ApplicationArea = All;
                }
                field(Name; Name)
{ApplicationArea = All;
                }
                field("Member No."; "Member No.")
{ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
{ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
{ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
{ApplicationArea = All;
                }
                field("Vendor Posting Group"; "Vendor Posting Group")
{ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
{ApplicationArea = All;
                }
                field(Status; Status)
{ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

    end;

    var
        AvailableBalance: Decimal;
}

