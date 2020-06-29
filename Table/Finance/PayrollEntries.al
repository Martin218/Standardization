table 50306 "Payroll Entries"
{
    // version TL2.0


    fields
    {
        field(1; "Employee No"; Code[30])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Empl.GET("Employee No") THEN BEGIN
                    "Global Dimension 1 code" := Empl."Global Dimension 1 Code";
                    "Global Dimension 2 Code" := Empl."Global Dimension 2 Code";
                    "Posting Group Filter" := Empl."Employee Posting Group";
                    IF Empl."Employee Posting Group" = '' THEN BEGIN
                        ERROR('Assign  %1  %2 a posting group before assigning any earning or deduction', Empl."First Name", Empl."Last Name");
                    END;
                END;

            end;
        }
        field(2; Type; Option)
        {
            NotBlank = false;
            OptionMembers = Payment,Deduction,"Saving Scheme",Loan,Informational;
        }
        field(3; "Code"; Code[20])
        {
            TableRelation = IF (Type = CONST(Payment)) "Earnings Setup"
            ELSE
            IF (Type = CONST(Deduction)) "Deductions Setup"
            ELSE
            IF (Type = CONST(Loan)) "Deductions Setup";

            trigger OnValidate();
            begin
                // "Payroll Period":=PayrollProcessing.GetOpenPeriod();
                // Description:=PayrollProcessing.GetEDDescription(Rec);
                // Amount:=PayrollProcessing.GetAmount(Rec);
            end;
        }
        field(5; "Effective Start Date"; Date)
        {
        }
        field(6; "Effective End Date"; Date)
        {
        }
        field(7; "Payroll Period"; Date)
        {

        }
        field(8; Amount; Decimal)
        {
            DecimalPlaces = 2 : 2;

            trigger OnValidate();
            begin
                IF Type = Type::Deduction THEN BEGIN
                    IF Amount > 0 THEN BEGIN
                        Amount := -Amount;
                    END;
                END;
            end;
        }
        field(9; Description; Text[80])
        {
        }
        field(10; Taxable; Boolean)
        {
        }
        field(11; "Tax Deductible"; Boolean)
        {
        }
        field(12; Frequency; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(13; "Pay Period"; Text[30])
        {
        }
        field(14; "G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(15; "Basic Pay"; Decimal)
        {
        }
        field(16; "Employer Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(17; "Global Dimension 1 code"; Code[20])
        {
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(18; "Next Period Entry"; Boolean)
        {
        }
        field(19; "Posting Group Filter"; Code[20])
        {
            TableRelation = "Dimension Value";
        }
        field(20; "Initial Amount"; Decimal)
        {
        }
        field(21; "Outstanding Amount"; Decimal)
        {
        }
        field(22; "Loan Repay"; Boolean)
        {
        }
        field(23; Closed; Boolean)
        {
            Editable = true;
        }
        field(24; "Salary Grade"; Code[20])
        {
        }
        field(25; "Tax Relief"; Boolean)
        {
        }
        field(26; "Interest Amount"; Decimal)
        {
        }
        field(27; "Period Repayment"; Decimal)
        {
        }
        field(28; "Non-Cash Benefit"; Boolean)
        {
        }
        field(29; Quarters; Boolean)
        {
        }
        field(30; "Salary Advance Account"; Code[20])
        {
        }
        field(31; Section; Code[20])
        {
        }
        field(33; Retirement; Boolean)
        {
        }
        field(34; CFPay; Boolean)
        {
        }
        field(35; BFPay; Boolean)
        {
        }
        field(36; "Opening Balance"; Decimal)
        {
        }
        field(37; DebitAcct; Code[20])
        {
        }
        field(38; CreditAcct; Code[20])
        {
        }
        field(39; Shares; Boolean)
        {
        }
        field(40; "Show on Report"; Boolean)
        {
        }
        field(41; "Earning/Deduction Type"; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(42; "Time Sheet"; Boolean)
        {
        }
        field(43; "Basic Salary Code"; Boolean)
        {
        }
        field(44; "Payroll Group"; Code[20])
        {
        }
        field(45; Paye; Boolean)
        {
        }
        field(46; "Taxable amount"; Decimal)
        {
        }
        field(47; "Less Pension Contribution"; Decimal)
        {
        }
        field(48; "Monthly Personal Relief"; Decimal)
        {
        }
        field(49; "Normal Earnings"; Boolean)
        {
            Editable = false;
        }
        field(50; "Monthly Self Contribution"; Decimal)
        {
        }
        field(51; "Monthly Self Cummulative"; Decimal)
        {
        }
        field(52; "Company Monthly Contribution"; Decimal)
        {
        }
        field(53; "Company Cummulative"; Decimal)
        {
        }
        field(54; "Main Deduction Code"; Code[20])
        {
        }
        field(55; "Opening Balance Company"; Decimal)
        {
        }
        field(56; "Insurance Code"; Boolean)
        {
        }
        field(57; "Reference No"; Code[50])
        {
        }
        field(58; "Manual Entry"; Boolean)
        {
        }
        field(59; "Salary Pointer"; Code[20])
        {
        }
        field(60; "Employee Voluntary"; Decimal)
        {
        }
        field(61; "Employer Voluntary"; Decimal)
        {
        }
        field(62; "Loan Product Type"; Code[20])
        {
        }
        field(63; "June Paye"; Decimal)
        {
        }
        field(64; "June Taxable Amount"; Decimal)
        {
        }
        field(65; "June Paye Diff"; Decimal)
        {
        }
        field(66; "Gratuity PAYE"; Decimal)
        {
        }
        field(67; "Basic Pay Arrears"; Boolean)
        {
        }
        field(68; "Policy No./Loan No."; Code[20])
        {
        }
        field(69; "Loan Balance"; Decimal)
        {
        }
        field(70; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(71; "Global Dimension 3 Code"; Code[20])
        {
        }
        field(72; Information; Boolean)
        {
        }
        field(73; Cost; Decimal)
        {
        }
        field(74; "Employee Tier I"; Decimal)
        {
        }
        field(75; "Employee Tier II"; Decimal)
        {
        }
        field(76; "Employer Tier I"; Decimal)
        {
        }
        field(77; "Employer Tier II"; Decimal)
        {
        }
        field(78; "Loan Interest"; Decimal)
        {
        }
        field(79; "Loan Principal"; Decimal)
        {
        }
        field(80; "Loan Insurance"; Decimal)
        {
        }
        field(81; DefaulterCode; Code[20])
        {
        }
        field(82; "Loan No"; Code[40])
        {
        }
        field(83; MemberNo; Code[30])
        {
        }
        field(84; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(85; "Account No."; Code[20])
        {
            //   TableRelation = IF (Account Type=CONST(G/L Account)) "G/L Account" WHERE (Account Type=CONST(Posting),
            //                                                                         Blocked=CONST(No))
            //                                                                        ELSE IF (Account Type=CONST(Customer)) Customer
            //                                                                        ELSE IF (Account Type=CONST(Vendor)) Vendor WHERE (Blocked=CONST(" "))
            //                                                                        ELSE IF (Account Type=CONST(Bank Account)) "Bank Account"
            //                                                                        ELSE IF (Account Type=CONST(Fixed Asset)) "Fixed Asset"
            //                                                                        ELSE IF (Account Type=CONST(IC Partner)) "IC Partner";
        }
    }

    keys
    {
        key(Key1; "Employee No", Type, "Code", "Payroll Period")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Empl: Record Employee;
        DeductionsSetup: Record "Deductions Setup";
        EarningsSetup: Record "Earnings Setup";
        //PayrollProcessing : Codeunit "50038";
        PayrollEntries: Record "Payroll Entries";
}

