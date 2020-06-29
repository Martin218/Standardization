table 50141 "FT Loan Product"
{
    // version TL2.0

    DrillDownPageID = "FT Loan Products";
    LookupPageID = "FT Loan Products";

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
        field(3; "Application Area"; Option)
        {
            OptionCaption = ' ,Source,Destination,Both';
            OptionMembers = " ",Source,Destination,Both;
        }
        field(4; Priority; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Loan Product Type")
        {
        }
        key(Key2; "Application Area", Priority)
        {
        }
    }

    fieldgroups
    {
    }

    var
        LoanProductType: Record "Loan Product Type";
}

