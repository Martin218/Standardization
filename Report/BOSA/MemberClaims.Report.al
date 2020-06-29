report 50112 "Member Claim"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Claim.rdlc';

    dataset
    {
        dataitem(DataItem1; "Member Claim Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.";
            column(No_MemberClaimHeader; "No.")
            {
            }
            column(MemberNo_MemberClaimHeader; "Member No.")
            {
            }
            column(MemberName_MemberClaimHeader; "Member Name")
            {
            }
            column(Description_MemberClaimHeader; Description)
            {
            }
            column(ReasonCode_MemberClaimHeader; "Reason Code")
            {
            }
            column(ReasonforExit_MemberClaimHeader; "Reason for Exit")
            {
            }
            column(ExitNo_MemberClaimHeader; "Exit No.")
            {
            }
            column(GlobalDimension1Code_MemberClaimHeader; "Global Dimension 1 Code")
            {
            }
            column(Remarks_MemberClaimHeader; Remarks)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Member Claim Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(AccountCategory_MemberClaimLine; "Account Category")
                {
                }
                column(AccountNo_MemberClaimLine; "Account No.")
                {
                }
                column(AccountName_MemberClaimLine; "Account Name")
                {
                }
                column(AccountBalance_MemberClaimLine; "Account Balance")
                {
                }
                column(AccountOwnership_MemberClaimLine; "Account Ownership")
                {
                }
                column(AccountType_MemberClaimLine; "Account Type")
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
        ReportTitle = 'Member Claim';
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

