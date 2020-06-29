page 50456 "Position Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50230;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Code; Code)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Reporting To"; "Reporting To")
                {
                    ApplicationArea = All;
                }
                field(Department; Department)
                {
                    ApplicationArea = All;
                }
                field(Grade; Grade)
                {
                    ApplicationArea = All;
                }
                field("No. of Posts"; "No. of Posts")
                {
                    ApplicationArea = All;
                }
                field("Occupied Positions"; "Occupied Positions")
                {
                    ApplicationArea = All;
                }
                field("Vacant Positions"; "Vacant Positions")
                {
                    ApplicationArea = All;
                }
                field("Job Description"; "Job Description")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Job KPI's"; "Job KPI's")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Active; Active)
                {
                    ApplicationArea = All;
                }
            }
            part("Position Qualifications"; "Position Qualifications")
            {
                ShowFilter = false;
                ApplicationArea = All;
                SubPageLink = "Position Code" = FIELD(Code);
            }

            part("Position Responsibilities"; "Position Responsibilities")
            {
                ShowFilter = false;
                ApplicationArea = All;
                SubPageLink = "Position Code" = FIELD(Code);
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Current Job Occupants")
            {
                Image = SalesPurchaseTeam;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                RunObject = Page 5201;
                RunPageLink = "Job Title" = FIELD("Job Title");
                RunPageMode = View;
            }
            action("Job Description Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    Position.RESET;
                    Position.SETRANGE(Code, Rec.Code);
                    IF Position.FINDFIRST THEN BEGIN
                        COMMIT;
                        REPORT.RUN(50285, TRUE, FALSE, Position);
                    END;
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        UpdateVacantPosition;
    end;

    var
        Position: Record 50230;
}

