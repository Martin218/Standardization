table 50029 "SMS Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "Phone No."; Code[20])
        {
        }
        field(4; "SMS Text"; BLOB)
        {
        }
        field(5; "Source Code"; Code[20])
        {
        }
        field(6; "Created Date"; Date)
        {
        }
        field(7; "Created Time"; Time)
        {
        }
        field(8; Sent; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Member: Record Member;

    procedure SetSMSTemplate(var NewSMSText: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
    begin
        CLEAR("SMS Text");
        IF NewSMSText = '' THEN
            EXIT;
        "SMS Text".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewSMSText);
        MODIFY;
    end;

    procedure GetSMSTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSText: Text;
        IStream: InStream;
    begin
        CALCFIELDS("SMS Text");
        IF NOT "SMS Text".HASVALUE THEN
            EXIT('');
        "SMS Text".CREATEinSTREAM(IStream);
        IStream.READ(SMSText);
        exit(SMSText);
    end;
}

