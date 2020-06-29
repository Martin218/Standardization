table 50155 "Loan Selloff"
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
        field(2; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application" WHERE(Posted = FILTER(true));

            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    VALIDATE("Member No.", LoanApplication."Member No.");
                    Description := LoanApplication.Description;
                    BOSAManagement.CalculateLoanArrears("Loan No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                    "Principal Arrears Amount" := ArrearsAmount[1];
                    "Interest Arrears Amount" := ArrearsAmount[2];
                    "Total Arrears Amount" := ArrearsAmount[1] + ArrearsAmount[2];
                END;
            end;
        }
        field(4; Description; Text[50])
        {
            Editable = false;
        }
        field(5; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(6; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(7; "Outstanding Balance"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE("Customer No." = FIELD("Loan No.")));
            Editable = false;

        }
        field(8; "Principal Arrears Amount"; Decimal)
        {
            Editable = false;
        }
        field(9; "Interest Arrears Amount"; Decimal)
        {
            Editable = false;
        }
        field(10; "Total Arrears Amount"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(11; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(13; "Created Date"; Date)
        {
            Editable = false;
        }
        field(14; "Created Time"; Time)
        {
            Editable = false;
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(17; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(18; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(19; "Institution Name"; Text[50])
        {
        }
        field(20; "Institution Branch Name"; Text[50])
        {
        }
        field(21; "Institution Address"; Text[50])
        {
        }
        field(25; Posted; Boolean)
        {
        }
        field(26; Remarks; Text[100])
        {
        }
        field(27; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
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
            NoSeriesManagement.InitSeries(CBSSetup."Loan Selloff Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        Member: Record Member;
        BOSAManagement: Codeunit "BOSA Management";
        LoanApplication: Record "Loan Application";
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LoanSelloffCharge: Record "Loan Selloff Charge";


    procedure Addattachment()
    begin
    end;
}

