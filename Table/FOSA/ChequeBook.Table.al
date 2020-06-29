table 50034 "Cheque Book"
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
        field(2; "Serial No."; Code[20])
        {
        }
        field(3; "Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin

                IF Member.GET("Member No.") THEN BEGIN
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;

                FindLastChequeBook;
            end;
        }
        field(4; "No. of Leaves"; Integer)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
                TESTFIELD("Account No.");
            end;
        }
        field(5; "Last Leaf Used"; Code[20])
        {
            Editable = false;
        }
        field(7; "Start Leaf No."; Code[20])
        {

            trigger OnValidate()
            begin
                TESTFIELD("No. of Leaves");

                IF IsNumeric("Start Leaf No.") > 0 THEN
                    ERROR(NumericValErr, FIELDCAPTION("Start Leaf No."));

                IF STRLEN("Start Leaf No.") <> 6 THEN
                    ERROR(LeafNoLenErr, FIELDCAPTION("Start Leaf No."), 6);
                "End Leaf No." := "Start Leaf No.";
                FOR i := 1 TO "No. of Leaves" - 1 DO
                    "End Leaf No." := INCSTR("End Leaf No.");

                VALIDATE("End Leaf No.");
            end;
        }
        field(8; "End Leaf No."; Code[20])
        {
            Editable = false;

            trigger OnValidate()
            begin
                TESTFIELD("No. of Leaves");

                IF IsNumeric("End Leaf No.") > 0 THEN
                    ERROR(NumericValErr, FIELDCAPTION("End Leaf No."));

                EVALUATE(StartLeafNo, "Start Leaf No.");
                EVALUATE(EndLeafNo, "End Leaf No.");

                IF StartLeafNo >= EndLeafNo THEN
                    ERROR(LeafNoValErr, FIELDCAPTION("Start Leaf No."), FIELDCAPTION("End Leaf No."));


                IF (EndLeafNo - StartLeafNo) + 1 <> "No. of Leaves" THEN
                    ERROR(LeavesCountValErr, FIELDCAPTION("No. of Leaves"), "No. of Leaves");

                IF STRLEN("End Leaf No.") <> 6 THEN
                    ERROR(LeafNoLenErr, FIELDCAPTION("End Leaf No."), 6);
            end;
        }
        field(9; "Member Name"; Text[50])
        {
        }
        field(10; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(11; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(12; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Issued';
            OptionMembers = New,Issued;
        }

        field(14; "Account No."; Code[20])
        {
            TableRelation = Vendor where("Member No." = Field("Member No."), Status = filter(0));

            trigger OnValidate()
            begin
                IF Vendor.GET("Account No.") THEN
                    "Account Name" := Vendor.Name;
            end;
        }
        field(15; "Account Name"; Text[50])
        {
            Editable = false;
        }
        field(16; Active; Boolean)
        {
        }
        field(17; "Issued Date"; Date)
        {
            Editable = false;
        }
        field(18; "Issued By"; Code[20])
        {
            Editable = false;
        }
        field(19; "Issued Time"; Time)
        {
            Editable = false;
        }
        field(20; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(21; "Created Date"; Date)
        {
            Editable = false;
        }
        field(22; "Created Time"; Time)
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

    trigger OnDelete()
    begin

    end;

    trigger OnInsert()
    begin
        CBSSetup.GET;
        IF "No." = '' THEN;
        NoSeriesManagement.InitSeries(CBSSetup."Cheque Book Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        Active := TRUE;
    end;

    var

        Member: Record Member;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        LeafNoValErr: Label '%1 cannot be greater than %2';
        LeavesCountValErr: Label '%1 must be equal to %2';

        Vendor: Record Vendor;
        LeafNoLenErr: Label '%1 Length must be equal to %2 digits';
        StartLeafNo: Integer;
        EndLeafNo: Integer;
        NumericValErr: Label '%1 cannot contain characters';
        i: Integer;


    procedure IsNumeric(Variant: Code[20]): Integer
    var
        j: Integer;
        i: Integer;
    begin
        FOR i := 1 TO STRLEN(Variant) DO BEGIN
            IF NOT (Variant[i] IN ['0' .. '9', '+']) THEN
                j += 1;
        END;
        EXIT(j);
    end;

    local procedure FindLastChequeBook()
    var
        ChequeBook: Record "Cheque Book";
    begin
        ChequeBook.RESET;
        ChequeBook.SETRANGE("Member No.", "Member No.");
        ChequeBook.SETRANGE(Status, ChequeBook.Status::Issued);
        IF ChequeBook.FINDLAST THEN BEGIN
            IF ChequeBook."End Leaf No." = ChequeBook."Last Leaf Used" THEN BEGIN
                "No. of Leaves" := ChequeBook."No. of Leaves";
                VALIDATE("Start Leaf No.", INCSTR(ChequeBook."End Leaf No."));
            END;
        END;
    end;
}

