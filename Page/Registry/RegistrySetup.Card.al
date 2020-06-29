page 50952 "Registry Setup"
{
    // version TL2.0

    InsertAllowed = true;
    PageType = Card;
    SourceTable = "Registry SetUp";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request ID"; "Request ID")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Return ID"; "Return ID")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Member File Nos."; "Member File Nos.")
                {
                    ApplicationArea = All;
                }
                field("Staff File Nos."; "Staff File Nos.")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Other File Nos."; "Other File Nos.")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Loan File Nos."; "Loan File Nos.")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("File Movement ID"; "File Movement ID")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Files No."; "Files No.")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Transfer ID"; "Transfer ID")
                {
                    ApplicationArea = All;
                }
                field("Max. Files held by a person"; "Max. Files held by a person")
                {
                    ApplicationArea = All;
                }
                field("Registry Email"; "Registry Email")
                {
                    ApplicationArea = All;
                }
            }
            group("File Numbers")
            {
                Caption = 'File Numbers';
                Visible = false;
                field("Branch1 Active"; "Branch1 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch2 Active"; "Branch2 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch3 Active"; "Branch3 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch4 Active"; "Branch4 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch5 Active"; "Branch5 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch6 Active"; "Branch6 Active")
                {
                    ApplicationArea = All;
                }
                field("Branch1 InActive"; "Branch1 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch2 InActive"; "Branch2 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch3 InActive"; "Branch3 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch4 InActive"; "Branch4 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch5 InActive"; "Branch5 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch6 InActive"; "Branch6 InActive")
                {
                    ApplicationArea = All;
                }
                field("Branch1 Withdrawn"; "Branch1 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch2 Withdrawn"; "Branch2 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch3 Withdrawn"; "Branch3 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch4 Withdrawn"; "Branch4 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch5 Withdrawn"; "Branch5 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch6 Withdrawn"; "Branch6 Withdrawn")
                {
                    ApplicationArea = All;
                }
                field("Branch1 Closed"; "Branch1 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch2 Closed"; "Branch2 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch3 Closed"; "Branch3 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch4 Closed"; "Branch4 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch5 Closed"; "Branch5 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch6 Closed"; "Branch6 Closed")
                {
                    ApplicationArea = All;
                }
                field("Branch1 Deceased"; "Branch1 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch2 Deceased"; "Branch2 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch3 Deceased"; "Branch3 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch4 Deceased"; "Branch4 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch5 Deceased"; "Branch5 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch6 Deceased"; "Branch6 Deceased")
                {
                    ApplicationArea = All;
                }
                field("Branch1 Volume"; "Branch1 Volume")
                {
                    ApplicationArea = All;
                }
                field("Branch2 Volume"; "Branch2 Volume")
                {
                    ApplicationArea = All;
                }
                field("Branch3 Volume"; "Branch3 Volume")
                {
                    ApplicationArea = All;
                }
                field("Branch4 Volume"; "Branch4 Volume")
                {
                    ApplicationArea = All;
                }
                field("Branch5 Volume"; "Branch5 Volume")
                {
                    ApplicationArea = All;
                }
                field("Branch6 Volume"; "Branch6 Volume")
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

