table 50071 "SpotCash Activation Line"
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
            TableRelation = "SpotCash Member";

            trigger OnValidate()
            begin
                IF SpotCashMember.GET("Member No.") THEN BEGIN
                    "Member Name" := SpotCashMember."Member Name";
                    "Phone No." := SpotCashMember."Phone No.";
                    "Account No." := SpotCashMember."Account No.";
                    "Account Name" := SpotCashMember."Account Name";
                END;
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Current Member Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }
        field(7; "New Member Status"; Option)
        {
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(8; "Activation Code"; Code[20])
        {
            TableRelation = "Activation Type" WHERE("Application Area" = FILTER(SpotCash));

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
            end;
        }
        field(9; "Account No."; Code[30])
        {
        }
        field(11; "Account Name"; Text[50])
        {
        }
        field(12; "Phone No."; Code[20])
        {
            TableRelation = "ATM Member";
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
        SpotCashMember: Record "SpotCash Member";
}

