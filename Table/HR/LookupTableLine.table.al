table 50267 "Lookup Table Line"
{
    // version TL2.0


    fields
    {
        field(1; "Table ID"; Code[20])
        {
            NotBlank = true;
            //TableRelation = "Lookup Table Header";
        }
        field(2; "Lower Amount (LCY)"; Decimal)
        {
        }
        field(3; "Upper Amount (LCY)"; Decimal)
        {
        }
        field(4; "Extract Amount (LCY)"; Decimal)
        {
        }
        field(5; Percent; Decimal)
        {
        }
        field(6; "Cumulate (LCY)"; Decimal)
        {
            Description = 'Not in use for Ethiopia';
        }
        field(7; Month; Integer)
        {
            MaxValue = 12;
            MinValue = 1;
        }
        field(50001; "Relief Amount"; Decimal)
        {
            Description = 'Ethiopian tax has a Relief for every income bracket';
        }
        field(50002; Range; Decimal)
        {
        }
        field(50003; Sequence; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Table ID", "Lower Amount (LCY)", Month)
        {
        }
    }

    fieldgroups
    {
    }

    var
        TableLines: Record 50267;
        PayrollSetup: Record 1660;
    //  gvAllowedPayrolls : Record "50268";
}

