page 51021 "Registry RoleCenter"
{
    PageType = RoleCenter;
    Caption = 'Registry Role Center';

    layout
    {
        area(RoleCenter)
        {
            group(Group1)
            {
                part(Part1; "Registry RoleCenter Headline")
                {
                    ApplicationArea = All;
                }

                part(Part2; "Registry RoleCenter Headline")
                {
                    Caption = 'Registry';
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
        area(Sections)
        {
            group("Registry")
            {
                Caption = 'REGISTRY';
                Image = AnalysisView;
                group(RegistryFiles)
                {
                    Caption = 'File List';

                    action("Register New File")
                    {
                        RunObject = Page "New File List";
                        ApplicationArea = All;
                    }
                    group(FileQueue)
                    {
                        Caption = 'File Queue';
                        action("Check File Queue")
                        {
                            ApplicationArea = All;
                            RunObject = page "File Queue";
                        }
                    }
                }

                group(FileInventory)
                {
                    Caption = 'File Inventory';
                    action("File Registry")
                    {
                        RunObject = Page "Registry File List";
                        ApplicationArea = All;
                    }


                }
            }

            group(FileIssuance)
            {
                Caption = 'File Issuance';
                action("Request File")
                {
                    ApplicationArea = All;
                    RunObject = page "Request File List";
                }
                action("Check Issued File List")
                {
                    ApplicationArea = All;
                    RunObject = page "Issued File List";
                }
                action("Supervisor File Approval")
                {
                    ApplicationArea = All;
                    RunObject = page "Supervisor File Approval Card1";
                }
                action("Check File Pending Issuance")
                {
                    ApplicationArea = All;
                    RunObject = page "Files Pending Issuance";
                }
            }
            group(InterBranchTransfer)
            {
                Caption = 'InterBranch Transfer';
                action("Inter Branch File Transfer")
                {
                    ApplicationArea = All;
                    RunObject = page "File Movement Request List";

                }
                action("Check File Movement Approval List")
                {
                    ApplicationArea = All;
                    RunObject = page "File Movement Approval List";

                }
                action("Branch Transfer Files")
                {
                    ApplicationArea = All;
                    RunObject = page "Ready To Transfer Files List";

                }
                action("Accept Dispatched Files")
                {
                    ApplicationArea = All;
                    RunObject = page "Receive Dispatched Files";

                }



            }
            group(RegistrySetup)
            {
                Caption = 'Setups';
                action("Registry Setups")
                {
                    ApplicationArea = All;
                    RunObject = page "Registry Number";
                }
                action("Check File Type")
                {
                    ApplicationArea = All;
                    RunObject = page "File Type";
                }
                action("Registry Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Registry Setup";
                }
                action("Member Type Setup")
                {
                    ApplicationArea = All;
                    RunObject = page "Registry Member Status";
                }


            }
            group(Reports)
            {
                Caption = 'Registry Reports';
                action("File Inventory")
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

// Creates a profile that uses the Role Center
profile RegistryProfile
{
    ProfileDescription = 'Registry Profile';
    RoleCenter = "Registry RoleCenter";
    Caption = 'Registry';
}

