table 50120 "Payout Header"
{
    // version TL2.0

    DataCaptionFields = "No.", "Payout Type", Description;

    fields
    {
        field(1; "No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                IF "No." = '' THEN BEGIN
                    CBSSetup.GET;
                    "No." := NoSeriesManagement.GetNextNo(CBSSetup."Payout Nos.", 0D, TRUE);
                END;
            end;
        }
        field(2; "Payout Type"; Code[20])
        {
            TableRelation = "Payout Type";

            trigger OnValidate()
            begin
                IF PayoutType.GET("Payout Type") THEN
                    Description := PayoutType.Description;
            end;
        }
        field(3; Description; Text[100])
        {
            Editable = false;
        }
        field(5; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(7; "Payment Method"; Code[20])
        {
            TableRelation = "Payment Method".Code;
        }
        field(8; "Agency Code"; Code[20])
        {
            TableRelation = Agency;

            trigger OnValidate()
            begin
                IF Agency.GET("Agency Code") THEN BEGIN
                    "Agency Name" := Agency.Name;
                    IF Vendor.GET(Agency."Vendor No.") THEN BEGIN
                        Vendor.CALCFIELDS("Balance (LCY)");
                        "Agency Account Balance" := ABS(Vendor."Balance (LCY)");
                    END;
                END;
            end;
        }
        field(9; "Agency Name"; Text[50])
        {
            Editable = false;
        }
        field(11; "Total Payout Amount"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Payout Line"."Gross Amount" WHERE("Document No." = FIELD("No.")));
            Editable = false;

        }
        field(13; "Agency Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(14; "Created By"; Code[100])
        {
            Editable = false;
        }
        field(15; "Created Date"; Date)
        {
            Editable = false;
        }
        field(16; "Created Time"; Time)
        {
            Editable = false;
        }
        field(17; Posted; Boolean)
        {
            Editable = false;
        }
        field(18; "Posted By"; Code[100])
        {
            Editable = false;
        }
        field(19; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(20; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(21; "Payment Type"; Code[20])
        {
            TableRelation = "Payout Type";
        }
        field(22; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(23; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(24; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(25; Status; Option)
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
        IF "No." = '' THEN BEGIN
            CBSSetup.GET;
            "No." := NoSeriesManagement.GetNextNo(CBSSetup."Payout Nos.", 0D, TRUE);
            "Created By" := USERID;
            "Created Date" := TODAY;
            "Created Time" := TIME;
        END;
    end;

    var
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DimensionValue: Record "Dimension Value";
        TransactionTypes: Record "Transaction -Type";
        PayoutType: Record "Payout Type";
        Agency: Record Agency;
        Vendor: Record Vendor;
}

