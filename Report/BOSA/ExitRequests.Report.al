report 50110 "Exit Request"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Exit Request.rdlc';

    dataset
    {
        dataitem(DataItem1; "Member Exit Header")
        {
            DataItemTableView = WHERE(Status = FILTER(Approved));
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_MemberExitHeader; "No.")
            {
            }
            column(MemberNo_MemberExitHeader; "Member No.")
            {
            }
            column(MemberName_MemberExitHeader; "Member Name")
            {
            }
            column(Description_MemberExitHeader; Description)
            {
            }
            column(ReasonCode_MemberExitHeader; "Reason Code")
            {
            }
            column(ReasonforExit_MemberExitHeader; "Reason for Exit")
            {
            }
            column(GlobalDimension1Code_MemberExitHeader; "Global Dimension 1 Code")
            {
            }
            column(Remarks_MemberExitHeader; Remarks)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Member Exit Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(AccountCategory_MemberExitLine; "Account Category")
                {
                }
                column(AccountNo_MemberExitLine; "Account No.")
                {
                }
                column(AccountName_MemberExitLine; "Account Name")
                {
                }
                column(AccountBalance_MemberExitLine; "Account Balance")
                {
                }
                column(AccountOwnership_MemberExitLine; "Account Ownership")
                {
                }
                column(AccountType_MemberExitLine; "Account Type")
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
        ReportTitle = 'Exit Request';
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

