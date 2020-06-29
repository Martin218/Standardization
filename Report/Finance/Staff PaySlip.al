report 50415 "Staff PaySlip"
{
    // version TL 2.0

    DefaultLayout = RDLC;
    RDLCLayout = 'Report\Finance\Staff PaySlip.rdlc';
    Caption = 'My PaySlip';

    dataset
    {
        dataitem(Employee; Employee)
        {

            RequestFilterFields = "No.";
            column(Addr_1__1_; Addr[1] [1])
            {
            }
            column(Addr_1__2_; Addr[1] [2])
            {
            }
            column(IDNumber_Employee; Employee."ID Number")
            {
            }
            column(NHIF_Employee; Employee.NHIF)
            {
            }
            column(NSSF_Employee; Employee.NSSF)
            {
            }
            column(PINNumber_Employee; Employee."PIN Number")
            {
            }
            column(CoRec_Picture; CoRec.Picture)
            {
            }
            column(DepartmentName_Employee; Employee."Department Name")
            {
            }
            column(DeptArr_1_1_; Employee."Department Name")
            {
            }
            column(CampArr_1_1_; CampArr[1, 1])
            {
            }
            column(ArrEarnings_1_1_; ArrEarnings[1, 1])
            {
            }
            column(ArrEarnings_1_2_; ArrEarnings[1, 2])
            {
            }
            column(ArrEarnings_1_3_; ArrEarnings[1, 3])
            {
            }
            column(ArrEarningsAmt_1_1_; ArrEarningsAmt[1, 1])
            {
                // DecimalPlaces = 2:2;
            }
            column(ArrEarningsAmt_1_2_; ArrEarningsAmt[1, 2])
            {
                // DecimalPlaces = 2:2;
            }
            column(ArrEarningsAmt_1_3_; ArrEarningsAmt[1, 3])
            {
                //DecimalPlaces = 2:2;
            }
            column(ArrEarnings_1_4_; ArrEarnings[1, 4])
            {
            }
            column(ArrEarningsAmt_1_4_; ArrEarningsAmt[1, 4])
            {
                //DecimalPlaces = 2:2;
            }
            column(ArrEarnings_1_5_; ArrEarnings[1, 5])
            {
            }
            column(ArrEarningsAmt_1_5_; ArrEarningsAmt[1, 5])
            {
                //DecimalPlaces = 2:2;
            }
            column(ArrEarnings_1_6_; ArrEarnings[1, 6])
            {
            }
            column(ArrEarningsAmt_1_6_; ArrEarningsAmt[1, 6])
            {
            }
            column(ArrEarnings_1_7_; ArrEarnings[1, 7])
            {
            }
            column(ArrEarningsAmt_1_7_; ArrEarningsAmt[1, 7])
            {
            }
            column(ArrEarnings_1_8_; ArrEarnings[1, 8])
            {
            }
            column(ArrEarningsAmt_1_8_; ArrEarningsAmt[1, 8])
            {
            }
            column(UPPERCASE_FORMAT_DateSpecified_0___month_text___year4____; UPPERCASE(FORMAT(DateSpecified, 0, '<month text> <year4>')))
            {
            }
            column(Age_CaptionLbl; Age_CaptionLbl)
            {
            }
            column(Age_; DAge)
            {
            }
            column(CoName; CoName)
            {
            }
            column(ArrEarningsAmt_1_9_; ArrEarningsAmt[1, 9])
            {
            }
            column(ArrEarningsAmt_1_10_; ArrEarningsAmt[1, 10])
            {
            }
            column(ArrEarningsAmt_1_11_; ArrEarningsAmt[1, 11])
            {
            }
            column(ArrEarningsAmt_1_12_; ArrEarningsAmt[1, 12])
            {
            }
            column(ArrEarningsAmt_1_13_; ArrEarningsAmt[1, 13])
            {
            }
            column(ArrEarningsAmt_1_14_; ArrEarningsAmt[1, 14])
            {
            }
            column(ArrEarningsAmt_1_15_; ArrEarningsAmt[1, 15])
            {
            }
            column(ArrEarningsAmt_1_16_; ArrEarningsAmt[1, 16])
            {
            }
            column(ArrEarnings_1_9_; ArrEarnings[1, 9])
            {
            }
            column(ArrEarnings_1_10_; ArrEarnings[1, 10])
            {
            }
            column(ArrEarnings_1_11_; ArrEarnings[1, 11])
            {
            }
            column(ArrEarnings_1_12_; ArrEarnings[1, 12])
            {
            }
            column(ArrEarnings_1_13_; ArrEarnings[1, 13])
            {
            }
            column(ArrEarnings_1_14_; ArrEarnings[1, 14])
            {
            }
            column(ArrEarnings_1_15_; ArrEarnings[1, 15])
            {
            }
            column(ArrEarnings_1_16_; ArrEarnings[1, 16])
            {
            }
            column(ArrEarningsAmt_1_17_; ArrEarningsAmt[1, 17])
            {
            }
            column(ArrEarnings_1_17_; ArrEarnings[1, 17])
            {
            }
            column(ArrEarnings_1_18_; ArrEarnings[1, 18])
            {
            }
            column(ArrEarnings_1_19_; ArrEarnings[1, 19])
            {
            }
            column(ArrEarnings_1_20_; ArrEarnings[1, 20])
            {
            }
            column(ArrEarnings_1_21_; ArrEarnings[1, 21])
            {
            }
            column(ArrEarnings_1_22_; ArrEarnings[1, 22])
            {
            }
            column(ArrEarnings_1_23_; ArrEarnings[1, 23])
            {
            }
            column(ArrEarnings_1_25_; ArrEarnings[1, 25])
            {
            }
            column(ArrEarnings_1_26_; ArrEarnings[1, 26])
            {
            }
            column(ArrEarnings_1_34_; ArrEarnings[1, 34])
            {
            }
            column(ArrEarnings_1_33_; ArrEarnings[1, 33])
            {
            }
            column(ArrEarnings_1_32_; ArrEarnings[1, 32])
            {
            }
            column(ArrEarnings_1_31_; ArrEarnings[1, 31])
            {
            }
            column(ArrEarnings_1_30_; ArrEarnings[1, 30])
            {
            }
            column(ArrEarnings_1_29_; ArrEarnings[1, 29])
            {
            }
            column(ArrEarnings_1_28_; ArrEarnings[1, 28])
            {
            }
            column(ArrEarnings_1_27_; ArrEarnings[1, 27])
            {
            }
            column(ArrEarnings_1_41_; ArrEarnings[1, 41])
            {
            }
            column(ArrEarnings_1_40_; ArrEarnings[1, 40])
            {
            }
            column(ArrEarnings_1_39_; ArrEarnings[1, 39])
            {
            }
            column(ArrEarnings_1_38_; ArrEarnings[1, 38])
            {
            }
            column(ArrEarnings_1_37_; ArrEarnings[1, 37])
            {
            }
            column(ArrEarnings_1_36_; ArrEarnings[1, 36])
            {
            }
            column(ArrEarnings_1_35_; ArrEarnings[1, 35])
            {
            }
            column(ArrEarningsAmt_1_33_; ArrEarningsAmt[1, 33])
            {
            }
            column(ArrEarningsAmt_1_32_; ArrEarningsAmt[1, 32])
            {
            }
            column(ArrEarningsAmt_1_31_; ArrEarningsAmt[1, 31])
            {
            }
            column(ArrEarningsAmt_1_30_; ArrEarningsAmt[1, 30])
            {
            }
            column(ArrEarningsAmt_1_29_; ArrEarningsAmt[1, 29])
            {
            }
            column(ArrEarningsAmt_1_28_; ArrEarningsAmt[1, 28])
            {
            }
            column(ArrEarningsAmt_1_27_; ArrEarningsAmt[1, 27])
            {
            }
            column(ArrEarningsAmt_1_26_; ArrEarningsAmt[1, 26])
            {
            }
            column(ArrEarningsAmt_1_25_; ArrEarningsAmt[1, 25])
            {
            }
            column(ArrEarningsAmt_1_24_; ArrEarningsAmt[1, 24])
            {
            }
            column(ArrEarningsAmt_1_23_; ArrEarningsAmt[1, 23])
            {
            }
            column(ArrEarningsAmt_1_22_; ArrEarningsAmt[1, 22])
            {
            }
            column(ArrEarningsAmt_1_21_; ArrEarningsAmt[1, 21])
            {
            }
            column(ArrEarningsAmt_1_20_; ArrEarningsAmt[1, 20])
            {
            }
            column(ArrEarningsAmt_1_19_; ArrEarningsAmt[1, 19])
            {
            }
            column(ArrEarningsAmt_1_18_; ArrEarningsAmt[1, 18])
            {
            }
            column(ArrEarnings_1_24_; ArrEarnings[1, 24])
            {
            }
            column(ArrEarningsAmt_1_39_; ArrEarningsAmt[1, 39])
            {
            }
            column(ArrEarningsAmt_1_38_; ArrEarningsAmt[1, 38])
            {
            }
            column(ArrEarningsAmt_1_37_; ArrEarningsAmt[1, 37])
            {
            }
            column(ArrEarningsAmt_1_36_; ArrEarningsAmt[1, 36])
            {
            }
            column(ArrEarningsAmt_1_35_; ArrEarningsAmt[1, 35])
            {
            }
            column(ArrEarningsAmt_1_34_; ArrEarningsAmt[1, 34])
            {
            }
            column(ArrEarningsAmt_1_41_; ArrEarningsAmt[1, 41])
            {
            }
            column(ArrEarningsAmt_1_40_; ArrEarningsAmt[1, 40])
            {
            }
            column(Message1; Message1)
            {
            }
            column(Message2_1_1_; Message2[1, 1])
            {
            }
            column(ArrEarningsAmt_1_43_; ArrEarningsAmt[1, 43])
            {
            }
            column(ArrEarningsAmt_1_42_; ArrEarningsAmt[1, 42])
            {
            }
            column(ArrEarningsAmt_1_45_; ArrEarningsAmt[1, 45])
            {
            }
            column(ArrEarningsAmt_1_44_; ArrEarningsAmt[1, 44])
            {
            }
            column(ArrEarnings_1_45_; ArrEarnings[1, 45])
            {
            }
            column(ArrEarnings_1_44_; ArrEarnings[1, 44])
            {
            }
            column(ArrEarnings_1_43_; ArrEarnings[1, 43])
            {
            }
            column(ArrEarnings_1_42_; ArrEarnings[1, 42])
            {
            }
            column(ArrEarningsAmt_1_48_; ArrEarningsAmt[1, 48])
            {
            }
            column(ArrEarningsAmt_1_46_; ArrEarningsAmt[1, 46])
            {
            }
            column(ArrEarningsAmt_1_47_; ArrEarningsAmt[1, 47])
            {
            }
            column(ArrEarnings_1_48_; ArrEarnings[1, 48])
            {
            }
            column(ArrEarnings_1_47_; ArrEarnings[1, 47])
            {
            }
            column(ArrEarnings_1_46_; ArrEarnings[1, 46])
            {
            }
            column(ArrEarningsAmt_1_49_; ArrEarningsAmt[1, 49])
            {
            }
            column(ArrEarningsAmt_1_50_; ArrEarningsAmt[1, 50])
            {
            }
            column(ArrEarningsAmt_1_51_; ArrEarningsAmt[1, 51])
            {
            }
            column(ArrEarningsAmt_1_52_; ArrEarningsAmt[1, 52])
            {
            }
            column(ArrEarningsAmt_1_53_; ArrEarningsAmt[1, 53])
            {
            }
            column(ArrEarningsAmt_1_54_; ArrEarningsAmt[1, 54])
            {
            }
            column(ArrEarningsAmt_1_55_; ArrEarningsAmt[1, 55])
            {
            }
            column(ArrEarningsAmt_1_56_; ArrEarningsAmt[1, 56])
            {
            }
            column(ArrEarningsAmt_1_57_; ArrEarningsAmt[1, 57])
            {
            }
            column(ArrEarningsAmt_1_58_; ArrEarningsAmt[1, 58])
            {
            }
            column(ArrEarningsAmt_1_59_; ArrEarningsAmt[1, 59])
            {
            }
            column(ArrEarningsAmt_1_60_; ArrEarningsAmt[1, 60])
            {
            }
            column(ArrEarnings_1_49_; ArrEarnings[1, 49])
            {
            }
            column(ArrEarnings_1_50_; ArrEarnings[1, 50])
            {
            }
            column(ArrEarnings_1_51_; ArrEarnings[1, 51])
            {
            }
            column(ArrEarnings_1_52_; ArrEarnings[1, 52])
            {
            }
            column(ArrEarnings_1_53_; ArrEarnings[1, 53])
            {
            }
            column(ArrEarnings_1_54_; ArrEarnings[1, 54])
            {
            }
            column(ArrEarnings_1_55_; ArrEarnings[1, 55])
            {
            }
            column(ArrEarnings_1_56_; ArrEarnings[1, 56])
            {
            }
            column(ArrEarnings_1_57_; ArrEarnings[1, 57])
            {
            }
            column(ArrEarnings_1_58_; ArrEarnings[1, 58])
            {
            }
            column(ArrEarnings_1_59_; ArrEarnings[1, 59])
            {
            }
            column(ArrEarnings_1_60_; ArrEarnings[1, 60])
            {
            }
            column(BalanceArray_1_1_; BalanceArrs[1, 1])
            {
            }
            column(BalanceArray_1_2_; BalanceArrs[1, 2])
            {
            }
            column(BalanceArray_1_3_; BalanceArrs[1, 3])
            {
            }
            column(BalanceArray_1_4_; BalanceArrs[1, 4])
            {
            }
            column(BalanceArray_1_5_; BalanceArrs[1, 5])
            {
            }
            column(BalanceArray_1_6_; BalanceArrs[1, 6])
            {
            }
            column(BalanceArray_1_7_; BalanceArrs[1, 7])
            {
            }
            column(BalanceArray_1_8_; BalanceArrs[1, 8])
            {
            }
            column(BalanceArray_1_9_; BalanceArrs[1, 9])
            {
            }
            column(BalanceArray_1_10_; BalanceArrs[1, 10])
            {
            }
            column(BalanceArray_1_11_; BalanceArrs[1, 11])
            {
            }
            column(BalanceArray_1_12_; BalanceArrs[1, 12])
            {
            }
            column(BalanceArray_1_13_; BalanceArrs[1, 13])
            {
            }
            column(BalanceArray_1_14_; BalanceArrs[1, 14])
            {
            }
            column(BalanceArray_1_15_; BalanceArrs[1, 15])
            {
            }
            column(BalanceArray_1_16_; BalanceArrs[1, 16])
            {
            }
            column(BalanceArray_1_17_; BalanceArrs[1, 17])
            {
            }
            column(BalanceArray_1_18_; BalanceArrs[1, 18])
            {
            }
            column(BalanceArray_1_19_; BalanceArrs[1, 19])
            {
            }
            column(BalanceArray_1_20_; BalanceArrs[1, 22])
            {
            }
            column(BalanceArray_1_21_; BalanceArrs[1, 21])
            {
            }
            column(BalanceArray_1_23_; BalanceArrs[1, 23])
            {
            }
            column(BalanceArray_1_24_; BalanceArrs[1, 24])
            {
            }
            column(BalanceArray_1_25_; BalanceArrs[1, 25])
            {
            }
            column(BalanceArray_1_26_; BalanceArrs[1, 26])
            {
            }
            column(BalanceArray_1_27_; BalanceArrs[1, 27])
            {
            }
            column(BalanceArray_1_28_; BalanceArrs[1, 28])
            {
            }
            column(BalanceArray_1_29_; BalanceArrs[1, 29])
            {
            }
            column(BalanceArray_1_30_; BalanceArrs[1, 30])
            {
            }
            column(BalanceArray_1_31_; BalanceArrs[1, 31])
            {
            }
            column(BalanceArray_1_32_; BalanceArrs[1, 32])
            {
            }
            column(BalanceArray_1_34_; BalanceArrs[1, 34])
            {
            }
            column(BalanceArray_1_33_; BalanceArrs[1, 33])
            {
            }
            column(BalanceArray_1_36_; BalanceArrs[1, 36])
            {
            }
            column(BalanceArray_1_35_; BalanceArrs[1, 35])
            {
            }
            column(BalanceArray_1_37_; BalanceArrs[1, 37])
            {
            }
            column(BalanceArray_1_38_; BalanceArrs[1, 38])
            {
            }
            column(BalanceArray_1_39_; BalanceArrs[1, 39])
            {
            }
            column(BalanceArray_1_40_; BalanceArrs[1, 40])
            {
            }
            column(BalanceArray_1_41_; BalanceArrs[1, 41])
            {
            }
            column(BalanceArray_1_42_; BalanceArrs[1, 42])
            {
            }
            column(BalanceArray_1_43_; BalanceArrs[1, 43])
            {
            }
            column(BalanceArray_1_44_; BalanceArrs[1, 44])
            {
            }
            column(BalanceArray_1_45_; BalanceArrs[1, 45])
            {
            }
            column(BalanceArray_1_46_; BalanceArrs[1, 46])
            {
            }
            column(BalanceArray_1_47_; BalanceArrs[1, 47])
            {
            }
            column(BalanceArray_1_48_; BalanceArrs[1, 48])
            {
            }
            column(STRSUBSTNO__Date__1__2__TODAY_TIME_; STRSUBSTNO('Date %1 %2', TODAY, TIME))
            {
            }
            column(USERID; USERID)
            {
            }
            column(CurrReport_PAGENO; CurrReport.PAGENO)
            {
            }
            column(EarningsCaption; EarningsCaptionLbl)
            {
            }
            column(Employee_No_Caption; Employee_No_CaptionLbl)
            {
            }
            column(Name_Caption; Name_CaptionLbl)
            {
            }
            column(Dept_Caption; Dept_CaptionLbl)
            {
            }
            column(Camp_Caption; Camp_CaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(Pay_slipCaption; Pay_slipCaptionLbl)
            {
            }
            column(EmptyStringCaption; EmptyStringCaptionLbl)
            {
            }
            column(CurrReport_PAGENOCaption; CurrReport_PAGENOCaptionLbl)
            {
            }
            column(Employee_No_; "No.")
            {
            }
            column(Loan_Balance; LoanBalance)
            {
            }
            column(copy99; copy99)
            {
            }
            column(Balance_9; BalanceArrs[1, 9])
            {
            }
            column(Balance_10; BalanceArrs[1, 10])
            {
            }
            column(Balance_11; BalanceArrs[1, 11])
            {
            }
            column(Balance_12; BalanceArrs[1, 12])
            {
            }
            column(Balance_13; BalanceArrs[1, 13])
            {
            }
            column(Balance_14; BalanceArrs[1, 14])
            {
            }
            column(Balance_15; BalanceArrs[1, 15])
            {
            }
            column(Balance_16; BalanceArrs[1, 16])
            {
            }
            column(Balance_17; BalanceArrs[1, 17])
            {
            }
            column(Balance_18; BalanceArrs[1, 18])
            {
            }
            column(Balance_19; BalanceArrs[1, 19])
            {
            }
            column(Balance_20; BalanceArrs[1, 20])
            {
            }
            column(Balance_21; BalanceArrs[1, 21])
            {
            }
            column(Balance_22; BalanceArrs[1, 22])
            {
            }
            column(Balance_23; BalanceArrs[1, 23])
            {
            }
            column(Balance_24; BalanceArrs[1, 24])
            {
            }
            column(Balance_25; BalanceArrs[1, 25])
            {
            }
            column(Balance_26; BalanceArrs[1, 26])
            {
            }
            column(Balance_27; BalanceArrs[1, 27])
            {
            }
            column(Balance_28; BalanceArrs[1, 28])
            {
            }
            column(Balance_29; BalanceArrs[1, 29])
            {
            }
            column(Balance_30; BalanceArrs[1, 30])
            {
            }
            column(Balance_31; BalanceArrs[1, 31])
            {
            }
            column(Balance_32; BalanceArrs[1, 32])
            {
            }
            column(Balance_33; BalanceArrs[1, 33])
            {
            }
            column(Balance_34; BalanceArrs[1, 34])
            {
            }
            column(Balance_35; BalanceArrs[1, 35])
            {
            }
            column(Balance_36; BalanceArrs[1, 36])
            {
            }
            column(Balance_37; BalanceArrs[1, 37])
            {
            }
            column(Balance_38; BalanceArrs[1, 38])
            {
            }
            column(Balance_39; BalanceArrs[1, 39])
            {
            }

            trigger OnAfterGetRecord();
            var
                PayrollSetup: Record "Payroll Setup";
            begin
                PayrollSetup.RESET;
                PayrollSetup.GET;
                CLEAR(Addr);
                CLEAR(DeptArr);
                CLEAR(BasicPay);
                CLEAR(EmpArray);
                CLEAR(ArrEarnings);
                CLEAR(ArrEarningsAmt);
                CLEAR(BalanceArray);
                CLEAR(Balance);
                GrossPay := 0;
                TotalDeduction := 0;
                Totalcoopshares := 0;
                Totalnssf := 0;
                NetPay := 0;
                Addr[1] [1] := Employee."No.";
                Addr[1] [2] := Employee."First Name" + ' ' + Employee."Last Name";

                // get Department Name
                DimVal.RESET;
                DimVal.SETRANGE(DimVal.Code, Employee."Global Dimension 1 Code");
                DimVal.SETRANGE("Global Dimension No.", 1);
                IF DimVal.FIND('-') THEN
                    DeptArr[1, 1] := DimVal.Name;

                // ======================Basic Salary

                TLEarning.RESET;
                TLEarning.SETRANGE("Basic Salary Code", TRUE);
                IF TLEarning.FINDFIRST THEN BEGIN
                    TLPayrollEntry.RESET;
                    TLPayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                    TLPayrollEntry.SETRANGE(Type, TLPayrollEntry.Type::Payment);
                    TLPayrollEntry.SETRANGE(Code, TLPayrollEntry.Code);
                    TLPayrollEntry.SETRANGE("Employee No", Employee."No.");
                    IF TLPayrollEntry.FINDFIRST THEN BEGIN
                        BasicPay[1, 1] := TLPayrollEntry.Description;
                        EmpArray[1, 1] := TLPayrollEntry.Amount;
                    END;
                END;
                i := 1;
                TLEarning1.RESET;
                TLEarning1.SETRANGE("Earning Type", TLEarning1."Earning Type"::"Normal Earning");
                TLEarning1.SETRANGE("Non-Cash Benefit", FALSE);
                IF TLEarning1.FINDFIRST THEN BEGIN
                    REPEAT
                        EarningCode := TLEarning1.Code;
                        PayrollEntry.RESET;
                        PayrollEntry.SETRANGE(Code, EarningCode);
                        PayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
                        PayrollEntry.SETRANGE("Employee No", Employee."No.");
                        IF PayrollEntry.FINDFIRST THEN BEGIN
                            REPEAT
                                ArrEarnings[1, i] := PayrollEntry.Description;
                                EVALUATE(ArrEarningsAmt[1, i], FORMAT(PayrollEntry.Amount));
                                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                                GrossPay := GrossPay + PayrollEntry.Amount;
                                i := i + 1;
                            UNTIL PayrollEntry.NEXT = 0;
                        END;
                        CLEAR(EarningCode);
                    UNTIL TLEarning1.NEXT = 0;
                END;


                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';
                i := i + 1;
                ArrEarnings[1, i] := 'GROSS PAY';
                EVALUATE(ArrEarningsAmt[1, i], FORMAT(GrossPay));
                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                i := i + 1;

                // NON CASH BENEFITS
                ArrEarnings[1, i] := 'NON CASH BENEFITS';

                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                i := i + 1;
                // Get Non Cash Benefits
                TLEarning.RESET;
                TLEarning.SETRANGE("Earning Type", TLEarning."Earning Type"::"Normal Earning");
                TLEarning.SETRANGE("Non-Cash Benefit", TRUE);
                IF TLEarning.FINDFIRST THEN BEGIN
                    REPEAT
                        TLPayrollEntry.RESET;
                        TLPayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                        TLPayrollEntry.SETRANGE(Type, TLPayrollEntry.Type::Payment);
                        TLPayrollEntry.SETRANGE("Employee No", Employee."No.");
                        TLPayrollEntry.SETRANGE("Basic Salary Code", FALSE);
                        TLPayrollEntry.SETRANGE(Code, TLEarning.Code);
                        IF TLPayrollEntry.FINDFIRST THEN BEGIN
                            REPEAT
                                ArrEarnings[1, i] := TLPayrollEntry.Description;
                                EVALUATE(ArrEarningsAmt[1, i], FORMAT(TLPayrollEntry.Amount));
                                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                                i := i + 1;
                            UNTIL TLPayrollEntry.NEXT = 0;
                        END;
                    UNTIL TLEarning.NEXT = 0;
                END;
                // i:=i+1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                i := i + 1;
                // TAXATION
                ArrEarnings[1, i] := 'TAXATIONS';

                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                // i:=i+1;
                //==============================PAYE
                TLDeduction.RESET;
                TLDeduction.SETRANGE("PAYE Code", TRUE);
                IF TLDeduction.FINDFIRST THEN BEGIN
                    TLPayrollEntry.RESET;
                    TLPayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                    TLPayrollEntry.SETRANGE(Type, TLPayrollEntry.Type::Deduction);
                    TLPayrollEntry.SETRANGE("Employee No", Employee."No.");
                    TLPayrollEntry.SETRANGE(Code, TLDeduction.Code);
                    IF TLPayrollEntry.FINDFIRST THEN BEGIN
                        AmountTaxed := 0;
                        PAYEAmount := 0;
                        AmountTaxed := TLPayrollEntry."Taxable amount";
                        PAYEAmount := TLPayrollEntry.Amount;
                    END;
                    i := i + 1;
                END;
                //============Get Taxable amount
                ArrEarnings[1, i] := 'Taxable Amount';
                EVALUATE(ArrEarningsAmt[1, i], FORMAT(ABS(AmountTaxed)));
                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                i := i + 1;
                ArrEarnings[1, i] := 'Tax Charged';
                EVALUATE(ArrEarningsAmt[1, i], FORMAT(ABS(PAYEAmount)));
                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                i := i + 1;
                //===========Get Relief
                TLEarning.RESET;
                TLEarning.SETFILTER("Earning Type", '%1|%2', TLEarning."Earning Type"::"Tax Relief", TLEarning."Earning Type"::"Insurance Relief");
                IF TLEarning.FINDFIRST THEN BEGIN
                    REPEAT
                        TLPayrollEntry.RESET;
                        TLPayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                        TLPayrollEntry.SETRANGE(Type, TLPayrollEntry.Type::Payment);
                        TLPayrollEntry.SETRANGE("Employee No", Employee."No.");
                        TLPayrollEntry.SETRANGE("Basic Salary Code", FALSE);
                        TLPayrollEntry.SETRANGE(Code, TLEarning.Code);
                        IF TLPayrollEntry.FINDFIRST THEN BEGIN
                            REPEAT
                                ArrEarnings[1, i] := TLPayrollEntry.Description;
                                EVALUATE(ArrEarningsAmt[1, i], FORMAT(ABS(TLPayrollEntry.Amount)));
                                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);

                                i := i + 1;
                            UNTIL TLPayrollEntry.NEXT = 0;
                        END;
                    UNTIL TLEarning.NEXT = 0;
                END;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';
                i := i + 1;
                // ======Get Deductions
                ArrEarnings[1, i] := 'DEDUCTIONS';

                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                //i:=i+1;
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
                PayrollEntry.SETRANGE("Employee No", Employee."No.");
                PayrollEntry.SETRANGE(Paye, TRUE);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    ArrEarnings[1, i] := PayrollEntry.Description;
                    EVALUATE(ArrEarningsAmt[1, i], FORMAT(ABS(PayrollEntry.Amount)));
                    ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);

                    TotalDeduction := TotalDeduction + ABS(PayrollEntry.Amount);
                END;

                i := i + 1;
                TLPayrollEntry.RESET;
                TLPayrollEntry.SETRANGE("Payroll Period", DateSpecified);
                TLPayrollEntry.SETFILTER(Type, '%1|%2', TLPayrollEntry.Type::Deduction, TLPayrollEntry.Type::Loan);
                TLPayrollEntry.SETRANGE("Employee No", Employee."No.");
                TLPayrollEntry.SETRANGE(Paye, FALSE);
                IF TLPayrollEntry.FINDFIRST THEN BEGIN
                    REPEAT
                        ArrEarnings[1, i] := TLPayrollEntry.Description;
                        EVALUATE(ArrEarningsAmt[1, i], FORMAT(ABS(ROUND(TLPayrollEntry.Amount, PayrollSetup."Payroll Roundoff"))));
                        ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);
                        TotalDeduction := TotalDeduction + ABS(TLPayrollEntry.Amount);
                        i := i + 1;
                    UNTIL TLPayrollEntry.NEXT = 0;
                END;
                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';
                i := i + 1;
                ArrEarnings[1, i] := 'TOTAL DEDUCTIONS';
                TotalDeduction := ROUND(TotalDeduction, PayrollSetup."Payroll Roundoff");
                EVALUATE(ArrEarningsAmt[1, i], FORMAT(TotalDeduction));
                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);

                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                i := i + 1;
                // Net Pay
                ArrEarnings[1, i] := 'NET PAY';
                NetPay := GrossPay - TotalDeduction;
                NetPay := ROUND(NetPay, PayrollSetup."Payroll Roundoff");
                EVALUATE(ArrEarningsAmt[1, i], FORMAT(NetPay));
                ArrEarningsAmt[1, i] := ConfirmRoundOff(ArrEarningsAmt[1, i]);

                i := i + 1;

                ArrEarnings[1, i] := '__________________________________________';
                ArrEarningsAmt[1, i] := '__________________________________________';

                i := i + 1;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field("Month Begin Date"; MonthStartDate)
                {
                    Caption = 'Month Begin Date';
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
        DateSpecified := MonthStartDate;
        CoRec.GET;
        CoRec.CALCFIELDS(Picture);
    end;

    var
        DAge: Text;
        EarningsCaptionLbl: Label 'Earnings';
        Employee_No_CaptionLbl: Label 'Employee No:';
        Name_CaptionLbl: Label 'Name:';
        Dept_CaptionLbl: Label 'Dept:';
        Camp_CaptionLbl: Label 'Campus:';
        AmountCaptionLbl: Label 'Amount';
        Pay_slipCaptionLbl: Label 'My Pay Slip';
        EmptyStringCaptionLbl: Label '___________________________________________________';
        CurrReport_PAGENOCaptionLbl: Label 'Copy';
        Age_CaptionLbl: Label 'Age';
        Addr: array[10, 100] of Text[250];
        NoOfRecords: Integer;
        RecordNo: Integer;
        NoOfColumns: Integer;
        ColumnNo: Integer;
        i: Integer;
        AmountRemaining: Decimal;
        IncomeTax: Decimal;
        TLPayrollPeriod: Record "Payroll Period";
        PayPeriodtext: Text[70];
        BeginDate: Date;
        DateSpecified: Date;
        EndDate: Date;
        BankName: Text[250];
        BasicSalary: Decimal;
        TaxableAmt: Decimal;
        RightBracket: Boolean;
        NetPay: Decimal;
        PayrollPeriod: Record "Payroll Period";
        PayrollEntry: Record "Payroll Entries";
        EmpRec: Record Employee;
        EmpNo: Code[50];
        TaxableAmount: Decimal;
        PAYE: Decimal;
        ArrEarnings: array[3, 100] of Text[250];
        ArrDeductions: array[3, 100] of Text[250];
        Index: Integer;
        Index1: Integer;
        j: Integer;
        ArrEarningsAmt: array[3, 100] of Text[60];
        ArrDeductionsAmt: array[3, 100] of Decimal;
        Year: Integer;
        EmpArray: array[10, 15] of Decimal;
        HoldDate: Date;
        DenomArray: array[3, 12] of Text[50];
        NoOfUnitsArray: array[3, 12] of Integer;
        AmountArray: array[3, 12] of Decimal;
        PayModeArray: array[3] of Text[30];
        HoursArray: array[3, 60] of Decimal;
        CompRec: Record "Human Resources Setup";
        HseLimit: Decimal;
        ExcessRetirement: Decimal;
        CfMpr: Decimal;
        relief: Decimal;
        TaxCode: Code[10];
        HoursBal: Decimal;
        TLEarning: Record "Earnings Setup";
        TLDeduction: Record "Deductions Setup";
        HoursArrayD: array[3, 60] of Decimal;
        BankBranch: Text[30];
        CoName: Text[70];
        retirecontribution: Decimal;
        EarngingCount: Integer;
        DeductionCount: Integer;
        EarnAmount: Decimal;
        GrossTaxCharged: Decimal;
        DimVal: Record "Dimension Value";
        Department: Text[60];
        LowInterestBenefits: Decimal;
        SpacePos: Integer;
        NetPayLength: Integer;
        AmountText: Text[30];
        DecimalText: Text[30];
        DecimalAMT: Decimal;
        InsuranceRelief: Decimal;
        InsuranceReliefText: Text[30];
        IncometaxNew: Decimal;
        NewRelief: Decimal;
        TaxablePayNew: Decimal;
        InsuranceReliefNew: Decimal;
        TaxChargedNew: Decimal;
        finalTax: Decimal;
        TotalBenefits: Decimal;
        RetireCont: Decimal;
        TotalQuarters: Decimal;
        "Employee Payroll": Record Employee;
        PayMode: Text[70];
        Intex: Integer;
        NetPay1: Decimal;
        Principal: Decimal;
        Interest: Decimal;
        Desc: Text[50];
        TLDeduction1: Record "Deductions Setup";
        RoundedNetPay: Decimal;
        diff: Decimal;
        CFWD: Decimal;
        Nssfcomptext: Text[70];
        Nssfcomp: Decimal;
        LoanDesc: Text[60];
        LoanDesc1: Text[60];
        TLDeduction2: Record "Deductions Setup";
        OriginalLoan: Decimal;
        LoanBalance: Decimal;
        Message1: Text[250];
        Message2: array[3, 1] of Text[250];
        DeptArr: array[3, 1] of Text[60];
        CampArr: array[3, 1] of Text[60];
        BasicPay: array[3, 1] of Text[250];
        InsurEARN: Decimal;
        HasInsurance: Boolean;
        RoundedAmt: Decimal;
        TerminalDues: Decimal;
        TLEarning1: Record "Earnings Setup";
        TLPayrollEntry: Record "Payroll Entries";
        RoundingDesc: Text[60];
        BasicChecker: Decimal;
        CoRec: Record "Company Information";
        GrossPay: Decimal;
        TotalDeduction: Decimal;
        PayrollMonth: Date;
        PayrollMonthText: Text[70];
        PayeeTest: Decimal;
        GroupCode: Code[20];
        CUser: Code[20];
        Totalcoopshares: Decimal;
        LoanBal: Decimal;
        TotalRepayment: Decimal;
        Totalnssf: Decimal;
        Totalpension: Decimal;
        Totalprovid: Decimal;
        BalanceArray: array[3, 100] of Decimal;
        TaxCharged: Decimal;
        FiscalStart: Date;
        MaturityDate: Date;
        PositivePAYEManual: Decimal;
        TotalToDate: Decimal;
        AccPeriod: Record "Accounting Period";
        MonthStartDate: Date;
        TLPayrollPeriod1: Record "Payroll Period";
        check7: Integer;
        copy99: Integer;
        PrincipalAmt: Decimal;
        InterestCode: Code[10];
        Balance: array[3, 100] of Decimal;
        TotalAmount: Decimal;
        BalanceArr: array[3, 100] of Decimal;
        BalanceArrs: array[3, 100] of Decimal;
        AmountTaxed: Decimal;
        PAYEAmount: Decimal;
        EarningCode: Code[10];

    procedure ConfirmRoundOff(var AmtText: Text[30]) ChckRound: Text[30];
    var
        LenthOfText: Integer;
        DecimalPos: Integer;
        AmtWithoutDec: Text[30];
        DecimalAmt: Text[30];
        Decimalstrlen: Integer;
    begin
        LenthOfText := STRLEN(AmtText);
        DecimalPos := STRPOS(AmtText, '.');
        IF DecimalPos = 0 THEN BEGIN
            AmtWithoutDec := AmtText;
            DecimalAmt := '.00';
        END ELSE BEGIN
            AmtWithoutDec := COPYSTR(AmtText, 1, DecimalPos - 1);
            DecimalAmt := COPYSTR(AmtText, DecimalPos + 1, 2);
            Decimalstrlen := STRLEN(DecimalAmt);
            IF Decimalstrlen < 2 THEN BEGIN
                DecimalAmt := '.' + DecimalAmt + '0';
            END ELSE
                DecimalAmt := '.' + DecimalAmt
        END;
        ChckRound := AmtWithoutDec + DecimalAmt;
    end;
}

