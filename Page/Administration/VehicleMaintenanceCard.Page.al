page 51008 "Vehicle Maintenance Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Vehicle Maintenance";

    layout
    {
        area(content)
        {
            group("Vehicle Maintenance Scheduling")
            {
                field("Vehicle Number Plate"; "Vehicle Number Plate")
                {
                    ApplicationArea = All;
                    TableRelation = "Vehicle Register";

                    trigger OnValidate();
                    begin
                        IF VehicleRegister.GET("Vehicle Number Plate") THEN BEGIN
                            "Responsible Driver" := VehicleRegister."Responsible Driver";
                            "Branch Code" := VehicleRegister."Branch Code";
                        END;
                    end;
                }
                field("Responsible Driver"; "Responsible Driver")
                {
                    ApplicationArea = All;
                    TableRelation = "Driver Setup";
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
            action(Schedule)
            {
                ApplicationArea = all;
                Caption = 'Schedule';
                Image = SignUp;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    AdminManagement.ScheduleVehicleMaintenance(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        VehicleRegister: Record "Vehicle Register";
        AdminManagement: Codeunit "Admin Management";
}

