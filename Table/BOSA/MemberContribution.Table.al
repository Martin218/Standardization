table 50038 "Member Contribution"
{
    // version TL2.0


    fields
    {
        field(1; "Application No."; Code[20])
        {
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";
            trigger OnValidate()
            var
                AccountType: Record "Account Type";
            begin
                if AccountType.Get("Account Type") then
                    Description := AccountType.Description;
            end;


        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; Amount; Decimal)
        {
        }



    }

    keys
    {
        key(Key1; "Application No.", "Account Type")
        {
        }
    }

    fieldgroups
    {
    }
}

