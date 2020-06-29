table 50082 "Standing Order Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary key"; Code[10])
        {
        }
        field(2; "Transaction Calculation Method"; Option)
        {
            OptionMembers = "%","Flat Amount";
        }
        field(3; "Transaction Flat Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Transaction Flat Amount" <> 0 THEN BEGIN
                    "Transaction Calculation Method" := "Transaction Calculation Method"::"Flat Amount";
                    "Transaction %" := 0;
                END;
            end;
        }
        field(4; "Transaction G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(5; "Penalty Calculation Method"; Option)
        {
            OptionMembers = "%","Flat Amount";
        }
        field(6; "Penalty Flat Amount"; Decimal)
        {

            trigger OnValidate()
            begin
                IF "Penalty Flat Amount" <> 0 THEN BEGIN
                    "Penalty Calculation Method" := "Penalty Calculation Method"::"Flat Amount";
                    "Penalty %" := 0;
                END;
            end;
        }
        field(7; "Penalty G/L Account"; Code[20])
        {
            TableRelation = "G/L Account";
        }
        field(8; "Charge Transaction"; Boolean)
        {
        }
        field(9; "Charge Penalty"; Boolean)
        {
        }
        field(10; "Transaction %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                IF "Transaction %" <> 0 THEN BEGIN
                    "Transaction Calculation Method" := "Transaction Calculation Method"::"%";
                    "Transaction Flat Amount" := 0;
                END;
                ;
            end;
        }
        field(11; "Penalty %"; Decimal)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(12; "Bank Control Account"; Code[20])
        {
            TableRelation = "Bank Account";
        }
        field(13; "Allow Overdrawing"; Boolean)
        {
        }
        field(14; "Recover Source Arrears"; Boolean)
        {
        }
        field(26; "Allow Partial Deduction"; Boolean)
        {
        }
        field(27; "Recover Destination Arrears"; Boolean)
        {
        }
        field(28; "Use Priority Posting"; Boolean)
        {
        }
        field(29; "Override LP Priority"; Boolean)
        {
        }
        field(30; "Overdrawing Option"; Option)
        {
            OptionCaption = 'Overdraw Account,Keep Global Log';
            OptionMembers = "Overdraw Account","Keep Global Log";
        }
        field(31; "Charge Option"; Option)
        {
            OptionCaption = 'Per Header,Per Line';
            OptionMembers = "Per Header","Per Line";
        }
        field(32; "Penalty Option"; Option)
        {
            OptionCaption = 'Per Header,Per Line';
            OptionMembers = "Per Header","Per Line";
        }
        field(33; "External Email Template"; BLOB)
        {
            SubType = Memo;
        }
        field(34; "Notification Option"; Option)
        {
            OptionCaption = 'SMS,Email,Both';
            OptionMembers = SMS,Email,Both;
        }
        field(35; "External SMS Template"; BLOB)
        {
            SubType = Memo;
        }
        field(36; "External Phone No."; Code[20])
        {
        }
        field(37; "External Email Address"; Text[50])
        {
        }
        field(38; "Notify Source Member"; Boolean)
        {
        }
        field(39; "Notify Destination Member"; Boolean)
        {
        }
        field(40; "Source SMS Template"; Text[250])
        {
        }
        field(41; "Destination SMS Template"; Text[250])
        {
        }
        field(42; "Source Email Template"; Text[250])
        {
        }
        field(43; "Destination Email Template"; Text[250])
        {
        }
        field(44; "Notify on External"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Primary key")
        {
        }
    }

    fieldgroups
    {
    }

    var
        BOSAManagement: Codeunit "BOSA Management";

    procedure SetEmailTemplate(var NewEmailTemplate: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
    begin
        CLEAR("External Email Template");
        IF NewEmailTemplate = '' THEN
            EXIT;
        "External Email Template".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewEmailTemplate);
        MODIFY;
    end;

    procedure GetEmailTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        EmailText: Text;
        IStream: InStream;
    begin
        CALCFIELDS("External Email Template");
        IF NOT "External Email Template".HASVALUE THEN
            EXIT('');
        "External Email Template".CREATEinSTREAM(IStream);
        IStream.READ(EmailText);
        exit(EmailText);
    end;


    procedure SetSMSTemplate(var NewSMSTemplate: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
    begin
        CLEAR("External SMS Template");
        IF NewSMSTemplate = '' THEN
            EXIT;
        "External SMS Template".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewSMSTemplate);
        MODIFY;
    end;


    procedure GetSMSTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSTemplate: Text;
        IStream: InStream;
    begin
        CALCFIELDS("External SMS Template");
        IF NOT "External SMS Template".HASVALUE THEN
            EXIT('');
        "External SMS Template".CREATEinSTREAM(IStream);
        IStream.READ(SMSTemplate);
        exit(SMSTemplate);
    end;

}

