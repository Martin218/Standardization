table 50126 "Payout Loan Product"
{
    // version TL2.0


    fields
    {
        field(1; "Payout Code"; Code[20])
        {
        }
        field(2; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type";

            trigger OnValidate()
            begin
                IF LoanProductType.GET("Loan Product Type") THEN
                    Description := LoanProductType.Description;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Payout Code", "Loan Product Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoanProductType: Record "Loan Product Type";
}

