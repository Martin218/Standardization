report 50104 "Payout Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Payout Report.rdlc';

    dataset
    {
        dataitem(DataItem1; "Payout Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_PayoutHeader; "No.")
            {
            }
            column(PayoutType_PayoutHeader; "Payout Type")
            {
            }
            column(Description_PayoutHeader; Description)
            {
            }
            column(GlobalDimension1Code_PayoutHeader; "Global Dimension 1 Code")
            {
            }
            column(PaymentMethod_PayoutHeader; "Payment Method")
            {
            }
            column(AgencyCode_PayoutHeader; "Agency Code")
            {
            }
            column(AgencyName_PayoutHeader; "Agency Name")
            {
            }
            column(TotalPayoutAmount_PayoutHeader; "Total Payout Amount")
            {
            }
            column(AgencyAccountBalance_PayoutHeader; "Agency Account Balance")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Payout Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(MemberNo_PayoutLine; "Member No.")
                {
                }
                column(MemberName_PayoutLine; "Member Name")
                {
                }
                column(GlobalDimension1Code_PayoutLine; "Global Dimension 1 Code")
                {
                }
                column(AccountNo_PayoutLine; "Account No.")
                {
                }
                column(AccountName_PayoutLine; "Account Name")
                {
                }
                column(GrossAmount_PayoutLine; "Gross Amount")
                {
                }
                column(ChargeAmount_PayoutLine; "Charge Amount")
                {
                }
                column(ExciseDutyAmount_PayoutLine; "Excise Duty Amount")
                {
                }
                column(WithholdingTaxAmount_PayoutLine; "Withholding Tax Amount")
                {
                }
                column(NetAmount_PayoutLine; "Net Amount")
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
        ReportTitle = 'Payout Report';
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

