page 50131 "ATM Member Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,History,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "ATM Member";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Card No."; "Card No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
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
                field("Application No."; "Application No.")
                {
                    ApplicationArea = All;
                }
                field("Collection No."; "Collection No.")
                {
                    ApplicationArea = All;
                }
                field("SMS Alert on"; "SMS Alert on")
                {
                    ApplicationArea = All;
                }
                field("E-Mail Alert on"; "E-Mail Alert on")
                {
                    ApplicationArea = All;
                }
                field("Balance (LCY)"; "Balance (LCY)")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Ledger Entries")
            {
                Image = LedgerEntries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50140;
                RunPageLink = "Card No." = FIELD("Card No.");
            }
        }
    }
}

