report 50106 "Guarantor Substitution Entries"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Guarantor Substitution Entries.rdlc';

    dataset
    {
        dataitem(DataItem1; "Guarantor Substitution Entry")
        {
            RequestFilterFields = "Loan No.", "Substitution Date";
            column(DocumentNo_GuarantorSubstitutionEntry; "Document No.")
            {
            }
            column(OldGuarantorNo_GuarantorSubstitutionEntry; "Previous Guarantor No.")
            {
            }
            column(OldGuarantorName_GuarantorSubstitutionEntry; "Previous Guarantor Name")
            {
            }
            column(NewGuarantorNo_GuarantorSubstitutionEntry; "New Guarantor No.")
            {
            }
            column(NewGuarantorName_GuarantorSubstitutionEntry; "New Guarantor Name")
            {
            }
            column(SubstitutionDate_GuarantorSubstitutionEntry; "Substitution Date")
            {
            }
            column(SubstitutionTime_GuarantorSubstitutionEntry; "Substitution Time")
            {
            }
            column(LoanNo_GuarantorSubstitutionEntry; "Loan No.")
            {
            }
            column(Description_GuarantorSubstitutionEntry; Description)
            {
            }
            column(OldAmountGuaranteed_GuarantorSubstitutionEntry; "Previous Amount Guaranteed")
            {
            }
            column(NewAmountGuaranteed_GuarantorSubstitutionEntry; "New Amount Guaranteed")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
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
        ReportTitle = 'Guarantor Substitution Entries';
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

