report 50091 "Yield Analysis"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Yield Analysis.rdlc';

    dataset
    {
        dataitem(DataItem1; "Dimension Value")
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
            dataitem(DataItem15; "Loan Product Type")
            {
                column(Code_LoanProductType; Code)
                {
                }
                column(Description_LoanProductType; Description)
                {
                }
                column(RSum_1; RSum[1])
                {
                }
                column(RSum_2; RSum[2])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RSum[1] := 0;
                    RSum[2] := 0;
                    RSum[3] := 0;

                    LoanApplication.RESET;
                    LoanApplication.SETRANGE("Loan Product Type", Code);
                    IF LoanApplication.FINDSET THEN BEGIN
                        REPEAT
                            GetSummary(LoanApplication."No.");
                        UNTIL LoanApplication.NEXT = 0;
                    END;
                end;
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
        ReportTitle = 'Yield Analysis';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
        SourceCodeSetup.GET;
    end;

    var
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";

    local procedure GetSummary(LoanNo: Code[20])
    begin
        CustLedgerEntry.RESET;
        CustLedgerEntry.SETRANGE("Customer No.", LoanNo);
        CustLedgerEntry.SETRANGE("Global Dimension 1 Code", DataItem1.Code);
        IF CustLedgerEntry.FINDSET THEN BEGIN
            REPEAT
                CustLedgerEntry.CALCFIELDS(Amount);
                IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                    RSum[1] += ABS(CustLedgerEntry.Amount);
                IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                    RSum[2] += ABS(CustLedgerEntry.Amount);
            UNTIL CustLedgerEntry.NEXT = 0;
        END;
    end;
}

