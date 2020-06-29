table 50075 "Cheque Clearance Header"
{
    // version CTS2.0


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
        field(3; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(4; "Created Date"; Date)
        {
            Editable = false;
        }
        field(5; "Created Time"; Time)
        {
            Editable = false;
        }
        field(6; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(7; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(8; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(9; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(12; "Approver ID"; Code[30])
        {
            Editable = false;
        }
        field(13; "Substitute ID"; Code[30])
        {
            Editable = false;
        }
        field(14; Posted; Boolean)
        {
        }
        field(15; "Cleared By"; Code[20])
        {
        }
        field(16; "Cleared Date"; Date)
        {
        }
        field(17; "Cleared Time"; Time)
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

    trigger OnDelete()
    begin
        DeleteRelatedLinks;
    end;

    trigger OnInsert()
    begin
        CBSSetup.GET;
        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(CBSSetup."Cheque Clearance Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        Description := STRSUBSTNO(ChkBookDesc, "No.");
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ChequeClearanceLine: Record "Cheque Clearance Line";
        CBSSetup: Record "CBS Setup";
        ChkBookDesc: Label 'Cheque Book Clearance %1';

    local procedure DeleteRelatedLinks()
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", "No.");
        ChequeClearanceLine.DELETEALL;
    end;
}

