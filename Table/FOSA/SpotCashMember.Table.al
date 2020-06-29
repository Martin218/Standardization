table 50068 "SpotCash Member"
{
    // version TL2.0


    fields
    {
        field(1; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    Member.TESTFIELD("Phone No.");
                    "Phone No." := Member."Phone No.";
                END;
            end;
        }
        field(2; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(3; "Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(4; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }
        field(6; "Phone No."; Code[20])
        {
            Editable = false;
        }
        field(7; "Service Type"; Option)
        {
            OptionCaption = 'Mobile Banking,Agency Banking';
            OptionMembers = "Mobile Banking","Agency Banking";
        }
        field(8; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - Sum ("Detailed Vendor Ledg. Entry"."Amount (LCY)" WHERE("Vendor No." = FIELD("Account No.")));
            Caption = 'Balance (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(12; "Created Date"; Date)
        {
            Editable = false;
        }
        field(14; "Created Time"; Time)
        {
            Editable = false;
        }
        field(15; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(16; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(18; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(19; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(20; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(21; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(22; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(23; "Approved By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(24; "Created By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(25; "Created By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(26; "Last Modified By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(27; "Last Modified By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(28; "Last Modified By Host MAC"; Code[20])
        {
            Editable = false;
        }

        field(30; "Approved By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(31; "Approved By Host MAC"; Code[20])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Phone No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
        Vendor: Record Vendor;
}

