table 50011 "Account Opening"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
            Editable = false;
            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; "Account Type"; Code[20])
        {
            TableRelation = "Account Type" where("Open Automatically" = filter(false));

            trigger OnValidate()
            begin
                AccountType.RESET;
                AccountType.GET("Account Type");
                Description := AccountType.Description;
            end;
        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; "Member No."; Code[30])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin
                Member.RESET;
                Member.SETRANGE("No.", "Member No.");
                IF Member.FINDFIRST THEN BEGIN
                    "Member Name" := Member."Full Name";
                    "Global Dimension 1 Code" := Member."Global Dimension 1 Code";
                END;
                CLEAR(RecRef);
                CLEAR(XRecRef);
                RecRef.GETTABLE(Rec);
                XRecRef.GETTABLE(xRec);
                //CBSManagement.CreateLogEntry(RecRef, XRecRef, 4, Rec.FIELDNAME("Member No."));
            end;
        }
        field(5; "Member Name"; Text[40])
        {
            Editable = false;
        }
        field(6; "Account No."; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                // CreateAccountMember("No.", "Member No.", "Account No.");
            end;
        }
        field(7; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }
        field(8; "Created By"; Code[30])
        {
            Editable = false;

            trigger OnValidate()
            begin
                CLEAR(RecRef);
                CLEAR(XRecRef);
                RecRef.GETTABLE(Rec);
                XRecRef.GETTABLE(xRec);

            end;
        }
        field(9; "Created Date"; Date)
        {
            Editable = false;
        }
        field(10; "Created Time"; Time)
        {
            Editable = false;
        }
        field(11; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(12; "Approved Date"; Date)
        {
            Editable = false;
        }
        field(13; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(14; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(15; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(16; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(17; "Approved By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(18; "Created By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(19; "Created By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(20; "Last Modified By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(21; "Last Modified By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(22; "Last Modified By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(23; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(24; "Approved By Host Name"; Code[20])
        {
            Editable = false;
        }
        field(25; "Approved By Host MAC"; Code[20])
        {
            Editable = false;
        }
        field(26; "Global Dimension 1 Code"; Code[20])
        {
            Editable = false;
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));


        }
        field(27; "Child's Name"; Text[50])
        {
        }
        field(28; "Child's Gender"; Option)
        {
            OptionMembers = ,Male,Female;
        }
        field(29; "Child,s Date of Birth"; Date)
        {
        }
        field(30; "Child's Birth Cert No."; Code[50])
        {
        }
        field(31; "Relationship with Child"; Option)
        {
            OptionMembers = ,Parent,Guardian,Other;
        }
        field(32; "FD Expected Interest"; Decimal)
        {
        }
        field(33; "FD Total Expected"; Decimal)
        {
        }
        field(34; "Period in Months"; Integer)
        {

            trigger OnValidate()
            begin
                /*EVALUATE("No. Of Days",FORMAT("Period in Months")+'M');
                VALIDATE("No. Of Days");*/

            end;
        }
        field(35; "Initial Amount"; Decimal)
        {
        }
        field(36; "Posted Interest"; Decimal)
        {
        }
        field(37; "Maturity FOSA Account"; Code[50])
        {
        }
        field(38; "FD Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                interest := "Interest Rate" / 100;
                totaldays := "Expected Maturity Date" - "Effective Date";
                totaldays2 := totaldays / 365;
                FixedDepositRate.RESET;
                FixedDepositRate.SETFILTER("Minimum Amount", '<=%1', "FD Amount");
                FixedDepositRate.SETFILTER("Maximum Amount", '>=%1', "FD Amount");
                FixedDepositRate.SETRANGE(Period, "Period in Months");
                IF FixedDepositRate.FINDFIRST THEN BEGIN
                    VALIDATE("Interest Rate", FixedDepositRate."Interest Rate");
                    //"FD Expected Interest":="FD Amount"*("Interest Rate"/100)*("Period in Months"/12);
                    "FD Expected Interest" := "FD Amount" * interest * totaldays2;
                    "FD Total Expected" := "FD Amount" + "FD Expected Interest";
                    MODIFY;
                END;

                /*
                "FD Expected Interest":="FD Amount"*("Interest Rate"/100)*("Period in Months"/12);
                "FD Total Expected":="FD Amount"+"FD Expected Interest";
                MODIFY;
                */

            end;
        }
        field(39; "Fixed Deposit Status"; Integer)
        {
        }
        field(40; "FD Posted"; Boolean)
        {
        }
        field(41; "Interest Capitalization Date"; Date)
        {
        }
        field(42; "Interest Rate"; Decimal)
        {
        }
        field(43; "Expected Maturity Date"; Date)
        {

            trigger OnValidate()
            begin
                //"No. Of Days":="Expected Maturity Date"-"Effective Date";
            end;
        }
        field(44; "Effective Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "No. Of Days" <> Emptydateformulae THEN
                    "Expected Maturity Date" := CALCDATE("No. Of Days", "Effective Date")
                ELSE
                    "Expected Maturity Date" := "Effected Date";
            end;
        }
        field(45; "Effected Date"; Date)
        {
        }

        field(47; "SMS Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
        }
        field(48; "E-Mail Alert on"; Option)
        {
            OptionCaption = ' ,Debit,Credit,Both';
            OptionMembers = " ",Debit,Credit,Both;
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
            NoSeriesManagement.InitSeries(CBSSetup."Account Opening Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
        END;
        GetHostInfo;
        "Created By" := USERID;
        "Created By Host IP" := HostIP;
        "Created By Host MAC" := HostMac;
        "Created By Host Name" := HostName;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    trigger OnModify()
    begin
        GetHostInfo;
        "Last Modified By Host IP" := HostIP;
        "Last Modified By Host MAC" := HostMac;
        "Last Modified By Host Name" := HostName;
        "Last Modified Date" := TODAY;
        "Last Modified Time" := TIME;
        "Last Modified By" := USERID;
    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        AccountType: Record "Account Type";
        Member: Record "Member";

        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        "No. Of Days": DateFormula;
        interest: Decimal;
        totaldays: Integer;
        totaldays2: Decimal;
        FixedDepositRate: Record "Fixed Deposit Rate";
        Emptydateformulae: DateFormula;
        HostMac: Text[50];
        HostName: Text[50];
        HostIP: Text[50];




    procedure ValidateFields()
    begin
        TESTFIELD("Member No.");
        TESTFIELD("Account Type");
        TESTFIELD("Global Dimension 1 Code");
        TESTFIELD("Account No.");

    end;

    local procedure GetHostInfo()
    var
        Dns: DotNet Dns;
        GetIPMac2: DotNet GetIPMac;
        IPHostEntry: DotNet IPHostEntry;
        IPAddress: DotNet IPAddress;
    begin
        HostName := Dns.GetHostName();
        Clear(GetIPMac2);
        GetIPMac2 := GetIPMac2.GetIPMac();
        HostIP := GetIPMac2.GetIP(HostName);
        HostMac := GetIPMac2.GetMac();
    end;
}

