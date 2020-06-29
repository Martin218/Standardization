report 50409 "Payroll Variance Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Payroll Variance Report.rdlc';
    Caption = 'Payroll Variance Report';

    dataset
    {
        dataitem("Earnings Setup";"Earnings Setup")
        {
            column(TITLES;TITLES)
            {
            }
            column(CompInfor_Picture;CompInfor.Picture)
            {
            }
            column(CurrentMonth;UPPERCASE(FORMAT(PayrollPeriod,0,'<month text> <year4>')))
            {
            }
            column(PreviousMonth;UPPERCASE(FORMAT(PayrollPeriodP,0,'<month text> <year4>')))
            {
            }
            column(DateDCSLbl;DateDCSLbl)
            {
            }
            column(SignatureMHCALbl;SignatureMHCALbl)
            {
            }
            column(SignatureMFLbl;SignatureMFLbl)
            {
            }
            column(SignatureDCSLbl;SignatureDCSLbl)
            {
            }
            column(Earning_Description;"Earnings Setup".Description)
            {
            }
            column(Non_Cash_Benefit;"Earnings Setup"."Non-Cash Benefit")
            {
            }
            column(CurentEarning;CurentEarning)
            {
            }
            column(PreviuosEarning;PreviuosEarning)
            {
            }
            column(Variance_E;Variance_E)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF "Earnings Setup"."Earning Type"<>"Earnings Setup"."Earning Type"::"Normal Earning" THEN BEGIN
                  CurrReport.SKIP;
                  END;
                IF "Earnings Setup"."Non-Cash Benefit"=TRUE THEN BEGIN
                  CurrReport.SKIP;
                  END;
                CurentEarning:=0;
                Variance_E:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
                TLPayrollEntries.SETRANGE(Code,"Earnings Setup".Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  CurentEarning:=CurentEarning+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                PreviuosEarning:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriodP);
                TLPayrollEntries.SETRANGE(Code,"Earnings Setup".Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  PreviuosEarning:=PreviuosEarning+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                IF (CurentEarning=0)  AND (PreviuosEarning=0)THEN BEGIN
                  CurrReport.SKIP;
                  END;
                Variance_E:=CurentEarning-PreviuosEarning;
            end;
        }
        dataitem(TLEarning;"Earnings Setup")
        {
            DataItemTableView = SORTING(Code)
                                ORDER(Ascending);
            column(TLEarningDescription;TLEarning.Description)
            {
            }
            column(CurentNC;CurentNC)
            {
            }
            column(PreviuosNC;PreviuosNC)
            {
            }
            column(Variance_NC;Variance_NC)
            {
            }

            trigger OnAfterGetRecord();
            begin
                IF TLEarning."Earning Type"=TLEarning."Earning Type"::"Normal Earning" THEN BEGIN
                  CurrReport.SKIP;
                END;
                IF TLEarning."Non-Cash Benefit"=FALSE THEN BEGIN
                  CurrReport.SKIP;
                END;

                CurentNC:=0;
                Variance_NC:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
                TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  CurentNC:=CurentNC+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                PreviuosNC:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriodP);
                TLPayrollEntries.SETRANGE(Code,TLEarning.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  PreviuosNC:=PreviuosNC+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                IF (CurentNC=0)  AND (PreviuosNC=0)THEN BEGIN
                  CurrReport.SKIP;
                END;
                Variance_NC:=CurentNC-PreviuosNC;
            end;
        }
        dataitem(DeductionsSetup;"Deductions Setup")
        {
            column(Deduction_Description;DeductionsSetup.Description)
            {
            }
            column(CurentDedutions;CurentDedutions)
            {
            }
            column(PreviuosDeductions;PreviuosDeductions)
            {
            }
            column(Variance_D;Variance_D)
            {
            }

            trigger OnAfterGetRecord();
            begin
                CurentDedutions:=0;
                Variance_D:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriod);
                TLPayrollEntries.SETRANGE(Code,DeductionsSetup.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  CurentDedutions:=CurentDedutions+ABS(TLPayrollEntries.Amount);
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                PreviuosDeductions:=0;
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Deduction);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriodP);
                TLPayrollEntries.SETRANGE(Code,DeductionsSetup.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  PreviuosDeductions:=PreviuosDeductions+ABS(TLPayrollEntries.Amount);
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                IF (CurentDedutions=0)  AND (PreviuosDeductions=0)THEN BEGIN
                  CurrReport.SKIP;
                  END;
                Variance_D:=CurentDedutions-PreviuosDeductions;
            end;
        }
        dataitem(Integer;Integer)
        {
            MaxIteration = 1;

            trigger OnAfterGetRecord();
            begin
                TLEarnings.RESET;
                TLEarnings.SETRANGE("Earning Type",TLEarnings."Earning Type"::"Tax Relief");
                IF TLEarnings.FINDFIRST THEN BEGIN
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriodP);
                TLPayrollEntries.SETRANGE(Code,TLEarnings.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  MPA:=MPA+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                END;
                TLEarnings.RESET;
                TLEarnings.SETRANGE("Earning Type",TLEarnings."Earning Type"::"Insurance Relief");
                IF TLEarnings.FINDFIRST THEN BEGIN
                TLPayrollEntries.RESET;
                TLPayrollEntries.SETRANGE(Type,TLPayrollEntries.Type::Payment);
                TLPayrollEntries.SETRANGE("Payroll Period",PayrollPeriodP);
                TLPayrollEntries.SETRANGE(Code,TLEarnings.Code);
                IF TLPayrollEntries.FINDFIRST THEN BEGIN
                REPEAT
                  INSURENCE:=INSURENCE+TLPayrollEntries.Amount;
                UNTIL TLPayrollEntries.NEXT=0;
                END;
                END;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Payroll Period";PayrollPeriod)
                {
                    TableRelation = "Payroll Period";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport();
    begin
        IF PayrollPeriod=0D THEN BEGIN
          ERROR('ENTER PAY PERIOD');
          END;
        PayrollPeriodP:=CALCDATE('-1M',PayrollPeriod);
        CompInfor.GET;
        CompInfor.CALCFIELDS(Picture);
    end;

    var
        TLPayrollEntries : Record "Payroll Entries";
        PayrollPeriod : Date;
        PayrollPeriodP : Date;
        CurentEarning : Decimal;
        PreviuosEarning : Decimal;
        CashBenefit : Text;
        NonCashBenefit : Text;
        Totals_earnings : Decimal;
        Variance_E : Decimal;
        CurentDedutions : Decimal;
        PreviuosDeductions : Decimal;
        Variance_D : Decimal;
        CurentNC : Decimal;
        PreviuosNC : Decimal;
        Variance_NC : Decimal;
        TITLES : Label 'ORGANIZATION PAYROLL VARIANCE REPORT';
        CompInfor : Record "Company Information";
        Payrollmonth : Text;
        DateDCSLbl : Label 'Date......................................';
        SignatureMHCALbl : Label 'Checked By H.O.F......................................................';
        SignatureMFLbl : Label 'First Authorized by HRAM.................................................';
        SignatureDCSLbl : Label 'Second Authorized by CEO............................................';
        PAYE : Decimal;
        TOTALTAXABLE : Decimal;
        MPA : Decimal;
        INSURENCE : Decimal;
        PreviuosPAYE : Decimal;
        PreviuosTOTALTAXABLE : Decimal;
        PreviuosMPA : Decimal;
        PreviuosINSURENCE : Decimal;
        VariancePAYE : Decimal;
        VarianceTOTALTAXABLE : Decimal;
        VarianceMPA : Decimal;
        VarianceINSURENCE : Decimal;
        TLEarnings : Record "Earnings Setup";
}

