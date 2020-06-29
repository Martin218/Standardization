table 50015 "Activation Type"
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Application Area"; Option)
        {
            OptionCaption = 'Member,Account,ATM,SpotCash';
            OptionMembers = Member,Account,ATM,SpotCash;
        }
        field(4; "Action Type"; Option)
        {
            OptionCaption = 'Member Joining,Member Re-Joining,Member Dormancy,Account Suspension,Account Dormancy,Account Freezing,Account Closure,ATM Card Activation,ATM Card Freezing,SpotCash Member Activation,SpotCash Member Freezing';
            OptionMembers = "Member Joining","Member Re-Joining","Member Dormancy","Account Suspension","Account Dormancy","Account Freezing","Account Closure","ATM Card Activation","ATM Card Freezing","SpotCash Member Activation","SpotCash Member Freezing";
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

