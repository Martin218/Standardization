table 50023 "Transaction Charge"
{
    // version TL2.0


    fields
    {
        field(1; "Transaction Type Code"; Code[30])
        {
            TableRelation = "Transaction -Type";
        }
        field(3; "Minimum Amount"; Decimal)
        {
        }
        field(4; "Maximum Amount"; Decimal)
        {
        }
        field(5; "Settlement %"; Decimal)
        {
            Caption = 'Settlement % (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(6; "Settlement Amount  (SACCO)"; Decimal)
        {
            Caption = 'Settlement Amount (SACCO)';
            Description = 'This is reserved for SACCO commission';
        }
        field(7; "Settlement % (TL)"; Decimal)
        {
            Caption = 'Settlement % (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(8; "Settlement Amount  (TL)"; Decimal)
        {
            Caption = 'Settlement Amount (TL)';
            Description = 'This is reserved for TL commission';
        }
        field(9; "Settlement % (COOP)"; Decimal)
        {
            Caption = 'Settlement % (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(10; "Settlement Amount (COOP)"; Decimal)
        {
            Caption = 'Settlement Amount (COOP)';
            Description = 'This is reserved for COOP commission';
        }
        field(11; "Settlement % (AGENT)"; Decimal)
        {
            Caption = 'Settlement % (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(12; "Settlement Amount (AGENT)"; Decimal)
        {
            Caption = 'Settlement Amount (AGENT)';
            Description = 'This is reserved for AGENT commission';
        }
        field(13; "Apportionment Amount"; Decimal)
        {
        }
        field(14; "Line No."; Integer)
        {
            AutoIncrement = true;
        }
        field(15; "Calculation Method"; Option)
        {
            OptionMembers = "Based Flat Amount","Based on %";
        }
    }

    keys
    {
        key(Key1; "Transaction Type Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Charges: Record Charge;
}

