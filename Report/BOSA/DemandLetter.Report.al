report 50096 "Demand Letter"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Demand Letter.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "No.", "Member No.";
            column(No_LoanApplication; "No.")
            {
            }
            column(LoanProductType_LoanApplication; "Loan Product Type")
            {
            }
            column(Description_LoanApplication; Description)
            {
            }
            column(MemberNo_LoanApplication; "Member No.")
            {
            }
            column(MemberName_LoanApplication; "Member Name")
            {
            }
            column(OutstandingBalance_LoanApplication; "Outstanding Balance")
            {
            }
            column(TotalArrearsAmount_LoanApplication; "Total Arrears Amount")
            {
            }
            column(DemandLetterText; FORMAT(DemandLetterText))
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CLEAR(DemandLetterText);
                CALCFIELDS("Outstanding Balance");
                LoanDefaultSetup."Demand Letter Template".CREATEOUTSTREAM(OStream);
                DemandLetterText.WRITE(OStream);
                DemandLetterText.ADDTEXT(STRSUBSTNO(LoanDefaultSetup.GetDemandLetterTemplate, ABS("Outstanding Balance"), "Total Arrears Amount", "Interest Rate",
                                         ABS("Outstanding Balance"), ABS("Outstanding Balance")));
            end;

            trigger OnPreDataItem()
            begin
                LoanDefaultSetup.GET;
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
        ReportTitle = 'Demand Letter';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        LoanDefaultSetup: Record "Loan Default Setup";
        DemandLetterText: BigText;
        OStream: OutStream;
        CompanyInfo: Record "Company Information";
}

