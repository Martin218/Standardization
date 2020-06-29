page 50191 "Standing Order Entries"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Standing Order Entry";
    UsageCategory = History;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
{ApplicationArea = All;
                }
                field("STO No."; "STO No.")
{ApplicationArea = All;
                }
                field("Member No."; "Member No.")
{ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
{ApplicationArea = All;
                }
                field("Account No."; "Account No.")
{ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
{ApplicationArea = All;
                }
                field(Amount; Amount)
{ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

