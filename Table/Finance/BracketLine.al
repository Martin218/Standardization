table 50303 "Bracket Line"
{

    fields
    {
        field(1; "Line No."; Integer)
        {
            AutoIncrement = true;
            Enabled = true;
        }
        field(2; Descripption; Text[70])
        {
            Editable = false;
        }
        field(3; "Table Code"; Code[30])
        {
            Editable = false;
            TableRelation = "Bracket Table";

            trigger OnValidate();
            begin
                TESTFIELD("Table Code");
                BracketTable.RESET;
                IF BracketTable.GET("Table Code") THEN BEGIN
                    Descripption := BracketTable.Description;
                END;
            end;
        }
        field(4; "Lower Limit"; Decimal)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Lower Limit");
                IF "Upper Limit" <> 0 THEN BEGIN
                    "Taxable Pay" := ("Upper Limit" - "Lower Limit") + 1;
                END;
            end;
        }
        field(5; "Upper Limit"; Decimal)
        {

            trigger OnValidate();
            begin
                TESTFIELD("Upper Limit");
                IF "Lower Limit" <> 0 THEN BEGIN
                    "Taxable Pay" := ("Upper Limit" - "Lower Limit") + 1;
                END;
            end;
        }
        field(6; "Amount Charged"; Decimal)
        {

            trigger OnValidate();
            begin
                IF BracketTable.GET("Table Code") THEN BEGIN
                    IF BracketTable.Type = BracketTable.Type::Percentage THEN BEGIN

                    END;
                END;
            end;
        }
        field(7; Percentage; Decimal)
        {

            trigger OnValidate();
            begin
                TESTFIELD(Percentage);
                PayrollSetup.GET(1);
                PayrollSetup.TESTFIELD("Tax Roundoff");
                IF BracketTable.GET("Table Code") THEN BEGIN
                    IF BracketTable.Type = BracketTable.Type::Percentage THEN BEGIN
                        IF "Taxable Pay" <> 0 THEN BEGIN
                            "Amount Charged" := ROUND("Taxable Pay" * (Percentage / 100), PayrollSetup."Tax Roundoff");
                        END;
                    END;
                END;
            end;
        }
        field(8; "From Date"; Date)
        {
        }
        field(9; "End Date"; Date)
        {
        }
        field(10; "Pay period"; Date)
        {
        }
        field(11; "Taxable Pay"; Decimal)
        {
            Enabled = true;
        }
    }

    keys
    {
        key(Key1; "Line No.", "Table Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BracketTable: Record "Bracket Table";
        PayrollSetup: Record "Payroll Setup";
}

