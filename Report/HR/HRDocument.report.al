report 50260 "HR Documents Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\HR\HR Documents Report.rdlc';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = all;

    dataset
    {
        dataitem(DataItem1; 50226)
        {
            column(DocumentName_HumanResourceDoc; "Document Name")
            {
            }
            column(Uploaddate_HumanResourceDoc; "Upload date")
            {
            }
            column(UploadBy_HumanResourceDoc; "Upload By")
            {
            }
            column(UploadTime_HumanResourceDoc; "Upload Time")
            {
            }
            column(Picture; CompanyInformation.Picture)
            {
            }
            column(Address; CompanyInformation.Address)
            {
            }
            column(Name; CompanyInformation.Name)
            {
            }
            column(SerialNo; "SerialNo.")
            {
            }

            trigger OnAfterGetRecord();
            begin
                CompanyInformation.RESET;
                CompanyInformation.CALCFIELDS(Picture);
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
        "SerialNo." += 1;
    end;

    var
        "SerialNo.": Integer;
        CompanyInformation: Record 79;
}

