page 51050 "Admin Actions"
{
    PageType = CardPart;
    SourceTable = "Admin Cue";

    layout
    {
        area(content)
        {
            cuegroup(VehicleBookingWideLayout)
            {

                Caption = 'Summary';
                CuegroupLayout = Wide;
                field("Total Fueled Cost"; "Total Fueled Cost")
                {
                    Caption = 'Total Fueled Amount';
                    DrillDownPageId = "Fuel Tracking List";
                    ApplicationArea = All;
                }
                field("Total Disbursed Amount"; "Total Valuation Amount")
                {
                    Caption = 'Drivers';

                    DrillDownPageId = "Vehicle Insurance List";
                    ApplicationArea = All;
                }


            }
            cuegroup(VehicleBookingCueContainer)
            {
                Caption = 'Vehicle Booking';
                //CuegroupLayout = Wide;
                field("Vehicle Booking-New"; "Vehicle Booking-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Vehicle Booking List";
                    ApplicationArea = All;
                }
                field("Vehicle Booking-Pending"; "Vehicle Approval-Pending")
                {
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Vehicle Booking List";
                    ApplicationArea = All;
                }
                field("Vehicle Booking-Approved"; "Vehicle Booking-Booked")
                {
                    Caption = 'Booked';
                    DrillDownPageId = "Vehicle Booking List";
                    ApplicationArea = All;
                }

            }
            cuegroup(BoardroomBookingCueContainer)
            {
                Caption = 'Boardroom Booking';
                //CuegroupLayout = Wide;
                field("Bardroom Booking-New"; "Boardroom Booking-New")
                {
                    Caption = 'New';
                    DrillDownPageId = "Booking List";
                    ApplicationArea = All;
                }
                field("Boardroom Booking-Pending"; "Boardroom Booking-Pending")
                {
                    Caption = 'Pending Approval';
                    DrillDownPageId = "Booking List";
                    ApplicationArea = All;
                }
                field("Boardroom Booking-Booked"; "Boardroom Booking-Approved")
                {
                    Caption = 'Approved';
                    DrillDownPageId = "Booking List";
                    ApplicationArea = All;
                }
                field("Boardroom Booking-Rejected"; "Boardroom Booking-Rejected")
                {
                    Caption = 'Rejected';
                    DrillDownPageId = "Booking List";
                    ApplicationArea = All;
                }

            }


            cuegroup(Boardroom)
            {
                Caption = 'Boardroom Details';

                actions
                {

                    action("New Loan Application")
                    {
                        Caption = 'Fresh';
                        RunPageMode = Create;
                        RunObject = page "Boardroom Information Card";
                        Image = TileNew;
                        ApplicationArea = All;
                        trigger OnAction()
                        begin

                        end;
                    }
                }
            }
        }
    }

    trigger OnOpenPage();
    begin
        RESET;
        if not get then begin
            INIT;
            INSERT;
        end;
    end;
}