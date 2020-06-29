report 50085 "Loan Movement"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Loan Movement.rdlc';

    dataset
    {
        dataitem(DataItem7; "Dimension Value")
        {
            DataItemTableView = SORTING("Dimension Code", Code)
                                WHERE("Global Dimension No." = FILTER(1));
            PrintOnlyIfDetail = true;
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
            dataitem(DataItem19; "Loan Application")
            {
                DataItemLink = "Global Dimension 1 Code" = FIELD(Code);
                DataItemTableView = SORTING("No.")
                                    WHERE(Posted = FILTER(true));
                column(No_LoanApplication; "No.")
                {
                }
                column(MemberNo_LoanApplication; "Member No.")
                {
                }
                column(MemberName_LoanApplication; "Member Name")
                {
                }
                column(LoanProductType_LoanApplication; "Loan Product Type")
                {
                }
                column(Description_LoanApplication; Description)
                {
                }
                column(InterestRate_LoanApplication; "Interest Rate")
                {
                }
                column(RepaymentPeriod_LoanApplication; "Repayment Period")
                {
                }
                column(RepaymentMethod_LoanApplication; "Repayment Method")
                {
                }
                column(RequestedAmount_LoanApplication; "Requested Amount")
                {
                }
                column(ApprovedAmount_LoanApplication; "Approved Amount")
                {
                }
                column(TotalSavingsAmount_LoanApplication; "Total Savings Amount")
                {
                }
                column(OutstandingBalance_LoanApplication; "Outstanding Balance")
                {
                }
                column(GlobalDimension1Code_LoanApplication; "Global Dimension 1 Code")
                {
                }
                column(TotalAmount_1; TotalAmount[1])
                {
                }
                column(TotalAmount_2; TotalAmount[2])
                {
                }
                column(TotalAmount_3; TotalAmount[3])
                {
                }
                column(TotalAmount_4; TotalAmount[4])
                {
                }
                column(TotalAmount_5; TotalAmount[5])
                {
                }
                column(TotalAmount_6; TotalAmount[6])
                {
                }
                column(TotalAmount_7; TotalAmount[7])
                {
                }
                column(TotalAmount_8; TotalAmount[8])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TotalAmount[1] := 0;
                    TotalAmount[2] := 0;
                    TotalAmount[3] := 0;
                    TotalAmount[4] := 0;
                    TotalAmount[5] := 0;
                    TotalAmount[6] := 0;
                    TotalAmount[7] := 0;
                    TotalAmount[8] := 0;
                    TotalAmount[9] := 0;
                    CustLedgerEntry.RESET;
                    CustLedgerEntry.SETRANGE("Customer No.", "No.");
                    IF CustLedgerEntry.FINDSET THEN BEGIN
                        REPEAT
                            CustLedgerEntry.CALCFIELDS(Amount);
                            IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN BEGIN
                                IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                                    TotalAmount[1] += CustLedgerEntry.Amount;
                                IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN
                                    TotalAmount[2] += CustLedgerEntry.Amount;
                            END;
                            IF CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly THEN BEGIN
                                IF CustLedgerEntry.Amount > 0 THEN
                                    TotalAmount[3] += CustLedgerEntry.Amount;
                                IF CustLedgerEntry.Amount < 0 THEN
                                    TotalAmount[4] += CustLedgerEntry.Amount;
                            END;
                            IF ((CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly) OR (CustLedgerEntry."Source Code" = SourceCodeSetup.Assembly)) THEN BEGIN
                                IF CustLedgerEntry.Amount > 0 THEN
                                    TotalAmount[5] += CustLedgerEntry.Amount;
                                IF CustLedgerEntry.Amount < 0 THEN
                                    TotalAmount[6] += CustLedgerEntry.Amount;
                            END;
                        UNTIL CustLedgerEntry.NEXT = 0;
                    END;
                    TotalAmount[7] := TotalAmount[1] + TotalAmount[3] + TotalAmount[4];
                    TotalAmount[8] := TotalAmount[2] + TotalAmount[5] + TotalAmount[6];
                end;
            }

            trigger OnPreDataItem()
            begin
                SourceCodeSetup.GET;
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
        ReportTitle = 'Loan Movement';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        SourceCodeSetup: Record "Source Code Setup";
        TotalAmount: array[10] of Decimal;
}

