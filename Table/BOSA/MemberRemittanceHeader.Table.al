table 50124 "Member Remittance Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                END;
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(6; "Created Date"; Date)
        {
            Editable = false;
        }
        field(7; "Created Time"; Time)
        {
            Editable = false;
        }
        field(8; "Last Modified By"; Code[20])
        {
            Editable = false;
        }
        field(9; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(10; "Last Modified Time"; Time)
        {
            Editable = false;
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

    trigger OnInsert()
    begin
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    trigger OnModify()
    begin
        "Last Modified By" := USERID;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
    end;

    var
        Member: Record Member;
        Agency: Record Agency;
}

