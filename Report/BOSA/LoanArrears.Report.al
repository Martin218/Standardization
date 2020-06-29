report 50071 "Loan Arrears"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Arrears.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "Global Dimension 1 Code";
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
            column(OutstandingBalance_LoanApplication; "Outstanding Balance")
            {
            }
            column(ArrearsAmount_1; ArrearsAmount[1])
            {
            }
            column(ArrearsAmount_2; ArrearsAmount[2])
            {
            }
            column(ArrearsAmount_3; ArrearsAmount[3])
            {
            }
            column(RemainingAmount_1; RemainingAmount[1])
            {
            }
            column(RemainingAmount_2; RemainingAmount[2])
            {
            }
            column(RemainingAmount_3; RemainingAmount[3])
            {
            }
            column(RemainingPeriod; RemainingPeriod)
            {
            }
            column(ArrearsCount_1; ArrearsCount[1])
            {
            }
            column(ArrearsCount_2; ArrearsCount[2])
            {
            }
            column(LastPaymentDate; LastPaymentDate)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }

            trigger OnAfterGetRecord()
            begin
                ArrearsAmount[1] := 0;
                ArrearsAmount[1] := 0;
                ArrearsAmount[3] := 0;
                TotalAmountDue[1] := 0;
                TotalAmountDue[2] := 0;
                TotalAmountPaid[1] := 0;
                TotalAmountPaid[2] := 0;

                CALCFIELDS("Outstanding Balance");
                BOSAManagement.CalculateLoanArrears("No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                ArrearsAmount[3] := ArrearsAmount[1] + ArrearsAmount[2];

                RemainingPeriod := BOSAManagement.CalculateNoofMonths(TODAY, "Date of Completion");
                BOSAManagement.CalculateTotalExpectedAmount("No.", TotalAmountDue[1], TotalAmountDue[2]);
                BOSAManagement.CalculateTotalAmountPaid("No.", "Date of Completion", TotalAmountPaid[1], TotalAmountPaid[2]);
                RemainingAmount[1] := TotalAmountDue[1] - TotalAmountPaid[1];
                RemainingAmount[2] := TotalAmountDue[2] - TotalAmountPaid[2];
                RemainingAmount[3] := RemainingAmount[1] + RemainingAmount[2];
                LastPaymentDate := BOSAManagement.GetLastRepaymentDate("No.", TODAY);
                BOSAManagement.CalculateDaysInstallmentsInArrears("No.", ArrearsAmount[3], ArrearsCount[1], ArrearsCount[2]);
                IF ArrearsAmount[3] <= 0 THEN
                    CurrReport.SKIP;
            end;
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
        ReportTitle = 'Loan Arrears';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        CompanyInfo: Record "Company Information";
        RemainingPeriod: Integer;
        RemainingAmount: array[4] of Decimal;
        TotalAmountDue: array[4] of Decimal;
        TotalAmountPaid: array[4] of Decimal;
        TotalApprovedAmount: Decimal;
        LastPaymentDate: Date;
        ArrearsCount: array[4] of Integer;
}

