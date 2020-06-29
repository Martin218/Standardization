page 50210 "Loan Guarantor List"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = List;
    SourceTable = "Loan Guarantor";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
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
                field("Account Balance"; "Account Balance")
                {ApplicationArea = All;
                }
                field("Other Guaranteed Amount"; "Other Guaranteed Amount")
                {ApplicationArea = All;
                }
                field("Net Account Balance"; "Net Account Balance")
                {ApplicationArea = All;
                }
                field("Amount To Guarantee"; "Amount To Guarantee")
                {ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

