report 50102 "Agency Remittance Advice"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Agency Remittance Advice.rdlc';

    dataset
    {
        dataitem(DataItem1; "Agency Remittance Header")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Agency Code", "Period Month", "Period Year";
            column(No_AgencyRemittanceHeader; "No.")
            {
            }
            column(AgencyCode_AgencyRemittanceHeader; "Agency Code")
            {
            }
            column(AgencyName_AgencyRemittanceHeader; "Agency Name")
            {
            }
            column(Description_AgencyRemittanceHeader; Description)
            {
            }
            column(CreatedBy_AgencyRemittanceHeader; "Created By")
            {
            }
            column(CreatedDate_AgencyRemittanceHeader; "Created Date")
            {
            }
            column(CreatedTime_AgencyRemittanceHeader; "Created Time")
            {
            }
            column(PeriodMonth_AgencyRemittanceHeader; "Period Month")
            {
            }
            column(PeriodYear_AgencyRemittanceHeader; "Period Year")
            {
            }
            column(NoSeries_AgencyRemittanceHeader; "No. Series")
            {
            }
            column(Status_AgencyRemittanceHeader; Status)
            {
            }
            column(TotalExpectedAmount_AgencyRemittanceHeader; "Total Expected Amount")
            {
            }
            column(TotalActualAmount_AgencyRemittanceHeader; "Total Actual Amount")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem2; "Agency Remittance Line")
            {
                DataItemLink = "Document No." = FIELD("No.");
                DataItemTableView = SORTING("Document No.", "Line No.");
                column(MemberNo_AgencyRemittanceLine; "Member No.")
                {
                }
                column(MemberName_AgencyRemittanceLine; "Member Name")
                {
                }
                column(AccountCategory_AgencyRemittanceLine; "Account Category")
                {
                }
                column(AccountType_AgencyRemittanceLine; "Account Type")
                {
                }
                column(AccountNo_AgencyRemittanceLine; "Account No.")
                {
                }
                column(AccountName_AgencyRemittanceLine; "Account Name")
                {
                }
                column(RemittanceCode_AgencyRemittanceLine; "Remittance Code")
                {
                }
                column(ExpectedAmount_AgencyRemittanceLine; "Expected Amount")
                {
                }
                column(ActualAmount_AgencyRemittanceLine; "Actual Amount")
                {
                }
                column(ContributionType_AgencyRemittanceLine; "Contribution Type")
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
        ReportTitle = 'Agency Remittance Advice';
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

