table 50233 "Position Responsibility"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Position Code"; Code[20])
        {
        }
        field(3; Responsibility; Text[150])
        {
        }
        field(4; Remarks; Text[50])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.", "Position Code")
        {
        }
    }

    fieldgroups
    {
    }
}

