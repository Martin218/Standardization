table 50500 "Fuel Tracking"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    NoSetup.GET();
                    NoSeriesMgt.TestManual(NoSetup.Mileage);
                    // "No.Series" := '';
                END;
            end;
        }
        field(2; "Fuel Receipt Date"; Date)
        {
        }
        field(3; "Fuel Cost"; Decimal)
        {
        }
        field(4; "Fueled Litres"; Decimal)
        {
        }
        field(5; Mileage; Code[10])
        {
        }
        field(6; "Vehicle Number Plate"; Code[10])
        {
            TableRelation = "Vehicle Register";

            trigger OnValidate();
            begin
                IF VehicleRegister.GET("Vehicle Number Plate") THEN BEGIN
                    "Branch Code" := VehicleRegister."Branch Code";
                    Driver := VehicleRegister."Responsible Driver";
                END;
            end;
        }
        field(7; Driver; Text[30])
        {
        }
        field(8; Tracked; Boolean)
        {
        }
        field(9; "Branch Code"; Code[30])
        {
            //TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            trigger OnValidate();
            begin

            end;
            //}

            //field(11; "No.Series"; Code[10])
            // {
        }
        field(12; "Notice Doc"; Text[250])
        {
        }
        field(13; "HOD File Path"; Text[100])
        {
        }
        field(14; "Opening Mileage"; Decimal)
        {
        }
        field(15; "Closing Mileage"; Decimal)
        {

            trigger OnValidate();
            begin
                Mileage := FORMAT("Closing Mileage" - "Opening Mileage");
                Mileage := Mileage + 'KM';
            end;
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

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD(Mileage);
            // NoSeriesMgt.InitSeries(NoSetup.Mileage, xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        NoSetup: Record "Admin Numbering Setup";
        // DimensionValue : Record "349";
        VehicleRegister: Record "Vehicle Register";
}

