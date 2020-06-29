page 50418 "Employee Plan Line"
{
    // version TL2.0

    Editable = true;
    PageType = ListPart;
    SourceTable = 50213;

    layout
    {
        area(content)
        {
            repeater(general)
            {
                field(Days; Days)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
                field(Balance; Balance)
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
            action("Reset Plan")
            {
                Image = ResetStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    ResetLines(Rec."No.");
                end;
            }
        }
    }

    var
        LeavePlanLines: Record 50213;
}

