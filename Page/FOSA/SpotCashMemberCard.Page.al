page 50148 "SpotCash Member Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,History,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "SpotCash Member";

    layout
    {
        area(content)
        {
            group(General)
            {
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
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Service Type"; "Service Type")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group(Audit)
            {
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
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
                RunObject = Page "SpotCash Ledger Entries";
                //RunPageLink = "Member No."=FIELD(Member n);
            }
        }
    }
}

