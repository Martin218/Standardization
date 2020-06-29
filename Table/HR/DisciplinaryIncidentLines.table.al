table 50221 "Disciplinary Incident Lines"
{
    // version TL2.0


    fields
    {
        field(1; "Incident No."; Code[20])
        {
        }
        field(2; "Incident Line No"; Integer)
        {
        }
        field(3; "Incident Date"; Date)
        {
        }
        field(4; "Disciplinary Case Code"; Code[20])
        {
            TableRelation = "Disciplinary Offense";

            trigger OnValidate();
            begin
                DisciplinaryOffense.GET("Disciplinary Case Code");
                "Disciplinary Case Description" := DisciplinaryOffense.Description;
            end;
        }
        field(5; "Disciplinary Case Description"; Text[50])
        {
        }
        field(6; "Case Discussion"; Text[250])
        {
        }
        field(7; "Recommended Action"; Text[100])
        {
        }
        field(8; "Accused Defense"; Text[100])
        {
        }
        field(9; Witnesses; Text[50])
        {
            TableRelation = Employee;
        }
        field(10; "Action Taken"; Code[20])
        {
        }
        field(11; "Action Date"; Date)
        {
        }
        field(12; Comments; Text[100])
        {
        }
        field(13; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(14; Rating; Integer)
        {
            Editable = false;
        }
        field(15; "Employee Name"; Text[50])
        {
            FieldClass = Normal;
        }
    }

    keys
    {
        key(Key1; "Incident No.", "Incident Line No")
        {
        }
        key(Key2; "Employee No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        /*  DisciplinaryIncidentHeader.GET("Incident No.");
          "Incident Date" := DisciplinaryIncidentHeader."Incident Date";
          "Employee No." := DisciplinaryIncidentHeader."Employee No";*/
    end;

    var
        //   DisciplinaryIncidentHeader: Record 50220;
        DisciplinaryOffense: Record 50216;
}

