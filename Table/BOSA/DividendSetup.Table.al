table 50159 "Dividend Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Dividend Rate %"; Decimal)
        {
        }
        field(3; "Charge Withholdig Tax"; Boolean)
        {
        }
        field(4; "Charge Excise Duty"; Boolean)
        {
        }
        field(5; "Interest Rate %"; Decimal)
        {
        }
        field(7; "Commission G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Topup Shares"; Boolean)
        {
        }
        field(9; "Commission Amount"; Decimal)
        {
        }
        field(10; "Dividend Control G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(11; "FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(12; "Dividend SMS Template"; Text[250])
        {
        }
        field(13; "Interest SMS Template"; Text[250])
        {
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

    var
        BOSAManagement: Codeunit "BOSA Management";
}

