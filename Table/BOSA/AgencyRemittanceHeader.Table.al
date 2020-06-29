table 50148 "Agency Remittance Header"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Agency Code"; Code[20])
        {

            trigger OnValidate()
            begin
                IF Agency.GET("Agency Code") THEN
                    "Agency Name" := Agency.Name;
            end;
        }
        field(3; "Agency Name"; Text[50])
        {
        }
        field(4; Description; Text[50])
        {
        }
        field(5; "Created By"; Code[20])
        {
        }
        field(6; "Created Date"; Date)
        {
        }
        field(7; "Created Time"; Time)
        {
        }
        field(8; "Period Month"; Text[20])
        {
        }
        field(9; "Period Year"; Integer)
        {
        }
        field(10; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(11; Status; Option)
        {
            OptionCaption = 'New,Exported,Imported,Posted';
            OptionMembers = New,Exported,Imported,Posted;
        }
        field(12; "Total Expected Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Agency Remittance Line"."Expected Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;

        }
        field(13; "Total Actual Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Agency Remittance Line"."Actual Amount" WHERE("Document No." = FIELD("No.")));
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
            NoSeriesManagement.InitSeries(CBSSetup."Agency Remittance Advice Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    var
        Member: Record Member;
        Agency: Record Agency;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
}
