table 50408 "Dimension Heads"
{

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Global Dimension 1 Code"; Code[50])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1),
                                                         "Dimension Value Type" = FILTER(Standard));
        }
        field(3; "Global Dimension 2 Code"; Code[50])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2),
                                                         "Dimension Value Type" = FILTER(Standard));
        }
        field(4; "Dimension 1 Head"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(5; "Dimension 2 Head"; Code[100])
        {
            TableRelation = "User Setup";
        }
    }

    keys
    {
        key(Key1; "Global Dimension 1 Code", "Global Dimension 2 Code")
        {
        }
    }

    fieldgroups
    {
    }
}

