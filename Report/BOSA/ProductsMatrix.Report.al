report 50090 "Products Matrix"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Products Matrix.rdlc';

    dataset
    {
        dataitem(DataItem7; "Loan Product Type")
        {
            RequestFilterFields = "Code";
            column(Code_LoanProductType; Code)
            {
            }
            column(Description_LoanProductType; Description)
            {
            }
            column(Picture; CompanyInfo.Picture)
            {
            }
            column(Name; CompanyInfo.Name)
            {
            }
            column(RSum_1; RSum[1])
            {
            }
            column(RSum_2; RSum[2])
            {
            }
            column(RSum_3; RSum[3])
            {
            }
            column(RCount_1; RCount[1])
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
                RSum[3] := 0;
                LoanApplication.RESET;
                LoanApplication.SETRANGE("Loan Product Type", Code);
                IF LoanApplication.FINDSET THEN BEGIN
                    REPEAT
                        LoanApplication.CALCFIELDS("Outstanding Balance");
                        RCount[1] += 1;
                        RSum[1] += LoanApplication."Approved Amount";
                        RSum[2] += LoanApplication."Outstanding Balance";

                        CustLedgerEntry.RESET;
                        CustLedgerEntry.SETRANGE("Customer No.", LoanApplication."No.");
                        CustLedgerEntry.SETRANGE("Source Code", SourceCodeSetup.Assembly);
                        IF CustLedgerEntry.FINDSET THEN BEGIN
                            REPEAT
                                CustLedgerEntry.CALCFIELDS(Amount);
                                RSum[3] += ABS(CustLedgerEntry.Amount);
                            UNTIL CustLedgerEntry.NEXT = 0;
                        END;
                    UNTIL LoanApplication.NEXT = 0;
                END;
            end;

            trigger OnPreDataItem()
            begin
                SourceCodeSetup.Get;
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
        ReportTitle = 'Products Matrix';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        SourceCodeSetup: Record "Source Code Setup";
        TotalAmount: array[10] of Decimal;
        RCount: array[4] of Integer;
        RSum: array[4] of Decimal;
        LoanApplication: Record "Loan Application";
        CustLedgerEntry: Record "Cust. Ledger Entry";
}

