report 50551 "File Requisition"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\File Requisition.rdlc';

    dataset
    {
        dataitem("File Issuance"; "File Issuance")
        {
            DataItemTableView = WHERE("Request Status" = FILTER(Active | Issued | 'Ready For PickUp'));
            RequestFilterFields = "Request ID", "Request Status", "Requisiton By", "Date Filter";
            // ReqFilterHeading = 'Requests';
            column(Name_CompanyInformation; CompanyInformation.Name)
            {
            }
            column(Address_CompanyInformation; CompanyInformation.Address)
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
            column(RequestID_FileIssuance; "File Issuance"."Request ID")
            {
            }
            column(RequestDate_FileIssuance; "File Issuance"."Request Date")
            {
            }
            column(RequiredDate_FileIssuance; "File Issuance"."Required Date")
            {
            }
            column(DurationRequiredDays_FileIssuance; "File Issuance"."Duration Required(Days)")
            {
            }
            column(DueDate_FileIssuance; "File Issuance"."Due Date")
            {
            }
            column(RequisitonBy_FileIssuance; "File Issuance"."Requisiton By")
            {
            }
            column(FileNo_FileIssuance; "File Issuance"."File No.")
            {
            }
            column(FileName_FileIssuance; "File Issuance"."File Name")
            {
            }
            column(ReasonCode_FileIssuance; "File Issuance".Reason)
            {
            }
            column(Remarks_FileIssuance; "File Issuance".Remarks)
            {
            }
            column(NoSeries_FileIssuance; "File Issuance"."No. Series")
            {
            }
            column(RequestStatus_FileIssuance; "File Issuance"."Request Status")
            {
            }
            column(IssuerID_FileIssuance; "File Issuance"."Issuer ID")
            {
            }
            column(RejectionComment_FileIssuance; "File Issuance"."Rejection Comment")
            {
            }
            column(IssuedDate_FileIssuance; "File Issuance"."Issued Date")
            {
            }
            column(Issued_FileIssuance; "File Issuance".Issued)
            {
            }
            column(Picked_FileIssuance; "File Issuance".Picked)
            {
            }
            column(ApproverID_FileIssuance; "File Issuance"."Approver ID")
            {
            }
            column(ApprovedDate_FileIssuance; "File Issuance"."Approved Date")
            {
            }
            column(ApprovalComment_FileIssuance; "File Issuance"."Approval Comment")
            {
            }
            column(Returned_FileIssuance; "File Issuance".Returned)
            {
            }
            column(Department_Name; deptName)
            {
            }
            column(RequestonBehalfOf_FileIssuance; "File Issuance"."Request on Behalf Of")
            {
            }
            dataitem("Registry Files Line"; "Registry Files Line")
            {
                DataItemLink = "Request ID" = FIELD("Request ID");
                RequestFilterFields = "Date Filter";
                //ReqFilterHeading = 'Files Requested';
                column(FileType_RegistryFilesLines; "Registry Files Line"."File Type")
                {
                }
                column(FileNo_RegistryFilesLines; "Registry Files Line"."File No.")
                {
                }
                column(FileName_RegistryFilesLines; "Registry Files Line"."File Name")
                {
                }
                column(Type_RegistryFilesLines; "Registry Files Line".Type)
                {
                }
                column(Status_RegistryFilesLines; "Registry Files Line".Status)
                {
                }
                column(Location_RegistryFilesLines; "Registry Files Line".Location)
                {
                }
                column(No_RegistryFilesLines; "Registry Files Line"."No.")
                {
                }
                column(RequestID_RegistryFilesLines; "Registry Files Line"."Request ID")
                {
                }
                column(MemberNo_RegistryFilesLines; "Registry Files Line"."Member No.")
                {
                }
                column(IDNo_RegistryFilesLines; "Registry Files Line"."ID No.")
                {
                }
                column(PayrollNo_RegistryFilesLines; "Registry Files Line"."Payroll No.")
                {
                }
                column(Returned_RegistryFilesLines; "Registry Files Line".Returned)
                {
                }
                column(ReturnDate_RegistryFilesLines; "Registry Files Line"."Return Date")
                {
                }
                column(ReturnedBy_RegistryFilesLines; "Registry Files Line"."Returned By")
                {
                }
                column(RequisitionBy_RegistryFilesLines; "Registry Files Line"."Requisition By")
                {
                }
                column(HODComments_RegistryFilesLines; "Registry Files Line"."HOD Comments")
                {
                }
                column(RegistryComment_RegistryFilesLines; "Registry Files Line"."Registry Comment")
                {
                }
                column(ApprovedRejectionTime_RegistryFilesLines; "Registry Files Line"."Approved/Rejection Time")
                {
                }
                column(FileNumber_RegistryFilesLines; "Registry Files Line"."File Number")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                deptCode := '';
                deptName := '';
                UserSetup.RESET;
                UserSetup.SETRANGE("User ID", "File Issuance"."Requisiton By");
                IF UserSetup.FINDFIRST THEN BEGIN


                    DimensionValue.RESET;
                    DimensionValue.SETRANGE("Global Dimension No.", 2);
                    IF DimensionValue.FINDFIRST THEN BEGIN
                        deptName := DimensionValue.Name;
                    END;

                END;
                RequestDate := DT2DATE("File Issuance"."Request Date");
                RequestDate2 := DT2DATE("File Issuance"."Request Date");
                IF DateFilterString <> '' THEN BEGIN
                    IF RequestDate < Date1 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    IF RequestDate2 > Date2 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin

                DateFilterString := "File Issuance".GETFILTER("File Issuance"."Date Filter");
                IF STRPOS(DateFilterString, '..') <> 0 THEN BEGIN
                    IF DateFilterString <> '' THEN BEGIN
                        Date1String := COPYSTR(DateFilterString, 1, STRPOS(DateFilterString, '..') - 1);
                        Date2String := COPYSTR(DateFilterString, STRPOS(DateFilterString, '..') + 2);
                        EVALUATE(Date1, Date1String);
                        EVALUATE(Date2, Date2String);
                    END;
                END;
                IF STRPOS(DateFilterString, '..') = 0 THEN BEGIN
                    IF DateFilterString <> '' THEN BEGIN
                        Date1String := DateFilterString;
                        Date2String := Date1String;
                        EVALUATE(Date1, Date1String);
                        EVALUATE(Date2, Date2String);
                    END;
                END;
            end;
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
        DateFilterString: Text;
        Date1String: Text;
        Date2String: Text;
        RequestDate: Date;
        RequestDate2: Date;
        FileIssuance: Record "File Issuance";
        deptCode: Code[10];
        DimensionValue: Record "Dimension Value";
        deptName: Text[100];
        UserSetup: Record "User Setup";
}

