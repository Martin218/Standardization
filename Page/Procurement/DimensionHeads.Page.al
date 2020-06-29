page 50710 "Dimension Heads"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Dimension Heads";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 1 Head"; "Dimension 1 Head")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Dimension 2 Head"; "Dimension 2 Head")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Populate Dimension Entries")
            {
                ApplicationArea = All;
                trigger OnAction();
                begin
                    ProcurementManagement.PopluateDimensionHeads;
                end;
            }
        }
    }

    var
        ProcurementManagement: Codeunit "Procurement Management";
}

