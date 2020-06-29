table 50036 "Cheque Book Application"
{
    // version CTS2.0


    fields
    {
        field(1; "No."; Code[20])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN;
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

                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    Signature := Member.Signature;

                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;
            END;
        }

        field(5; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(6; "Cheque Book No."; Code[20])
        {
            TableRelation = "Cheque Book" WHERE(Status = FILTER(New),
                                                        "Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF ChequeBook.GET("Cheque Book No.") THEN BEGIN
                    "No. of Leaves" := ChequeBook."No. of Leaves";
                    "Cheque Book S/No." := ChequeBook."Serial No.";
                    VALIDATE("Account No.", ChequeBook."Account No.");
                END;
            end;
        }
        field(7; "Cheque Book S/No."; Code[20])
        {
            Editable = false;
        }
        field(8; "No. of Leaves"; Integer)
        {
            Editable = false;
        }
        field(9; "Account No."; Code[20])
        {
            Editable = false;
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN BEGIN
                    "Account Name" := Vendor.Name;
                    AccountType.GET(Vendor."Account Type");
                    Vendor.CALCFIELDS("Balance (LCY)");
                    AccountBalance := ABS(Vendor."Balance (LCY)") - AccountType."Minimum Balance";
                    IF AccountBalance > 0 THEN
                        "Account Balance" := AccountBalance
                    ELSE
                        ERROR(InsuffAccBalErr);
                END;
            end;
        }
        field(10; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(11; "Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(12; "Created By"; Code[20])
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
        field(15; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(16; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(17; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(18; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(19; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; Signature; Media)
        {
        }
        field(22; "Global Dimension 1 Code"; Code[20])
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
            NoSeriesManagement.InitSeries(CBSSetup."Cheque Book Application Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        Description := STRSUBSTNO(ChkBookDesc, "No.");
    end;

    var
        Member: Record Member;

        ChequeBook: Record "Cheque Book";
        Vendor: Record Vendor;
        AccountType: Record "Account Type";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        AccountBalance: Decimal;
        InsuffAccBalErr: Label 'Insufficient Account Balance';
        ChkBookDesc: Label 'Cheque Book  Issuance %1';

        SignatureText: Text;
}

