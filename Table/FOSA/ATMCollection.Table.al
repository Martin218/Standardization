table 50061 "ATM Collection"
{
    // version TL2.0

    DrillDownPageID = "Approved ATM Collection List";
    LookupPageID = "Approved ATM Collection List";

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
        field(2; "Application No."; Code[20])
        {
            TableRelation = "ATM Application" WHERE(Status = FILTER(Approved));

            trigger OnValidate()
            begin
                IF ATMApplication.GET("Application No.") THEN BEGIN
                    "Member No." := ATMApplication."Member No.";
                    "Member Name" := ATMApplication."Member Name";
                    "Account No." := ATMApplication."Account No.";
                    "Account Name" := ATMApplication."Account Name";
                    "Card No." := ATMApplication."Card No.";
                END;
            end;
        }
        field(3; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(5; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor;
        }
        field(6; "Account Name"; Code[20])
        {
            Editable = false;
        }

        field(8; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(9; "Created Time"; Time)
        {
            Editable = false;
        }
        field(10; "Created Date"; Date)
        {
            Editable = false;
        }

        field(11; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(12; "Card No."; Code[20])
        {
            Editable = false;
        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
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
            NoSeriesManagement.InitSeries(CBSSetup."ATM Collection Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        ATMApplication: Record "ATM Application";
}

