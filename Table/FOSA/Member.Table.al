table 50006 Member
{
    // version TL2.0

    DataCaptionFields = "No.", "First Name", "Last Name";
    //  DrillDownPageID = 50012;
    //LookupPageID = 50012;

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
        field(2; Surname; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(3; "First Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(4; "Last Name"; Text[50])
        {

            trigger OnValidate()
            begin
                "Full Name" := "First Name" + ' ' + "Last Name" + ' ' + Surname;
            end;
        }
        field(5; "National ID"; Code[10])
        {
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
            OptionCaption = 'Active,Dormant,Suspended,Frozen,Closed,Withdrawn';
            OptionMembers = Active,Dormant,Suspended,Frozen,Closed,Withdrawn;
        }

        field(22; "Introducer Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(23; "Introducer Member Name"; Text[50])
        {
        }
        field(24; "PIN No."; Code[20])
        {
        }
        field(25; Nationality; Option)
        {
            OptionCaption = 'Kenya,Uganda,Tanzania';
            OptionMembers = Kenya,Uganda,Tanzania;
        }
        field(26; "Payroll No."; Code[10])
        {
        }
        field(27; "E-mail"; Text[30])
        {
            ExtendedDatatype = EMail;
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
        field(34; "Approval Date"; Date)
        {
            Editable = false;
        }
        field(36; "Application No."; Code[20])
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

        field(58; "Member Classification"; Option)
        {
            OptionCaption = ',Staff,Board';
            OptionMembers = ,Staff,Board;
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
        field(65; "Registration Date"; Date)
        {
        }
        field(66; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Global Dimension 1 Code");
            end;
        }
        field(67; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Global Dimension 2 Code");
            end;
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
                // ERROR(Error005, FIELDCAPTION("Last Meeting Date"));
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

    end;

    trigger OnModify()
    begin

    end;

    var
        NoSeriesManagement: Codeunit NoSeriesManagement;
        CBSSetup: Record "CBS Setup";
        MemberApplication: Record "Member Application";
        // CBSManagement: Codeunit "50000";
        RecRef: RecordRef;
        XRecRef: RecordRef;
        "Trigger": Option OnCreate,OnModify;
        DimMgt: Codeunit DimensionManagement;

    local procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateDimValueCode(FieldNumber, ShortcutDimCode);
        DimMgt.SaveDefaultDim(DATABASE::Customer, "No.", FieldNumber, ShortcutDimCode);
        MODIFY;
    end;
}

