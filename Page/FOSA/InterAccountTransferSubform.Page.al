page 50098 "Inter Account Transfer Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Account Transfer Line";

    layout
    {
        area(content)
        {
            repeater(R1)
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
                field("Account Balance"; "Account Balance")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

