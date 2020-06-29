page 51005 "Car Booking Card"
{
    // version TL2.0

    Editable = false;
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
                }
                field("Available Car"; "Available Car")
                {
                    Caption = 'List of cars';
                    TableRelation = "Vehicle Register";
                    ApplicationArea = All;


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
                    Caption = 'Days Of Use needed';
                    ApplicationArea = All;

                }
                field("Start Time"; "Start Time")
                {
                    Visible = ShowTime;
                    ApplicationArea = All;

                }
                field("End Time"; "End Time")
                {
                    Visible = ShowTime;
                    ApplicationArea = All;

                }
                field("Period of Use"; "Period of Use")
                {
                    Caption = 'Hours Needed';
                    Visible = ShowTime;
                    ApplicationArea = All;

                }
                field("Hourly use"; "Hourly use")
                {
                    Caption = 'Specific time vehicle is needed';
                    Visible = false;
                    ApplicationArea = All;

                }
                field("Time of Use"; "Time of Use")
                {
                    Caption = 'Specific Dates Vehicle is needed';
                    Visible = false;
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }
                field("Driver Required ?"; "Driver Required ?")
                {
                    Caption = 'Book Driver?';
                    ApplicationArea = All;

                }
                field(User; User)
                {
                    Caption = 'Booked by';
                    ApplicationArea = All;

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
                Image = CalculatePlan;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

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
        //smtpcu : Codeunit "400";
        bdDialog: Dialog;
        //smtpsetup : Record "409";
        mailheader: Text;
        mailbody: Text;
        vehiclebooking: Record "Vehicle Booking";
        //depemails : Record "349";
        ShowTime: Boolean;
        AdminManagement: Codeunit "Admin Management";
}

