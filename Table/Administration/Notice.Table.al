table 50492 Notice
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
                    NoSeriesMgt.TestManual(NoSetup.Agenda);
                    "No.Series" := '';
                END;
            end;
        }
        field(2; Date; Date)
        {
        }
        field(3; Agenda; Code[100])
        {
        }
        field(4; User; Text[30])
        {
        }
        field(5; "No.Series"; Code[10])
        {
        }
        field(6; "HOD File Path"; Text[100])
        {
        }
        field(7; Status; Option)
        {
            OptionMembers = New,Pending,Approved;
        }
        field(8; "Approval Remarks"; Code[100])
        {
        }
        field(9; "Notice Doc"; Text[250])
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
        User := USERID;
        IF "No." = '' THEN BEGIN
            NoSetup.GET;
            NoSetup.TESTFIELD(Agenda);
            NoSeriesMgt.InitSeries(NoSetup.Agenda, xRec."No.Series", 0D, "No.", "No.Series");
        END;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
}

