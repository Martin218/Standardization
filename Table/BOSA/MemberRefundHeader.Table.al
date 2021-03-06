table 50117 "Member Refund Header"
{
    // version TL2.0


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
        field(2; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                DeleteRelatedLinks;
                DeleteRefundLines;
                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    Description := STRSUBSTNO(Text000, "Member Name");
                END;
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(8; "Reason Code"; Code[10])
        {
            TableRelation = "Exit Reason";

            trigger OnValidate()
            begin
                IF ExitReason.GET("Reason Code") THEN
                    "Reason for Exit" := ExitReason.Description;
            end;
        }
        field(9; "Reason for Exit"; Text[50])
        {
            Editable = false;
        }
        field(10; "Exit No."; Code[20])
        {
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(17; "Created By"; Code[20])
        {
        }
        field(18; "Created Date"; Date)
        {
            Editable = false;
        }
        field(19; "Created Time"; Time)
        {
            Editable = false;
        }
        field(22; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(23; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(24; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(25; Remarks; Text[50])
        {
        }
        field(26; Posted; Boolean)
        {
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
        CBSSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(CBSSetup."Refund Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        Vendor: Record Vendor;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Member: Record Member;
        Customer: Record "Customer";
        ExitReason: Record "Exit Reason";
        Text000: Label 'Refund request for %1';

    local procedure DeleteRelatedLinks()
    var
        MemberRefundLine: Record "Member Refund Line";
    begin
        MemberRefundLine.RESET;
        MemberRefundLine.SETRANGE("Document No.", "No.");
        MemberRefundLine.DELETEALL;
    end;

    local procedure DeleteRefundLines()
    var
        MemberRefundLine: Record "Member Refund Line";
    begin
        MemberRefundLine.RESET;
        MemberRefundLine.SETRANGE("Document No.", "No.");
        MemberRefundLine.DELETEALL;
    end;

    local procedure GetLastLineNo(): Integer
    var
        MemberRefundLine: Record "Member Refund Line";
        LineNo: Integer;
    begin
        MemberRefundLine.RESET;
        MemberRefundLine.SETRANGE("Document No.", "No.");
        IF MemberRefundLine.FINDLAST THEN
            LineNo := MemberRefundLine."Line No."
        ELSE
            LineNo := 0;
        EXIT(LineNo);
    end;
}

