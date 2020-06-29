table 50100 "Loan Application Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "Notify Member"; Boolean)
        {
        }
        field(3; "Email Template"; Text[250])
        {
        }
        field(4; "SMS Template"; Text[250])
        {
        }
        field(5; "Notification Option"; Option)
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

