page 51010 "Vehicle Insurance Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Vehicle Insurance Scheduling";

    layout
    {
        area(content)
        {
            group("Insurance Scheduling")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Fixed Asset car No."; "Fixed Asset car No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                    TableRelation = "Vehicle Register";
                }
                field("Vehicle Description"; "Vehicle Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Designated Driver"; "Designated Driver")
                {
                    ApplicationArea = All;
                    TableRelation = "Driver Setup";
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Type of Insurance"; "Type of Insurance")
                {
                    ApplicationArea = All;
                }
                field("Insurance Company"; "Insurance Company")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Valuation Date"; "Valuation Date")
                {
                    ApplicationArea = All;
                }
                field("Last Valuation Date"; "Last Valuation Date")
                {
                    ApplicationArea = All;
                }
                field("Last Valuation Amount"; "Last Valuation Amount")
                {
                    ApplicationArea = All;
                }
                field("Last Valuer Company"; "Last Valuer Company")
                {
                    ApplicationArea = All;
                }
                field(Scheduled; Scheduled)
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Schedule Insurance Valuation")
            {
                ApplicationArea = all;
                Caption = 'Schedule Valuation';
                Image = Insurance;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    AdminManagement.ScheduleInsuranceValuation(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        AdminManagement: Codeunit "Admin Management";
}

