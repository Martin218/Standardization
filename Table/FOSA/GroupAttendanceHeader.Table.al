table 52010 "Group Attendance Header"
{
    // version MC2.0

    Caption = 'Group Attendance Header';
    DataCaptionFields = "No.", "Group No.", "Group Name";

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;
        }
        field(2; "Group No."; Code[20])
        {
            TableRelation = Member."No." WHERE(Category = FILTER(Group));

            trigger OnValidate()
            begin
                DeleteAttendanceLine;
                IF Member.GET("Group No.") THEN BEGIN
                    "Group Name" := Member."Full Name";
                    "Meeting Venue" := Member."Group Meeting Venue";
                    //"Last Meeting Date" := MicroCreditManagement.GetLastAttendanceDate("Group No.");
                    //"Current Meeting Date" := CALCDATE('-' + FORMAT(Member."Group Meeting Frequency"), MicroCreditManagement.GetNextMeetingDate("Group No."));
                    "Current Meeting Time" := Member."Group Meeting Time";
                    "Loan Officer ID" := Member."Loan Officer ID";
                    GetGroupMembers("Group No.");
                END;
            end;
        }
        field(3; "Current Meeting Date"; Date)
        {
            Editable = false;
        }
        field(4; "Meeting Venue"; Text[100])
        {
            Editable = false;
        }
        field(5; "Loan Officer ID"; Code[100])
        {
            Editable = false;
        }
        field(6; Remarks; Text[250])
        {
        }
        field(7; "Last Meeting Date"; Date)
        {
            Editable = false;
        }
        field(8; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Group Name"; Text[150])
        {
            Editable = false;
        }
        field(10; "Created Date"; Date)
        {
            Editable = false;
        }
        field(11; "Created Time"; Time)
        {
            Editable = false;
        }
        field(12; "Validated Date"; Date)
        {
            Editable = false;
        }
        field(13; "Validated Time"; Time)
        {
            Editable = false;
        }
        field(14; "Current Meeting Time"; Time)
        {
            Editable = false;
        }
        field(15; "Actual Meeting Date"; Date)
        {
        }
        field(16; "Actual Meeting Time"; Time)
        {
        }
        field(17; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Validated';
            OptionMembers = New,Validated;
        }
        field(18; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(19; "Validated By"; Code[20])
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
        fieldgroup(DropDown; "No.", "Group No.", "Current Meeting Date", "Loan Officer ID")
        {
        }
        fieldgroup(Brick; "No.", "Group No.", "Current Meeting Date", "Loan Officer ID")
        {
        }
    }

    trigger OnDelete()
    begin
        TESTFIELD(Status, Status::New);
        DeleteRelatedLinks;
    end;

    trigger OnInsert()
    begin
        CBSSetup.GET;
        CBSSetup.GET;
        NoSeriesManagement.InitSeries(CBSSetup."Group Attendance Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanOfficerSetup: Record "Loan Officer Setup";
        Error000: Label 'You have not been set up as a loan officer!';
        Member: Record Member;
    //MicroCreditManagement: Codeunit "55001";

    local procedure GetGroupMembers(GroupNo: Code[20])
    var
        Member: Record "Member";
        GroupAttendanceLine: Record "Group Attendance Line";
    begin
        Member.RESET;
        Member.SETRANGE("Group Link No.", GroupNo);
        Member.SETRANGE(Status, Member.Status::Active);
        //Member.SETRANGE("Exit Status", Member."Exit Status"::" ");
        IF Member.FINDSET THEN BEGIN
            REPEAT
                GroupAttendanceLine.INIT;
                GroupAttendanceLine."Document No." := "No.";
                GroupAttendanceLine.VALIDATE("Member No.", Member."No.");
                GroupAttendanceLine.INSERT;
            UNTIL Member.NEXT = 0;
        END;
    end;

    local procedure DeleteRelatedLinks()
    var
        GroupAttendanceLine: Record "Group Attendance Line";
    begin
        GroupAttendanceLine.RESET;
        GroupAttendanceLine.SETRANGE("Document No.", "No.");
        GroupAttendanceLine.DELETEALL;
    end;

    local procedure DeleteAttendanceLine()
    var
        GroupAttendanceLine: Record "Group Attendance Line";
    begin
        GroupAttendanceLine.RESET;
        GroupAttendanceLine.SETRANGE("Document No.", "No.");
        GroupAttendanceLine.DELETEALL;
    end;
}

