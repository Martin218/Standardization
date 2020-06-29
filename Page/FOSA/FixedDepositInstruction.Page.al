page 50062 "Fixed Deposit Instruction"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "FD Instruction";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FD Account No"; "FD Account No")
                {ApplicationArea=All;
                }
                field("Renew Principal & Interest"; "Renew Principal & Interest")
                {ApplicationArea=All;
                }
                field("Renew Interest"; "Renew Interest")
                {ApplicationArea=All;
                }
                field("Renew Principal"; "Renew Principal")
                {ApplicationArea=All;
                }
                field("Renew Amount"; "Renew Amount")
                {ApplicationArea=All;
                }
                field(Months; Months)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

