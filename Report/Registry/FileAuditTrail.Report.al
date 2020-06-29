report 50557 "File Audit Trail Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\File Audit Trail Report.rdlc';
    Caption = 'File Audit Trail Report';

    dataset
    {
        dataitem("Registry File"; "Registry File")
        {
            DataItemTableView = WHERE("Created" = filter('Yes'));
            RequestFilterFields = "File No.", "File Number", "File Name", "Member No.", "ID No.";
            column(FileNo_RegistryFiles; "Registry File"."File No.")
            {
            }
            column(FileNumber_RegistryFiles; "Registry File"."File Number")
            {
            }
            column(FileName_RegistryFiles; "Registry File"."File Name")
            {
            }
            column(FileType_RegistryFiles; "Registry File"."File Type")
            {
            }
            column(MemberNo_RegistryFiles; "Registry File"."Member No.")
            {
            }
            column(IDNo_RegistryFiles; "Registry File"."ID No.")
            {
            }
            column(PayrollNo_RegistryFiles; "Registry File"."Payroll No.")
            {
            }
            column(CreatedBy_RegistryFiles; "Registry File"."Created By")
            {
            }
            column(DateCreated_RegistryFiles; "Registry File"."Date Created")
            {
            }
            column(FileRequestStatus_RegistryFiles; "Registry File"."File Request Status")
            {
            }
            column(Status_RegistryFiles; "Registry File".Status)
            {
            }
            column(MemberStatus_RegistryFiles; "Registry File"."Member Status")
            {
            }
            column(Volume_RegistryFiles; "Registry File".Volume)
            {
            }
            column(File1_No; File1.No)
            {
            }
            column(File1_DateCreated; File1."Date Created")
            {
            }
            column(File2_No; File2."No.")
            {
            }
            column(File2_Date; File2.Date)
            {
            }
            dataitem("Transfer Files Lines"; "Transfer Files Line")
            {
                DataItemLink = "Member No" = FIELD("Member No.");
                RequestFilterFields = "File Number", "File Name", "Member No", "ID No", "File No";
                column(Name; CompanyInformation.Name)
                {
                }
                column(Address; CompanyInformation.Address)
                {
                }
                column(PostCode_CompanyInformation; CompanyInformation."Post Code")
                {
                }
                column(City_CompanyInformation; CompanyInformation.City)
                {
                }
                column(Pic_CompanyInformation; CompanyInformation.Picture)
                {
                }
                column(TransferID_TransferFilesLines; TransferFilesLines."Transfer ID")
                {
                }
                column(FileNo_TransferFilesLines; TransferFilesLines."File No")
                {
                }
                column(FileName_TransferFilesLines; TransferFilesLines."File Name")
                {
                }
                column(MemberNo_TransferFilesLines; TransferFilesLines."Member No")
                {
                }
                column(IDNo_TransferFilesLines; TransferFilesLines."ID No")
                {
                }
                column(PayrollNo_TransferFilesLines; TransferFilesLines."Payroll No")
                {
                }
                column(ReleasedFrom_TransferFilesLines; TransferFilesLines."Released From")
                {
                }
                column(TimeReleased_TransferFilesLines; TransferFilesLines."Time Released")
                {
                }
                column(ReleasedTo_TransferFilesLines; TransferFilesLines."Released To")
                {
                }
                column(ReceivedBy_TransferFilesLines; TransferFilesLines."Received By")
                {
                }
                column(TimeReceived_TransferFilesLines; TransferFilesLines."Time Received")
                {
                }
                column(FileType_TransferFilesLines; TransferFilesLines."File Type")
                {
                }
                column(FileNumber_TransferFilesLines; TransferFilesLines."File Number")
                {
                }
                column(FileVolume_TransferFilesLines; TransferFilesLines."File Volume")
                {
                }
                column(FileVolumes_Volume; FileVolumes.Volume)
                {
                }
                column(FileVolumes_DateCreated; FileVolumes."Date Created")
                {
                }
                column(Volume; Volume)
                {
                }
                column(DateCreated; DateCreated)
                {
                }
                column(ReceivedByDept; departmentText2)
                {
                }
                column(ReleasedToDept; departmentText1)
                {
                }
                dataitem("Registry File Number"; "Registry File Number")
                {
                    DataItemLink = "No." = FIELD("File No");
                    column(FileNumber_RegistryFileNumbers; "Registry File Number"."File Number")
                    {
                    }
                    column(Date_RegistryFileNumbers; "Registry File Number".Date)
                    {
                    }
                    column(No_RegistryFileNumbers; "Registry File Number"."No.")
                    {
                    }
                    column(PreviousFileNumber_RegistryFileNumbers; "Registry File Number"."Previous File Number")
                    {
                    }
                    column(ChangedBy_RegistryFileNumbers; "Registry File Number"."Changed By")
                    {
                    }
                }
                dataitem("File Volume"; "File Volume")
                {
                    DataItemLink = No = FIELD("File No");
                    column(Volume_FileVolumes; "File Volume".Volume)
                    {
                    }
                    column(FileNumber_FileVolumes; "File Volume"."File Number")
                    {
                    }
                    column(FileLocation_FileVolumes; "File Volume"."File Location")
                    {
                    }
                    column(DateCreated_FileVolumes; "File Volume"."Date Created")
                    {
                    }
                    column(Select_FileVolumes; "File Volume".Select)
                    {
                    }
                    column(PreviousFileNumber_FileVolumes; "File Volume"."Previous File Number")
                    {
                    }
                    column(CreatedBy_FileVolumes; "File Volume"."Created By")
                    {
                    }
                }

                trigger OnAfterGetRecord();
                begin
                    departmentCode := '';
                    departmentCode1 := '';
                    departmentText1 := '';
                    departmentText2 := '';
                    UserIDText := '';
                    UserIDText2 := '';
                    userID1 := '';
                    userID2 := '';
                    userID3 := '';


                    userID1 := "Transfer Files Lines"."Released From";
                    UserIDText := FORMAT(userID1);
                    UserIDText2 := COPYSTR(UserIDText, 1, 8);
                    IF UserIDText2 = 'REGISTRY' THEN BEGIN
                        UserIDText3 := SELECTSTR(2, UserIDText);
                        userID2 := FORMAT(UserIDText3);
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", userID2);
                        IF UserSetup.FINDFIRST THEN BEGIN


                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Global Dimension No.", 2);
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                departmentText1 := DimensionValue.Name;
                            END;

                        END;
                    END ELSE BEGIN
                        UserIDText2 := COPYSTR(UserIDText, 1, 13);
                        IF UserIDText2 = 'RECALLED FROM' THEN BEGIN
                            UserIDText3 := SELECTSTR(2, UserIDText);
                            userID2 := FORMAT(UserIDText3);
                            UserSetup.RESET;
                            UserSetup.SETRANGE("User ID", userID2);
                            IF UserSetup.FINDFIRST THEN BEGIN
                                DimensionValue.RESET;
                                DimensionValue.SETRANGE("Global Dimension No.", 2);
                                IF DimensionValue.FINDFIRST THEN BEGIN
                                    departmentText1 := DimensionValue.Name;
                                END;
                            END;
                        END
                    END;
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", "Transfer Files Lines"."Released From");
                    IF UserSetup.FINDFIRST THEN BEGIN
                        DimensionValue.RESET;
                        DimensionValue.SETRANGE("Global Dimension No.", 2);
                        IF DimensionValue.FINDFIRST THEN BEGIN
                            departmentText1 := DimensionValue.Name;
                        END;

                    END;


                    userID3 := "Transfer Files Lines"."Received By";
                    UserIDText4 := FORMAT(userID3);
                    UserIDText5 := COPYSTR(UserIDText4, 1, 8);
                    IF UserIDText5 = 'REGISTRY' THEN BEGIN
                        UserIDText6 := SELECTSTR(2, UserIDText4);
                        userID4 := FORMAT(UserIDText6);
                        UserSetup.RESET;
                        UserSetup.SETRANGE("User ID", userID4);
                        IF UserSetup.FINDFIRST THEN BEGIN
                            DimensionValue.RESET;
                            DimensionValue.SETRANGE("Global Dimension No.", 2);
                            IF DimensionValue.FINDFIRST THEN BEGIN
                                departmentText2 := DimensionValue.Name;
                            END;
                        END;

                    END;


                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", "Transfer Files Lines"."Received By");
                    IF UserSetup.FINDFIRST THEN BEGIN
                        DimensionValue.RESET;
                        DimensionValue.SETRANGE("Global Dimension No.", 2);
                        IF DimensionValue.FINDFIRST THEN BEGIN
                            departmentText2 := DimensionValue.Name;
                        END;

                    END;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport();
    begin
        CompanyInformation.GET;
        CompanyInformation.CALCFIELDS(Picture);

        FileFilter := '';
    end;

    trigger OnPreReport();
    begin
        WITH "Registry File" DO
            FileFilter := GETFILTER("File No.");

        IF FileFilter = '' THEN
            ERROR('Please specify a file');
    end;

    var
        CompanyInformation: Record "Company Information";
        FileFilter: Text;
        Reg: Record "Registry File";
        RegistryFileNumbers: Record "Registry File Number";
        FileVolumes: Record "File Volume";
        Volume: Code[20];
        DateCreated: Date;
        File1: Record "File Volume";
        File2: Record "Registry File Number";
        DimensionValue: Record "Dimension Value";
        departmentCode: Code[10];
        departmentCode1: Code[10];
        UserSetup: Record "User Setup";
        user: Code[90];
        departmentText1: Text;
        departmentText2: Text;
        TransferFilesLines: Record "Transfer Files Line";
        userID1: Code[60];
        userID3: Code[80];
        userID2: Code[60];
        userID4: Code[60];
        UserIDText: Text[80];
        UserIDText2: Text[80];
        UserIDText3: Text[80];
        UserIDText4: Text[80];
        UserIDText5: Text[80];
        UserIDText6: Text[80];
}

