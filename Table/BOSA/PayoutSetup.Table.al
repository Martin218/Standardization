table 50123 "Payout Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Charges Calculation Method"; Option)
        {
            OptionMembers = "%","Flat Amount";
        }
        field(3; "Flat Amount"; Decimal)
        {
        }
        field(4; "Charges G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Charge Witholding Tax"; Boolean)
        {
        }
        field(12; "Charge Excise Duty"; Boolean)
        {
        }
        field(13; "Charge %"; Decimal)
        {
        }
        field(14; "FOSA Account Type"; Code[20])
        {
            TableRelation = "Account Type";
        }
        field(15; "Notification Option"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(16; "Notify Member"; Boolean)
        {
        }
        field(17; "SMS Template"; Text[250])
        {
        }
        field(18; "Email Template"; Text[250])
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

