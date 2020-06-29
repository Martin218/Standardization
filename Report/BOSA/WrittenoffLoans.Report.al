report 50108 "Written off Loans"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Written off Loans.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Writeoff Header")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_LoanWriteoffHeader; "No.")
            {
            }
            column(Description_LoanWriteoffHeader; Description)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Loan Writeoff Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(LoanNo_LoanWriteoffLine; "Loan No.")
                {
                }
                column(Description_LoanWriteoffLine; Description)
                {
                }
                column(MemberNo_LoanWriteoffLine; "Member No.")
                {
                }
                column(MemberName_LoanWriteoffLine; "Member Name")
                {
                }
                column(TotalArrearsAmount_LoanWriteoffLine; "Total Arrears Amount")
                {
                }
                column(NoofDaysinArrears_LoanWriteoffLine; "No. of Days in Arrears")
                {
                }
                column(NoofInstallmentDefaulted_LoanWriteoffLine; "No. of Installment Defaulted")
                {
                }
                column(OutstandingBalance_LoanWriteoffLine; "Outstanding Balance")
                {
                }
                column(GlobalDimension1Code_LoanWriteoffLine; "Global Dimension 1 Code")
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
        ReportTitle = 'Written off Loans';
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

