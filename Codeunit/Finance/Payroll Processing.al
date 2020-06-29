codeunit 50038 "Payroll Processing"
{


    trigger OnRun();
    begin
        CreateMorestatus();
    end;

    var
        PayrollPeriods: Record "Payroll Period";
        BracketTable: Record "Bracket Table";
        BracketLines: Record "Bracket Line";
        EarningsSetup: Record "Earnings Setup";
        DeductionsSetup: Record "Deductions Setup";
        PayrollEntry: Record "Payroll Entries";
        Text000: Label 'The new fiscal year begins before an existing fiscal year, so the new year will be closed automatically.\\';
        Text001: Label 'Do you want to create and close the fiscal year?';
        Text002: Label 'Once you create the new fiscal year you cannot change its starting date.\\';
        Text003: Label 'Do you want to create the fiscal year?';
        Text004: Label 'It is only possible to create new fiscal years before or after the existing ones.';
        CurrentPeriod: Date;
        NextPeriod: Date;
        BasicPay: Decimal;
        PayPeriodDate: Date;
        BasicPayCode: Code[10];
        PrincipalAmount: Decimal;
        InterestAmount: Decimal;
        InsuranceAmount: Decimal;
        LoanCode: Code[20];
        PayrollSetup: Record "Payroll Setup";
        Allowance: Decimal;
        TaxableAmount: Decimal;
        PAYECode: Code[20];
        DeductionAmount: Decimal;
        GrossAmount: Decimal;
        Employee: Record Employee;
        // RunPayroll : Report "50402";
        Records: Integer;
        CurrentRec: Integer;
        Window: Dialog;
        ImprestMgnt: Record "Imprest Management";
        Customer: Record Customer;
        CashManagement: Codeunit "Cash Management";

    procedure ProcessingPayroll(Employee: Record Employee);
    begin
        BasicPay := 0;
        PrincipalAmount := 0;
        InsuranceAmount := 0;
        InterestAmount := 0;
        Allowance := 0;
        TaxableAmount := 0;
        DeductionAmount := 0;
        LoanCode := '';
        PayPeriodDate := GetOpenPeriod();
        WITH Employee DO BEGIN
            IF Employee.Status = Employee.Status::Terminated THEN BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Payroll Period", PayPeriodDate);
                PayrollEntry.SETRANGE("Employee No", Employee."No.");
                IF PayrollEntry.FINDSET THEN BEGIN
                    PayrollEntry.DELETEALL;
                END;
            END;
            IF Employee.Status <> Employee.Status::Active THEN BEGIN
                EXIT;
            END;
            ComputeBasicSalary(Employee);
            ComputeOtherEarings(Employee);
            ComputeOtherDeductions(Employee);
            CalculateAdvanceSalary(Employee);
            ComputeLoans(Employee);
            ComputePAYE(Employee);
        END;
    end;

    procedure TransferingToJounal(Employee: Record Employee);
    begin
    end;

    procedure UpdatingPayrollEntry(PayrollEntries: Record "Payroll Entries") Description: Text;
    begin
        WITH PayrollEntries DO BEGIN
            CASE Type OF
                Type::Payment:
                    BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(Code) THEN BEGIN
                            IF EarningsSetup.Block = TRUE THEN BEGIN
                                ERROR('Earning Blocked');
                            END;
                            IF EarningsSetup."Basic Salary Code" = TRUE THEN BEGIN
                                "Basic Salary Code" := TRUE;
                            END;
                            Description := EarningsSetup.Description;
                            IF (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Tax Relief") OR (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Insurance Relief") THEN BEGIN
                                "Tax Relief" := TRUE;
                            END;
                            IF EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Normal Earning" THEN BEGIN
                                "Normal Earnings" := TRUE
                            END ELSE BEGIN
                                "Normal Earnings" := FALSE;
                            END;
                            IF EarningsSetup.Taxable = TRUE THEN BEGIN
                                Taxable := TRUE;
                            END ELSE BEGIN
                                Taxable := FALSE;
                            END;
                        END;
                        "Account Type" := EarningsSetup."Account Type";
                        "Account No." := EarningsSetup."Account No.";
                    END;
                Type::Deduction:
                    BEGIN
                        DeductionsSetup.RESET;
                        IF DeductionsSetup.GET(Code) THEN BEGIN
                            IF DeductionsSetup.Block = TRUE THEN BEGIN
                                ERROR('Deduction Blocked');
                            END;
                            Description := DeductionsSetup.Description;
                            "G/L Account" := DeductionsSetup."Account No.";
                            "Tax Deductible" := DeductionsSetup."Tax deductible";
                            Retirement := DeductionsSetup."Pension Scheme";
                            Shares := DeductionsSetup.Shares;
                            Paye := DeductionsSetup."PAYE Code";
                            "Insurance Code" := DeductionsSetup."Insurance Code";
                            "Main Deduction Code" := DeductionsSetup."Main Deduction Code";
                        END;
                        "Account Type" := DeductionsSetup."Account Type";
                        "Account No." := DeductionsSetup."Account No.";
                        IF "Account Type" = "Account Type"::Customer THEN BEGIN
                            ImprestMgnt.RESET;
                            ImprestMgnt.SETRANGE("Paying Document", "Reference No");
                            ImprestMgnt.SETRANGE("Employee No", "Employee No");
                            IF ImprestMgnt.FINDFIRST THEN BEGIN
                                IF ImprestMgnt."Transaction Type" = ImprestMgnt."Transaction Type"::"Salary Advance" THEN BEGIN
                                    "Account No." := ImprestMgnt."Staff A/C";
                                END;
                            END;
                        END;
                    END;
            END;
            MODIFY;
        END;
    end;

    procedure CreatingPayrollPeriod(NoOfPeriods: Integer; PeriodLength: DateFormula; PayStartDate: Date; PeriodType: Option " ",Daily,Weekly,"Bi-Weekly",Monthly);
    var
        FiscalYearStartDate: Date;
        FirstPeriodStartDate: Date;
        LastPeriodStartDate: Date;
        FirstPeriodLocked: Boolean;
        i: Integer;
        CreateStatus: Boolean;
    begin
        FiscalYearStartDate := PayStartDate;
        CreateStatus := FALSE;
        FOR i := 1 TO NoOfPeriods + 1 DO BEGIN
            IF PayrollPeriods.GET(FiscalYearStartDate) THEN BEGIN
                MESSAGE('Pay Period already Exists!');
                EXIT;
            END;
            PayrollPeriods.INIT;
            PayrollPeriods."Starting Date" := FiscalYearStartDate;
            PayrollPeriods.Type := PeriodType;
            PayrollPeriods.VALIDATE("Starting Date");
            IF (i = 1) OR (i = NoOfPeriods + 1) THEN BEGIN
                PayrollPeriods."New Fiscal Year" := TRUE;
            END;
            IF (FirstPeriodStartDate = 0D) AND (i = 1) THEN BEGIN
                PayrollPeriods."Date Locked" := TRUE;
            END;
            IF (PayrollPeriods."Starting Date" < FirstPeriodStartDate) AND FirstPeriodLocked THEN BEGIN
                PayrollPeriods.Closed := TRUE;
                PayrollPeriods."Date Locked" := TRUE;
            END;
            PayrollPeriods.INSERT;
            FiscalYearStartDate := CALCDATE(PeriodLength, FiscalYearStartDate);
            CreateStatus := TRUE;
        END;
        IF CreateStatus = TRUE THEN BEGIN
            MESSAGE('Pay Period Successfully Created');
        END;
    end;

    procedure ClosingPayrollPeriod();
    var
        CloseStatus: Boolean;
        PayrollEntryCopy: Record "Payroll Entries";
        NextPeriod: Date;
    begin
        CloseStatus := FALSE;
        PayrollPeriods.RESET;
        PayrollPeriods.SETRANGE(Closed, FALSE);
        IF PayrollPeriods.FINDFIRST THEN BEGIN
            CurrentPeriod := PayrollPeriods."Starting Date";
            IF NOT CONFIRM('Are you Sure You Want To Close this Pay Period:  ' + FORMAT(CurrentPeriod) + '?' + //
            '  Make sure all Earnings and Dedcutions are correct before closing the current pay period! ', FALSE) THEN BEGIN
                EXIT;
            END;
            NextPeriod := CALCDATE('1M', CurrentPeriod);
            PayrollPeriods."Closed on Date" := CURRENTDATETIME;
            PayrollPeriods."Close Pay" := TRUE;
            PayrollPeriods.Closed := TRUE;
            PayrollPeriods."Closed By" := USERID;
            PayrollPeriods.MODIFY;
            CloseStatus := TRUE;
        END;
        Window.OPEN('Processing Payroll For: #1### Progress @2@@@@');
        IF CloseStatus = TRUE THEN BEGIN
            Window.OPEN('Closing Pay Period For the Month Of: #1### Progress @2@@@@');
            Records := 0;
            CurrentRec := 0;
            NextPeriod := CALCDATE('1M', CurrentPeriod);
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Payroll Period", CurrentPeriod);
            Records := PayrollEntry.COUNT;
            IF PayrollEntry.FINDFIRST THEN BEGIN
                REPEAT
                    Window.UPDATE(1, CurrentPeriod);
                    CurrentRec += 1;
                    IF PayrollEntry.Type = PayrollEntry.Type::Payment THEN BEGIN
                        EarningsSetup.RESET;
                        EarningsSetup.GET(PayrollEntry.Code);
                        IF EarningsSetup."Pay Type" = EarningsSetup."Pay Type"::Recurring THEN BEGIN
                            PayrollEntryCopy := PayrollEntry;
                            PayrollEntryCopy."Payroll Period" := NextPeriod;
                            PayrollEntryCopy.INSERT;
                        END;
                    END;
                    IF PayrollEntry.Type = PayrollEntry.Type::Deduction THEN BEGIN
                        DeductionsSetup.RESET;
                        DeductionsSetup.GET(PayrollEntry.Code);
                        IF DeductionsSetup.Type = DeductionsSetup.Type::Recurring THEN BEGIN
                            PayrollEntryCopy := PayrollEntry;
                            PayrollEntryCopy."Payroll Period" := NextPeriod;
                            PayrollEntryCopy.INSERT;
                        END;
                    END;
                    PayrollEntry.Closed := TRUE;
                    PayrollEntry.MODIFY;
                    Window.UPDATE(2, ((CurrentRec / Records) * 10000) DIV 1);
                UNTIL PayrollEntry.NEXT = 0;
            END;
            COMMIT;
            Window.CLOSE;
            MESSAGE('Payroll Period %1 Successfully Closed!', CurrentPeriod);
        END;
    end;

    procedure GetOpenPeriod() CurrentOpenPeriod: Date;
    begin
        PayrollPeriods.SETRANGE(Closed, FALSE);
        IF PayrollPeriods.FINDFIRST THEN BEGIN
            CurrentOpenPeriod := PayrollPeriods."Starting Date";
        END;
    end;

    procedure MakePayrollEntry(Employee: Record Employee; PayCode: Code[20]; PayPeriod: Date; Amount: Decimal; TaxableAmount: Decimal; Type: Option Payment,Deduction,"Saving Scheme",Loan,Informational; Principal: Decimal; Interest: Decimal; Insurance: Decimal; ReferenceCode: Code[30]);
    begin
        WITH Employee DO BEGIN
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Employee No", Employee."No.");
            PayrollEntry.SETRANGE(Type, Type);
            PayrollEntry.SETRANGE(Code, PayCode);
            PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
            IF PayrollEntry.FINDFIRST THEN BEGIN
                PayrollEntry.Amount := Amount;
                PayrollEntry."Taxable amount" := TaxableAmount;
                PayrollEntry."Loan Principal" := Principal;
                PayrollEntry."Loan Interest" := Interest;
                PayrollEntry."Loan Insurance" := Insurance;
                PayrollEntry."Reference No" := ReferenceCode;
                PayrollEntry.MODIFY;
                UpdatingPayrollEntry(PayrollEntry);
            END ELSE BEGIN
                PayrollEntry.INIT;
                PayrollEntry."Employee No" := Employee."No.";
                PayrollEntry.Type := Type;
                PayrollEntry.Code := PayCode;
                PayrollEntry."Payroll Period" := PayPeriod;
                PayrollEntry.Amount := Amount;
                PayrollEntry."Taxable amount" := TaxableAmount;
                PayrollEntry."Loan Principal" := Principal;
                PayrollEntry."Loan Interest" := Interest;
                PayrollEntry."Loan Insurance" := Insurance;
                PayrollEntry."Reference No" := ReferenceCode;
                IF PayrollEntry.Amount <> 0 THEN BEGIN
                    PayrollEntry.INSERT;
                    UpdatingPayrollEntry(PayrollEntry);
                END;
            END;
        END;
    end;

    procedure GetEarningsAmount(Empl: Record Employee; Earnings: Record "Earnings Setup"; ControlAmount: Decimal; PayPeriod: Date; NewHREntry: Boolean) EarningsAmount: Decimal;
    begin
        EarningsAmount := 0;
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH Earnings DO BEGIN
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"Flat amount" THEN BEGIN
                Earnings.TESTFIELD("Flat Amount");
                EarningsAmount := Earnings."Flat Amount";
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Basic pay" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND(ControlAmount * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Gross pay" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND((GetGrossPay(Empl, PayPeriod)) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Calculation Method" = Earnings."Calculation Method"::"% of Taxable income" THEN BEGIN
                Earnings.TESTFIELD(Percentage);
                EarningsAmount := ROUND((GetTaxableAmount(Empl, PayPeriod)) * (Earnings.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Earnings."Applies to All" = TRUE THEN BEGIN
                EarningsAmount := EarningsAmount;
            END ELSE BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
                PayrollEntry.SETRANGE(Code, Earnings.Code);
                PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    EarningsAmount := EarningsAmount;
                END ELSE BEGIN
                    IF NewHREntry = FALSE THEN BEGIN
                        EarningsAmount := 0;
                    END;
                END;
            END;
        END;
    end;

    procedure GetTaxableAmount(Employee: Record Employee; PayrollPeriod: Date) TaxableAmount: Decimal;
    var
        Earnings: Record "Earnings Setup";
        AllowableDeductions: Decimal;
        Deductions: Record "Deductions Setup";
    begin
        TaxableAmount := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Employee No", Employee."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF Earnings.GET(PayrollEntry.Code) THEN BEGIN
                    IF Earnings.Taxable = TRUE THEN BEGIN
                        TaxableAmount := TaxableAmount + ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
        AllowableDeductions := 0;
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Pension Cap");
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
        PayrollEntry.SETRANGE("Employee No", Employee."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                Deductions.RESET;
                Deductions.GET(PayrollEntry.Code);
                IF Deductions."Tax deductible" = TRUE THEN BEGIN
                    IF Deductions."Pension Scheme" = TRUE THEN BEGIN
                        AllowableDeductions := AllowableDeductions + ABS(PayrollEntry.Amount);
                    END ELSE BEGIN
                        TaxableAmount := TaxableAmount - ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
            IF AllowableDeductions > PayrollSetup."Pension Cap" THEN BEGIN
                AllowableDeductions := PayrollSetup."Pension Cap";
            END;
            TaxableAmount := TaxableAmount - AllowableDeductions;
        END;
    end;

    procedure GetTaxCharged(BracketTable: Record "Bracket Table"; Amount: Decimal; PayrollPeriod: Date) TaxCharged: Decimal;
    var
        EndTax: Boolean;
        AmountRemaining: Decimal;
        TaxedAmount: Decimal;
        Tax: Decimal;
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH BracketTable DO BEGIN
            IF BracketTable.Type = BracketTable.Type::Percentage THEN BEGIN
                EndTax := FALSE;

                BracketLines.RESET;
                BracketLines.SETCURRENTKEY("Lower Limit");
                BracketLines.SETRANGE("Table Code", BracketTable."Table Code");
                IF BracketLines.FINDFIRST THEN BEGIN
                    REPEAT
                        BracketLines.TESTFIELD(Percentage);
                        IF TaxableAmount <= 0 THEN BEGIN
                            EndTax := TRUE
                        END ELSE BEGIN
                            IF (BracketLines."Upper Limit" < Amount) AND (BracketLines."Upper Limit" <> 0) THEN BEGIN
                                TaxedAmount := TaxedAmount + BracketLines."Amount Charged";
                            END ELSE BEGIN
                                AmountRemaining := (TaxableAmount - (BracketLines."Lower Limit")) + 1;
                                Tax := ROUND(AmountRemaining * (BracketLines.Percentage / 100), PayrollSetup."Payroll Roundoff");
                                TaxedAmount := TaxedAmount + Tax;
                                EndTax := TRUE;
                            END;
                        END;
                    UNTIL (BracketLines.NEXT = 0) OR (EndTax = TRUE);
                    TaxCharged := TaxedAmount;
                END;
            END;
            IF BracketTable.Type = BracketTable.Type::Range THEN BEGIN
                TaxCharged := 0;
                BracketLines.RESET;
                BracketLines.SETRANGE("Table Code", BracketTable."Table Code");
                BracketLines.SETFILTER("Lower Limit", '<=%1', GrossAmount);
                BracketLines.SETFILTER("Upper Limit", '>=%1', GrossAmount);
                IF BracketLines.FINDFIRST THEN BEGIN
                    TaxCharged := BracketLines."Amount Charged";
                END;
            END;
        END;
    end;

    procedure GetTaxRelief(Empl: Record Employee; PayrollPeriod: Date) TaxRelief: Decimal;
    begin
        TaxRelief := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", PayrollPeriod);
        PayrollEntry.SETRANGE(Taxable, FALSE);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    IF (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Tax Relief") OR (EarningsSetup."Earning Type" = EarningsSetup."Earning Type"::"Insurance Relief") THEN BEGIN
                        TaxRelief := TaxRelief + ABS(PayrollEntry.Amount);
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetDeductionsAmount(Empl: Record Employee; Deductions: Record "Deductions Setup"; ControlAmount: Decimal; PayPeriod: Date; NewHREntry: Boolean) DeductionsAmount: Decimal;
    var
        Insurancerelief: Decimal;
    begin
        DeductionsAmount := 0;
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("Payroll Roundoff");
        WITH Deductions DO BEGIN
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"Flat Amount" THEN BEGIN
                Deductions.TESTFIELD("Flat Amount");
                DeductionsAmount := Deductions."Flat Amount";
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Basic Pay" THEN BEGIN
                Deductions.TESTFIELD(Percentage);
                DeductionsAmount := ROUND(ControlAmount * (Deductions.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"% of Gross Pay" THEN BEGIN
                Deductions.TESTFIELD(Percentage);
                DeductionsAmount := ROUND((GetGrossPay(Empl, PayPeriod)) * (Deductions.Percentage / 100), PayrollSetup."Payroll Roundoff");
            END;
            IF Deductions."Calculation Method" = Deductions."Calculation Method"::"Based on Table" THEN BEGIN
                Deductions.TESTFIELD("Deduction Table");
                BracketTable.GET(Deductions."Deduction Table");
                GrossAmount := 0;
                GrossAmount := GetGrossPay(Empl, PayPeriod);
                IF GrossAmount <> 0 THEN BEGIN
                    DeductionsAmount := GetTaxCharged(BracketTable, GrossAmount, PayPeriod);
                END;
            END;

            IF Deductions."Applies to All" = TRUE THEN BEGIN
                DeductionsAmount := DeductionsAmount;
            END ELSE BEGIN
                PayrollEntry.RESET;
                PayrollEntry.SETRANGE("Employee No", Empl."No.");
                PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
                PayrollEntry.SETRANGE(Code, Deductions.Code);
                PayrollEntry.SETRANGE("Payroll Period", PayPeriod);
                IF PayrollEntry.FINDFIRST THEN BEGIN
                    IF PayrollEntry.Amount <> 0 THEN BEGIN
                        IF DeductionsAmount <> ABS(PayrollEntry.Amount) THEN BEGIN
                            DeductionsAmount := ABS(DeductionsAmount);
                        END;
                        IF Deductions."Insurance Code" = TRUE THEN BEGIN
                            Insurancerelief := 0;
                            EarningsSetup.RESET;
                            EarningsSetup.SETRANGE("Basic Salary Code", FALSE);
                            EarningsSetup.SETRANGE("Earning Type", EarningsSetup."Earning Type"::"Insurance Relief");
                            IF EarningsSetup.FINDFIRST THEN BEGIN
                                EarningsSetup.TESTFIELD(Percentage);
                                PayrollSetup.TESTFIELD("Insurance Relief Cap");
                                IF ABS(PayrollEntry.Amount) <= PayrollSetup."Insurance Relief Cap" THEN BEGIN
                                    Insurancerelief := (ABS(PayrollEntry.Amount) * EarningsSetup.Percentage / 100);
                                END ELSE BEGIN
                                    Insurancerelief := (PayrollSetup."Insurance Relief Cap" * EarningsSetup.Percentage / 100);
                                END;
                                Insurancerelief := ROUND(Insurancerelief, PayrollSetup."Payroll Roundoff");
                                IF Insurancerelief <> 0 THEN BEGIN
                                    MakePayrollEntry(Empl, EarningsSetup.Code, PayPeriodDate, Insurancerelief, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                                END;
                            END ELSE BEGIN
                                ERROR('Kindly Add Insurance Relief on Earnings Setup!');
                            END;
                        END;
                    END;
                END ELSE BEGIN
                    IF NewHREntry = FALSE THEN BEGIN
                        DeductionsAmount := 0;
                    END;
                END;
            END;
        END;
    end;

    procedure GetGrossPay(Empl: Record Employee; Payrollperiod: Date) GrossPay: Decimal;
    begin
        GrossPay := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Payment);
        PayrollEntry.SETRANGE("Non-Cash Benefit", FALSE);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                    IF EarningsSetup."Non-Cash Benefit" = FALSE THEN BEGIN
                        GrossPay := GrossPay + PayrollEntry.Amount;
                    END;
                END;
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetTotalDeductions(Empl: Record Employee; Payrollperiod: Date) TotalDeductions: Decimal;
    begin
        TotalDeductions := 0;
        PayrollEntry.RESET;
        PayrollEntry.SETRANGE(Type, PayrollEntry.Type::Deduction);
        PayrollEntry.SETRANGE("Employee No", Empl."No.");
        PayrollEntry.SETRANGE("Payroll Period", Payrollperiod);
        IF PayrollEntry.FINDFIRST THEN BEGIN
            REPEAT
                TotalDeductions := TotalDeductions + ABS(PayrollEntry.Amount);
            UNTIL PayrollEntry.NEXT = 0;
        END;
    end;

    procedure GetEDDescription(PayrollEntries: Record "Payroll Entries") EDDescription: Text;
    begin
        WITH PayrollEntries DO BEGIN
            CASE Type OF
                Type::Payment:
                    BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(Code) THEN BEGIN
                            IF EarningsSetup.Block = TRUE THEN BEGIN
                                ERROR('Earning Blocked');
                            END;
                            EDDescription := EarningsSetup.Description;
                        END;
                    END;
                Type::Deduction:
                    BEGIN
                        DeductionsSetup.RESET;
                        IF DeductionsSetup.GET(Code) THEN BEGIN
                            IF DeductionsSetup.Block = TRUE THEN BEGIN
                                ERROR('Deduction Blocked');
                            END;
                            EDDescription := DeductionsSetup.Description;
                        END;
                    END;
            END;
        END;
    end;

    procedure ComputeBasicSalary(Employee: Record Employee);
    begin
        Employee.TESTFIELD("Basic Pay");
        Employee.TESTFIELD("Member No.");
        BasicPay := GetBasicPay(Employee);
        BasicPayCode := '';
        EarningsSetup.RESET;
        EarningsSetup.SETRANGE("Basic Salary Code", TRUE);
        IF EarningsSetup.FINDFIRST THEN BEGIN
            BasicPayCode := EarningsSetup.Code;
            MakePayrollEntry(Employee, BasicPayCode, PayPeriodDate, BasicPay, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
        END;
    end;

    procedure ComputeOtherEarings(Employee: Record Employee);
    begin
        EarningsSetup.RESET;
        EarningsSetup.SETRANGE("Basic Salary Code", FALSE);
        IF EarningsSetup.FINDFIRST THEN BEGIN
            REPEAT
                Allowance := GetEarningsAmount(Employee, EarningsSetup, BasicPay, PayPeriodDate, FALSE);
                IF Allowance <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, EarningsSetup.Code, PayPeriodDate, Allowance, TaxableAmount, PayrollEntry.Type::Payment, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            UNTIL EarningsSetup.NEXT = 0;
        END;
    end;

    procedure ComputePAYE(Employee: Record Employee);
    begin
        DeductionsSetup.RESET;
        DeductionsSetup.SETRANGE("PAYE Code", TRUE);
        IF DeductionsSetup.FINDFIRST THEN BEGIN
            DeductionsSetup.TESTFIELD("Deduction Table");
            BracketTable.GET(DeductionsSetup."Deduction Table");
            TaxableAmount := 0;
            TaxableAmount := GetTaxableAmount(Employee, PayPeriodDate);
            IF TaxableAmount <> 0 THEN BEGIN
                DeductionAmount := 0;
                DeductionAmount := GetTaxCharged(BracketTable, TaxableAmount, PayPeriodDate);
                IF DeductionAmount <> 0 THEN BEGIN
                    DeductionAmount := DeductionAmount - GetTaxRelief(Employee, PayPeriodDate);
                    IF DeductionAmount > 0 THEN BEGIN
                        DeductionAmount := -DeductionAmount;
                    END;
                    MakePayrollEntry(Employee, DeductionsSetup.Code, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            END;
        END;
    end;

    procedure ComputeOtherDeductions(Employee: Record Employee);
    begin
        DeductionsSetup.RESET;
        DeductionsSetup.SETRANGE("PAYE Code", FALSE);
        DeductionsSetup.SETRANGE(Loan, FALSE);
        IF DeductionsSetup.FINDFIRST THEN BEGIN
            REPEAT
                DeductionAmount := 0;
                DeductionAmount := GetDeductionsAmount(Employee, DeductionsSetup, BasicPay, PayPeriodDate, FALSE);
                DeductionAmount := -DeductionAmount;
                IF DeductionAmount <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, DeductionsSetup.Code, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            UNTIL DeductionsSetup.NEXT = 0;
        END;
    end;

    procedure ComputeLoans(Employee: Record Employee);
    begin
        DeductionsSetup.RESET;
        DeductionsSetup.SETRANGE("PAYE Code", FALSE);
        DeductionsSetup.SETRANGE(Loan, TRUE);
        IF DeductionsSetup.FINDFIRST THEN BEGIN
            REPEAT
                DeductionAmount := 0;
                DeductionAmount := GetDeductionsAmount(Employee, DeductionsSetup, BasicPay, PayPeriodDate, FALSE);
                DeductionAmount := -DeductionAmount;
                IF DeductionAmount <> 0 THEN BEGIN
                    MakePayrollEntry(Employee, DeductionsSetup.Code, PayPeriodDate, DeductionAmount, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, LoanCode);
                END;
            UNTIL DeductionsSetup.NEXT = 0;
        END;
    end;

    procedure GetAmount(PayrollEntries: Record "Payroll Entries") GetControlAmount: Decimal;
    var
        Amount: Decimal;
    begin
        WITH PayrollEntries DO BEGIN
            Employee.GET(PayrollEntries."Employee No");
            IF Type = Type::Payment THEN BEGIN
                EarningsSetup.GET(PayrollEntries.Code);
                GetControlAmount := GetEarningsAmount(Employee, EarningsSetup, GetBasicPay(Employee), GetOpenPeriod, TRUE);
            END;
            IF Type = Type::Deduction THEN BEGIN
                DeductionsSetup.GET(PayrollEntries.Code);
                GetControlAmount := -GetDeductionsAmount(Employee, DeductionsSetup, GetBasicPay(Employee), GetOpenPeriod, TRUE);
            END;
        END;
    end;

    procedure GetBasicPay(Employee: Record Employee) BasicPaid: Decimal;
    begin
        WITH Employee DO BEGIN
            BasicPaid := Employee."Basic Pay";
        END;
    end;

    procedure GetStaffLoans(Employee: Record Employee; PayrollDate: Date; LoanCode: Code[20]) LoanAmount: Decimal;
    var
    // LoanRepaymentSchedule : Record "50110";
    begin
    end;

    procedure CreateMorestatus();
    var
        Employ: Record Employee;
        HumanResSetup: Record "Human Resources Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Counts: Integer;
    begin
        HumanResSetup.GET;
        HumanResSetup.TESTFIELD("Employee Nos.");
        Employee.RESET;
        Counts := 500;
        IF Employee.FINDFIRST THEN BEGIN
            REPEAT
                Employ.COPY(Employee);
                Employ."No." := NoSeriesMgt.GetNextNo(HumanResSetup."Employee Nos.", TODAY, TRUE);
                Employ."First Name" := Employ."No." + '' + 'F';
                Employ."Middle Name" := Employ."No." + '' + 'M';
                Employ."Last Name" := Employ."No." + '' + 'L';
                Employ."Basic Pay" := Employ."Basic Pay" + 1000;
                Employ.INSERT;
                Counts := Counts - 1;
            UNTIL (Employee.NEXT = 0) OR (Counts = 0);
        END;
    end;

    procedure TransferingPayrollToJournal(Employee: Record Employee; GnLLineNumber: Integer) LastLineNumber: Integer;
    var
        EDDescription: Text;
        NetPay: Decimal;
    begin
        WITH Employee DO BEGIN
            NetPay := 0;
            PayrollEntry.RESET;
            PayrollEntry.SETRANGE("Employee No", Employee."No.");
            PayrollEntry.SETRANGE("Payroll Period", GetOpenPeriod());
            IF PayrollEntry.FINDFIRST THEN BEGIN
                REPEAT
                    EDDescription := PayrollEntry.Description + ': ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                    IF PayrollEntry.Type = PayrollEntry.Type::Payment THEN BEGIN
                        EarningsSetup.RESET;
                        IF EarningsSetup.GET(PayrollEntry.Code) THEN BEGIN
                            IF EarningsSetup."Non-Cash Benefit" = FALSE THEN BEGIN
                                CreatingJurnalLines(EDDescription, PayrollEntry, Employee, PayrollEntry.Amount, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber);
                            END;
                        END;
                    END;
                    IF PayrollEntry.Type = PayrollEntry.Type::Deduction THEN BEGIN
                        CreatingJurnalLines(EDDescription, PayrollEntry, Employee, PayrollEntry.Amount, PayrollEntry."Account Type", PayrollEntry."Account No.", GnLLineNumber);
                    END;
                    IF PayrollEntry.Type = PayrollEntry.Type::Loan THEN BEGIN
                    END;
                    GnLLineNumber := GnLLineNumber + 1;
                UNTIL PayrollEntry.NEXT = 0;
                NetPay := -(GetGrossPay(Employee, PayrollEntry."Payroll Period") - GetTotalDeductions(Employee, PayrollEntry."Payroll Period"));
                EDDescription := 'Net Pay' + ': ' + FORMAT(PayrollEntry."Payroll Period", 0, '<month text> <year4>');
                CreatingJurnalLines(EDDescription, PayrollEntry, Employee, NetPay, PayrollEntry."Account Type"::Vendor, '', GnLLineNumber);
                LastLineNumber := GnLLineNumber + 1;
            END ELSE BEGIN
                EXIT;
            END;
        END;
    end;

    procedure CreatingJurnalLines(Description: Text; PayrollEntries: Record "Payroll Entries"; Employee: Record Employee; Amount: Decimal; "Account Type": Option "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner"; "Account No.": Code[20]; GnLLineNumber: Integer);
    var
        GenJournalLine: Record "Gen. Journal Line";
        LineNumber: Integer;
        Noseries: Code[20];
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        Noseries := FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 2)) + '-' + FORMAT(DATE2DMY(PayrollEntries."Payroll Period", 3));
        GenJournalLine.INIT;
        GenJournalLine."Journal Template Name" := PayrollSetup."General Journal Template Name";
        GenJournalLine."Journal Batch Name" := PayrollSetup."General Journal Batch Name";
        GenJournalLine."Line No." := GnLLineNumber;
        GenJournalLine."Account Type" := "Account Type";
        GenJournalLine."Account No." := "Account No.";
        GenJournalLine.VALIDATE("Account No.");
        GenJournalLine."Posting Date" := TODAY;
        GenJournalLine.Description := Description;
        GenJournalLine."Document No." := Noseries;
        GenJournalLine.Amount := Amount;
        GenJournalLine."Gen. Posting Type" := GenJournalLine."Gen. Posting Type"::" ";
        GenJournalLine."Gen. Bus. Posting Group" := '';
        GenJournalLine."Gen. Prod. Posting Group" := '';
        // GenJournalLine."Transaction Type":=GenJournalLine."Transaction Type";
        GenJournalLine.VALIDATE(Amount);
        GenJournalLine."Shortcut Dimension 1 Code" := Employee."Global Dimension 1 Code";
        // GenJournalLine."Employee ID":=PayrollEntries."Employee No";
        // GenJournalLine."Employee Name":=Employee.FullName;
        IF GenJournalLine."Account Type" = GenJournalLine."Account Type"::Customer THEN BEGIN
            IF PayrollEntries."Reference No" <> '' THEN BEGIN
                GenJournalLine."Applies-to Doc. No." := PayrollEntries."Reference No";
                GenJournalLine."Applies-to Doc. Type" := GenJournalLine."Applies-to Doc. Type"::Invoice;
            END;
        END;
        IF GenJournalLine.Amount <> 0 THEN BEGIN
            GenJournalLine.INSERT;
        END;
    end;

    procedure ClearJournalLines();
    var
        GenJnline: Record "Gen. Journal Line";
    begin
        PayrollSetup.GET(1);
        PayrollSetup.TESTFIELD("General Journal Template Name");
        PayrollSetup.TESTFIELD("General Journal Batch Name");
        GenJnline.RESET;
        GenJnline.SETRANGE("Journal Template Name", PayrollSetup."General Journal Template Name");
        GenJnline.SETRANGE("Journal Batch Name", PayrollSetup."General Journal Batch Name");
        IF GenJnline.FINDSET THEN BEGIN
            GenJnline.DELETEALL;
        END;
    end;

    procedure CheckJournal(BatchName: Code[100]) Status: Boolean;
    begin
        Status := FALSE;
        PayrollSetup.RESET;
        IF PayrollSetup."General Journal Batch Name" = BatchName THEN BEGIN
            MESSAGE(PayrollSetup."General Journal Batch Name" + 'ttt' + BatchName);
            Status := TRUE;
        END;
    end;

    procedure CalculateOneThirdOfBasic(Employee: Record Employee): Decimal;
    begin
        WITH Employee DO BEGIN
            PayrollSetup.GET(1);
            IF PayrollSetup."Apply 1/3 Rule?" = TRUE THEN BEGIN
                EXIT(ROUND(GetBasicPay(Employee) * (1 / 3), PayrollSetup."Payroll Roundoff"));
                ;
            END;
        END;
    end;

    procedure CalculateAdvanceSalary(Empl4sa: Record Employee);
    var
        SalAdvanceAmt: Decimal;
        Vendor: Record Vendor;
    begin
        WITH Empl4sa DO BEGIN
            ImprestMgnt.RESET;
            ImprestMgnt.SETRANGE("Transaction Type", ImprestMgnt."Transaction Type"::"Salary Advance");
            ImprestMgnt.SETRANGE("Employee No", "No.");
            ImprestMgnt.SETRANGE(Posted, TRUE);
            ImprestMgnt.SETRANGE(Cleared, FALSE);
            IF ImprestMgnt.FINDFIRST THEN BEGIN
                SalAdvanceAmt := ImprestMgnt."Monthly Repayment";
                Vendor.reset;
                IF Vendor.GET(ImprestMgnt."Staff A/C") THEN BEGIN
                    PayrollSetup.GET(1);
                    PayrollSetup.TESTFIELD("Salary Advance Code");
                    IF (SalAdvanceAmt > CashManagement.GetVendDocumentBalance(ImprestMgnt."Paying Document", ImprestMgnt."Staff A/C")) THEN BEGIN
                        SalAdvanceAmt := CashManagement.GetVendDocumentBalance(ImprestMgnt."Paying Document", ImprestMgnt."Staff A/C");
                    END;
                    IF SalAdvanceAmt <> 0 THEN BEGIN
                        MakePayrollEntry(Empl4sa, PayrollSetup."Salary Advance Code", GetOpenPeriod, -SalAdvanceAmt, TaxableAmount, PayrollEntry.Type::Deduction, PrincipalAmount, InsuranceAmount, InsuranceAmount, ImprestMgnt."Paying Document");
                    END;
                END;
                IF SalAdvanceAmt = 0 THEN BEGIN
                    ImprestMgnt.Cleared := TRUE;
                    ImprestMgnt.MODIFY;
                END;
            END;
        END;
    end;
}

