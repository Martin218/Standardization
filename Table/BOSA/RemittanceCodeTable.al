table 50146 "Remittance Code"
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
        field(3; "Account Category"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;
        }
        field(4; "Account Type"; Code[20])
        {
            TableRelation = IF ("Account Category" = FILTER(Vendor)) "Account Type"
            ELSE
            IF ("Account Category" = FILTER(Customer)) "Loan Product Type";

            trigger OnValidate()
            begin
                IF "Account Category" = "Account Category"::Vendor THEN BEGIN
                    AccountType.GET("Account Type");
                    Description := AccountType.Description
                END;

                IF "Account Category" = "Account Category"::Customer THEN BEGIN
                    LoanProductType.GET("Account Type");
                    Description := LoanProductType.Description
                END;
            end;
        }
        field(5; "Contribution Type"; Option)
        {
            OptionCaption = 'Normal,Principal Due,Interest Due,Insurance';
            OptionMembers = Normal,"Principal Due","Interest Due",Insurance;
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

    var
        AccountType: Record "Account Type";
        LoanProductType: Record "Loan Product Type";
}

