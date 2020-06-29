table 50010 "Account Type"
{
    // version TL2.0

    LookupPageId = "Account Type List";
    DrillDownPageId = "Account Type List";
    fields
    {
        field(1; "Code"; Code[30])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Minimum Balance"; Decimal)
        {
        }
        field(4; "Dormancy Period"; Code[10])
        {
        }
        field(5; "Maintenance Fee"; Decimal)
        {
        }
        field(6; Type; Option)
        {
            OptionCaption = ',Savings,Share Capital,Loan,Fixed Deposit,Deposit';
            OptionMembers = ,Savings,"Share Capital",Loan,"Fixed Deposit",Deposit;
        }
        field(8; "Allow Withdrawal"; Boolean)
        {
        }
        field(9; "Allow Deposit"; Boolean)
        {
        }
        field(10; "Allow Payout"; Boolean)
        {
        }
        field(11; "Allow ATM"; Boolean)
        {
        }
        field(12; "Allow Spotcash"; Boolean)
        {
        }
        field(13; "Allow Agency"; Boolean)
        {
        }
        field(14; "Earns Interest"; Boolean)
        {
        }
        field(15; "Interest Rate"; Decimal)
        {
        }
        field(16; "Posting Group"; Code[30])
        {
            TableRelation = IF (Type = FILTER(Loan)) "Customer Posting Group"
            ELSE
            IF (Type = FILTER(<> Loan)) "Vendor Posting Group";
        }
        field(17; "Closing Fees"; Decimal)
        {
        }
        field(18; "Maximum No. of Withdrawal"; Integer)
        {
        }
        field(19; "Allow Multiple Accounts"; Boolean)
        {
        }
        field(20; "Allow Cheque Deposit"; Boolean)
        {
        }
        field(21; "Allow Cheque Withdrawal"; Boolean)
        {
        }
        field(22; "Exclude from Closure"; Boolean)
        {
        }
        field(23; "Transfer Account After Closure"; Code[10])
        {
            TableRelation = "Account Type";

            trigger OnValidate()
            begin
                IF "Transfer Account After Closure" = Code THEN BEGIN
                    ERROR(Error000);
                END;
            end;
        }

        field(25; "Open Automatically"; Boolean)
        {
        }
        field(28; "Allow Joint Member"; Boolean)
        {
        }
        field(29; "Allow InterAccount Transfer"; Boolean)
        {
        }

        field(33; "Minimum Contribution"; Decimal)
        {
        }
        field(34; "Earns Dividend"; Boolean)
        {
        }
        field(35; "Earns Commission on Interest"; Boolean)
        {
        }
        field(36; "Paybill Short Code"; Code[20])
        {
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

    var
        Error000: Label 'Please select a different account';
}

