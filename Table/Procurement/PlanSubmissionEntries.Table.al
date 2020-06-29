table 50407 "Plan Submission Entries"
{

    fields
    {
        field(1; "Current Budget"; Code[30])
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
        field(4; "Created By"; Code[80])
        {
        }
        field(5; "Created On"; Date)
        {
        }
        field(6; "Created Time"; Time)
        {
        }
        field(7; "Budget Per Branch?"; Boolean)
        {
        }
        field(8; "Budget Per Department?"; Boolean)
        {
        }
        field(9; Submitted; Boolean)
        {
        }
        field(10; "Plan No."; Code[20])
        {
        }
        field(11; "Line No"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Line No")
        {
        }
    }

    fieldgroups
    {
    }
}

