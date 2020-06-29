page 51009 "Vehicle Insurance List"
{
    // version TL2.0

    CardPageID = "Vehicle Insurance Card";
    PageType = List;
    SourceTable = "Vehicle Insurance Scheduling";

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
                field("Fixed Asset car No."; "Fixed Asset car No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Description"; "Vehicle Description")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Designated Driver"; "Designated Driver")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
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
                field(Scheduled; Scheduled)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Print Valuation Details")
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    TESTFIELD("Insurance Company");
                    TESTFIELD("Valuation Date");
                    CLEAR("Vehicle Valuation Scheduling");
                    "Vehicle Insurance Scheduling".RESET;
                    "Vehicle Insurance Scheduling".SETRANGE("Insurance Company", "Insurance Company");
                    IF "Vehicle Insurance Scheduling".FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(51222, TRUE, FALSE, "Vehicle Insurance Scheduling");
                    END;
                end;
            }
        }
    }

    var
        "Vehicle Insurance Scheduling": Record "Vehicle Insurance Scheduling";
        "Vehicle Valuation Scheduling": Record "Vehicle Insurance Scheduling";
}

