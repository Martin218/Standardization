page 50252 "Member Claim Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Member Claim Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
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
                field("Account Ownership"; "Account Ownership")
                {
                    ApplicationArea = All;
                }
                field("Account Balance"; "Account Balance")
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

