table 50498 "Vehicle Maintenance"
{
    // version TL2.0


    fields
    {
        field(1; "Vehicle Number Plate"; Code[10])
        {
        }
        field(2; "Responsible Driver"; Text[30])
        {
        }
        field(3; "Branch Code"; Code[20])
        {
            //TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            trigger OnValidate();
            begin
                /*DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.",1);
                DimensionValue.SETRANGE(Code,"Branch Code");
                IF DimensionValue.FIND('-') THEN BEGIN
                  "Branch Code":=DimensionValue.Name;
                END;*/

            end;
        }
        field(4; "Service Date"; Date)
        {
        }
        field(5; "Service Agent Name"; Text[80])
        {
        }
        field(6; Comment; Text[50])
        {
        }
        field(7; Scheduled; Boolean)
        {
        }
        field(8; "Fixed Asset Car No."; Code[30])
        {
            // TableRelation = "Fixed Asset";
        }
    }

    keys
    {
        key(Key1; "Vehicle Number Plate")
        {
        }
    }

    fieldgroups
    {
    }

    var
    // DimensionValue: Record "Dimension Value";
}

