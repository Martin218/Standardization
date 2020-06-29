table 50496 "Vehicle Register"
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
                    NoSeriesMgt.TestManual(NoSetup."Chassis No");
                    "No.Series" := '';
                END;
            end;
        }
        field(2; Description; Text[30])
        {
        }
        field(3; "Responsible Driver"; Code[20])
        {
        }
        field(4; Insured; Boolean)
        {
        }
        field(5; "No.Series"; Code[30])
        {
            TableRelation = "No. Series";
        }
        field(6; "Branch Code"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));

            trigger OnValidate();
            begin
                // DimensionValue.RESET;
                //DimensionValue.SETRANGE("Global Dimension No.", 1);
                //DimensionValue.SETRANGE(Code, "Branch Code");
                /*IF DimensionValue.FIND('-') THEN BEGIN
                    "Branch Code" := DimensionValue.Name;
                END;*/
            end;
        }
        field(7; "Number Plate"; Code[20])
        {
        }
        field(8; "Chassis No"; Code[20])
        {
        }
        field(9; "Body Type"; Code[30])
        {
        }
        field(10; Colour; Code[30])
        {
        }
        field(11; Model; Text[30])
        {
        }
        field(12; "Engine No"; Code[10])
        {
        }
        field(13; YOM; Integer)
        {
        }
        field(14; Registered; Boolean)
        {
        }
        field(15; Booked; Boolean)
        {
        }
        field(16; "Fixed Asset Car No."; Code[50])
        {
            TableRelation = "Fixed Asset";
        }
        field(17; "Date of Insurance"; Date)
        {

            trigger OnValidate();
            begin
                IF Days <> Emptydateformulae THEN
                    "Insurance Expiry Date" := CALCDATE(Days, "Date of Insurance")
            end;
        }
        field(18; Months; Integer)
        {

            trigger OnValidate();
            begin
                EVALUATE(Days, FORMAT(Months) + 'M');
                //VALIDATE(Days);
            end;
        }
        field(19; "Insurance Expiry Date"; Date)
        {
        }
        field(20; Days; DateFormula)
        {

            trigger OnValidate();
            begin
                "Insurance Expiry Date" := CALCDATE(Days, "Date of Insurance");

                IF "Date of Insurance" <> 0D THEN
                    "Insurance Expiry Date" := CALCDATE(Days, "Date of Insurance");

                "Insurance Expiry Date" := CALCDATE('<-1D>', "Insurance Expiry Date");
            end;
        }
        field(21; Color; Code[30])
        {
        }
        field(22; "YOM-Month"; Code[20])
        {
        }
        field(23; "Condition of Vehicle"; Option)
        {
            OptionMembers = ,Working,"Not in Use","In Repairs";
        }
    }

    keys
    {
        key(Key1; "Number Plate")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Number Plate", "Branch Code")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("Chassis No");
            NoSeriesMgt.InitSeries(NoSetup."Chassis No", xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Days: DateFormula;
        Emptydateformulae: DateFormula;
        NoSetup: Record "Admin Numbering Setup";
    //DimensionValue: Record "Dimension Value";
}

