table 50143 "Exit Reason Fee"
{
    // version TL2.0


    fields
    {
        field(1; "Reason Code"; Code[20])
        {
        }
        field(2; "Code"; Code[20])
        {
            TableRelation = "Exit Fee";

            trigger OnValidate()
            begin
                IF ExitFee.GET(Code) THEN BEGIN
                    Description := ExitFee.Description;
                    Amount := ExitFee.Amount;
                END;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Reason Code", "Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ExitFee: Record "Exit Fee";
}

