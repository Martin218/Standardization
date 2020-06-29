table 50497 "Vehicle Booking"
{
    // version TL2.0


    fields
    {
        field(1; User; Text[100])
        {
            Editable = false;
        }
        field(2; "Branch Code"; Code[20])
        {
            // TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('BRANCH'));
            trigger OnValidate();
            begin
                /*DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.",1);
                DimensionValue.SETRANGE(Code,"Branch Code");
                IF DimensionValue.FIND('-') THEN BEGIN
                  "Branch Code":=DimensionValue.Name;
                END;*/

            end;
        }
        field(3; "Period of Use"; Code[30])
        {
        }
        field(4; "Booking Time"; Time)
        {
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionMembers = New,Pending,Booked,Rejected,Returned;
        }
        field(6; "Available Car"; Code[10])
        {
        }
        field(7; "Booking Date"; Date)
        {
            Editable = false;
        }
        field(8; Booked; Boolean)
        {
            Editable = false;
        }
        field(9; "No."; Code[40])
        {
            Editable = true;

            trigger OnValidate();
            begin
                /*IF "No."<>xRec."No." THEN BEGIN
                  NoSetup.GET();
                  NoSeriesMgt.TestManual(NoSetup."Approval Remarks");
                  "No.Series":='';
                  END;
                  */

            end;
        }
        field(10; "Approval Remarks"; Text[80])
        {
        }
        field(11; "Required Date"; Date)
        {
        }
        field(12; "Time of Use"; Code[100])
        {
        }
        field(13; "Driver Required ?"; Boolean)
        {
        }
        field(14; "Assign Driver"; Text[30])
        {
            TableRelation = "Driver Setup";
        }
        field(15; "No.Series"; Code[40])
        {
        }
        field(16; "Vehicle Return Date"; Date)
        {
            Editable = false;
        }
        field(17; "Return Vehicle"; Boolean)
        {
            Editable = true;
        }
        field(18; "Hourly use"; Code[10])
        {
        }
        field(19; "Days use"; Code[100])
        {
        }
        field(20; "Vehicle Return time"; Time)
        {
        }
        field(21; "Required To Date"; Date)
        {

            trigger OnValidate();
            begin
                days := "Required To Date" - "Required Date";
                "Days use" := FORMAT(days);
            end;
        }
        field(22; "End Time"; Time)
        {

            trigger OnValidate();
            begin
                IF "End Time" < "Start Time" THEN BEGIN
                    ERROR('End Time cannot be earlier than Start Time!');
                END;

                hrs := "End Time" - "Start Time";
                //hrs:=hrs/3600000;
                hrs2 := hrs / 3600000;
                "Period of Use" := FORMAT(hrs2);
                "Period of Use" := PADSTR("Period of Use", 3) + ' HRS';
            end;
        }
        field(23; "Start Time"; Time)
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
            NoSetup.TESTFIELD("Approval Remarks");
            NoSeriesMgt.InitSeries(NoSetup."Approval Remarks", xRec."No.Series", 0D, "No.", "No.Series");
        END;
        "Booking Date" := TODAY;
        "Booking Time" := TIME;
        "Vehicle Return time" := TIME;
        "Vehicle Return Date" := TODAY;
    end;

    var
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSetup: Record "Admin Numbering Setup";
        days: Integer;
        hrs: Integer;
        hrs2: Decimal;
    // DimensionValue: Record "Dimension Value";
}

