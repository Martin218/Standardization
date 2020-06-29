page 50085 "Treasury Coinage"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Treasury Coinage";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;
                }
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field(Value; Value)
                {
                    ApplicationArea = All;
                }
                field("Total Amount"; "Total Amount")
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

