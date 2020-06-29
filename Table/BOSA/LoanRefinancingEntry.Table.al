table 50106 "Loan Refinancing Entry"
{
    // version TL2.0

    DrillDownPageID = 50211;
    LookupPageID = 50211;

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Loan To Refinance"; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan To Refinance") THEN BEGIN
                    /*  "Loan Product Type Code":=LoanApplication."Application Date";
                      "Loan Product Description":=LoanApplication."Loan Product Type";
                      "Outstanding Principal":=LoanApplication."Vendor No";
                      "Outstanding Interest":=LoanApplication.Defaulted;*/
                END;

            end;
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
            Editable = false;
        }
        field(4; "Outstanding Balance"; Decimal)
        {
            Editable = false;
        }
        field(5; Select; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Loan To Refinance")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        LoanApplication: Record "Loan Application";
}

