table 50033 "CTS Setup"
{
    // version CTS2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }

        field(3; "Charges Per Leaf"; Decimal)
        {
        }

        field(6; "Charges G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(8; "Charge Excise Duty"; Boolean)
        {
        }

        field(10; "Clearance Charges"; Decimal)
        {
        }
        field(11; "Commission G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Cheque Clearance Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(13; "SMS Charges"; Decimal)
        {
        }
        field(14; "SMS G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }

        field(16; "Penalty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

