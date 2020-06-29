report 50552 "Issued Files Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\Issued Files Report.rdlc';

    dataset
    {
        dataitem("Issued Registry File"; "Issued Registry File")
        {
            RequestFilterFields = "Request ID", "Requisiton By", "Date Filter";
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
            column(RequestID_IssuedRegistryFiles; "Issued Registry File"."Request ID")
            {
            }
            column(RequestDate_IssuedRegistryFiles; "Issued Registry File"."Request Date")
            {
            }
            column(RequiredDate_IssuedRegistryFiles; "Issued Registry File"."Required Date")
            {
            }
            column(DurationRequiredDays_IssuedRegistryFiles; "Issued Registry File"."Duration Required(Days)")
            {
            }
            column(DueDate_IssuedRegistryFiles; "Issued Registry File"."Due Date")
            {
            }
            column(RequisitonBy_IssuedRegistryFiles; "Issued Registry File"."Requisiton By")
            {
            }
            column(FileNo_IssuedRegistryFiles; "Issued Registry File"."File No.")
            {
            }
            column(FileName_IssuedRegistryFiles; "Issued Registry File"."File Name")
            {
            }
            column(ReasonCode_IssuedRegistryFiles; "Issued Registry File"."Reason Code")
            {
            }
            column(Remarks_IssuedRegistryFiles; "Issued Registry File".Remarks)
            {
            }
            column(RequestStatus_IssuedRegistryFiles; "Issued Registry File"."Request Status")
            {
            }
            column(IssuerID_IssuedRegistryFiles; "Issued Registry File"."Issuer ID")
            {
            }
            column(RejectionComment_IssuedRegistryFiles; "Issued Registry File"."Rejection Comment")
            {
            }
            column(IssuedDate_IssuedRegistryFiles; "Issued Registry File"."Issued Date")
            {
            }
            column(ApproverID_IssuedRegistryFiles; "Issued Registry File"."Approver ID")
            {
            }
            column(ApprovalComment_IssuedRegistryFiles; "Issued Registry File"."Approval Comment")
            {
            }
            dataitem("Registry Files Line"; "Registry Files Line")
            {
                DataItemLink = "Request ID" = FIELD("Request ID");
                DataItemTableView = WHERE("Registry Approval" = filter('Yes'));
                RequestFilterFields = "File No.", "Member No.";
                column(FileType_RegistryFilesLines; "Registry Files Line"."File Type")
                {
                }
                column(ApprovedRejectionTime_RegistryFilesLines; "Registry Files Line"."Approved/Rejection Time")
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
                column(Duration; Duration)
                {
                }
                column(FileNumber_RegistryFilesLines; "Registry Files Line"."File Number")
                {
                }
            }

            trigger OnAfterGetRecord();
            begin
                RequestDate2 := DT2DATE("Issued Registry File"."Request Date");
                FromRequestDate2 := DT2DATE("Issued Registry File"."Request Date");
                IF datefilterstring <> '' THEN BEGIN
                    IF RequestDate2 < date1 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                    IF FromRequestDate2 > date2 THEN BEGIN
                        CurrReport.SKIP;
                    END;
                END;
            end;

            trigger OnPreDataItem();
            begin
                datefilterstring := "Issued Registry File".GETFILTER("Issued Registry File"."Date Filter");
                IF STRPOS(datefilterstring, '..') <> 0 THEN BEGIN
                    IF datefilterstring <> '' THEN BEGIN
                        date1string := COPYSTR(datefilterstring, 1, STRPOS(datefilterstring, '..') - 1);
                        date2string := COPYSTR(datefilterstring, STRPOS(datefilterstring, '..') + 2);
                        EVALUATE(date1, date1string);
                        EVALUATE(date2, date2string);
                    END;
                END;
                IF STRPOS(datefilterstring, '..') = 0 THEN BEGIN
                    IF datefilterstring <> '' THEN BEGIN
                        date1string := datefilterstring;
                        date2string := date1string;
                        EVALUATE(date1, date1string);
                        EVALUATE(date2, date2string);
                    END;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                //Caption = 'Request Date';
            }
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
        Duration: DateFormula;
        RequestDate: Date;
        RequestDate2: Date;
        RequestTime: Time;
        RequestDateTime: DateTime;
        FromRequestDate: Date;
        FromRequestDate2: Date;
        date1: Date;
        date2: Date;
        datefilterstring: Text;
        date1string: Text;
        date2string: Text;
}

