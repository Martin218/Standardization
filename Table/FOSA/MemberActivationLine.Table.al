table 50008 "Member Activation Line"
{
    // version TL2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Application No.";
                    "National ID" := Member."National ID";
                    "Current Member Status" := Member.Status;
                END;
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "National ID"; Code[20])
        {
            Editable = false;
        }
        field(6; "Current Member Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(7; "New Member Status"; Option)
        {
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(8; "Activation Code"; Code[20])
        {
            TableRelation = "Activation Type" WHERE("Application Area" = FILTER(Member));

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record "Member";
    //FOSAActivationType: Record "fosa ac";
    // FOSAActivationChargeLine: Record "fosa act";
}

