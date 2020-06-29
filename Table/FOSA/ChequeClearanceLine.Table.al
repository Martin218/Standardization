table 50076 "Cheque Clearance Line"
{
    // version CTS2.0


    fields
    {
        field(1; "Document No."; Code[20])
        {
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; "Account No."; Code[20])
        {
            Editable = false;
        }
        field(4; "Serial No."; Code[20])
        {
            Editable = false;
        }
        field(5; "Sort Code"; Code[10])
        {
            Editable = false;
        }
        field(6; Amount; Decimal)
        {
            Editable = false;
        }
        field(7; "Voucher Type"; Code[10])
        {
            Editable = false;
        }
        field(8; "Posting Date"; Code[10])
        {
            Editable = false;
        }
        field(9; "Processing Date"; Code[10])
        {
            Editable = false;
        }
        field(10; Indicator; Code[10])
        {
            Editable = false;
        }
        field(11; "Unpaid Reason"; Text[100])
        {
            Editable = false;
        }
        field(12; "Unpaid Code"; Code[10])
        {
            TableRelation = "CC Reason Code";

            trigger OnValidate()
            begin
                IF CCReasonCode.GET("Unpaid Code") THEN
                    "Unpaid Reason" := CCReasonCode.Description;
            end;
        }
        field(13; "Presenting Bank"; Code[10])
        {
            Editable = false;
        }
        field(14; "Currency Code"; Code[10])
        {
            Editable = false;
        }
        field(15; Session; Code[10])
        {
            Editable = false;
        }
        field(16; "Bank No."; Code[10])
        {
            Editable = false;
        }
        field(17; "Branch No."; Code[10])
        {
            Editable = false;
        }
        field(18; "Sacco Account No."; Code[20])
        {
            Editable = false;
        }
        field(19; Validated; Boolean)
        {
            Editable = false;
        }
        field(22; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                TESTFIELD(Select, TRUE);


                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;

                ValidateChequeBook;
            end;
        }
        field(23; "Member Name"; Text[50])
        {
            Editable = false;
        }

        field(25; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(26; Description; Text[50])
        {
        }
        field(27; "Savings Account No."; Code[20])
        {
            TableRelation = Vendor WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                IF Vendor.GET("Savings Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(28; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(29; Select; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        CCReasonCode: Record "CC Reason Code";
        Member: Record Member;

        Vendor: Record Vendor;
        NoChequeBookErr: Label 'No Active Cheque Book found for this member.';

    procedure LinesExist(DocumentNo: Code[20]): Boolean
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", DocumentNo);
        EXIT(ChequeClearanceLine.FINDFIRST);
    end;

    procedure LinesNotValidated(DocumentNo: Code[20]): Boolean
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", DocumentNo);
        ChequeClearanceLine.SETRANGE(Validated, FALSE);
        EXIT(ChequeClearanceLine.FINDFIRST);
    end;

    procedure MoreValidations(DocumentNo: Code[20])
    var
        ChequeClearanceLine: Record "Cheque Clearance Line";
    begin
        ChequeClearanceLine.RESET;
        ChequeClearanceLine.SETRANGE("Document No.", DocumentNo);
        IF ChequeClearanceLine.FINDSET THEN BEGIN
            REPEAT
                ChequeClearanceLine.TESTFIELD("Member No.");
                ChequeClearanceLine.TESTFIELD(Description);
                ChequeClearanceLine.TESTFIELD(Indicator);
            UNTIL ChequeClearanceLine.NEXT = 0;
        END;
    end;

    local procedure ValidateChequeBook()
    var
        ChequeBookHeader: Record "Cheque Book";
    begin
        ChequeBookHeader.RESET;
        ChequeBookHeader.SETRANGE("Member No.", "Member No.");
        ChequeBookHeader.SETRANGE(Status, ChequeBookHeader.Status::Issued);
        ChequeBookHeader.SETRANGE(Active, TRUE);
        IF ChequeBookHeader.FINDFIRST THEN
            VALIDATE("Savings Account No.", ChequeBookHeader."Account No.")
        ELSE
            ERROR(NoChequeBookErr);
    end;
}
