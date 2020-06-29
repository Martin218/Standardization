report 50405 "P10 Report"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\P10 Report.rdlc';
    Caption = 'P10 Report';

    dataset
    {
        dataitem("Payroll Period";"Payroll Period")
        {
            column(EmptyString;'......................................................................')
            {
            }
            column(DataItem22;'We/I forward herewith ...........Tax Deduction Cards(P9A/P9B) showing the total tax deducted(as listed on P.10A) amounting to Kshs.................................................')
            {
            }
            column(This_total_tax_has_been_paid_as_follows___;'This total tax has been paid as follows:-')
            {
            }
            column(Company__Company_P_I_N_;Company."Company P.I.N")
            {
            }
            column(FORMAT__Starting_Date__0___year4___;FORMAT("Starting Date",0,'<year4>'))
            {
            }
            column(Payroll_PeriodX1_Name;UPPERCASE(FORMAT("Payroll Period"."Starting Date",0,'<Month Text>')))
            {
            }
            column(EmptyString_Control16;'......................................................................')
            {
            }
            column(ABS_paye_;ABS(paye))
            {
            }
            column(STRSUBSTNO__NAME_OF_EMPLOYER_____1__COMPANYNAME_;STRSUBSTNO('NAME OF EMPLOYER:   %1',COMPANYNAME))
            {
            }
            column(ABS__P_A_Y_E__;ABS("P.A.Y.E"))
            {
            }
            column(We_I_certify_that_the_particulars_entered_above_are_correct_;'We/I certify that the particulars entered above are correct')
            {
            }
            column(OFFICIAL_USE_;'OFFICIAL USE')
            {
            }
            column(BATCH_No_________________________________________________________________;'BATCH No................................................................')
            {
            }
            column(SIGNATURE____________________________________________________________;'SIGNATURE...........................................................')
            {
            }
            column(DATE______________________________________________________________________;'DATE.....................................................................')
            {
            }
            column(SIGNATURE_______________________________________________________________;'SIGNATURE..............................................................')
            {
            }
            column(DATE___________________________________________________________________________;'DATE..........................................................................')
            {
            }
            column(Payroll_PeriodX1__P_A_Y_E_;"P.A.Y.E")
            {
            }
            column(P10Caption;P10CaptionLbl)
            {
            }
            column(KENYA_REVENUE_AUTHORITYCaption;KENYA_REVENUE_AUTHORITYCaptionLbl)
            {
            }
            column(INCOME_TAX_DEPARTMENTCaption;INCOME_TAX_DEPARTMENTCaptionLbl)
            {
            }
            column(P_A_Y_E_EMPLOYER_S_CERTIFICATECaption;P_A_Y_E_EMPLOYER_S_CERTIFICATECaptionLbl)
            {
            }
            column(To_Senior_Assistant_Assistant_Commisioner_Caption;To_Senior_Assistant_Assistant_Commisioner_CaptionLbl)
            {
            }
            column(EMPLOYER_S_P_I_NCaption;EMPLOYER_S_P_I_NCaptionLbl)
            {
            }
            column(YEARCaption;YEARCaptionLbl)
            {
            }
            column(MonthCaption;MonthCaptionLbl)
            {
            }
            column(P_A_Y_E_TAXCaption;P_A_Y_E_TAXCaptionLbl)
            {
            }
            column(DATE_PAID_PER_RECEIVING_BANK_STAMP_Caption;DATE_PAID_PER_RECEIVING_BANK_STAMP_CaptionLbl)
            {
            }
            column(TOTAL_TAX_SHS_Caption;TOTAL_TAX_SHS_CaptionLbl)
            {
            }
            column(ADDRESS__________________________________________________________________Caption;ADDRESS__________________________________________________________________CaptionLbl)
            {
            }
            column(Payroll_PeriodX1_Starting_Date;"Starting Date")
            {
            }

            trigger OnAfterGetRecord();
            begin
                "Payroll Period".CALCFIELDS("P.A.Y.E");
                paye:="Payroll Period"."P.A.Y.E";
                Totpaye:=Totpaye+paye;
            end;

            trigger OnPreDataItem();
            begin
                "Payroll Period".SETFILTER("Starting Date",'%1..%2',MonthStartDate,MonthEndDate);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Enter Year";Years)
                {
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
        Company.GET;
        IF  Years=0 THEN BEGIN
           ERROR('Please Specify The YEAR For The Period');
          END;

          IF STRLEN(FORMAT(Years))<>4 THEN BEGIN
            ERROR('ENTER A FOUR DIGIT NUMBER, I.e %1',DATE2DMY(TODAY,3)-1);
            END;
           EVALUATE(MyDate,'0101'+''+FORMAT(Years));
           MonthStartDate:=CALCDATE('<-CY>',MyDate);
           MonthEndDate:=CALCDATE('<CY>',MyDate);
    end;

    var
        Company : Record "Company Information";
        paye : Decimal;
        Totpaye : Decimal;
        Period : Text[30];
        GroupCode : Code[20];
        CUser : Code[20];
        MonthStartDate : Date;
        P10CaptionLbl : Label 'P10';
        KENYA_REVENUE_AUTHORITYCaptionLbl : Label 'KENYA REVENUE AUTHORITY';
        INCOME_TAX_DEPARTMENTCaptionLbl : Label 'INCOME TAX DEPARTMENT';
        P_A_Y_E_EMPLOYER_S_CERTIFICATECaptionLbl : Label 'P.A.Y.E-EMPLOYER''S CERTIFICATE';
        To_Senior_Assistant_Assistant_Commisioner_CaptionLbl : Label '"To Senior Assistant/Assistant Commisioner "';
        EMPLOYER_S_P_I_NCaptionLbl : Label 'EMPLOYER''S P.I.N';
        YEARCaptionLbl : Label 'YEAR';
        MonthCaptionLbl : Label 'Month';
        P_A_Y_E_TAXCaptionLbl : Label 'P.A.Y.E TAX';
        DATE_PAID_PER_RECEIVING_BANK_STAMP_CaptionLbl : Label 'DATE PAID PER(RECEIVING BANK STAMP)';
        TOTAL_TAX_SHS_CaptionLbl : Label 'TOTAL TAX SHS.';
        ADDRESS__________________________________________________________________CaptionLbl : Label 'ADDRESS .................................................................';
        MonthEndDate : Date;
        Years : Integer;
        MyDate : Date;
}

