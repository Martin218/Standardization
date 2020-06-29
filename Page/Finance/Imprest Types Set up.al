page 50645 "Imprest Types Set up"
{
    PageType = List;
    SourceTable = "Imprest Types";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code;Code)
                {
                    ApplicationArea=All;
                }
                field(Description;Description)
                {
                    ApplicationArea=All;
                }
                field("G/L Account";"G/L Account")
                {
                    ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

