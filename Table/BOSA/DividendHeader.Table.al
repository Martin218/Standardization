table 50157 "Dividend Header"
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
        field(2; Description; Text[50])
        {
            Editable = false;
        }
        field(3; "Period Code"; Code[20])
        {
            Editable = false;
        }
        field(7; "Total Amount"; Decimal)
        {
            CalcFormula = Sum ("Dividend Line"."Gross Earning Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Created By"; Code[20])
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
        field(12; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(13; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(14; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; Posted; Boolean)
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

    trigger OnInsert()
    begin
        CBSSetup.GET;

        IF "No." = '' THEN BEGIN
            NoSeriesManagement.InitSeries(CBSSetup."Dividend Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
        "Period Code" := FORMAT(DATE2DMY(TODAY, 3));
        Description := STRSUBSTNO(Text000, DATE2DMY(TODAY, 3));
    end;

    var
        Member: Record Member;
        Vendor: Record Vendor;
        AccountTypes: Record "Account Type";
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BOSAManagement: Codeunit "BOSA Management";
        Text000: Label 'Dividend for Year %1';
}

