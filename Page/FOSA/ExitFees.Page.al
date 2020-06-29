page 50248 "Exit Fees"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Exit Fee";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Earning Party"; "Earning Party")
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

