page 50150 "SpotCash Ledger Entries"
{
    // version TL2.0

    Editable = false;
    PageType = List;
    SourceTable = "SpotCash Ledger Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {ApplicationArea=All;
                }
                field("Transaction No."; "Transaction No.")
                {ApplicationArea=All;
                }
                field("Phone No."; "Phone No.")
                {ApplicationArea=All;
                }
                field("Member No."; "Member No.")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Time"; "Transaction Time")
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field(Reversed; Reversed)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

