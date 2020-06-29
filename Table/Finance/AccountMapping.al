table 50338 "Account Mapping"
{
    // version TL 2.0


    fields
    {
        field(1; "Account Type"; Code[20])
        {
            TableRelation = "Account Mapping Type";
        }
        field(2; "Employee No."; Code[10])
        {
            TableRelation = Employee;
        }
        field(3; "Staff A/C"; Code[10])
        {
            TableRelation = Vendor;
        }
    }

    keys
    {
        key(Key1; "Account Type", "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }
}

