table 50039 Agency
{
    // version TL2.0


    fields
    {
        field(1; "Code"; Code[20])
        {
        }
        field(2; Name; Text[50])
        {

            trigger OnValidate()
            begin
                Name := UPPERCASE(Name);
            end;
        }
        field(3; "Vendor No."; Code[20])
        {
            TableRelation = Vendor WHERE("Vendor Type" = FILTER(FOSA));
        }
        field(4; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(5; Balance; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry".Amount WHERE("Vendor No." = FIELD("Vendor No.")));
            Editable = false;

        }
    }

    keys
    {
        key(Key1; "Code")
        {
        }
    }

    fieldgroups
    {
    }
}

