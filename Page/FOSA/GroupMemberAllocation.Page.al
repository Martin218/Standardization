page 55034 "Group Member Allocation"
{
    // version MC2.0

    AutoSplitKey = true;
    Caption = 'Group Member Allocations';
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Group Member Allocation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {ApplicationArea=All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Amount Due"; "Amount Due")
                {
                    ApplicationArea = All;
                }
                field("Amount in Arrears"; "Amount in Arrears")
                {
                    ApplicationArea = All;
                }
                field("Overpayment Amount"; "Overpayment Amount")
                {
                    ApplicationArea = All;
                }
                field("Allocation Amount"; "Allocation Amount")
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

