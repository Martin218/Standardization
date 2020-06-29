table 50060 "ATM Application"
{
    // version TL2.0

    DrillDownPageID = "Approved ATM Application List";
    LookupPageID = "Approved ATM Application List";

    fields
    {
        field(1; "No."; Code[20])
        {

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
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Account No."; Code[20])
        {

        }
        field(5; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Created Date"; Date)
        {
            Editable = false;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Card No."; Code[20])
        {
        }
        field(9; "SMS Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(10; "E-Mail Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(11; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(12; "No. Series"; Code[20])
        {
        }
        field(13; "Created Time"; Time)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Member No.")
        {
        }
        key(Key3; "Member Name")
        {
        }
        key(Key4; "Account No.")
        {
        }
        key(Key5; "Account Name")
        {
        }

    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Member No.", "Member Name", "Created Date")
        {
        }
        fieldgroup(Brick; "No.", "Member No.", "Member Name", "Created Date")
        {
        }
    }

    trigger OnInsert()
    begin
        CBSSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(CBSSetup."ATM Application Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created By" := USERID;
        "Created Time" := Time;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        Member: Record Member;
        Vendor: Record Vendor;
}

