report 50111 "Member Refund"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Refund.rdlc';

    dataset
    {
        dataitem(DataItem1; "Member Refund Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_MemberRefundHeader; "No.")
            {
            }
            column(MemberNo_MemberRefundHeader; "Member No.")
            {
            }
            column(MemberName_MemberRefundHeader; "Member Name")
            {
            }
            column(Description_MemberRefundHeader; Description)
            {
            }
            column(ReasonCode_MemberRefundHeader; "Reason Code")
            {
            }
            column(ReasonforExit_MemberRefundHeader; "Reason for Exit")
            {
            }
            column(ExitNo_MemberRefundHeader; "Exit No.")
            {
            }
            column(GlobalDimension1Code_MemberRefundHeader; "Global Dimension 1 Code")
            {
            }
            column(Remarks_MemberRefundHeader; Remarks)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Status_MemberRefundHeader; Status)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Member Refund Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(AccountCategory_MemberRefundLine; "Account Category")
                {
                }
                column(AccountNo_MemberRefundLine; "Account No.")
                {
                }
                column(AccountName_MemberRefundLine; "Account Name")
                {
                }
                column(AccountBalance_MemberRefundLine; "Account Balance")
                {
                }
                column(AccountOwnership_MemberRefundLine; "Account Ownership")
                {
                }
                column(AccountType_MemberRefundLine; "Account Type")
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
        ReportTitle = 'Member Refund';
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

