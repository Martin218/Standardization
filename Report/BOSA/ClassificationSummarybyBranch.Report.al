report 50092 "Classification Summary- Branch"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Classification Summary- Branch.rdlc';
    Caption = 'Classification Summary By Branch';

    dataset
    {
        dataitem(DataItem10; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Global Dimension No." = FILTER(1));
            RequestFilterFields = "Code";
            column(Code_DimensionValue; Code)
            {
            }
            column(Name_DimensionValue; UPPERCASE(Name))
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            dataitem(DataItem1; "Loan Classification Setup")
            {
                RequestFilterFields = "Code";
                column(Code_LoanClassificationSetup; Code)
                {
                }
                column(Name_LoanClassificationSetup; Description)
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
                    RSum[1] := 0;
                    RSum[2] := 0;
                    GetSummary(Description);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
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
        ReportTitle = 'Classification Summary by Branch';
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
        LoanApplication: Record "Loan Application";

    local procedure GetSummary(ClassDesc: Text[50])
    begin
        LoanClassificationEntry.RESET;
        LoanClassificationEntry.SETRANGE("Classification Class", DataItem1.Description);
        LoanClassificationEntry.SETRANGE("Global Dimension 1 Code", DataItem1.Code);
        IF LoanClassificationEntry.FINDSET THEN BEGIN
            LoanClassificationEntry.CALCSUMS("Outstanding Balance");
            RCount[1] := LoanClassificationEntry.COUNT;
            RSum[1] := LoanClassificationEntry."Outstanding Balance";
        END;
    end;
}

