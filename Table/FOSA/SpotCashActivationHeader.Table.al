table 50070 "SpotCash Activation Header"
{
    // version TL2.0


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
        field(2; Description; Text[50])
        {
        }
        field(3; "Request Date"; Date)
        {
            Editable = false;
        }
        field(4; "Requested By"; Code[30])
        {
            Editable = false;
            TableRelation = "User Setup";
        }
        field(5; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(6; "No. Series"; Code[20])
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
        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(CBSSetup."SpotCash Activation Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Request Date" := TODAY;
        "Requested By" := USERID;
        Description := Text000 + "No.";
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text000: Label 'SpotCash Activation Request ';
}

