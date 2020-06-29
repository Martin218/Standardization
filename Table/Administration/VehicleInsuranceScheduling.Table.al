table 50499 "Vehicle Insurance Scheduling"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate();
            begin
                IF "No." <> xRec."No." THEN BEGIN
                    NoSetup.GET();
                    NoSeriesMgt.TestManual(NoSetup.Comment);
                    "No.Series" := '';
                END;
            end;
        }
        field(2; "Vehicle Number Plate"; Code[10])
        {
            TableRelation = "Vehicle Register";

            trigger OnValidate();
            begin
                IF VehicleRegister.GET("Vehicle Number Plate") THEN BEGIN
                    "Designated Driver" := VehicleRegister."Responsible Driver";
                    "Branch Code" := VehicleRegister."Branch Code";
                END;
            end;
        }
        field(3; "Vehicle Description"; Code[50])
        {
        }
        field(4; "Designated Driver"; Text[30])
        {
        }
        field(5; "Insurance Company"; Code[50])
        {
        }
        field(6; "Valuation Date"; Date)
        {
        }
        field(7; Comment; Text[100])
        {
        }
        field(8; Scheduled; Boolean)
        {
        }
        field(9; "Branch Code"; Code[30])
        {
            //TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            trigger OnValidate();
            begin
                //DimensionValue.RESET;
                // DimensionValue.SETRANGE("Global Dimension No.",1);
                // DimensionValue.SETRANGE(Code,"Branch Code");
                /* IF DimensionValue.FIND('-') THEN BEGIN
                     "Branch Code" := DimensionValue.Name;
                 END;*/
            end;
        }
        field(10; "Fixed Asset car No."; Code[50])
        {
            //TableRelation = "Fixed Asset";
        }
        field(11; "No.Series"; Code[10])
        {
        }
        field(12; "Type of Insurance"; Option)
        {
            OptionMembers = ,Comprehensive,"Third-Party";
        }
        field(13; "Last Valuation Date"; Date)
        {
        }
        field(14; "Last Valuation Amount"; Decimal)
        {
        }
        field(15; "Last Valuer Company"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
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
            NoSetup.TESTFIELD(Comment);
            NoSeriesMgt.InitSeries(NoSetup.Comment, xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
        VehicleRegister: Record "Vehicle Register";
    // DimensionValue: Record "Dimension Value";
}

