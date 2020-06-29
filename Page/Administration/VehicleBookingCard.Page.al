page 51003 "Vehicle Booking Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Vehicle Booking";

    layout
    {
        area(content)
        {
            group("Vehicle Booking")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Available Car"; "Available Car")
                {
                    ApplicationArea = All;
                    Caption = 'List of cars';
                    TableRelation = "Vehicle Register";

                    trigger OnValidate();
                    begin
                        GvVehicle.RESET;
                        GvVehicle.SETRANGE("Number Plate", "Available Car");
                        IF GvVehicle.FIND('-') THEN BEGIN
                            "Branch Code" := GvVehicle."Branch Code";
                        END;
                    end;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Booking Date"; "Booking Date")
                {
                    ApplicationArea = All;
                }
                field("Required Date"; "Required Date")
                {
                    Caption = 'Required From Date';
                    ApplicationArea = All;
                }
                field("Required To Date"; "Required To Date")
                {
                    ApplicationArea = All;

                    trigger OnValidate();
                    begin
                        IF "Days use" < '1' THEN BEGIN
                            ShowTime := TRUE;
                        END;
                    end;
                }
                field("Days use"; "Days use")
                {
                    ApplicationArea = All;
                    Caption = 'Days Of Use needed';
                }
                field("Start Time"; "Start Time")
                {
                    ApplicationArea = All;
                    Visible = ShowTime;
                }
                field("End Time"; "End Time")
                {
                    ApplicationArea = All;
                    Visible = ShowTime;
                }
                field("Period of Use"; "Period of Use")
                {
                    ApplicationArea = All;
                    Caption = 'Hours Needed';
                    Visible = ShowTime;
                }
                field("Hourly use"; "Hourly use")
                {
                    ApplicationArea = All;
                    Caption = 'Specific time vehicle is needed';
                    Visible = false;
                }
                field("Time of Use"; "Time of Use")
                {
                    ApplicationArea = All;
                    Caption = 'Specific Dates Vehicle is needed';
                    Visible = false;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Driver Required ?"; "Driver Required ?")
                {
                    ApplicationArea = All;
                    Caption = 'Book Driver?';
                }
                field(User; User)
                {
                    ApplicationArea = All;
                    Caption = 'Booked by';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action(Book)
            {
                Caption = 'Book Vehicle';
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = all;

                trigger OnAction();
                begin
                    AdminManagement.BookVehicle(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        ShowTime := TRUE;
    end;

    var
        GvVehicle: Record "Vehicle Register";
        AdminNoseries: Record "Admin Numbering Setup";
        //CurrentUser : Record "91";
        //Mail : Codeunit "397";
        Employee: Record Employee;
        HODEmail: Text[80];
        // smtpcu : Codeunit "400";
        bdDialog: Dialog;
        //smtpsetup : Record "409";
        mailheader: Text;
        mailbody: Text;
        vehiclebooking: Record "Vehicle Booking";
        //depemails : Record "349";
        ShowTime: Boolean;
        AdminManagement: Codeunit "Admin Management";
}

