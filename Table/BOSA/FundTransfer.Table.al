table 50134 "Fund Transfer"
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
            TableRelation = Member;

            trigger OnValidate()
            begin
                IF Rec."Member No." <> xRec."Member No." THEN BEGIN
                    ClearSourceField;
                    ClearDestinationField;
                END;

                IF Member.GET("Member No.") THEN
                    "Member Name" := Member."Full Name";
            end;
        }
        field(3; "Member Name"; Text[50])
        {
            Editable = false;
        }
        field(4; "Source Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;

            trigger OnValidate()
            begin
                ClearDestinationField;
                IF (("Source Account Type" = "Source Account Type"::Customer)) AND (("Destination Account Type" = "Destination Account Type"::Customer)) THEN
                    ERROR(Error003);
            end;
        }
        field(6; "Source Account No."; Code[20])
        {
            TableRelation = IF ("Source Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Member No."))
            ELSE
            IF ("Source Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Member No."));

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
                IF "Source Account Type" = "Source Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Source Account No.") THEN
                        "Source Account Name" := Vendor.Name;
                    "Source Account Balance" := BOSAManagement.GetAccountBalance(0, "Source Account No.");
                END;
                IF "Source Account Type" = "Source Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Source Account No.") THEN
                        "Source Account Name" := Customer.Name;
                    "Source Account Balance" := BOSAManagement.GetAccountBalance(1, "Source Account No.");
                END;

                IF "Source Account No." = "Destination Account No." THEN
                    ERROR(Error010, FIELDCAPTION("Source Account No."), FIELDCAPTION("Destination Account No."));
            end;
        }
        field(7; "Source Account Name"; Text[50])
        {
            Editable = false;
        }
        field(8; "Destination Account No."; Code[20])
        {
            TableRelation = IF ("Destination Account Type" = FILTER(Vendor)) Vendor WHERE("Member No." = FIELD("Destination Member No."))
            ELSE
            IF ("Destination Account Type" = FILTER(Customer)) Customer WHERE("Member No." = FIELD("Destination Member No."));

            trigger OnValidate()
            begin
                IF "Destination Account Type" = "Destination Account Type"::Vendor THEN BEGIN
                    IF Vendor.GET("Destination Account No.") THEN
                        "Destination Account Name" := Vendor.Name;
                    "Destination Account Balance" := BOSAManagement.GetAccountBalance(0, "Destination Account No.");
                END;
                IF "Destination Account Type" = "Destination Account Type"::Customer THEN BEGIN
                    IF Customer.GET("Destination Account No.") THEN
                        "Destination Account Name" := Customer.Name;
                    "Destination Account Balance" := BOSAManagement.GetAccountBalance(1, "Destination Account No.");
                    BOSAManagement.CalculateLoanArrears("Destination Account No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                    "Principal Arrears" := ArrearsAmount[1];
                    "Interest Arrears" := ArrearsAmount[2];
                    "Total Arrears" := ArrearsAmount[1] + ArrearsAmount[2];
                END;
                IF "Source Account No." = "Destination Account No." THEN
                    ERROR(Error010, FIELDCAPTION("Source Account No."), FIELDCAPTION("Destination Account No."));
            end;
        }
        field(9; "Destination Account Name"; Text[50])
        {
            Editable = false;
        }
        field(10; "Source Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(11; "Destination Account Balance"; Decimal)
        {
            Editable = false;
        }
        field(12; "Total Arrears"; Decimal)
        {
            DecimalPlaces = 2 : 2;
            Editable = false;
        }
        field(13; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(14; "Pay from Guarantors"; Boolean)
        {

            trigger OnValidate()
            begin
                TESTFIELD("Destination Account Type", "Destination Account Type"::Customer);
                //TESTFIELD("Destination Member No.");
                TESTFIELD("Destination Account No.");
                TESTFIELD("Total Arrears");
            end;
        }
        field(15; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(16; "Created By"; Code[20])
        {
            Editable = false;
        }
        field(17; "Created Date"; Date)
        {
            Editable = false;
        }
        field(18; "Created Time"; Time)
        {
            Editable = false;
        }
        field(19; "Pay from Member"; Boolean)
        {
            Editable = false;
        }
        field(20; "Amount to Transfer"; Decimal)
        {

            trigger OnValidate()
            begin
                FundTransferSetup.GET;
                IF (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                    AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
                   (("Source Account Balance" < "Amount to Transfer") AND (NOT FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                    AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
                   (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (NOT FundTransferSetup."Recover Destination Arrears")
                    AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction")) OR
                   (("Source Account Balance" < "Amount to Transfer") AND (FundTransferSetup."Recover Source Arrears") AND (FundTransferSetup."Recover Destination Arrears")
                    AND (NOT FundTransferSetup."Allow Overdrawing") AND (NOT FundTransferSetup."Allow Partial Deduction"))
                THEN BEGIN
                    ERROR(Error000, FIELDCAPTION("Amount to Transfer"), FIELDCAPTION("Source Account Balance"));
                END;
            end;
        }
        field(21; "Principal Arrears"; Decimal)
        {
            Editable = false;
        }
        field(22; "Interest Arrears"; Decimal)
        {
            Editable = false;
        }
        field(23; Posted; Boolean)
        {
        }
        field(24; "Amount to Pay from Guarantors"; Decimal)
        {
            Caption = 'Amount to Pay-Guarantor';
            Editable = false;
        }
        field(27; Description; Text[50])
        {
            Editable = false;
        }
        field(28; "Overpayment-Principal"; Decimal)
        {
            Editable = false;
        }
        field(29; "Overpayment-Interest"; Decimal)
        {
            Editable = false;
        }
        field(30; "Overpayment-Total"; Decimal)
        {
            Editable = false;
        }
        field(31; "Approved By"; Code[20])
        {
            Editable = false;
        }
        field(32; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(33; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(34; "Destination Account Type"; Option)
        {
            OptionCaption = 'Vendor,Customer';
            OptionMembers = Vendor,Customer;

            trigger OnValidate()
            begin
                ClearDestinationField;
                IF (("Source Account Type" = "Source Account Type"::Customer)) AND (("Destination Account Type" = "Destination Account Type"::Customer)) THEN
                    ERROR(Error003);
            end;
        }
        field(35; "Destination Account Ownership"; Option)
        {
            OptionCaption = ' ,Self,Other Member';
            OptionMembers = " ",Self,"Other Member";

            trigger OnValidate()
            begin
                IF "Destination Account Ownership" = "Destination Account Ownership"::Self THEN BEGIN
                    "Destination Member No." := "Member No.";
                    "Destination Member Name" := "Member Name";
                END ELSE BEGIN
                    "Destination Member No." := '';
                    "Destination Member Name" := '';
                END;
                "Destination Account No." := '';
                "Destination Account Name" := '';
                "Destination Account Balance" := 0;
                "Destination Loan No." := '';
                "Dest. Loan Description" := '';
                "Dest. Loan Balance" := 0;
            end;
        }
        field(36; "Destination Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                TESTFIELD("Member No.");
                TESTFIELD("Source Account No.");
                TESTFIELD("Destination Account Ownership");
                IF Member.GET("Destination Member No.") THEN BEGIN
                    IF "Destination Account Ownership" = "Destination Account Ownership"::Self THEN BEGIN
                        IF "Destination Member No." <> "Member No." THEN
                            ERROR(Error008, FIELDCAPTION("Destination Member No."), "Member No.", "Member Name");
                        "Destination Loan No." := '';
                        "Dest. Loan Description" := '';
                        "Dest. Loan Balance" := 0;
                    END;
                    IF "Destination Account Ownership" = "Destination Account Ownership"::"Other Member" THEN BEGIN
                        IF "Destination Member No." = "Member No." THEN
                            ERROR(Error009, FIELDCAPTION("Destination Member No."), "Member No.", "Member Name");
                    END;
                    "Destination Member Name" := Member."Full Name"
                END;
            end;
        }
        field(37; Remarks; Text[150])
        {
        }
        field(40; "Destination Member Name"; Text[50])
        {
            Editable = false;
        }
        field(41; "Source Loan No."; Code[20])
        {
            Editable = false;
        }
        field(42; "Source Loan Description"; Text[50])
        {
            Editable = false;
        }
        field(43; "Source Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(44; "Destination Loan No."; Code[20])
        {
        }
        field(45; "Dest. Loan Description"; Text[50])
        {
            Editable = false;
        }
        field(46; "Dest. Loan Balance"; Decimal)
        {
            Editable = false;
        }
        field(47; "Source Has Loan"; Boolean)
        {
        }
        field(48; "Dest. Has Loan"; Boolean)
        {
        }
        field(49; "Amount Transferred"; Decimal)
        {
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
            NoSeriesManagement.InitSeries(CBSSetup."Fund Transfer Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
            Description := Text000 + "No."
        END;
        "Created Date" := TODAY;
        "Created Time" := TIME;
        "Created By" := USERID;
    end;

    var
        BOSAManagement: Codeunit "BOSA Management";
        Vendor: Record Vendor;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;

        ArrearsAmount: array[6] of Decimal;
        OverpaymentAmount: array[6] of Decimal;
        Customer: Record "Customer";
        Member: Record Member;
        Error000: Label '%1 cannot exceed %2';
        Text000: Label 'Fund Transfer ';
        Error003: Label 'Loan to Loan Transfer is not allowed';
        Error004: Label '%1 must be a Loan Account';
        Error005: Label '%1 must NOT be a Loan Account';
        Error006: Label 'Loan %1 has no overpayment';
        Error007: Label '%1 cannot exceed the %2';
        Error008: Label '%1 must be %2 %3';
        Error009: Label '%1 must NOT be %2 %3';
        Error010: Label '%1 and %2 cannot be the same';
        FundTransferSetup: Record "Fund Transfer Setup";

    procedure ClearSourceField()
    begin
        //"Member No.":='';
        "Member Name" := '';
        "Source Account No." := '';
        "Source Account Name" := '';
        "Source Account Balance" := 0;
        "Source Has Loan" := FALSE;
        "Source Loan No." := '';
        "Source Loan Description" := '';
        "Source Loan Balance" := 0;
    end;

    procedure ClearDestinationField()
    begin
        "Destination Member No." := '';
        "Destination Member Name" := '';
        "Destination Account No." := '';
        "Destination Account Name" := '';
        "Dest. Has Loan" := FALSE;
        "Destination Loan No." := '';
        "Dest. Loan Description" := '';
        "Dest. Loan Balance" := 0;
        "Dest. Loan Description" := '';
        "Interest Arrears" := 0;
        "Principal Arrears" := 0;
        "Total Arrears" := 0;
        "Overpayment-Interest" := 0;
        "Overpayment-Principal" := 0;
        "Overpayment-Total" := 0;
        "Amount to Transfer" := 0;
        "Pay from Member" := FALSE;
        "Amount to Pay from Guarantors" := 0;
        "Pay from Guarantors" := FALSE;
        "Destination Account No." := '';
        "Destination Account Name" := '';
        "Destination Member No." := '';
        "Destination Member Name" := '';
        "Destination Account Balance" := 0;
    end;
}

