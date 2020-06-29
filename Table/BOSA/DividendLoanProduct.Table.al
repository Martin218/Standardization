table 50160 "Dividend Loan Product"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Type"; Code[20])
        {
            TableRelation = "Loan Product Type";

            trigger OnValidate()
            begin
                IF LoanProductType.GET("Loan Product Type") THEN
                    Description := LoanProductType.Description;
            end;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Product Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoanProductType: Record "Loan Product Type";
}

