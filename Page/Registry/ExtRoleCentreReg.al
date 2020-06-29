page 51052 "Registry 2.0 Role Center"
{
    PageType = RoleCenter;
    Caption = 'Registry 2.0';

    layout
    {
        area(RoleCenter)
        {
            part(Headline; "Registry RoleCenter Headline")
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
            action("Add File to Registry")
            {
                RunPageMode = Create;
                Caption = 'Add file to registry';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Registry File Card";
                ApplicationArea = Basic, Suite;
            }
            action("Request File")
            {
                RunPageMode = Create;
                Caption = 'Request File';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "File Request Card";
                ApplicationArea = Basic, Suite;
            }
            action("Issue File")
            {
                RunPageMode = Create;
                Caption = 'Isseu File';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "File Issue Card";
                ApplicationArea = Basic, Suite;
            }
            action("Inter Branch File Transfer")
            {
                RunPageMode = Create;
                Caption = 'Inter Branch File Transfer';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Transfer Files Card";
                ApplicationArea = Basic, Suite;
            }
            action("File Movement")
            {
                RunPageMode = Create;
                Caption = 'File Movement';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "File Movement Request Card";
                ApplicationArea = Basic, Suite;
            }
            action(" Add Setup")
            {
                RunPageMode = Create;
                Caption = 'Add Setups';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Registry Numbers Card";
                ApplicationArea = Basic, Suite;
            }
            action("Registry Members Card")
            {
                RunPageMode = Create;
                Caption = 'Registry Member Status';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "Registry Member Status";
                ApplicationArea = Basic, Suite;
            }
            action("Registry File Status")
            {
                RunPageMode = Create;
                Caption = 'Registry File Status';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "File Type";
                ApplicationArea = Basic, Suite;
            }
            action("Return File")
            {
                RunPageMode = Create;
                Caption = 'Return File';
                ToolTip = 'Add some tooltip here';
                Image = New;
                RunObject = page "File Return Card";
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
            group("File Registry Reports")
            {
                action("Vehicle Register")
                {
                    Caption = 'File Register';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Registry Inventory";
                    ApplicationArea = Basic, Suite;
                }
                action("File Trail")
                {
                    Caption = 'File Movement';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "File Movement Report";
                    ApplicationArea = Basic, Suite;
                }
                action("File Circulation")
                {
                    Caption = 'File Circulation';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "File Circulation";
                    ApplicationArea = Basic, Suite;
                }

                action("File Requistion")
                {
                    Caption = 'File Requistion';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "File Requisition";
                    ApplicationArea = Basic, Suite;
                }
                action("Returned Files")
                {
                    Caption = 'Returned Files';
                    ToolTip = 'AppNameSomeReport description';
                    Image = Report;
                    RunObject = report "Returned File";
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
            group("File List")
            {
                action("File Inventory")
                {
                    ApplicationArea = All;
                    RunObject = page "Registry File List";
                }
                action("File Queue")
                {
                    ApplicationArea = All;
                    RunObject = page "File Queue";
                }
                group("Inventory")
                {
                    action("Registry Report")
                    {
                        ApplicationArea = All;
                        RunObject = report "Registry Inventory";
                    }

                }
            }
            group("Files Request")
            {
                action("Request Files")
                {

                    ApplicationArea = All;
                    RunObject = page "File Movement Request List";
                }
                action("File Movement List")
                {
                    ApplicationArea = All;
                    RunObject = page "File Movement Approval List";
                }

                action("Issued File List")
                {

                    ApplicationArea = All;
                    RunObject = page "Issued File List";
                }
                action("Check File Pending Issuance")
                {

                    ApplicationArea = All;
                    RunObject = page "Files Pending Issuance";
                }

            }
            group("Inter Branch Transfer")
            {
                action("Inter Branch Files Transfer")
                {

                    ApplicationArea = All;
                    RunObject = page "File Movement Request List";
                }
                action("Check File Movement")
                {
                    ApplicationArea = All;
                    RunObject = page "File Movement Approval List";
                }

                action("Branch Transfer Files")
                {

                    ApplicationArea = All;
                    RunObject = page "Ready To Transfer Files List";
                }
                action("Receive Dispatched Files")
                {

                    ApplicationArea = All;
                    RunObject = page "Receive Dispatched Files";
                }

            }
            group("File Return")
            {
                action("Return Files")
                {

                    ApplicationArea = All;
                    RunObject = page "File Return List";
                }
            }
            group("Registry Setups")
            {
                action("Registry Numbers")
                {

                    ApplicationArea = All;
                    RunObject = page "Registry File Numbers";
                }
                action("RegistryNo. Series")
                {

                    ApplicationArea = All;
                    RunObject = page "Registry Number";
                }
                action("Registry Setup")
                {

                    ApplicationArea = All;
                    RunObject = page "Registry Setup";
                }
                action("File Types")
                {

                    ApplicationArea = All;
                    RunObject = page "File Type";
                }
                action("File Member Status")
                {

                    ApplicationArea = All;
                    RunObject = page "Registry Member Status";
                }

            }
            group(Reports)
            {
                Caption = 'Registry Reports';
                action("File Registry")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "Registry Inventory";
                }
                action("File Requisition")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "File Requisition";
                }
                action("Issued Files Report")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "Issued Files Report";
                }
                action("Files in Circulation Report")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "File Circulation";
                }
                action("Returned Files Report")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "Returned File";
                }
                action("Overdue Files Report")
                {
                    Image = Report;
                    ApplicationArea = All;
                    //RunObject = report fil
                }
                action("File Movement Report")
                {
                    Image = Report;
                    //Caption = 'Boardroom Booking';
                    ApplicationArea = All;
                    RunObject = report "File Movement Report";
                }
                action("File Audit Trail Report")
                {
                    Image = Report;
                    ApplicationArea = All;
                    RunObject = report "File Audit Trail Report";
                }
            }
        }
    }

}
profile Regisry2Profile
{
    ProfileDescription = 'Registry Profile';
    RoleCenter = "Registry 2.0 Role Center";
    Caption = 'REGISTRYPROFILE';
}