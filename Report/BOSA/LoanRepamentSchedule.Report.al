report 50070 "Loan Repament Schedule"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Repament Schedule.rdlc';

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
        {
            RequestFilterFields = "No.";
            column(No_LoanApplication; "No.")
            {

            }
            column(InterestRate_LoanApplication; "Interest Rate")
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
            dataitem(DataItem1; "Loan Repayment Schedule")
            {
                DataItemLink = "Loan No." = FIELD("No.");
                DataItemTableView = SORTING("Loan No.", "Instalment No.");
                column(LoanNo_LoanRepaymentSchedule; "Loan No.")
                {
                }
                column(LoanAmount_LoanRepaymentSchedule; "Loan Amount")
                {
                }
                column(RepaymentDate_LoanRepaymentSchedule; "Repayment Date")
                {
                }
                column(InstalmentNo_LoanRepaymentSchedule; "Instalment No.")
                {
                }
                column(PrincipalInstallment_LoanRepaymentSchedule; "Principal Installment")
                {
                }
                column(InterestInstallment_LoanRepaymentSchedule; "Interest Installment")
                {
                }
                column(TotalInstallment_LoanRepaymentSchedule; "Total Installment")
                {
                }
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
        ReportTitle = 'Loan Repayment Schedule';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        TotalAmount: array[4] of Decimal;
}

