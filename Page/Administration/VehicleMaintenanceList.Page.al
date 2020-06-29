page 51007 "Vehicle Maintenance List"
{
    // version TL2.0

    CardPageID = "Vehicle Maintenance Card";
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Maintenance";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                }
                field("Fixed Asset Car No."; "Fixed Asset Car No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Responsible Driver"; "Responsible Driver")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Service Date"; "Service Date")
                {
                    ApplicationArea = All;
                }
                field("Service Agent Name"; "Service Agent Name")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
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
            action("Print Maintenance Schedule")
            {

                trigger OnAction();
                begin
                    /*CLEAR ("Vehicle Maintenance Report");
                    "Vehicle Maintenance".RESET;
                    "Vehicle Maintenance".SETRANGE ("Vehicle Number Plate","Vehicle Number Plate");
                    IF "Vehicle Maintenance".FINDFIRST THEN BEGIN
                      REPORT.RUNMODAL(51220,TRUE,FALSE,"Vehicle Maintenance");
                      END;*/

                end;
            }
        }
    }

    var
        "Vehicle Maintenance": Record "Vehicle Maintenance";
}

