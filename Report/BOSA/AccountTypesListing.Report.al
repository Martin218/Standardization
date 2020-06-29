report 50095 "Account Types Listing"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Account Types Listing.rdlc';

    dataset
    {
        dataitem(DataItem1; "Account Type")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Code";
            column(Code_AccountType; Code)
            {
            }
            column(Description_AccountType; Description)
            {
            }
            column(RSum_1; RSum[1])
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem5; Vendor)
            {
                DataItemLink = "Account Type" = FIELD(Code);
                DataItemTableView = SORTING("No.");
                column(MemberName_Vendor; "Member Name")
                {
                }
                column(MemberNo_Vendor; "Member No.")
                {
                }
                column(No_Vendor; "No.")
                {
                }
                column(Name_Vendor; Name)
                {
                }
                column(BalanceLCY_Vendor; "Balance (LCY)")
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
        ReportTitle = 'Account Types Listing';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
}

