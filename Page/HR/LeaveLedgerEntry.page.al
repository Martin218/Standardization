page 50413 "Leave Ledger Entry"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50209;
    UsageCategory = Lists;
    ApplicationArea = all;

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
                field("Leave Period"; "Leave Period")
                {
                    ApplicationArea = All;
                }
                field(Closed; Closed)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Document No"; "Document No")
                {
                    ApplicationArea = All;
                }
                field("Leave Code"; "Leave Code")
                {
                    ApplicationArea = All;
                }
                field(Days; Days)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    ApplicationArea = All;
                }
                field("Lost Days"; "Lost Days")
                {
                    ApplicationArea = All;
                }
                field("Earned Leave Days"; "Earned Leave Days")
                {
                    ApplicationArea = All;
                }
                field("Balance Brought Forward"; "Balance Brought Forward")
                {
                    ApplicationArea = All;
                }
                field(Recall; Recall)
                {
                    ApplicationArea = All;
                }
                field("Added Back Days"; "Added Back Days")
                {
                    ApplicationArea = All;
                }
                field(Modified; Modified)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
        }
    }

    var
        LeaveLedgerEntry: Record 50209;
}

