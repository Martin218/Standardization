report 50072 "Branch Performance"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Branch Performance.rdlc';

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
            column(RCount_1; RCount[1])
            {
            }
            column(RCount_2; RCount[2])
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
            column(RSum_4; RSum[4])
            {
            }
            column(RSum_5; RSum[5])
            {
            }
            column(RSum_6; RSum[6])
            {
            }
            column(RSum_7; RSum[7])
            {
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RCount[2] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
                RSum[3] := 0;
                RSum[4] := 0;
                RSum[5] := 0;
                RSum[6] := 0;
                RSum[7] := 0;
                ArrearsAmount[1] := 0;
                ArrearsAmount[1] := 0;
                ArrearsAmount[3] := 0;
                TotalAmountDue[1] := 0;
                TotalAmountDue[2] := 0;
                TotalAmountPaid[1] := 0;
                TotalAmountPaid[2] := 0;
                Member.RESET;
                Member.SETRANGE("Global Dimension 1 Code", Code);
                RCount[1] := Member.COUNT;

                LoanApplication.RESET;
                LoanApplication.SETRANGE("Global Dimension 1 Code", Code);
                IF LoanApplication.FINDSET THEN BEGIN
                    REPEAT
                        LoanApplication.CALCFIELDS("Outstanding Balance");
                        RCount[2] += 1;

                        RSum[1] += LoanApplication."Approved Amount";
                        RSum[2] += LoanApplication."Outstanding Balance";

                        BOSAManagement.CalculateTotalExpectedAmount(LoanApplication."No.", TotalAmountDue[1], TotalAmountDue[2]);
                        BOSAManagement.CalculateTotalAmountPaid(LoanApplication."No.", LoanApplication."Date of Completion", TotalAmountPaid[1], TotalAmountPaid[2]);
                        RemainingAmount[1] := TotalAmountDue[1] - TotalAmountPaid[1];
                        RemainingAmount[2] := TotalAmountDue[2] - TotalAmountPaid[2];
                        RemainingAmount[3] := RemainingAmount[1] + RemainingAmount[2];
                        RSum[3] += RemainingAmount[1];
                        RSum[4] += RemainingAmount[2];
                        RSum[5] += RemainingAmount[3];

                        BOSAManagement.CalculateLoanArrears(LoanApplication."No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                        ArrearsAmount[3] := ArrearsAmount[1] + ArrearsAmount[2];
                        RSum[6] += ArrearsAmount[3];
                        IF ArrearsAmount[3] > 0 THEN BEGIN
                            RSum[7] += LoanApplication."Outstanding Balance";
                        END;
                    UNTIL LoanApplication.NEXT = 0;
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
        ReportTitle = 'Branch Performance';
    }

    trigger OnPreReport()
    begin
        CompanyInfo.GET;
        CompanyInfo.CALCFIELDS(Picture);
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        CompanyInfo: Record "Company Information";
        LoanApplication: Record "Loan Application";
        Member: Record "Member";
        RCount: array[4] of Integer;
        RSum: array[10] of Decimal;
        TotalAmountDue: array[4] of Decimal;
        TotalAmountPaid: array[4] of Decimal;
        RemainingAmount: array[4] of Decimal;
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
}

