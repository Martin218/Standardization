report 50554 "Returned File"
{
    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Registry\Returned File.rdlc';

    dataset
    {
        dataitem("Transfer Files Line"; "Transfer Files Line")
        {
            DataItemTableView = WHERE(Returned = filter('Yes'));
            column(TransferID_TransferFilesLine; "Transfer Files Line"."Transfer ID")
            {
            }
            column(FileNo_TransferFilesLine; "Transfer Files Line"."File No")
            {
            }
            column(FileName_TransferFilesLine; "Transfer Files Line"."File Name")
            {
            }
            column(MemberNo_TransferFilesLine; "Transfer Files Line"."Member No")
            {
            }
            column(ReleasedFrom_TransferFilesLine; "Transfer Files Line"."Released From")
            {
            }
            column(TimeReleased_TransferFilesLine; "Transfer Files Line"."Time Released")
            {
            }
            column(ReleasedTo_TransferFilesLine; "Transfer Files Line"."Released To")
            {
            }
            column(ReceivedBy_TransferFilesLine; "Transfer Files Line"."Received By")
            {
            }
            column(TimeReceived_TransferFilesLine; "Transfer Files Line"."Time Received")
            {
            }
            column(FileType_TransferFilesLine; "Transfer Files Line"."File Type")
            {
            }
            column(RequestID_TransferFilesLine; "Transfer Files Line"."Request ID")
            {
            }
            column(CurrentUserID_TransferFilesLine; "Transfer Files Line"."Current User ID")
            {
            }
            column(Returndate_TransferFilesLine; "Transfer Files Line"."Return date")
            {
            }
            column(Returnedby_TransferFilesLine; "Transfer Files Line"."Returned by")
            {
            }
            column(ReturnID_TransferFilesLine; "Transfer Files Line"."Return ID")
            {
            }
            column(FileNumber_TransferFilesLine; "Transfer Files Line"."File Number")
            {
            }
            column(FileVolume_TransferFilesLine; "Transfer Files Line"."File Volume")
            {
            }
            column(CarriedBy_TransferFilesLine; "Transfer Files Line"."Carried By")
            {
            }
            dataitem("Company Information"; "Company Information")
            {
                column(Name; CompanyInformation.Name)
                {
                }
                column(Picture; CompanyInformation.Picture)
                {
                }
                column(Address; CompanyInformation.Address)
                {
                }
            }

            trigger OnPreDataItem();
            begin
                TransferFilesLine.RESET;
                TransferFilesLine.SETRANGE(Returned, TRUE);
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
        TransferFilesLine: Record "Transfer Files Line";
}

