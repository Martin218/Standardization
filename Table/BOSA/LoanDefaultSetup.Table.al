table 50153 "Loan Default Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(2; "First Notice Template"; Text[250])
        {
        }
        field(3; "Second Notice Template"; Text[250])
        {
        }
        field(4; "Third Notice Template"; Text[250])
        {
        }
        field(5; "Guarantor Notice Template"; Text[250])
        {
        }
        field(6; "Attach on"; Option)
        {
            OptionCaption = 'First Notice,Second Notice,Third Notice';
            OptionMembers = "First Notice","Second Notice","Third Notice";
        }
        field(7; "Grace Period"; DateFormula)
        {
        }
        field(8; "Demand Letter Template"; BLOB)
        {
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    procedure SetDemandLetterTemplate(var NewDemandLetterTemplate: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OStream: OutStream;
    begin
        CLEAR("Demand Letter Template");
        IF NewDemandLetterTemplate = '' THEN
            EXIT;
        "Demand Letter Template".CREATEOUTSTREAM(OStream);
        OStream.WRITE(NewDemandLetterTemplate);
        MODIFY;
    end;

    procedure GetDemandLetterTemplate(): Text
    var
        TempBlob: Codeunit "Temp Blob";
        SMSText: Text;
        IStream: InStream;
    begin
        CALCFIELDS("Demand Letter Template");
        IF NOT "Demand Letter Template".HASVALUE THEN
            EXIT('');
        "Demand Letter Template".CREATEinSTREAM(IStream);
        IStream.READ(SMSText);
        exit(SMSText);
    end;
}

