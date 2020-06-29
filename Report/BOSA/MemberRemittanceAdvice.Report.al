report 50101 "Member Remittance Advice"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Member Remittance Advice.rdlc';

    dataset
    {
        dataitem(DataItem1; "Member Remittance Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Member No.";
            column(No_MemberRemittanceHeader; "No.")
            {
            }
            column(MemberNo_MemberRemittanceHeader; "Member No.")
            {
            }
            column(MemberName_MemberRemittanceHeader; "Member Name")
            {
            }
            column(CreatedBy_MemberRemittanceHeader; "Created By")
            {
            }
            column(CreatedDate_MemberRemittanceHeader; "Created Date")
            {
            }
            column(CreatedTime_MemberRemittanceHeader; "Created Time")
            {
            }
            column(LastModifiedBy_MemberRemittanceHeader; "Last Modified By")
            {
            }
            column(LastModifiedDate_MemberRemittanceHeader; "Last Modified Date")
            {
            }
            column(LastModifiedTime_MemberRemittanceHeader; "Last Modified Time")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Member Remittance Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(AccountType_MemberRemittanceLine; "Account Type")
                {
                }
                column(AccountCategory_MemberRemittanceLine; "Account Category")
                {
                }
                column(AccountNo_MemberRemittanceLine; "Account No.")
                {
                }
                column(AccountName_MemberRemittanceLine; "Account Name")
                {
                }
                column(RemittanceCode_MemberRemittanceLine; "Remittance Code")
                {
                }
                column(ExpectedAmount_MemberRemittanceLine; "Expected Amount")
                {
                }
                column(ActualAmount_MemberRemittanceLine; "Actual Amount")
                {
                }
                column(ContributionType_MemberRemittanceLine; "Contribution Type")
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
        ReportTitle = 'Member Remittance Advice';
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

