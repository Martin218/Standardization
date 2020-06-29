table 50305 "Deductions Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[20])
        {
            NotBlank = true;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Type; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(6; "Tax deductible"; Boolean)
        {
        }
        field(7; Advance; Boolean)
        {
        }
        field(8; "Start date"; Date)
        {
        }
        field(9; "End Date"; Date)
        {
        }
        field(10; Percentage; Decimal)
        {
        }
        field(11; "Calculation Method"; Option)
        {
            OptionMembers = "Flat Amount","% of Basic Pay","Based on Table","Based on Hourly Rate","Based on Daily Rate ","% of Gross Pay","% of Basic Pay+Hse Allowance","% of Salary Recovery","User Defined";
        }
        field(12; "Account No."; Code[40])
        {
             TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account" WHERE ("Account Type"=CONST(Posting),
                                                                                    Blocked=CONST(false))
                                                                                    ELSE IF ("Account Type"=CONST(Customer)) Customer
                                                                                   ELSE IF ("Account Type"=CONST(Vendor)) Vendor WHERE (Blocked=CONST(" "))
                                                                                  ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"
                                                                                  ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"
                                                                                 ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner";
        }
        field(13; "Flat Amount"; Decimal)
        {
        }
        field(14; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(15; "Date Filter"; Date)
        {
        }
        field(16; "Posting Group Filter"; Code[10])
        {
        }
        field(17; Loan; Boolean)
        {
        }
        field(18; "Maximum Amount"; Decimal)
        {
        }
        field(19; "Grace period"; DateFormula)
        {
        }
        field(20; "Repayment Period"; DateFormula)
        {
        }
        field(21; "Pay Period Filter"; Date)
        {
        }
        field(26; "Pension Scheme"; Boolean)
        {
        }
        field(27; "Deduction Table"; Code[10])
        {
            TableRelation = "Bracket Table";
        }
        field(28; "G/L Account Employer"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(29; "Percentage Employer"; Decimal)
        {
        }
        field(30; "Minimum Amount"; Decimal)
        {
        }
        field(31; "Flat Amount Employer"; Decimal)
        {
        }
        field(32; "Total Amount Employer"; Decimal)
        {
        }
        field(33; "Loan Type"; Option)
        {
            OptionMembers = " ","Low Interest Benefit","Fringe Benefit";
        }
        field(34; "Show Balance"; Boolean)
        {
        }
        field(35; CoinageRounding; Boolean)
        {
        }
        field(36; "Employee Filter"; Code[10])
        {
            TableRelation = Employee;
        }
        field(37; "Opening Balance"; Decimal)
        {
        }
        field(38; "Global Dimension 2 Filter"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(39; "Balance Mode"; Option)
        {
            OptionMembers = Increasing," Decreasing";
            // TableRelation = Table0;
        }
        field(40; "Main Loan Code"; Code[20])
        {
            //TableRelation = "Loan Product Type";
        }
        field(41; Shares; Boolean)
        {
        }
        field(42; "Show on report"; Boolean)
        {
        }
        field(43; "Non-Interest Loan"; Boolean)
        {
        }
        field(44; "Exclude when on Leave"; Boolean)
        {
        }
        field(45; "Co-operative"; Boolean)
        {
        }
        field(46; "Total Shares"; Decimal)
        {
        }
        field(47; Rate; Decimal)
        {
        }
        field(48; "PAYE Code"; Boolean)
        {
        }
        field(49; "Total Days"; Decimal)
        {
        }
        field(50; PF; Boolean)
        {
        }
        field(51; "Pension Limit Percentage"; Decimal)
        {
        }
        field(52; "Pension Limit Amount"; Decimal)
        {
        }
        field(53; "Applies to All"; Boolean)
        {
        }
        field(54; "Show on Master Roll"; Boolean)
        {
        }
        field(55; "Pension Scheme Code"; Boolean)
        {
        }
        field(56; "Main Deduction Code"; Code[10])
        {
        }
        field(57; "Insurance Code"; Boolean)
        {
        }
        field(58; Block; Boolean)
        {
        }
        field(59; "Institution Code"; Code[20])
        {
        }
        field(60; "Reference Filter"; Code[20])
        {
        }
        field(61; "Show on Payslip Information"; Boolean)
        {
        }
        field(62; "Voluntary Percentage"; Decimal)
        {
        }
        field(63; "Salary Recovery"; Boolean)
        {
        }
        field(64; Gratuity; Boolean)
        {
        }
        field(65; "Gratuity Arrears"; Boolean)
        {
        }
        field(66; Informational; Boolean)
        {
        }
        field(67; Board; Boolean)
        {
        }
        field(68; "Pension Arrears"; Boolean)
        {
        }
        field(69; Voluntary; Boolean)
        {
        }
        field(70; "Voluntary Amount"; Decimal)
        {
        }
        field(71; "Voluntary Code"; Code[20])
        {
        }
        field(72; TickedCode; Boolean)
        {
        }
        field(73; "Expense G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(74; "Salary Advance"; Boolean)
        {
        }
        field(75; "Maximum Allowed"; Decimal)
        {
        }
        field(76; Defualter; Boolean)
        {
        }
        field(77; "Account Type"; Option)
        {
            Caption = 'Account Type';
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
        }
        field(78; "Account Types"; Code[30])
        {

            // TableRelation = "Account Type";
        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

