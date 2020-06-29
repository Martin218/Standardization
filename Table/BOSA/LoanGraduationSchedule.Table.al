table 50133 "Loan Graduation Schedule"
{
    // version TL2.0


    fields
    {
        field(1; "Loan Product Code"; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Minimum Loan Amount"; Decimal)
        {
        }
        field(4; "Maximum Loan Amount"; Decimal)
        {
        }
        field(5; "Minimum Repayment Period"; Integer)
        {
        }
        field(6; "Maximum Repayment Period"; Integer)
        {
        }
        field(7; "Increment Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Incremental Method", "Incremental Method"::"Flat Amount");
            end;
        }
        field(8; "Increment Factor"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Incremental Method", "Incremental Method"::Factor);
            end;
        }
        field(9; "Maximum Amount"; Decimal)
        {
        }
        field(10; "Incremental Method"; Option)
        {
            OptionMembers = "Flat Amount",Factor;

            trigger OnValidate()
            begin
                IF "Increment Factor" <> 0 THEN
                    TESTFIELD("Incremental Method", "Incremental Method"::Factor);
                IF "Increment Amount" <> 0 THEN
                    TESTFIELD("Incremental Method", "Incremental Method"::"Flat Amount");
            end;
        }
    }

    keys
    {
        key(Key1; "Loan Product Code", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

