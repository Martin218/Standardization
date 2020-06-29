table 50000 "Member Application"
{
    // version TL2.0

    DataCaptionFields = "No.", "Full Name";
    DrillDownPageId = "Member Application List";
    LookupPageId = "Member Application List";

    fields
    {
        field(1; "No."; Code[10])
        {

            trigger OnValidate()
            begin
                IF "No." <> xRec."No." THEN
                    "No. Series" := '';
            end;
        }
        field(2; Surname; Text[40])
        {

            trigger OnValidate()
            begin
                Surname := UpperCase(Surname);
                "Full Name" := GetFullName;
            end;
        }
        field(3; "First Name"; Text[40])
        {

            trigger OnValidate()
            begin
                "First Name" := UpperCase("First Name");
                "Full Name" := GetFullName;
            end;
        }
        field(4; "Last Name"; Text[40])
        {

            trigger OnValidate()
            begin
                "Last Name" := UpperCase("Last Name");
                "Full Name" := GetFullName;
            end;
        }
        field(5; "National ID"; Code[10])
        {

            trigger OnValidate()
            begin
                IF "National ID" <> '' THEN BEGIN
                    IF Rec."National ID" <> '' THEN BEGIN
                        IF IsNumeric("National ID") > 0 THEN
                            ERROR(NotContainCharErr);
                    END;
                    Member.RESET;
                    Member.SETRANGE(Member."National ID", "National ID");
                    IF Member.FINDSET THEN BEGIN
                        REPEAT
                            IF "No." = Member."No." THEN BEGIN

                            END ELSE BEGIN
                                ERROR(Text001, Member."Full Name");
                            END;
                        UNTIL Member.NEXT = 0
                    END;
                END;
            end;
        }
        field(6; "Passport ID"; Code[10])
        {
        }
        field(7; "Registration No."; Code[20])
        {
        }
        field(8; Gender; Option)
        {
            OptionCaption = ' ,Male,Female,Other';
            OptionMembers = " ",Male,Female,Other;
        }
        field(9; "Date of Birth"; Date)
        {
            trigger OnValidate()
            var
                Year: array[4] of Integer;
            begin
                IF NOT IsMemberOver18("Date of Birth") THEN
                    ERROR(MemberNotOver18Err);
            end;
        }
        field(10; "Date of Registration"; Date)
        {
        }
        field(11; "Date of Renewal"; Date)
        {
        }
        field(12; "Phone No."; Code[30])
        {
            ExtendedDatatype = PhoneNo;

            trigger OnValidate()
            begin
                IF Rec."Phone No." <> '' THEN BEGIN
                    IF IsNumeric(Rec."Phone No.") > 0 THEN
                        ERROR(NotContainCharErr);
                    CBSSetup.Get;
                    if CBSSetup."Phone No. Format" = CBSSetup."Phone No. Format"::"07XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 10 THEN
                            ERROR(ExceedCharErr, 10);

                        IF STRLEN(Rec."Phone No.") < 10 THEN
                            ERROR(NotLessThanCharErr, 10);
                    end;
                    if CBSSetup."Phone No. Format" = CBSSetup."Phone No. Format"::"2547XXXXXXXX" then begin
                        IF STRLEN(Rec."Phone No.") > 12 THEN
                            ERROR(ExceedCharErr, 12);

                        IF STRLEN(Rec."Phone No.") < 12 THEN
                            ERROR(NotLessThanCharErr, 12);
                    end;
                END;
            end;
        }
        field(13; "Marital Status"; Option)
        {
            OptionCaption = 'Single,Married,Divorced,Widowed,Others';
            OptionMembers = Single,Married,Divorced,Widowed,Others;
        }
        field(14; Category; Option)
        {
            OptionCaption = 'Individual,Group,Company,Joint';
            OptionMembers = Individual,Group,Company,Joint;
        }
        field(15; Picture; Media)
        {
        }
        field(16; Signature; Media)
        {
        }
        field(17; "Front ID"; Media)
        {
        }
        field(18; "Back ID"; Media)
        {
        }
        field(19; Occupation; Code[20])
        {
        }
        field(20; Status; Option)
        {
            Editable = false;
            OptionCaption = 'New,Pending Approval,Approved,Rejected';
            OptionMembers = New,"Pending Approval",Approved,Rejected;
        }

        field(22; "Introducer Member No."; Code[20])
        {
            TableRelation = Member;

            trigger OnValidate()
            begin

                IF Member.GET("Introducer Member No.") THEN BEGIN
                    "Introducer Member Name" := Member."Full Name";
                END ELSE BEGIN
                    "Introducer Member Name" := ''
                END;
            end;
        }
        field(23; "Introducer Member Name"; Text[50])
        {
        }
        field(24; "PIN No."; Code[20])
        {
        }
        field(25; Nationality; Option)
        {
            InitValue = Kenya;
            OptionCaption = 'Nigeria,Ethiopia,Egypt,Democratic Republic of the Congo,South Africa,Tanzania,Kenya,Algeria,Uganda,Sudan,Morocco,Ghana,Mozambique,Ivory Coast,Madagascar,Angola,Cameroon,Niger,Burkina Faso,Mali,Malawi,Zambia,Senegal,Zimbabwe,Chad,Guinea,Tunisia,Rwanda,South Sudan,Benin,Somalia,Burundi,Togo,Libya,Sierra Leone,Central African Republic,Eritrea,Republic of the Congo,Liberia,Mauritania,Gabon,Namibia,Botswana,Lesotho,Equatorial Guinea,Gambia,Guinea-Bissau,Mauritius,Swaziland,Djibouti,Reunion (France),Comoros,Western Sahara,Cape Verde,Mayotte (France),Sao Tome and Principe,Seychelles';
            OptionMembers = Nigeria,Ethiopia,Egypt,"Democratic Republic of the Congo","South Africa",Tanzania,Kenya,Algeria,Uganda,Sudan,Morocco,Ghana,Mozambique,"Ivory Coast",Madagascar,Angola,Cameroon,Niger,"Burkina Faso",Mali,Malawi,Zambia,Senegal,Zimbabwe,Chad,Guinea,Tunisia,Rwanda,"South Sudan",Benin,Somalia,Burundi,Togo,Libya,"Sierra Leone","Central African Republic",Eritrea,"Republic of the Congo",Liberia,Mauritania,Gabon,Namibia,Botswana,Lesotho,"Equatorial Guinea",Gambia,"Guinea-Bissau",Mauritius,Swaziland,Djibouti,"Reunion (France)",Comoros,"Western Sahara","Cape Verde","Mayotte (France)","Sao Tome and Principe","Seychelles";
        }
        field(26; "Payroll No."; Code[10])
        {
        }
        field(27; "E-mail"; Text[30])
        {
            ExtendedDatatype = EMail;
            trigger OnValidate()
            var

            begin
                IF "E-mail" <> '' THEN BEGIN
                    IF NOT IsValidEmail(Rec."E-mail") THEN
                        ERROR(InvalidEmailErr);
                END;
            end;
        }
        field(28; "Postal Address"; Text[50])
        {
        }
        field(29; "Physical Address"; Text[50])
        {
        }

        field(31; "Created By"; Code[30])
        {
            Editable = false;
        }
        field(32; "Created Date"; Date)
        {
            Editable = false;
        }
        field(33; "Approved By"; Code[30])
        {
            Editable = false;
        }
        field(34; "Approved Date"; Date)
        {
            Editable = false;
        }

        field(37; "Created Time"; Time)
        {
            Editable = false;
        }
        field(38; "Approved Time"; Time)
        {
            Editable = false;
        }
        field(39; "Last Modified Date"; Date)
        {
            Editable = false;
        }
        field(40; "Last Modified Time"; Time)
        {
            Editable = false;
        }
        field(41; "Last Modified By"; Code[30])
        {
            Editable = false;
        }
        field(42; "Created By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(43; "Created By Host IP"; Code[20])
        {
            Editable = false;
        }
        field(44; "Created By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(45; "Last Modified By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(46; "Last Modified By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(47; "Last Modified By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(48; "Approved By Host Name"; Code[30])
        {
            Editable = false;
        }
        field(49; "Approved By Host IP"; Code[30])
        {
            Editable = false;
        }
        field(50; "Approved By Host MAC"; Code[30])
        {
            Editable = false;
        }
        field(51; "No. Series"; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(52; "Office Location"; Text[30])
        {
        }
        field(53; Activity; Code[30])
        {
        }
        field(54; "Registration Certificate"; Media)
        {
        }

        field(59; "Branch Name"; Text[30])
        {

            CalcFormula = Lookup ("Dimension Value".Name WHERE("Global Dimension No." = CONST(1),
                                                               Code = FIELD("Global Dimension 1 Code")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Full Name"; Text[150])
        {

        }

        field(64; "Agency Code"; Code[20])
        {
            TableRelation = Agency;
        }
        field(66; "Global Dimension 1 Code"; Code[20])
        {
            Caption = 'Global Dimension 1 Code';
            CaptionClass = '1,1,1';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(67; "Global Dimension 2 Code"; Code[20])
        {
            Caption = 'Global Dimension 2 Code';
            CaptionClass = '1,1,2';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(68; "Loan Officer ID"; Code[20])
        {
            TableRelation = "Loan Officer Setup";

        }
        field(69; "Group Meeting Frequency"; DateFormula)
        {

        }
        field(70; "Group Paybill Code"; Code[20])
        {

        }
        field(71; "Social Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Social Name" := UPPERCASE("Social Name");
            end;
        }
        field(72; "Home Village"; Code[70])
        {
        }
        field(73; "Nearest LandMark"; Code[100])
        {
        }
        field(74; "Group Link No."; Code[20])
        {
            TableRelation = IF ("Group Link Type" = FILTER("Link to New Group")) "Member Application" WHERE(Status = FILTER(New),
                                                                                                          Category = FILTER(Group))
            ELSE
            IF ("Group Link Type" = FILTER("Link to Existing Group")) "Member" WHERE(Category = FILTER(Group));
        }
        field(75; "Group Registration No."; Code[30])
        {

            trigger OnValidate()
            begin
                /*  IF CheckFieldExist("Group Registration No.", 14) THEN
                     ERROR(Error001, FIELDCAPTION("Group Registration No.")); */
            end;
        }

        field(76; "Group Meeting Day"; Option)
        {
            OptionCaption = 'Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday;
        }
        field(77; "Group Meeting Time"; Time)
        {
        }

        field(78; "Group Meeting Venue"; Code[30])
        {
        }
        field(79; "Group Registration Date"; Date)
        {
            trigger OnValidate()
            var
                myInt: Integer;
            begin
                IF "Group Registration Date" >= TODAY THEN
                    ERROR(InvalidRegDateErr, FieldCaption("Group Registration Date"));
            end;
        }
        field(80; "Min. Contribution per Meeting"; Decimal)
        {
        }
        field(81; "No. of Subgroups"; Integer)
        {
        }
        field(82; "Group Certificate"; Media)
        {
        }
        field(83; "Group Meeting Frequency Option"; Option)
        {
            Caption = 'Group Meeting Frequency';
            OptionCaption = ' ,Weekly,Fortnightly,Monthly';
            OptionMembers = " ",Weekly,Fortnightly,Monthly;

            trigger OnValidate()
            begin
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Weekly THEN
                    EVALUATE("Group Meeting Frequency", '1W');
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Fortnightly THEN
                    EVALUATE("Group Meeting Frequency", '2W');
                IF "Group Meeting Frequency Option" = "Group Meeting Frequency Option"::Monthly THEN
                    EVALUATE("Group Meeting Frequency", '1M');
            end;
        }

        field(85; "Is Group Official"; Boolean)
        {
        }
        field(86; "Group Official Position"; Option)
        {
            OptionCaption = ' ,ChairPerson,Secretary,Treasurer';
            OptionMembers = " ",ChairPerson,Secretary,Treasurer;
        }
        field(87; "Last Meeting Date"; Date)
        {

            trigger OnValidate()
            begin
                IF "Last Meeting Date" > TODAY THEN;
                ERROR(InvalidRegDateErr, FIELDCAPTION("Last Meeting Date"));
            end;
        }
        field(88; "Group Link Type"; Option)
        {
            OptionCaption = ' ,Link to New Group,Link to Existing Group';
            OptionMembers = " ","Link to New Group","Link to Existing Group";
        }
        field(89; "No. of Members"; Integer)
        {
            CalcFormula = Count ("Member Application" WHERE("Group Link No." = FIELD("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(90; "Huduma No."; Code[20])
        {

        }
        field(91; "Current Residence"; Code[20])
        {

        }
        field(92; "Home Ownership"; Option)
        {
            OptionCaption = 'Rented,Self';
            OptionMembers = Rented,Self;
        }

    }

    keys
    {
        key(Key1; "No.")
        {
        }
        key(Key2; "Full Name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Full Name", "Global Dimension 1 Code")
        {
        }
    }

    trigger OnInsert()
    begin
        CBSSetup.GET;
        CASE Category OF
            Category::Individual:
                BEGIN
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(CBSSetup."MA Individual Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Group:
                BEGIN
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(CBSSetup."MA Group Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Company:
                BEGIN
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(CBSSetup."MA Company Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
            Category::Joint:
                BEGIN
                    IF "No." = '' THEN BEGIN
                        NoSeriesManagement.InitSeries(CBSSetup."MA Joint Nos.", xRec."No. Series", TODAY, "No.", "No. Series");
                    END;
                END;
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
        Member: Record Member;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        HostMac: Text[50];
        HostName: Text[50];
        HostIP: Text[50];
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;

        Text001: Label 'Identification Number has been used before for %1.Kindly check your No.';

    procedure AddNewGroupMember()
    var
        MemberApplication: Record "Member Application";

    begin
        CBSSetup.GET;
        MemberApplication.INIT;
        MemberApplication."No." := NoSeriesManagement.GetNextNo(CBSSetup."MA Individual Nos.", TODAY, TRUE);
        MemberApplication."Group Link Type" := MemberApplication."Group Link Type"::"Link to New Group";
        MemberApplication."Group Link No." := "No.";
        MemberApplication.Category := MemberApplication.Category::Individual;
        MemberApplication."Created By" := USERID;
        MemberApplication."Created Date" := TODAY;
        MemberApplication."Created Time" := TIME;
        MemberApplication."Loan Officer ID" := USERID;
        MemberApplication.VALIDATE("Loan Officer ID");
        MemberApplication."Created Date" := TODAY;
        MemberApplication."Created Time" := TIME;
        GetHostInfo;
        MemberApplication."Created By Host IP" := HostIP;
        MemberApplication."Created By Host MAC" := HostMac;
        MemberApplication."Created By Host Name" := HostName;
        MemberApplication.INSERT;
        MemberApplication.GET(MemberApplication."No.");
        PAGE.RUN(50000, MemberApplication);
    end;

    procedure ValidateFields()
    begin
        CASE Category OF
            Category::Individual:
                BEGIN
                    TESTFIELD(Surname);
                    TESTFIELD("First Name");
                    TESTFIELD("Last Name");
                    TESTFIELD("National ID");
                    TESTFIELD("Date of Birth");
                    //TESTFIELD("Marital Status");
                    TESTFIELD("Global Dimension 1 Code");
                    TESTFIELD(Occupation);
                    TESTFIELD("PIN No.");
                    TESTFIELD("Phone No.");
                    TESTFIELD(Picture);
                    TESTFIELD(Signature);
                    TESTFIELD("Front ID");
                    TESTFIELD("Back ID");
                END;
            Category::Group:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    TESTFIELD("Date of Registration");
                    TESTFIELD("PIN No.");
                    TESTFIELD("Office Location");
                    TESTFIELD(Picture);
                    TESTFIELD("Registration Certificate");
                    TESTFIELD("Phone No.");
                END;
            Category::Company:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    TESTFIELD("Date of Registration");
                    TESTFIELD("PIN No.");
                    TESTFIELD("Office Location");
                    TESTFIELD(Picture);
                    TESTFIELD("Registration Certificate");
                    TESTFIELD("Phone No.");
                END;
            Category::Joint:
                BEGIN
                    TESTFIELD("Full Name");
                    TESTFIELD(Activity);
                    TESTFIELD("National ID");
                    TESTFIELD("PIN No.");
                    TESTFIELD(Picture);
                    TESTFIELD("Phone No.");
                END;
        END;
    end;

    local procedure CheckMembersExist()
    begin
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

    local procedure GetFullName(): Text[100]
    begin
        EXIT(UpperCase("First Name") + ' ' + UpperCase("Last Name") + ' ' + UpperCase(Surname));
    end;

    procedure IsNumeric(Variant: Code[20]): Integer
    var
        j: Integer;
    begin
        FOR i := 1 TO STRLEN(Variant) DO BEGIN
            IF NOT (Variant[i] IN ['0' .. '9', '+']) THEN
                j += 1;
        END;
        EXIT(j);
    end;

    local procedure IsValidEmail(EmailAddress: Code[20]): Boolean
    var
        Email: Code[20];
        Regex: DotNet Regex;
        RegexOptions: DotNet RegexOptions;
        Pattern: Text[50];
        Result: Boolean;
    begin
        Pattern := '^[A-Z0-9._%+-]+@(?:[A-Z0-9-]+\.)+[A-Z]{2,4}$';

        RegexOptions := 0;
        RegexOptions := RegexOptions.Parse(RegexOptions.GetType(), 'IgnoreCase');

        Result := Regex.IsMatch(EmailAddress, Pattern, RegexOptions);

        EXIT(Result);
    end;

    local procedure IsMemberOver18(Variant: Date): Boolean
    var
        Year: array[4] of Integer;
    begin
        Year[1] := DATE2DMY(Variant, 3);
        Year[2] := DATE2DMY(TODAY, 3);
        IF (Year[2] - Year[1]) >= 18 THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    var
        i: Integer;
        NotContainCharErr: Label 'Phone No. cannot contain characters.';
        ExceedCharErr: Label 'Phone No. cannot exceed %1 characters.';
        NotLessThanCharErr: Label 'Phone No. cannot be less than %1 characters.';


        InvalidEmailErr: Label 'Email Address is not valid';
        MemberNotOver18Err: Label 'Member must be 18 years and above.';
        InvalidRegDateErr: Label '%1 cannot be TODAY or future date';

}

