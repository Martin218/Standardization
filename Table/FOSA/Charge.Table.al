table 50028 Charge
{
    // version TL2.0


    fields
    {
        field(1; "Charge Code"; Code[30])
        {
            NotBlank = true;
        }
        field(2; Description; Text[150])
        {
        }
        field(3; "Charge Amount"; Decimal)
        {
        }
        field(4; "Percentage of Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Percentage of Amount" > 100 THEN
                    ERROR('You cannot exceed 100. Please enter a valid number.');
            end;
        }
        field(5; "Use Percentage"; Boolean)
        {
        }
        field(6; "GL Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(7; "Minimum Amount"; Decimal)
        {
        }
        field(8; "Maximum Amount"; Decimal)
        {
        }
        field(9; "Deduct Excise"; Boolean)
        {
        }
        field(10; "Excise %"; Decimal)
        {
        }
        field(11; "Excise G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(12; "Posting Description"; Text[150])
        {
        }
        field(13; Interbranch; Boolean)
        {
        }
        field(14; "Settlement Amount"; Decimal)
        {
        }
        field(15; "Settlement GL Account"; Code[30])
        {
            TableRelation = "G/L Account";
        }
        field(16; Mobile; Boolean)
        {
        }
        field(17; Classified; Boolean)
        {
        }
        field(18; "Stamp Duty"; Decimal)
        {
        }
        field(19; "Stamp Duty G/L Account"; Code[10])
        {
            TableRelation = "G/L Account";
        }
        field(20; "Safaricom Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(21; "Safaricom Amount"; Decimal)
        {
        }
        field(22; "TL Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(23; "TL Amount"; Decimal)
        {
        }
        field(24; "Agent Store"; Decimal)
        {
        }
        field(25; "Agent Settlement Amount"; Decimal)
        {
        }
        field(26; "Settlement Bank"; Code[20])
        {
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1; "Charge Code")
        {
        }
    }

    fieldgroups
    {
    }
}

