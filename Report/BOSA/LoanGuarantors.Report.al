report 50086 "Loan Guarantors"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Guarantors.rdlc';

    dataset
    {
        dataitem(DataItem16; "Loan Application")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_LoanApplication; "No.")
            {
            }
            column(MemberNo_LoanApplication; "Member No.")
            {
            }
            column(MemberName_LoanApplication; "Member Name")
            {
            }
            column(LoanProductType_LoanApplication; "Loan Product Type")
            {
            }
            column(Description_LoanApplication; Description)
            {
            }
            column(InterestRate_LoanApplication; "Interest Rate")
            {
            }
            column(RepaymentPeriod_LoanApplication; "Repayment Period")
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            dataitem(DataItem14; "Loan Guarantor")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Line No.");
                column(MemberNo_LoanGuarantor; "Member No.")
                {
                }
                column(MemberName_LoanGuarantor; "Member Name")
                {
                }
                column(AccountNo_LoanGuarantor; "Account No.")
                {
                }
                column(AccountName_LoanGuarantor; "Account Name")
                {
                }
                column(AccountBalance_LoanGuarantor; "Account Balance")
                {
                }
                column(OtherGuaranteedAmount_LoanGuarantor; "Other Guaranteed Amount")
                {
                }
                column(NetAccountBalance_LoanGuarantor; "Net Account Balance")
                {
                }
                column(AmountToGuarantee_LoanGuarantor; "Amount To Guarantee")
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
        ReportTitle = 'Loan Guarantors';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
}

