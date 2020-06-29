table 52018 "Group Allocation Header"
{
    // version MC2.0

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; Description; Text[50])
        {
        }
        field(3; "Group No."; Code[20])
        {
            Caption = 'Group No.';
            TableRelation = Member;//; WHERE(Category = FILTER(Group));

            trigger OnValidate()
            begin
                DeleteRelatedLinks;
                IF Member.GET("Group No.") THEN BEGIN
                    //"Last Meeting Date" := MicroCreditManagement.GetLastAttendanceDate("Group No.");
                    // "Current Meeting Date" := CALCDATE('-' + FORMAT(Member."Group Meeting Frequency"), MicroCreditManagement.GetNextMeetingDate("Group No."));
                    "Group Name" := Member."Full Name";
                    "Loan Officer ID" := Member."Loan Officer ID";
                    Description := Text000 + FORMAT("Current Meeting Date");
                    // MicroCreditManagement.CopyCollectionEntries("No.", "Group No.", 0D, "Current Meeting Date");
                END;
            end;
        }
        field(4; "Group Name"; Text[50])
        {
            Caption = 'Group Name';
            Editable = false;
        }
        field(6; "Loan Officer ID"; Code[20])
        {
            Editable = false;
            TableRelation = "Loan Officer Setup";
        }
        field(7; "Created Date"; Date)
        {
            Editable = false;
        }
        field(8; "Created Time"; Time)
        {
            Editable = false;
        }
        field(9; Status; Option)
        {
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; Posted; Boolean)
        {
            Editable = false;
        }
        field(12; "Last Meeting Date"; Date)
        {
            Editable = false;
        }
        field(15; "Current Meeting Date"; Date)
        {
            Editable = false;
        }
        field(16; "Total Collected Amount"; Decimal)
        {
            CalcFormula = Sum ("Group Allocation Line"."Amount to Allocate" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(17; "Total Allocated Amount"; Decimal)
        {
            CalcFormula = Sum ("Group Member Allocation"."Allocation Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18; "Total Remaining Amount"; Decimal)
        {
            CalcFormula = Sum ("Group Allocation Line"."Remaining Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(19; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(20; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(21; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(22; "Approved Time"; Time)
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

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::New);
        DeleteRelatedLinks;
    end;

    trigger OnInsert()
    begin
        CBSSetup.GET;
        NoSeriesManagement.InitSeries(CBSSetup."Group Allocation Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Member: Record Member;
        Text000: Label 'Allocation for Meeting ';
    //MicroCreditManagement: Codeunit "55001";

    procedure CheckAllocationEntriesExist(): Boolean
    var
        GroupMemberAllocation: Record "Group Member Allocation";
    begin
        GroupMemberAllocation.RESET;
        GroupMemberAllocation.SETRANGE("Document No.", "No.");
        EXIT(GroupMemberAllocation.FINDFIRST);
    end;

    local procedure DeleteRelatedLinks()
    var
        GroupAllocationLine: Record "Group Allocation Line";
        GroupMemberAllocation: Record "Group Member Allocation";
    begin
        GroupAllocationLine.RESET;
        GroupAllocationLine.SETRANGE("Document No.", "No.");
        GroupAllocationLine.DELETEALL;

        GroupMemberAllocation.RESET;
        GroupMemberAllocation.SETRANGE("Document No.", "No.");
        GroupMemberAllocation.DELETEALL;
    end;
}

