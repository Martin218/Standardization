page 50293 "Member Remittance Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Member Remittance Line";

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
                field("Remittance Code"; "Remittance Code")
                {
                    ApplicationArea = All;
                }
                field("Contribution Type"; "Contribution Type")
                {
                    ApplicationArea = All;
                }
                field("Expected Amount"; "Expected Amount")
                {
                    ApplicationArea = All;
                }
                field("Actual Amount"; "Actual Amount")
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

