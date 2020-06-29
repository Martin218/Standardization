page 50149 "SpotCash Members List"
{
    // version TL2.0

    Caption = 'SpotCash Members';
    CardPageID = "SpotCash Member Card";
    Editable = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,History,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "SpotCash Member";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {ApplicationArea=All;
                }
                field("Member Name"; "Member Name")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Account Name"; "Account Name")
                {ApplicationArea=All;
                }
                field("Phone No."; "Phone No.")
                {ApplicationArea=All;
                }
                field("Service Type"; "Service Type")
                {ApplicationArea=All;
                }
                field(Status; Status)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

