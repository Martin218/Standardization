table 50490 Attendance
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[40])
        {

            trigger OnValidate();
            begin
                /*IF Remarks<>xRec.Remarks THEN BEGIN
                  NoSetup.GET();
                  NoSeriesMgt.TestManual(NoSetup.Comment);
                  "No.Series":='';
                  END;
                  */

            end;
        }
        field(2; "Attendee Names"; Text[70])
        {
        }
        field(3; "Meeting Agenda"; Text[70])
        {
        }
        field(4; "No.Series"; Code[10])
        {
        }
        field(5; Remarks; Text[100])
        {
        }
        field(6; LineNo; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "No.", "Attendee Names", "Meeting Agenda", Remarks, LineNo)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        /*IF Remarks<>xRec.Remarks THEN BEGIN
        NoSetup.GET;
        NoSetup.TESTFIELD (Comment);
        NoSeriesMgt.InitSeries(NoSetup.Comment,xRec."No.Series",0D,Remarks,"No.Series");
        END;*/

    end;

    var
        NoSeriesMgt: Codeunit "NoSeriesManagement";
        NoSetup: Record "Admin Numbering Setup";
}

