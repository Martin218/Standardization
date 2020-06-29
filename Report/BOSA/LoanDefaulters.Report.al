report 50078 "Loan Defaulters"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Defaulters.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Default Entry")
        {
            RequestFilterFields = "Member No.";
            column(LoanNo_LoanDefaultEntry; "Loan No.")
            {
            }
            column(Description_LoanDefaultEntry; Description)
            {
            }
            column(MemberNo_LoanDefaultEntry; "Member No.")
            {
            }
            column(MemberName_LoanDefaultEntry; "Member Name")
            {
            }
            column(ApprovedAmount_LoanDefaultEntry; "Approved Amount")
            {
            }
            column(RepaymentMethod_LoanDefaultEntry; "Repayment Method")
            {
            }
            column(RepaymentPeriod_LoanDefaultEntry; "Repayment Period")
            {
            }
            column(RemainingPeriod_LoanDefaultEntry; "Remaining Period")
            {
            }
            column(RemainingPrincipalAmount_LoanDefaultEntry; "Remaining Principal Amount")
            {
            }
            column(RemainingInterestAmount_LoanDefaultEntry; "Remaining Interest Amount")
            {
            }
            column(PrincipalInstallment_LoanDefaultEntry; "Principal Installment")
            {
            }
            column(InterestInstallment_LoanDefaultEntry; "Interest Installment")
            {
            }
            column(TotalInstallment_LoanDefaultEntry; "Total Installment")
            {
            }
            column(PrincipalArrearsAmount_LoanDefaultEntry; "Principal Arrears Amount")
            {
            }
            column(InterestArrearsAmount_LoanDefaultEntry; "Interest Arrears Amount")
            {
            }
            column(TotalArrearsAmount_LoanDefaultEntry; "Total Arrears Amount")
            {
            }
            column(OutstandingBalance_LoanDefaultEntry; "Outstanding Balance")
            {
            }
            column(ClassificationClass_LoanDefaultEntry; "Classification Class")
            {
            }
            column(RepaymentFrequency_LoanDefaultEntry; "Repayment Frequency")
            {
            }
            column(NoofDaysinArrears_LoanDefaultEntry; "No. of Days in Arrears")
            {
            }
            column(LastPaymentDate_LoanDefaultEntry; "Last Payment Date")
            {
            }
            column(NoofDefaultedInstallment_LoanDefaultEntry; "No. of Defaulted Installment")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
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
        ReportTitle = 'Loan Defaulters';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
}

