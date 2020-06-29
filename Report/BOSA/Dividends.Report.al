report 50103 "Dividends Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Dividends Report.rdlc';

    dataset
    {
        dataitem(DataItem1; "Dividend Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_DividendHeader; "No.")
            {
            }
            column(Description_DividendHeader; Description)
            {
            }
            column(PeriodCode_DividendHeader; "Period Code")
            {
            }
            column(TotalAmount_DividendHeader; "Total Amount")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Dividend Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(MemberNo_DividendLine; "Member No.")
                {
                }
                column(MemberName_DividendLine; "Member Name")
                {
                }
                column(AccountType_DividendLine; "Account Type")
                {
                }
                column(AccountNo_DividendLine; "Account No.")
                {
                }
                column(AccountName_DividendLine; "Account Name")
                {
                }
                column(AccountBalance_DividendLine; "Account Balance")
                {
                }
                column(EarningType_DividendLine; "Earning Type")
                {
                }
                column(GrossEarningAmount_DividendLine; "Gross Earning Amount")
                {
                }
                column(GlobalDimension1Code_DividendLine; "Global Dimension 1 Code")
                {
                }
                column(ExciseDutyAmount_DividendLine; "Excise Duty Amount")
                {
                }
                column(WithholdingTaxAmount_DividendLine; "Withholding Tax Amount")
                {
                }
                column(CommissionAmount_DividendLine; "Commission Amount")
                {
                }
                column(NetEarningAmount_DividendLine; "Net Earning Amount")
                {
                }
                column(DistributionOption_DividendLine; "Distribution Option")
                {
                }
                column(SharesTopupAmount_DividendLine; "Shares Topup Amount")
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
        ReportTitle = 'Dividends Report';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
}

