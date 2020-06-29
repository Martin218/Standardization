report 50084 "G/L vs MPA By Branch"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/GL vs MPA By Branch.rdlc';

    dataset
    {
        dataitem(DataItem7; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Global Dimension No." = FILTER(1));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; UPPERCASE(Name))
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
                DataItemLink = "Global Dimension 1 Code" = FIELD(Code);
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

                    GLAccount.SETFILTER("Global Dimension 1 Filter", "Global Dimension 1 Code");
                    IF GLAccount.FINDSET THEN BEGIN
                        GLAccount.CALCFIELDS("Balance at Date");
                        Balance[2] := GLAccount."Balance at Date";
                    END;
                end;
            }
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
        ReportTitle = 'Loans Vs MPA By Branch';
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
        GLAccount: Record "G/L Account";
        Balance: array[4] of Decimal;
        NoofAccounts: Integer;
}

