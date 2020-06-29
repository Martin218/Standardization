report 50081 "Member Loan Statement"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Loan Statement.rdlc';

    dataset
    {
        dataitem(DataItem1; Member)
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_Member; "No.")
            {
            }
            column(Surname_Member; Surname)
            {
            }
            column(FullName_Member; "Full Name")
            {
            }
            column(GlobalDimension1Code_Member; "Global Dimension 1 Code")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem7; "Loan Application")
            {
                DataItemLink = "Member No." = FIELD("No.");
                DataItemTableView = SORTING("No.")
                                    WHERE(Posted = FILTER(true));
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
                column(RepaymentMethod_LoanApplication; "Repayment Method")
                {
                }
                column(RequestedAmount_LoanApplication; "Requested Amount")
                {
                }
                column(ApprovedAmount_LoanApplication; "Approved Amount")
                {
                }
                column(TotalSavingsAmount_LoanApplication; "Total Savings Amount")
                {
                }
                dataitem(DataItem6; "Cust. Ledger Entry")
                {
                    DataItemLink = "Customer No." = FIELD("No.");
                    DataItemTableView = SORTING("Entry No.");
                    column(CustomerNo_CustLedgerEntry; "Customer No.")
                    {
                    }
                    column(PostingDate_CustLedgerEntry; "Posting Date")
                    {
                    }
                    column(DocumentType_CustLedgerEntry; "Document Type")
                    {
                    }
                    column(DocumentNo_CustLedgerEntry; "Document No.")
                    {
                    }
                    column(Description_CustLedgerEntry; Description)
                    {
                    }
                    column(CurrencyCode_CustLedgerEntry; "Currency Code")
                    {
                    }
                    column(Amount_CustLedgerEntry; Amount)
                    {
                    }
                    column(RemainingAmount_CustLedgerEntry; "Remaining Amount")
                    {
                    }
                    column(RunningBalance; RunningBalance)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        RunningBalance += Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        RunningBalance := 0;
                    end;
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
        ReportTitle = 'Loan Statement';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RunningBalance: Decimal;
}

