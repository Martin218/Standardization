table 50304 "Earnings Setup"
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
        field(3; "Pay Type"; Option)
        {
            OptionMembers = Recurring,"Non-recurring";
        }
        field(4; "Start Date"; Date)
        {
        }
        field(5; "End Date"; Date)
        {
        }
        field(6; Taxable; Boolean)
        {
        }
        field(7; "Calculation Method"; Option)
        {
            OptionCaption = 'User Assigned,Flat amount,% of Basic pay,% of Gross pay,% of Insurance Amount,% of Taxable income,% of Basic after tax,Based on Hourly Rate,Based on Daily Rate,% of Salary Recovery,% of Loan Amount,% of Cost,Basic Pay';
            OptionMembers = "User Assigned","Flat amount","% of Basic pay","% of Gross pay","% of Insurance Amount","% of Taxable income","% of Basic after tax","Based on Hourly Rate","Based on Daily Rate","% of Salary Recovery","% of Loan Amount","% of Cost","Basic Pay";
        }
        field(8; "Flat Amount"; Decimal)
        {
        }
        field(9; Percentage; Decimal)
        {
            DecimalPlaces = 2 : 4;
        }
        field(10; "Account No."; Code[20])
        {
            TableRelation = IF ("Account Type"=CONST("G/L Account")) "G/L Account" WHERE ("Account Type"=CONST(Posting),
                                                                                    Blocked=CONST(false))
                                                                                   ELSE IF ("Account Type"=CONST(Customer)) Customer
                                                                                   ELSE IF ("Account Type"=CONST(Vendor)) Vendor WHERE (Blocked=CONST(" "))
                                                                                   ELSE IF ("Account Type"=CONST("Bank Account")) "Bank Account"
                                                                                   ELSE IF ("Account Type"=CONST("Fixed Asset")) "Fixed Asset"
                                                                                 ELSE IF ("Account Type"=CONST("IC Partner")) "IC Partner";
        }
        field(11; "Total Amount"; Decimal)
        {
            Editable = false;
        }
        field(12; "Date Filter"; Date)
        {
        }
        field(13; "Posting Group Filter"; Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(14; "Pay Period Filter"; Date)
        {
            ClosingDates = false;
            FieldClass = FlowFilter;
        }
        field(15; Quarters; Boolean)
        {
        }
        field(16; "Non-Cash Benefit"; Boolean)
        {
        }
        field(17; "Minimum Limit"; Decimal)
        {
        }
        field(18; "Maximum Limit"; Decimal)
        {
        }
        field(19; "Reduces Tax"; Boolean)
        {
        }
        field(20; "Overtime Factor"; Decimal)
        {
        }
        field(21; "Employee Filter"; Code[10])
        {
            FieldClass = FlowFilter;
        }
        field(22; Counter; Integer)
        {
        }
        field(23; NoOfUnits; Decimal)
        {
        }
        field(24; "Low Interest Benefit"; Boolean)
        {
        }
        field(25; "Show Balance"; Boolean)
        {
        }
        field(26; CoinageRounding; Boolean)
        {
        }
        field(27; OverDrawn; Boolean)
        {
        }
        field(28; "Opening Balance"; Decimal)
        {
        }
        field(29; OverTime; Boolean)
        {
        }
        field(30; "Global Dimension 1 Filter"; Code[10])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(31; Months; Decimal)
        {
        }
        field(32; "Show on Report"; Boolean)
        {
        }
        field(33; "Time Sheet"; Boolean)
        {
        }
        field(34; "Total Days"; Decimal)
        {
        }
        field(35; "Total Hrs"; Decimal)
        {
        }
        field(36; Weekend; Boolean)
        {
        }
        field(37; Weekday; Boolean)
        {
        }
        field(38; "Basic Salary Code"; Boolean)
        {
        }
        field(39; "Default Enterprise"; Code[10])
        {
        }
        field(40; "Default Activity"; Code[10])
        {
        }
        field(41; "ProRata Leave"; Boolean)
        {
        }
        field(42; "Earning Type"; Option)
        {
            OptionMembers = "Normal Earning","Owner Occupier","Home Savings","Low Interest","Tax Relief","Insurance Relief","Disability Relief";
        }
        field(43; "Applies to All"; Boolean)
        {
        }
        field(44; "Show on Master Roll"; Boolean)
        {
        }
        field(45; "Transfer Allowance Code"; Boolean)
        {
        }
        field(46; "Responsibility Allowance Code"; Boolean)
        {
        }
        field(47; "Commuter Allowance Code"; Boolean)
        {
        }
        field(48; Block; Boolean)
        {
        }
        field(49; "Basic Pay Arrears"; Boolean)
        {
        }
        field(50; "Market Rate"; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(51; "Company Rate"; Decimal)
        {
            DecimalPlaces = 2 : 5;
        }
        field(52; "Acting Allowance Code"; Boolean)
        {
        }
        field(53; "Salary Recovery"; Boolean)
        {
        }
        field(54; "Loan Code"; Code[20])
        {
        }
        field(55; "Global Dimension 2 Filter"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(56; Board; Boolean)
        {
        }
        field(57; TickedCode; Boolean)
        {
        }
        field(58; "Expense G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(59; "Leave Code"; Boolean)
        {
        }
        field(60; "Account Type"; Option)
        {
            OptionCaption = 'G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
            OptionMembers = "G/L Account",Customer,Vendor,"Bank Account","Fixed Asset","IC Partner";
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

