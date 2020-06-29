table 50016 "Activation Charge Line"
{
    // version TL2.0


    fields
    {
        field(1; "Activation Code"; Code[20])
        {
        }
        field(2; "Charge Code"; Code[20])
        {
            TableRelation = "Activation Charge";

            trigger OnValidate()
            begin
                IF FOSACharge.GET("Charge Code") THEN
                    Description := FOSACharge.Description;
            end;
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "GL Account No."; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; Amount; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Activation Code", "Charge Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        FOSACharge: Record "Activation Charge";
}

