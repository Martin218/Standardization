table 50064 "ATM Activation Line"
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
        field(6; "Current ATM Status"; Option)
        {
            Editable = false;
            OptionCaption = 'Active,Frozen';
            OptionMembers = Active,Frozen;
        }
        field(7; "New ATM Status"; Option)
        {
            OptionCaption = 'Active,Dormant,Withdrawn,Deceased';
            OptionMembers = Active,Dormant,Withdrawn,Deceased;
        }
        field(8; "Activation Code"; Code[20])
        {
            TableRelation = "Activation Type" WHERE("Application Area" = FILTER(ATM));

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
        field(12; "Card No."; Code[20])
        {
            TableRelation = "ATM Member";

            trigger OnValidate()
            begin
                IF ATMCard.GET("Card No.") THEN BEGIN
                    "Member No." := ATMCard."Member No.";
                    "Member Name" := ATMCard."Member Name";
                    "Account No." := ATMCard."Account No.";
                    "Account Name" := ATMCard."Account Name";
                    "Current ATM Status" := ATMCard.Status;
                END;
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
        Member: Record Member;
        ATMCard: Record "ATM Member";
}

