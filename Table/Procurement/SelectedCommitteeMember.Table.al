table 50419 "Selected Committee Member"
{

    fields
    {
        field(1; "User ID"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(2; "Process No."; Code[20])
        {
        }
        field(3; "Committee Code"; Code[10])
        {
            TableRelation = "Procurement Committee Setup";

            trigger OnValidate();
            begin
                IF ProcurementCommitteeSetup.GET("Committee Code") THEN
                    Description := ProcurementCommitteeSetup.Description;
            end;
        }
        field(4; Description; Text[70])
        {
        }
        field(5; "Process Stage"; Option)
        {
            OptionCaption = '" ,Opening,Approval,Evaluation,Disposal,I&Acceptance"';
            OptionMembers = " ",Opening,Approval,Evaluation,Disposal,"I&Acceptance";
        }
        field(6; "Employee No."; Code[10])
        {
        }
        field(7; Position; Option)
        {
            OptionCaption = '" ,Chair Person,Secretary,Member"';
            OptionMembers = " ","Chair Person",Secretary,Member;

            trigger OnLookup();
            var
                SelectedCommitteeMember: Record "Selected Committee Member";
            begin
            end;

            trigger OnValidate();
            begin
                IF Position = Position::"Chair Person" THEN BEGIN
                    SelectedCommitteeMember.RESET;
                    SelectedCommitteeMember.SETRANGE("Process No.", "Process No.");
                    SelectedCommitteeMember.SETRANGE(Position, Position);
                    SelectedCommitteeMember.SETRANGE("Committee Code", "Committee Code");
                    SelectedCommitteeMember.SETRANGE("User ID", '<>%1', USERID);
                    IF SelectedCommitteeMember.FINDFIRST THEN BEGIN
                        ERROR(ChairPersonErr, SelectedCommitteeMember."User ID");
                    END;
                END;
            end;
        }
    }

    keys
    {
        key(Key1; "User ID", "Process No.", "Committee Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        ProcurementCommitteeSetup: Record "Procurement Committee Setup";
        SelectedCommitteeMember: Record "Selected Committee Member";
        ChairPersonErr: Label 'You already have a Chair Person %1.';
}

