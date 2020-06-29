table 50486 "Boardroom Detail"
{
    // version TL2.0


    fields
    {
        field(1; "Boardroom No"; Code[30])
        {

            trigger OnValidate();
            begin
                IF "Boardroom No" <> xRec."Boardroom No" THEN BEGIN
                    NoSetup.GET();
                    NoSeriesMgt.TestManual(NoSetup."Boardroom Name");
                    "No.Series" := '';
                END;
            end;
        }
        field(2; "Boardroom Name"; Text[100])
        {
        }
        field(3; Register; Boolean)
        {
            Editable = false;
        }
        field(4; "No.Series"; Code[10])
        {
        }
        field(5; Location; Code[30])
        {
            // TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            trigger OnValidate();
            begin
                //DimensionValue.RESET;
                //DimensionValue.SETRANGE("Global Dimension No.", 1);

                //Address := DimensionValue.Name;
            end;
        }
        field(6; Address; Code[50])
        {
        }
        field(7; "Equipment Available"; Code[40])
        {
            TableRelation = "Boardroom Setup";
        }
        field(8; "Maximum Capacity"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Boardroom No", "Boardroom Name")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF "Boardroom No" = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Boardroom Name");
            NoSeriesMgt.InitSeries(NoSetup."Boardroom Name", xRec."No.Series", 0D, "Boardroom No", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
    // DimensionValue: Record "Dimension Value";
}

