report 50097 "Share Certificate"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Share Certificate.rdlc';

    dataset
    {
        dataitem(DataItem1; Member)
        {
            RequestFilterFields = "No.";
            column(FullName_Member; "Full Name")
            {
            }
            column(No_Member; "No.")
            {
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
}

