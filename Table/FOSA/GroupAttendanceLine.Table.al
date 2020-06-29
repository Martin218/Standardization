table 52011 "Group Attendance Line"
{
    // version MC2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(4; "Member No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(5; "Member Name"; Text[100])
        {
        }
        field(6; Present; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Member No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;
}

