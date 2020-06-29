page 50781 "Procurement Contract List"
{
    // version TL2.0

    CardPageID = "Procurement Contract Card";
    PageType = List;
    SourceTable = "Contract Header";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Process No."; "Process No.")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Award Date"; "Award Date")
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

