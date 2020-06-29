table 50163 "Loan Writeoff Header"
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
        field(9; "Posted By"; Code[20])
        {
            Editable = false;
        }
        field(10; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(11; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(12; Posted; Boolean)
        {
            Editable = false;
        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Total Writeoff Amount"; Decimal)
        {
            CalcFormula = Sum ("Loan Writeoff Line"."Outstanding Balance" WHERE("Document No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; Remarks; Text[250])
        {
        }
        field(16; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
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
            NoSeriesManagement.InitSeries(CBSSetup."Loan Writeoff Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
        Description := STRSUBSTNO(Text000, "No.");
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        BOSAManagement: Codeunit "BOSA Management";
        Text000: Label 'Loan Writeoff Request %1';
}

