table 50236 "Training Need"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Integer)
        {
        }
        field(3; "Training Description"; Text[100])
        {
        }
        field(4; "Course/Seminar Name"; Text[100])
        {
        }
        field(5; "Training Institution"; Text[100])
        {
        }
        field(6; Venue; Text[100])
        {
        }
        field(7; Duration; Decimal)
        {
        }
        field(8; "Duration Units"; Option)
        {
            OptionCaption = '" ,Hours,Days,Weeks,Months,Years"';
            OptionMembers = " ",Hours,Days,Weeks,Months,Years;
        }
        field(9; "Start Date"; Date)
        {
        }
        field(10; "End Date"; Date)
        {
        }
        field(11; Location; Option)
        {
            OptionCaption = '" ,Town,City"';
            OptionMembers = " ",Town,City;
        }
        field(12; "Cost of Training"; Decimal)
        {
        }
        field(13; "Total Cost of Training"; Decimal)
        {
        }
        field(14; "Training Request No."; Code[20])
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
        TrainingNeed.RESET;
        IF TrainingNeed.FINDLAST THEN BEGIN
            "No." := TrainingNeed."No." + 1;
        END ELSE BEGIN
            "No." := 1;
        END;
    end;

    var
        NoSeriesMgt: Codeunit 396;
        HRSetup: Record 5218;

        TrainingNeed: Record 50236;
}

