report 50080 "Loan Provisioning Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Provisioning Report.rdlc';

    dataset
    {
        dataitem(DataItem1; "Loan Classification Setup")
        {
            RequestFilterFields = "Code";
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; Description)
            {
            }
            column(MinDefaultedDays_LoanClassificationSetup; "Min. Defaulted Days")
            {
            }
            column(MaxDefaultedDays_LoanClassificationSetup; "Max. Defaulted Days")
            {
            }
            column(Provisioning_LoanClassificationSetup; "Provisioning %")
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(RCount_1; RCount[1])
            {
            }
            column(RSum_1; RSum[1])
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RCount[2] := 0;
                RSum[1] := 0;
                LoanClassificationEntry.RESET;
                LoanClassificationEntry.SETRANGE("Classification Class", Description);
                IF LoanClassificationEntry.FINDSET THEN BEGIN
                    LoanClassificationEntry.CALCSUMS("Outstanding Balance");
                    RCount[1] := LoanClassificationEntry.COUNT;
                    RSum[1] := LoanClassificationEntry."Outstanding Balance";
                END;
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
        ReportTitle = 'Loan Provisioning';
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
        LoanClassificationEntry: Record "Loan Classification Entry";
}

