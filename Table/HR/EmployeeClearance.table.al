table 50239 "Employee Clearance"
{
    // version TL2.0


    fields
    {
        field(1; "Employee No."; Code[20])
        {
        }
        field(2; "Clearance Area Code"; Code[20])
        {
            NotBlank = true;
            TableRelation = "Clearance Area".Code;

            trigger OnValidate();
            begin
                IF "Clearance Area Code" <> '' THEN BEGIN
                    HRClearanceArea.GET("Clearance Area Code");
                    "Clearance Area" := HRClearanceArea.Description;
                END ELSE BEGIN
                    "Clearance Area" := '';
                END;
            end;
        }
        field(3; "Clearance Area"; Text[100])
        {
            Editable = false;
        }
        field(4; "Clearance Details"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", "Clearance Area Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        HRClearanceArea: Record 50242;
}

