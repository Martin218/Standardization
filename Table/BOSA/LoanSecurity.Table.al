table 50104 "Loan Security"
{
    // version TL2.0

    DrillDownPageID = 50209;
    LookupPageID = 50209;

    fields
    {
        field(1; "Loan No."; Code[30])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Security Code"; Code[30])
        {
            TableRelation = "Security Type";

            trigger OnValidate()
            begin
                IF SecurityType.GET("Security Code") THEN BEGIN
                    Description := SecurityType.Description;
                    "Security Factor" := SecurityType.Factor;

                END;
            end;
        }
        field(4; Description; Text[30])
        {
        }
        field(5; "Security Value"; Decimal)
        {

            trigger OnValidate()
            begin
                "Guaranteed Amount" := "Security Factor" * "Security Value";
            end;
        }
        field(6; "Guaranteed Amount"; Decimal)
        {
        }
        field(7; "Security Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                "Guaranteed Amount" := "Security Factor" * "Security Value";
            end;
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SecurityType: Record "Security Type";
}

