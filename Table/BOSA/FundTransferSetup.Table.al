table 50136 "Fund Transfer Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Recover Source Arrears"; Boolean)
        {
        }
        field(3; "Recover Destination Arrears"; Boolean)
        {
        }
        field(4; "Allow Overdrawing"; Boolean)
        {
        }
        field(5; "Notify Source Member"; Boolean)
        {
        }
        field(6; "Notify Destination Member"; Boolean)
        {
        }
        field(7; "Allow Partial Deduction"; Boolean)
        {
        }
        field(8; "Overdraw/Partial Priority"; Option)
        {
            OptionCaption = 'Partial,Overdrawing';
            OptionMembers = Partial,Overdrawing;
        }
        field(9; "Deduction Priority"; Option)
        {
            OptionCaption = 'Source Arrears>Destination Arrears>Required Amount,Required Amount>Source Arrears>Destination Arrears';
            OptionMembers = "Source Arrears>Destination Arrears>Required Amount","Required Amount>Source Arrears>Destination Arrears";
        }
        field(10; "Source SMS Template"; Text[250])
        {
        }
        field(11; "Destination SMS Template"; Text[250])
        {
        }
        field(12; "Notification Option"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(13; "Source Email Template"; Text[250])
        {
        }
        field(14; "Destination Email Template"; Text[250])
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

