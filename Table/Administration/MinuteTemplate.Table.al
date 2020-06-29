table 50494 MinuteTemplate
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
                    NoSeriesMgt.TestManual(NoSetup."HOD File Path");
                    "No.Series" := '';
                END;
            end;
        }
        field(2; "Day of meeting"; Date)
        {
        }
        field(3; Remarks; Code[80])
        {
        }
        field(4; user; Text[50])
        {
        }
        field(5; "HOD File Path"; Text[100])
        {
        }
        field(6; "No.Series"; Code[10])
        {
        }
        field(7; "Notice Doc"; Text[250])
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
        user := USERID;
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD("HOD File Path");
            NoSeriesMgt.InitSeries(NoSetup."HOD File Path", xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
}

