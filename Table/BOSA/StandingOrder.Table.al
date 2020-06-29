table 50080 "Standing Order"
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
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                DeleteRelatedLinks;
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(4; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Source Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Source Account No.") THEN BEGIN
                    "Source Account Name" := Vendor.Name;
                    "Source Account Balance" := ABS(Vendor."Balance (LCY)");
                END;
            end;
        }
        field(8; "Source Account Name"; Text[50])
        {
            Editable = false;
        }
        field(9; Running; Boolean)
        {
            Editable = false;
        }
        field(10; "Next Run Date"; Date)
        {
        }
        field(11; "Start Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "Start Date" < TODAY THEN
                    ERROR(Error000);
                "Next Run Date" := "Start Date";

                IF "Start Date" > "End Date" THEN
                    ERROR(Error001);
            end;
        }
        field(12; "End Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "Start Date" > "End Date" THEN
                    ERROR(Error001);
            end;
        }
        field(13; Frequency; DateFormula)
        {
        }
        field(14; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; "Created Date"; Date)
        {
            Editable = false;
        }
        field(17; "Created Time"; Time)
        {
            Editable = false;
        }
        field(18; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(19; "Total Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Standing Order Line"."Line Amount" WHERE("Document No." = FIELD("No.")));
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
        field(25; "Source Account Balance"; Decimal)
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

        IF "No." = '' THEN
            NoSeriesManagement.InitSeries(CBSSetup."Standing Order Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
        Description := Text000 + "No.";
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text000: Label 'Standing Order ';
        Member: Record Member;
        Vendor: Record "Vendor";
        Error000: Label 'Start Date cannot be a historical date';
        Error001: Label 'Start Date cannot be greater than End Date';

    local procedure DeleteRelatedLinks()
    var
        StandingOrderLine: Record "Standing Order Line";
    begin
        StandingOrderLine.RESET;
        StandingOrderLine.SETRANGE("Document No.", "No.");
        StandingOrderLine.DELETEALL;
    end;

    procedure StandingOrderLineExist(): Boolean
    var
        StandingOrderLine: Record "Standing Order Line";
    begin
        StandingOrderLine.RESET;
        StandingOrderLine.SETRANGE("Document No.", "No.");
        EXIT(StandingOrderLine.FINDFIRST);
    end;
}

