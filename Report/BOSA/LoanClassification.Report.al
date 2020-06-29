report 50077 "Loan Classification Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Classification Report.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Classification Entry")
        {
            RequestFilterFields = "Classification Date";
            column(EntryNo_LoanClassificationEntry; "Entry No.")
            {
            }
            column(LoanNo_LoanClassificationEntry; "Loan No.")
            {
            }
            column(ClassificationDate_LoanClassificationEntry; "Classification Date")
            {
            }
            column(ClassificationTime_LoanClassificationEntry; "Classification Time")
            {
            }
            column(Description_LoanClassificationEntry; Description)
            {
            }
            column(MemberNo_LoanClassificationEntry; "Member No.")
            {
            }
            column(MemberName_LoanClassificationEntry; "Member Name")
            {
            }
            column(ApprovedAmount_LoanClassificationEntry; "Approved Amount")
            {
            }
            column(RepaymentMethod_LoanClassificationEntry; "Repayment Method")
            {
            }
            column(RepaymentPeriod_LoanClassificationEntry; "Repayment Period")
            {
            }
            column(RemainingPeriod_LoanClassificationEntry; "Remaining Period")
            {
            }
            column(RemainingPrincipalAmount_LoanClassificationEntry; "Remaining Principal Amount")
            {
            }
            column(RemainingInterestAmount_LoanClassificationEntry; "Remaining Interest Amount")
            {
            }
            column(PrincipalInstallment_LoanClassificationEntry; "Principal Installment")
            {
            }
            column(InterestInstallment_LoanClassificationEntry; "Interest Installment")
            {
            }
            column(TotalInstallment_LoanClassificationEntry; "Total Installment")
            {
            }
            column(PrincipalArrearsAmount_LoanClassificationEntry; "Principal Arrears Amount")
            {
            }
            column(InterestArrearsAmount_LoanClassificationEntry; "Interest Arrears Amount")
            {
            }
            column(TotalArrearsAmount_LoanClassificationEntry; "Total Arrears Amount")
            {
            }
            column(OutstandingBalance_LoanClassificationEntry; "Outstanding Balance")
            {
            }
            column(ProvisioningAmount_LoanClassificationEntry; "Provisioning Amount")
            {
            }
            column(ClassificationClass_LoanClassificationEntry; "Classification Class")
            {
            }
            column(RepaymentFrequency_LoanClassificationEntry; "Repayment Frequency")
            {
            }
            column(NoofDaysinArrears_LoanClassificationEntry; "No. of Days in Arrears")
            {
            }
            column(LastPaymentDate_LoanClassificationEntry; "Last Payment Date")
            {
            }
            column(NoofDefaultedInstallment_LoanClassificationEntry; "No. of Defaulted Installment")
            {
            }
            column(PrincipalOverpayment_LoanClassificationEntry; "Principal Overpayment")
            {
            }
            column(InterestOverpayment_LoanClassificationEntry; "Interest Overpayment")
            {
            }
            column(TotalOverpayment_LoanClassificationEntry; "Total Overpayment")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(TotalAmount_1; TotalAmount[1])
            {
            }
            column(TotalAmount_2; TotalAmount[2])
            {
            }
            column(TotalAmount_3; TotalAmount[3])
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
        ReportTitle = 'Loan Classification';
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

