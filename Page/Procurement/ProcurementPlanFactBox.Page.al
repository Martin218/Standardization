page 50704 "Procurement Plan FactBox"
{
    // version TL2.0

    PageType = CardPart;
    SourceTable = "Procurement Plan Header";

    layout
    {
        area(content)
        {
            field("No."; "No.")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field(Amount; Amount)
            {
                ApplicationArea = All;
            }
            field("Current Budget"; "Current Budget")
            {
                ApplicationArea = All;
            }
            field("Created By"; "Created By")
            {
                ApplicationArea = All;
            }
            field("Budget Period"; "Budget Period")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }

    var
        AmountsEstimated: Decimal;
        ProcurementManagement: Codeunit "Procurement Management";
}

