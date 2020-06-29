table 50131 "Loan Rescheduling"
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
        field(2; "Member No."; Code[20])
        {
            Editable = false;
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application" WHERE(Posted = FILTER(true));

            trigger OnValidate()
            begin
                IF LoanApplication.GET("Loan No.") THEN BEGIN
                    LoanReschedulingSetup.GET;
                    "Rescheduling Option" := LoanReschedulingSetup."Rescheduling Option";
                    Description := LoanApplication.Description;
                    VALIDATE("Member No.", LoanApplication."Member No.");
                    "Approved Loan Amount" := LoanApplication."Approved Amount";
                    "Current Repayment Period" := LoanApplication."Repayment Period";
                    "Current Repayment Frequency" := LoanApplication."Repayment Frequency";
                    "Current Interest Rate" := LoanApplication."Interest Rate";
                END;
                IF Customer.GET("Loan No.") THEN BEGIN
                    Customer.CALCFIELDS("Balance (LCY)");
                    "Outstanding Loan Balance" := Customer."Balance (LCY)";
                END;
            end;
        }
        field(5; Description; Text[50])
        {
            Editable = false;
        }
        field(6; "Approved Loan Amount"; Decimal)
        {
            Editable = false;
        }
        field(7; "Outstanding Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(8; "Current Repayment Period"; Decimal)
        {
            Editable = false;
        }
        field(9; "New Repayment Period"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Loan No.");
                IF LoanApplication.GET("Loan No.") THEN;
                IF LoanProductType.GET(LoanApplication."Loan Product Type") THEN BEGIN
                    IF "New Repayment Period" > LoanProductType."Repayment Period" THEN
                        ERROR(Error000, FIELDCAPTION("New Repayment Period"));
                END;
            end;
        }
        field(13; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(14; "Created Date"; Date)
        {
            Editable = false;
        }
        field(15; "Created Time"; Time)
        {
            Editable = false;
        }
        field(16; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(20; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(21; Remarks; Text[150])
        {
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
        field(25; "Current Repayment Frequency"; Option)
        {
            Editable = false;
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(26; "New Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(27; "Current Interest Rate"; Decimal)
        {
            Editable = false;
        }
        field(28; "New Interest Rate"; Decimal)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Loan No.");
                IF LoanApplication.GET("Loan No.") THEN;
                IF LoanProductType.GET(LoanApplication."Loan Product Type") THEN BEGIN
                    IF "New Interest Rate" > LoanProductType."Interest Rate" THEN
                        ERROR(Error002, FIELDCAPTION("New Interest Rate"));
                END;
            end;
        }
        field(29; "Rescheduling Option"; Option)
        {
            Editable = false;
            OptionCaption = 'Repayment Period,Interest Rate,Repayment Frequency,All';
            OptionMembers = "Repayment Period","Interest Rate","Repayment Frequency",All;
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
            NoSeriesManagement.InitSeries(CBSSetup."Loan Rescheduling Nos.", xRec."No. Series", TODAY, "No.", "No. Series");

        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        LoanApplication: Record "Loan Application";
        Vendor: Record Vendor;
        LoanProductType: Record "Loan Product Type";
        Error000: Label '%1 cannot exceed the Maximum Repayment period set for this Loan Product';
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Member: Record Member;
        Customer: Record "Customer";
        Error001: Label 'You must attach supporting documents';
        Error002: Label '%1 cannot exceed the Maximum Interest Rate set for this Loan Product';
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";

    procedure ValidateAttachment()
    var
        LoanReschedulingSetup: Record "Loan Rescheduling Setup";
        CBSAttachment: Record "CBS Attachment";
    begin
        LoanReschedulingSetup.GET;
        IF LoanReschedulingSetup."Attachment Mandatory" THEN BEGIN
            CBSAttachment.RESET;
            CBSAttachment.SETRANGE("Document No.", "No.");
            IF NOT CBSAttachment.FINDFIRST THEN
                ERROR(Error001);
        END;
    end;

    procedure ValidateReschedulingOption()
    begin
        IF "Rescheduling Option" = "Rescheduling Option"::"Repayment Period" THEN
            TESTFIELD("New Repayment Period");
        IF "Rescheduling Option" = "Rescheduling Option"::"Interest Rate" THEN
            TESTFIELD("New Interest Rate");
        IF "Rescheduling Option" = "Rescheduling Option"::"Repayment Frequency" THEN
            TESTFIELD("New Repayment Frequency");
        IF "Rescheduling Option" = "Rescheduling Option"::All THEN BEGIN
            TESTFIELD("New Repayment Period");
            TESTFIELD("New Interest Rate");
            TESTFIELD("New Repayment Frequency");
        END;
    end;
}

