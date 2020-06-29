report 50083 "G/L vs MPA By Product"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/GL vs MPA By Product.rdlc';

    dataset
    {
        dataitem(DataItem7; "Loan Product Type")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(Code_LoanProductType; Code)
            {
            }
            column(Description_LoanProductType; Description)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem19; "Loan Application")
            {
                DataItemLink = "Loan Product Type" = FIELD(Code);
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
                column(OutstandingBalance_LoanApplication; "Outstanding Balance")
                {
                }
                column(GlobalDimension1Code_LoanApplication; "Global Dimension 1 Code")
                {
                }
                column(Balance_1; Balance[1])
                {
                }
                column(Balance_2; Balance[2])
                {
                }
                column(ShowSummary; ShowSummary)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    Balance[1] := 0;
                    Balance[2] := 0;
                    NoofAccounts += 1;
                    CALCFIELDS("Outstanding Balance");
                    Balance[1] := "Outstanding Balance";

                    LoanProductType.GET("Loan Product Type");
                    CustomerPostingGroup.GET(LoanProductType."Loan Posting Group");

                    IF GLAccount.GET(CustomerPostingGroup."Receivables Account") THEN BEGIN
                        GLAccount.CALCFIELDS("Balance at Date");
                        Balance[2] := GLAccount."Balance at Date";
                    END;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                NoofAccounts := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShowSummary; ShowSummary)
                {
                    Caption = 'Show Summary';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitle = 'Loans Vs MPA';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        ShowSummary: Boolean;
        GLEntry: Record "G/L Entry";
        LoanProductType: Record "Loan Product Type";
        CustomerPostingGroup: Record "Customer Posting Group";
        GLAccount: Record "G/L Account";
        Balance: array[4] of Decimal;
        NoofAccounts: Integer;
}

