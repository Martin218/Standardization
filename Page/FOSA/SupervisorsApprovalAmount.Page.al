page 50063 "Supervisors Approval Amount"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Supervisor Approval Amount";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SupervisorID; SupervisorID)
                {ApplicationArea=All;
                }
                field("Transaction Type"; "Transaction Type")
                {ApplicationArea=All;
                }
                field("Maximum Approval Amount"; "Maximum Approval Amount")
                {ApplicationArea=All;
                }
                field(Branch; Branch)
                {ApplicationArea=All;
                }
                field("Branch Name"; "Branch Name")
                {ApplicationArea=All;
                }
                field("Global Administrator"; "Global Administrator")
                {ApplicationArea=All;
                }
                field("Approval Level"; "Approval Level")
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

