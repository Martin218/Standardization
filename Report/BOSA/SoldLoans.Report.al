report 50109 "Sold Loans"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Sold Loans.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Selloff")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "Loan No.";
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(InstitutionName_LoanSelloff; "Institution Name")
            {
            }
            column(InstitutionBranchName_LoanSelloff; "Institution Branch Name")
            {
            }
            column(InstitutionAddress_LoanSelloff; "Institution Address")
            {
            }
            column(No_LoanSelloff; "No.")
            {
            }
            column(LoanNo_LoanSelloff; "Loan No.")
            {
            }
            column(Description_LoanSelloff; Description)
            {
            }
            column(MemberNo_LoanSelloff; "Member No.")
            {
            }
            column(MemberName_LoanSelloff; "Member Name")
            {
            }
            column(OutstandingBalance_LoanSelloff; "Outstanding Balance")
            {
            }
            column(PrincipalArrearsAmount_LoanSelloff; "Principal Arrears Amount")
            {
            }
            column(InterestArrearsAmount_LoanSelloff; "Interest Arrears Amount")
            {
            }
            column(TotalArrearsAmount_LoanSelloff; "Total Arrears Amount")
            {
            }
            column(Remarks_LoanSelloff; Remarks)
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
        ReportTitle = 'Sold Loans';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalAmount: array[4] of Decimal;
}

