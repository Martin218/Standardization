page 51016 "Admin RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'Boardroom Role Center';

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part(Part1; "BOSA RoleCenter Headline")
                {
                    ApplicationArea = All;
                }

                part(Part2; "BOSA RoleCenter Headline")
                {
                    Caption = 'Boardroom';
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
        area(Sections)
        {
            group("Vehicle Management")
            {
                Caption = 'Vehicle & Boardroom Management';
                Image = RegisteredDocs;
                group(VehicleManagement)
                {
                    Caption = 'Vehicle Registry';

                    action("Register New Vehicle")
                    {
                        RunObject = Page "Vehicle Registry list";
                        ApplicationArea = All;
                    }
                    group(VehicleBooking)
                    {
                        Caption = 'Vehicle Booking';
                        action("Book Vehicle")
                        {
                            ApplicationArea = All;
                            RunObject = page "Vehicle Booking List";
                        }
                    }
                    group(VehicleBookingApproval)
                    {
                        Caption = 'Vehicle Booking Approval';
                        action("Approve Vehicle Booking")
                        {
                            ApplicationArea = All;
                            RunObject = page "Vehicle Booking Approval";
                        }
                    }
                }

                group(VehicleMaintenance)
                {
                    Caption = 'Vehicle Maintenance';
                    action("Maintain Vehicle")
                    {
                        RunObject = Page "Vehicle Maintenance List";
                        ApplicationArea = All;
                    }

                    group(VehicleInsurance)
                    {
                        Caption = 'Vehicle Insurance';
                        action("Vehicle Insurance")
                        {
                            ApplicationArea = All;
                            RunObject = page "Vehicle Insurance List";
                        }
                    }
                }

                group(FuelTracking)
                {
                    Caption = 'Fuel Tracking';
                    action("Track Fuel Consumption")
                    {
                        ApplicationArea = All;
                        RunObject = page "Fuel Tracking List";
                    }
                    action("Return Vehicle")
                    {
                        ApplicationArea = All;
                        RunObject = page "Returned Vehicle";
                    }
                    action("Driver Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Driver Setup List";
                    }
                    action("Administration 2.0 Setup")
                    {
                        ApplicationArea = All;
                        RunObject = page "Admin No. Setup";
                    }
                }
                group(BoardroomDetails)
                {
                    Caption = 'Boardroom Management';
                    action("RegisterBoardroom")
                    {
                        ApplicationArea = All;
                        RunObject = page "Boardroom Information List";

                    }
                    action("Book boardroom")
                    {
                        ApplicationArea = All;
                        RunObject = page "Booking List";

                    }
                    action("Approve Boardroom Booking")
                    {
                        ApplicationArea = All;
                        RunObject = page "Boardroom Approval";

                    }

                    group(Minutes)
                    {
                        Caption = 'Minutes Template';
                        action("View Minutes Template")
                        {
                            ApplicationArea = All;
                            RunObject = page "Minutes Template List";
                        }
                    }
                }
                group(Notices)
                {
                    Caption = 'Notices';
                    action("New Notice")
                    {
                        ApplicationArea = All;
                        RunObject = page "Notice List";
                    }
                    action("Notices Approval")
                    {
                        ApplicationArea = All;
                        RunObject = page "Notice Approval";
                    }

                    group(CEOScheduling)
                    {
                        Caption = 'CEOScheduling';
                        action("Scheduling")
                        {
                            ApplicationArea = All;
                            RunObject = page "Notice List";
                        }
                    }
                }
                group(Reports)
                {
                    Caption = 'Admin Reports';
                    action("Vehicle Booking Report")
                    {
                        Image = Report;
                        ApplicationArea = All;
                        RunObject = report "Vehicle Booking Report";
                    }
                    action("Vehicle Return Report")
                    {
                        Image = Report;
                        ApplicationArea = All;
                        RunObject = report "Vehicle Return Report";
                    }
                    action("Vehicle Register Report")
                    {
                        Image = Report;
                        ApplicationArea = All;
                        RunObject = report "Vehicle Register";
                    }
                    action("Vehicle Valuation Report")
                    {
                        Image = Report;
                        ApplicationArea = All;
                        RunObject = report "Vehicle Valuation Scheduling";
                    }
                    action("Booking Report")
                    {
                        Image = Report;
                        Caption = 'Boardroom Booking';
                        ApplicationArea = All;
                        RunObject = report "Boardroom Booking";
                    }
                }

            }
        }
    }
}
// Creates a profile that uses the Role Center
profile BoardroomProfile
{
    ProfileDescription = 'Vehicle & Boardroom Profile';
    RoleCenter = "Admin RoleCenter";
    Caption = 'VEHICLE';
}

