page 51051 "Admin2.0 Role Center"
{
    PageType = RoleCenter;
    Caption = 'Admin 2.0';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Admin RoleCenter Headline")
            {
                ApplicationArea = Basic, Suite;
            }
            part(Activities; "Admin Actions")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Help Apnd Chart Wrapper"; "Help And Chart Wrapper")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Report Inbox Part"; "Report Inbox Part")
            {
                ApplicationArea = Basic, Suite;
            }
            part("Power BI Report Spinner Part"; "Power BI Report Spinner Part")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
        area(Creation)
        {
            action("Add vehicle to registry")
            {
                RunPageMode = Create;
                Caption = 'Add vehicle to registry';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Vehicle Register card";
                ApplicationArea = Basic, Suite;
            }
            action("Book Vehicle")
            {
                RunPageMode = Create;
                Caption = 'Book Vehicle';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Vehicle Booking Card";
                ApplicationArea = Basic, Suite;
            }
            action("Track Insurance Scheduling")
            {
                RunPageMode = Create;
                Caption = 'Track Insurance Scheduling';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Vehicle Insurance Card";
                ApplicationArea = Basic, Suite;
            }
            action("Track Fuel Consumption")
            {
                RunPageMode = Create;
                Caption = 'Track Fuel Consumption';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Fuel Tracking Card";
                ApplicationArea = Basic, Suite;
            }
            action("Track Vehicle Maintenance")
            {
                RunPageMode = Create;
                Caption = 'Track Vehicle Maintenance';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Vehicle Maintenance Card";
                ApplicationArea = Basic, Suite;
            }
            action(" Add Setup")
            {
                RunPageMode = Create;
                Caption = 'Add Setups';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Admin No. Card Setup";
                ApplicationArea = Basic, Suite;
            }
            action("Add boardroom to registry")
            {
                RunPageMode = Create;
                Caption = 'Add boardroom to registry';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Boardroom Information Card";
                ApplicationArea = Basic, Suite;
            }
            action("Book Boardroom")
            {
                RunPageMode = Create;
                Caption = 'Book Boardroom';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Booking Process Card";
                ApplicationArea = Basic, Suite;
            }
            action("Attach Notices")
            {
                RunPageMode = Create;
                Caption = 'Attach Notices';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Notice Card";
                ApplicationArea = Basic, Suite;
            }
            action("Attach Minutes")
            {
                RunPageMode = Create;
                Caption = 'Attach Minutes';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Minutes Template Card";
                ApplicationArea = Basic, Suite;
            }

        }
        area(Processing)
        {
            group(New)
            {
                action("AppNameMasterData")
                {
                    RunPageMode = Create;
                    Caption = 'AppNameMasterData';
                    ToolTip = 'Register new AppNameMasterData';
                    //RunObject = page "AppNameMasterData Card";
                    Image = DataEntry;
                    ApplicationArea = Basic, Suite;
                }
            }
            group("AppNameSomeProcess Group")
            {
                action("AppNameSomeProcess")
                {
                    Caption = 'AppNameSomeProcess';
                    ToolTip = 'AppNameSomeProcess description';
                    Image = Process;
                    //RunObject = Codeunit "AppNameSomeProcess";
                    ApplicationArea = Basic, Suite;
                }
            }
            group("Admin Reports")
            {
                action("Vehicle Register")
                {
                    Caption = 'Vehicle Register';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Vehicle Register";
                    ApplicationArea = Basic, Suite;
                }
                action("Vehicle Maintenance Rport")
                {
                    Caption = 'Vehicle Maintenance';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Vehicle Maintenance Report";
                    ApplicationArea = Basic, Suite;
                }
                action("Vehicle Insurance")
                {
                    Caption = 'Vehicle Insurance';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Vehicle Valuation Scheduling";
                    ApplicationArea = Basic, Suite;
                }
                action("Motor Vehicle Booking Report")
                {
                    Caption = 'Vehicle Booking';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Vehicle Booking Report";
                    ApplicationArea = Basic, Suite;
                }
                action("Boardroom Booking")
                {
                    Caption = 'Boardroom Registry';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Boardroom Booking";
                    ApplicationArea = Basic, Suite;
                }
            }
        }
        area(Reporting)
        {
            action("AppNameSomeReport")
            {
                Caption = 'AppNameSomeReport';
                ToolTip = 'AppNameSomeReport description';
                Image = Report;
                //RunObject = report "AppNameSomeReport";
                Promoted = true;
                PromotedCategory = Report;
                PromotedIsBig = true;
                ApplicationArea = Basic, Suite;
            }

        }
        area(Embedding)
        {
            action("AppNameMasterData List")
            {
                //RunObject = page "AppNameMasterData List";
                ApplicationArea = Basic, Suite;
            }

        }
        area(Sections)
        {

            group("Vehicle Management")
            {
                action("Vehicle Addition")
                {
                    ApplicationArea = All;
                    RunObject = page "Vehicle Registry list";
                }
                action("Vehicle Booking")
                {
                    ApplicationArea = All;
                    RunObject = page "Vehicle Booking List";
                }
                action("Booking Approval")
                {
                    ApplicationArea = All;
                    RunObject = page "Vehicle Booking Approval";
                }
                group("Booking Status")
                {
                    action("Booking Report")
                    {
                        ApplicationArea = All;
                        RunObject = report "Vehicle Booking Report";
                    }

                }
                group("Vehicle Maintenance")
                {
                    action("Maintain Vehicle")
                    {
                        ApplicationArea = All;
                        RunObject = page "Vehicle Maintenance List";
                    }

                }
                group("Vehicle Insurance Scheduling")
                {
                    action("Schedule Valuation")
                    {
                        ApplicationArea = All;
                        RunObject = page "Vehicle Insurance List";
                    }

                }
                group("Vehicle Fuel Tracking")
                {
                    action("Track Fuel Expenses")
                    {
                        ApplicationArea = All;
                        RunObject = page "Fuel Tracking List";
                    }

                }
                group("Vehicle Return")
                {
                    action("Return Vehicle")
                    {
                        ApplicationArea = All;
                        RunObject = page "Returned Vehicle";
                    }

                }
            }
            group("Boardroom Management")
            {
                action("Add Boardroom Details")
                {

                    ApplicationArea = All;
                    RunObject = page "Boardroom Information List";
                }
                action("BookBoardroom")
                {
                    ApplicationArea = All;
                    RunObject = page "Booking List";
                }

                action("Booked Boardrooms")
                {

                    ApplicationArea = All;
                    RunObject = report "Boardroom Booking";
                }
                action("Approve Boardroom")
                {

                    ApplicationArea = All;
                    RunObject = page "Boardroom Approval";
                }

            }
            group("Minutes")
            {
                action("Attach Minute Minutes")
                {

                    ApplicationArea = All;
                    RunObject = page "Minutes Template List";
                }


            }
            group("Notices")
            {
                action("Manage Notices")
                {

                    ApplicationArea = All;
                    RunObject = page "Notice List";
                }
                action("Approve Notices")
                {

                    ApplicationArea = All;
                    RunObject = page "Notice Approval";
                }
            }
            group("Administration Setups")
            {
                action("Admin No. Series Numbers")
                {

                    ApplicationArea = All;
                    RunObject = page "Admin No. Setup";
                }
                action("Driver Setup")
                {

                    ApplicationArea = All;
                    RunObject = page "Driver Setup List";
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
                action("BRD Booking Report")
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



profile AdministrationProfile
{
    ProfileDescription = 'Administration Profile';
    RoleCenter = "Admin2.0 Role Center";
    Caption = 'ADMINPROFILE';
}