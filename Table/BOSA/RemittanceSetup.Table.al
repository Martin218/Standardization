table 50127 "Remittance Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Rem. G/L Control Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(3; "Rem. Bank Control Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(4; "SQL Server"; Code[20])
        {
        }
        field(5; "SQL Database"; Text[50])
        {
        }
        field(6; "SQL User ID"; Text[50])
        {
        }
        field(7; "SQL Password"; Text[50])
        {
            ExtendedDatatype = Masked;
        }
        field(8; "Notify Member"; Boolean)
        {
        }
        field(9; "Email Template"; Text[250])
        {
        }
        field(10; "SMS Template"; Text[250])
        {
        }
        field(11; "Notification Option"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
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

