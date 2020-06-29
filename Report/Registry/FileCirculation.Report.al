report 50553 "File Circulation"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\File Circulation.rdlc';
    Caption = 'Files In Circulation';

    dataset
    {
        dataitem("Registry File"; "Registry File")
        {
            DataItemTableView = WHERE("File Request Status" = filter('Issued Out'));
            PrintOnlyIfDetail = true;
            column(FileNumber_RegistryFiles; "Registry File"."File Number")
            {
            }
            column(FileName_RegistryFiles; "Registry File"."File Name")
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
            dataitem("Transfer Files Line"; "Transfer Files Line")
            {
                DataItemLink = "File Number" = FIELD("File Number");
                DataItemTableView = WHERE(Returned = filter('No'));
                RequestFilterFields = "File Number", "Date Filter";
                //ReqFilterHeading = 'Registry Files';
                column(Name; CompanyInformation.Name)
                {
                }
                column(Address; CompanyInformation.Address)
                {
                }
                column(PostCode; CompanyInformation."Post Code")
                {
                }
                column(City; CompanyInformation.City)
                {
                }
                column(Picture; CompanyInformation.Picture)
                {
                }
                column(TransferID_TransferFilesLines; "Transfer Files Line"."Transfer ID")
                {
                }
                column(FileNo_TransferFilesLines; "Transfer Files Line"."File No")
                {
                }
                column(FileVolume_TransferFilesLines; "Transfer Files Line"."File Volume")
                {
                }
                column(FileNumber_TransferFilesLines; "Transfer Files Line"."File Number")
                {
                }
                column(FileName_TransferFilesLines; "Transfer Files Line"."File Name")
                {
                }
                column(MemberNo_TransferFilesLines; "Transfer Files Line"."Member No")
                {
                }
                column(IDNo_TransferFilesLines; "Transfer Files Line"."ID No")
                {
                }
                column(PayrollNo_TransferFilesLines; "Transfer Files Line"."Payroll No")
                {
                }
                column(ReleasedFrom_TransferFilesLines; "Transfer Files Line"."Released From")
                {
                }
                column(TimeReleased_TransferFilesLines; "Transfer Files Line"."Time Released")
                {
                }
                column(ReleasedTo_TransferFilesLines; "Transfer Files Line"."Released To")
                {
                }
                column(ReceivedBy_TransferFilesLines; "Transfer Files Line"."Received By")
                {
                }
                column(TimeReceived_TransferFilesLines; "Transfer Files Line"."Time Received")
                {
                }
                column(FileType_TransferFilesLines; "Transfer Files Line"."File Type")
                {
                }
                column(RequestID_TransferFilesLines; "Transfer Files Line"."Request ID")
                {
                }
                column(CurrentUser_TransferFilesLines; "Transfer Files Line"."Current User")
                {
                }
                column(CurrentUserID_TransferFilesLines; "Transfer Files Line"."Current User ID")
                {
                }
                column(Returned_TransferFilesLines; "Transfer Files Line".Returned)
                {
                }
                column(Returndate_TransferFilesLines; "Transfer Files Line"."Return date")
                {
                }
                column(Returnedby_TransferFilesLines; "Transfer Files Line"."Returned by")
                {
                }
                column(ReturnID_TransferFilesLines; "Transfer Files Line"."Return ID")
                {
                }
                column(DueDate_TransferFilesLines; "Transfer Files Line"."Due Date")
                {
                }
                column(departmentText1; departmentText1)
                {
                }
                column(departmentText2; departmentText2)
                {
                }

                trigger OnAfterGetRecord();
                begin
                    IssuedDate1 := DT2DATE(TransferFilesLines."Time Released");
                    IssuedDate2 := DT2DATE(TransferFilesLines."Time Released");
                    IF DateFilterString <> '' THEN BEGIN
                        IF IssuedDate1 < Date1 THEN BEGIN
                            CurrReport.SKIP;
                        END;
                        IF IssuedDate2 > Date2 THEN BEGIN
                            CurrReport.SKIP;
                        END;
                    END;
                    departmentCode := '';
                    departmentCode1 := '';
                    departmentText1 := '';
                    departmentText2 := '';
                    userID1 := '';
                    userID2 := '';
                    userID1 := TransferFilesLines."Released From";
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", userID1);
                    IF UserSetup.FINDFIRST THEN BEGIN

                        DimensionValue.RESET;
                        DimensionValue.SETRANGE("Global Dimension No.", 2);
                        IF DimensionValue.FINDFIRST THEN BEGIN
                            departmentText1 := DimensionValue.Name;
                        END;

                    END;

                    userID2 := TransferFilesLines."Released To";
                    UserSetup.RESET;
                    UserSetup.SETRANGE("User ID", userID2);
                    IF UserSetup.FINDFIRST THEN BEGIN

                        DimensionValue.RESET;
                        DimensionValue.SETRANGE("Global Dimension No.", 2);

                        IF DimensionValue.FINDFIRST THEN BEGIN
                            departmentText2 := DimensionValue.Name;
                        END;
                    END;
                end;

                trigger OnPreDataItem();
                begin
                    DateFilterString := TransferFilesLines.GETFILTER(TransferFilesLines."Date Filter");
                    IF STRPOS(DateFilterString, '..') <> 0 THEN BEGIN
                        Date1String := COPYSTR(DateFilterString, 1, STRPOS(DateFilterString, '..') - 1);
                        Date2String := COPYSTR(DateFilterString, STRPOS(DateFilterString, '..') + 2);
                        EVALUATE(Date1, Date1String);
                        EVALUATE(Date2, Date2String);
                    END;
                    IF STRPOS(DateFilterString, '..') = 0 THEN BEGIN
                        Date1String := DateFilterString;
                        Date2String := Date1String;
                        EVALUATE(Date1, Date1String);
                        EVALUATE(Date2, Date2String);
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
    end;

    var
        CompanyInformation: Record "Company Information";
        Date1: Date;
        Date2: Date;
        Date1String: Text;
        Date2String: Text;
        DateFilterString: Text;
        IssuedDate1: Date;
        IssuedDate2: Date;
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

