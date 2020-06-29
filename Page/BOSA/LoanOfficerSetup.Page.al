page 55001 "Loan Officer Setup"
{
    // version MC2.0

    PageType = List;
    SourceTable = "Loan Officer Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; "User ID")
                {ApplicationArea=All;
                }
                field("First Name"; "First Name")
                {ApplicationArea=All;
                }
                field("Last Name"; "Last Name")
                {ApplicationArea=All;
                }
                field("ID No."; "ID No.")
                {ApplicationArea=All;
                }
                field("Phone No."; "Phone No.")
                {ApplicationArea=All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

