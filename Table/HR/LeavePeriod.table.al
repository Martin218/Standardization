table 50212 "Leave Period"
{
    // version TL2.0


    fields
    {
        field(1; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            NotBlank = true;

            trigger OnValidate();
            begin
                "Period Description" := FORMAT("Starting Date", 0, Text000);
            end;
        }
        field(2; "Period Description"; Text[100])
        {
            Caption = 'Name';
            Editable = false;
        }
        field(3; "New Fiscal Year"; Boolean)
        {
            Caption = 'New Fiscal Year';

            trigger OnValidate();
            begin
                TESTFIELD("Date Locked", FALSE);
            end;
        }
        field(4; Closed; Boolean)
        {
            Caption = 'Closed';
            Editable = false;
        }
        field(5; "Date Locked"; Boolean)
        {
            Caption = 'Date Locked';
            Editable = false;
        }
        field(6; "Reimbursement Closing Date"; Boolean)
        {
        }
        field(8; "Period Code"; Code[10])
        {
        }
    }

    keys
    {
        key(Key1; "Starting Date")
        {
        }
    }

    fieldgroups
    {
    }

    var

        Text000: Label '<Month Text>';

    procedure UpdateAvgItems();
    begin
    end;
}

