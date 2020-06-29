report 50074 "Branch Portfolio Report"
{
    // version TL2.0

    DefaultLayout = RDLC;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = 'Report/BOSA/Branch Portfolio Report.rdlc';

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
            column(RCount_3; RCount[3])
            {
            }
            column(RCount_4; RCount[4])
            {
            }
            column(RSum_1; RSum[1])
            {
            }
            column(RSum_2; RSum[2])
            {
            }
            column(RSum_4; RSum[4])
            {
            }
            dataitem(DataItem14; "Loan Classification Setup")
            {
                column(Code_LoanClassificationSetup; Code)
                {
                }
                column(Description_LoanClassificationSetup; Description)
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
                column(RCount_2; RCount[2])
                {
                }
                column(RSum_3; RSum[3])
                {
                }

                trigger OnAfterGetRecord()
                begin
                    RCount[2] := 0;
                    RSum[3] := 0;

                    //MESSAGE(Name);
                    LoanApplication.RESET;
                    LoanApplication.SETRANGE("Global Dimension 1 Code", Code);
                    IF LoanApplication.FINDSET THEN BEGIN
                        REPEAT
                            LoanClassificationEntry.RESET;
                            LoanClassificationEntry.SETRANGE("Loan No.", LoanApplication."No.");
                            IF LoanClassificationEntry.FINDFIRST THEN BEGIN
                                IF LoanClassificationEntry."Classification Class" = Description THEN BEGIN
                                    RCount[2] += 1;
                                    RSum[3] += LoanClassificationEntry."Outstanding Balance";
                                END;
                            END;
                        UNTIL LoanApplication.NEXT = 0;
                    END;
                    //"Loan Classification Setup"
                end;
            }

            trigger OnAfterGetRecord()
            begin
                RCount[1] := 0;
                RCount[3] := 0;
                RSum[1] := 0;
                RSum[2] := 0;
                RSum[4] := 0;
                ArrearsAmount[1] := 0;
                ArrearsAmount[1] := 0;
                ArrearsAmount[3] := 0;
                TotalAmountDue[1] := 0;
                TotalAmountDue[2] := 0;
                TotalAmountPaid[1] := 0;
                TotalAmountPaid[2] := 0;
                LoanApplication.RESET;
                LoanApplication.SETRANGE("Global Dimension 1 Code", Code);
                IF LoanApplication.FINDSET THEN BEGIN
                    REPEAT
                        LoanApplication.CALCFIELDS("Outstanding Balance");
                        RCount[1] += 1;
                        BOSAManagement.CalculateTotalExpectedAmount(LoanApplication."No.", TotalAmountDue[1], TotalAmountDue[2]);
                        RSum[1] += TotalAmountDue[1];
                        RSum[2] += TotalAmountDue[2];

                        BOSAManagement.CalculateTotalAmountPaid(LoanApplication."No.", LoanApplication."Date of Completion", TotalAmountPaid[1], TotalAmountPaid[2]);
                        RemainingAmount[1] := TotalAmountDue[1] - TotalAmountPaid[1];
                        RemainingAmount[2] := TotalAmountDue[2] - TotalAmountPaid[2];
                        RemainingAmount[3] := RemainingAmount[1] + RemainingAmount[2];

                        BOSAManagement.CalculateLoanArrears(LoanApplication."No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                        ArrearsAmount[3] := ArrearsAmount[1] + ArrearsAmount[2];
                        IF ROUND(ArrearsAmount[3], 0.01, '<') > 0 THEN BEGIN
                            RCount[3] += 1;
                            RSum[4] += LoanApplication."Outstanding Balance";
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
        ReportTitle = 'Branch Portfolio';
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
        LoanRepaymentSchedule: Record "Loan Repayment Schedule";
        LoanClassificationEntry: Record "Loan Classification Entry";
        LoanClassificationSetup: Record "Loan Classification Setup";
        RSum: array[10] of Decimal;
        RCount: array[10] of Decimal;
        TotalAmountDue: array[4] of Decimal;
        TotalAmountPaid: array[4] of Decimal;
        RemainingAmount: array[4] of Decimal;
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
}

