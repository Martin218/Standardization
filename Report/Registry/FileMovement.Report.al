report 50556 "File Movement Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\File Movement Report.rdlc';

    dataset
    {
        dataitem("File Movement"; "File Movement")
        {
            column(FileMovementID_FileMovement; "File Movement"."File Movement ID")
            {
            }
            column(FileNo_FileMovement; "File Movement"."File No.")
            {
            }
            column(FileName_FileMovement; "File Movement"."File Name")
            {
            }
            column(ReasonCode_FileMovement; "File Movement"."Reason Code")
            {
            }
            column(Volume_FileMovement; "File Movement".Volume)
            {
            }
            column(FromLocation_FileMovement; "File Movement"."From Location")
            {
            }
            column(ToLocation_FileMovement; "File Movement"."To Location")
            {
            }
            column(RequestRemarks_FileMovement; "File Movement"."Request Remarks")
            {
            }
            column(ReleasedBy_FileMovement; "File Movement"."Released By")
            {
            }
            column(ReleasedTo_FileMovement; "File Movement"."Released To")
            {
            }
            column(DateReleased_FileMovement; "File Movement"."Date Released")
            {
            }
            column(CarriedBy_FileMovement; "File Movement"."Carried By")
            {
            }
            column(Status_FileMovement; "File Movement".Status)
            {
            }
            column(RequestDate_FileMovement; "File Movement"."Request Date")
            {
            }
            column(ApprovedDate_FileMovement; "File Movement"."Approved Date")
            {
            }
            column(ReceivedBy_FileMovement; "File Movement"."Received By")
            {
            }
            column(MemberNo_FileMovement; "File Movement"."Member No")
            {
            }
            column(RequestedBy_FileMovement; "File Movement"."Requested By")
            {
            }
            dataitem("Company Information"; "Company Information")
            {
                column(Name; "Company Information".Name)
                {
                }
                column(Address; "Company Information".Address)
                {
                }
                column(Picture; "Company Information".Picture)
                {
                }
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
}

