report 50094 "CRB Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/CRB Report.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true),
                                      "Total Arrears Amount" = FILTER(> 0),
                                      "Notice Category" = FILTER("Third Notice"));
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
            column(TotalDepositsAmount_LoanApplication; "Total Deposits Amount")
            {
            }
            column(TotalSharesAmount_LoanApplication; "Total Shares Amount")
            {
            }
            column(MaximumEligibleAmount_LoanApplication; "Maximum Eligible Amount")
            {
            }
            column(NoSeries_LoanApplication; "No. Series")
            {
            }
            column(RefinanceAnotherLoan_LoanApplication; "Refinance Another Loan")
            {
            }
            column(Status_LoanApplication; Status)
            {
            }
            column(DateofCompletion_LoanApplication; "Date of Completion")
            {
            }
            column(NextDueDate_LoanApplication; "Next Due Date")
            {
            }
            column(CreatedBy_LoanApplication; "Created By")
            {
            }
            column(CreatedDate_LoanApplication; "Created Date")
            {
            }
            column(CreatedTime_LoanApplication; "Created Time")
            {
            }
            column(AppraisedBy_LoanApplication; "Appraised By")
            {
            }
            column(AppraisalDate_LoanApplication; "Appraisal Date")
            {
            }
            column(AppraisalTime_LoanApplication; "Appraisal Time")
            {
            }
            column(ApprovedBy_LoanApplication; "Approved By")
            {
            }
            column(ApprovedDate_LoanApplication; "Approved Date")
            {
            }
            column(ApprovedTime_LoanApplication; "Approved Time")
            {
            }
            column(Posted_LoanApplication; Posted)
            {
            }
            column(TotalGuaranteedAmount_LoanApplication; "Total Guaranteed Amount")
            {
            }
            column(TotalSecurityAmount_LoanApplication; "Total Security Amount")
            {
            }
            column(Remarks_LoanApplication; Remarks)
            {
            }
            column(NoofGuarantors_LoanApplication; "No. of Guarantors")
            {
            }
            column(NoofOtherSecurities_LoanApplication; "No. of Other Securities")
            {
            }
            column(NoofLoansRefinanced_LoanApplication; "No. of Loans Refinanced")
            {
            }
            column(TotalRefinancedAmount_LoanApplication; "Total Refinanced Amount")
            {
            }
            column(GlobalDimension1Code_LoanApplication; "Global Dimension 1 Code")
            {
            }
            column(RepaymentFrequency_LoanApplication; "Repayment Frequency")
            {
            }
            column(DisbursedBy_LoanApplication; "Disbursed By")
            {
            }
            column(DisbursalDate_LoanApplication; "Disbursal Date")
            {
            }
            column(DisbursalTime_LoanApplication; "Disbursal Time")
            {
            }
            column(FOSAAccountNo_LoanApplication; "FOSA Account No.")
            {
            }
            column(PhoneNo_LoanApplication; "Phone No.")
            {
            }
            column(FOSAAccountName_LoanApplication; "FOSA Account Name")
            {
            }
            column(NetAmount_LoanApplication; "Net Amount")
            {
            }
            column(CompanyName_LoanApplication; "Company Name")
            {
            }
            column(PrincipalArrearsAmount_LoanApplication; "Principal Arrears Amount")
            {
            }
            column(InterestArrearsAmount_LoanApplication; "Interest Arrears Amount")
            {
            }
            column(TotalArrearsAmount_LoanApplication; "Total Arrears Amount")
            {
            }
            column(PrincipalOverpayment_LoanApplication; "Principal Overpayment")
            {
            }
            column(InterestOverpayment_LoanApplication; "Interest Overpayment")
            {
            }
            column(TotalOverpayment_LoanApplication; "Total Overpayment")
            {
            }
            column(NoticeCategory_LoanApplication; "Notice Category")
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

            trigger OnAfterGetRecord()
            begin
                LoanRepaymentSchedule.RESET;
                LoanRepaymentSchedule.SETRANGE("Loan No.", "No.");
                LoanRepaymentSchedule.CALCSUMS("Principal Installment", "Interest Installment", "Total Installment");
                TotalAmount[1] := LoanRepaymentSchedule."Principal Installment";
                TotalAmount[2] := LoanRepaymentSchedule."Interest Installment";
                TotalAmount[3] := LoanRepaymentSchedule."Total Installment";
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
        ReportTitle = 'CRB Report';
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

