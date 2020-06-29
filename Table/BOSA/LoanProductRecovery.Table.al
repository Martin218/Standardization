table 50167 "Loan Product Recovery"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Type"; Code[20])
        {
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";

            trigger OnValidate()
            begin
                AccountType.GET("Account Type");
                Description := AccountType.Description;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "Calculation Method"; Option)
        {
            OptionCaption = '%,Flat Amount';
            OptionMembers = "%","Flat Amount";
        }
        field(5; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Product Type", "Account Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AccountType: Record "Account Type";
}

