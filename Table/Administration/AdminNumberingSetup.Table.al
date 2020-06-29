table 50488 "Admin Numbering Setup"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(2; "Chassis No"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(3; "No.Series"; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(4; Comment; Text[100])
        {
            TableRelation = "No. Series";
        }
        field(5; "Primary Key"; Code[10])
        {
        }
        field(6; Mileage; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(7; "Boardroom Name"; Text[30])
        {
            TableRelation = "No. Series";
        }
        field(8; "Booking Date"; Date)
        {
            TableRelation = "No. Series";
        }
        field(9; Duration; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(10; Remarks; Text[30])
        {
            TableRelation = "No. Series";
        }
        field(11; Agenda; Code[10])
        {
            TableRelation = "No. Series";
        }
        field(12; "HOD File Path"; code[10])
        {
            TableRelation = "No. Series";
        }
        field(13; "Approval Remarks"; Text[30])
        {
            TableRelation = "No. Series";
        }
        field(14; Description; Text[100])
        {
            TableRelation = "No. Series";
        }
        field(15; Comments; Code[100])
        {
            TableRelation = "No. Series";
        }
        field(16; "Approver Email"; Text[100])
        {
        }
        field(17; "Notice File"; Text[250])
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

