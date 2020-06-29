page 50050 "Teller Shortage/Excess Account"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Teller Shortage/Excess Account";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("G/L Account"; "G/L Account")
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

