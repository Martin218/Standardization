page 51011 "Fuel Tracking List"
{
    // version TL2.0

    CardPageID = "Fuel Tracking Card";
    PageType = List;
    SourceTable = "Fuel Tracking";

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
                field(Driver; Driver)
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Fuel Receipt Date"; "Fuel Receipt Date")
                {
                    ApplicationArea = All;
                }
                field("Fuel Cost"; "Fuel Cost")
                {
                    ApplicationArea = All;
                }
                field("Fueled Litres"; "Fueled Litres")
                {
                    ApplicationArea = All;
                }
                field(Mileage; Mileage)
                {
                    ApplicationArea = All;
                }
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                }
                field(Tracked; Tracked)
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
            action("Print Fuel Mgt Report")
            {

                trigger OnAction();
                begin
                    CLEAR("Fuel Management");
                    "Fuel Tracking".RESET;
                    "Fuel Tracking".SETRANGE("Fuel Cost", "Fuel Cost");
                    IF "Fuel Tracking".FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(51221, TRUE, FALSE, "Fuel Tracking");
                    END;
                end;
            }
        }
    }

    var
        "Fuel Tracking": Record "Fuel Tracking";
        "Fuel Management": Record "Fuel Tracking";
}

