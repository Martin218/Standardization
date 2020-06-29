page 50511 "Employee Deductions Lines"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = 50258;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Item Description"; "Item Description")
                {
                    ApplicationArea = All;
                }
                field("Asset Tag"; "Asset Tag")
                {
                    ApplicationArea = All;
                }
                field("Serial No"; "Serial No")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
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

