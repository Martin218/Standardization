table 50246 "Recruitment Request"
{
    // version TL2.0


    fields
    {
        field(1; "Recruitment No."; Code[30])
        {
        }
        field(2; "Job ID"; Text[150])
        {
            TableRelation = Position WHERE(Active = FILTER('Yes'));

            trigger OnValidate();
            begin
                Position.RESET;
                Position.SETRANGE(Code, "Job ID");
                IF Position.FINDFIRST THEN BEGIN
                    "Job Title Request" := Position."Job Title";

                    PositionResponsibility.RESET;
                    PositionResponsibility.SETRANGE("Position Code", "Job ID");
                    IF PositionResponsibility.FINDSET THEN BEGIN
                        REPEAT
                            "Expected Responsibilities" := "Expected Responsibilities" + ' ' + PositionResponsibility.Responsibility;
                        UNTIL PositionResponsibility.NEXT = 0;
                    END;

                    PositionQualification.RESET;
                    PositionQualification.SETRANGE("Position Code", "Job ID");
                    IF PositionQualification.FINDSET THEN BEGIN
                        REPEAT
                            "Required Qualifications" := "Required Qualifications" + ' ' + PositionQualification.Description;
                        UNTIL PositionQualification.NEXT = 0;
                    END;
                END;
            end;
        }
        field(3; Description; Text[50])
        {
            Editable = false;
        }
        field(4; "Recruitment Date"; Date)
        {

            trigger OnValidate();
            begin
                IF "Recruitment Date" < TODAY THEN BEGIN
                    ERROR('You cannot select a date earlier than today!');
                END;
            end;
        }
        field(5; Priority; Option)
        {
            OptionCaption = '" ,Low,Medium,High"';
            OptionMembers = " ",Low,Medium,High;
        }
        field(6; "Requested Positions"; Integer)
        {
        }
        field(7; "Requested By"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = "User Setup"."User ID";
        }
        field(8; "Need Source"; Option)
        {
            NotBlank = true;
            OptionCaption = '" ,Appraisal,Succession,Training,Employee,Employee Skill Plan"';
            OptionMembers = " ",Appraisal,Succession,Training,Employee,"Employee Skill Plan";
        }
        field(9; "Approved positions"; Integer)
        {
        }
        field(10; Status; Option)
        {
            OptionCaption = 'Open,Released,Pending Approval,Rejected';
            OptionMembers = Open,Released,"Pending Approval",Rejected;
        }
        field(11; "First Name"; Text[100])
        {
        }
        field(12; "ID No"; Text[30])
        {
        }
        field(13; Address; Text[100])
        {
        }
        field(14; "Phone No_"; Text[30])
        {
        }
        field(15; "E-Mail"; Text[50])
        {
        }
        field(16; Gender; Option)
        {
            OptionCaption = 'Male,Female';
            OptionMembers = Male,Female;
        }
        field(17; "Marital Status"; Option)
        {
            OptionCaption = 'Single,Married,Divorced';
            OptionMembers = Single,Married,Divorced;
        }
        field(18; "Last Name"; Text[100])
        {
        }
        field(19; "No. series"; Code[20])
        {
        }
        field(20; "Recruitment Needs Code"; Code[20])
        {
        }
        field(21; Name; Text[100])
        {
            Editable = false;
        }
        field(22; Branch; Text[70])
        {
            Editable = false;
        }
        field(23; "Job Title"; Text[70])
        {
            Editable = false;
        }
        field(24; "Request Done By"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Request Done By") THEN BEGIN
                    Name := Employee.FullName;
                    Branch := Employee."Branch Name";
                    "Job Title" := Employee."Job Title";
                    "Department Code" := Employee."Department Name";
                END;
            end;
        }
        field(25; "Recruitment Type"; Option)
        {
            OptionCaption = ',Internal,External';
            OptionMembers = ,Internal,External;
        }
        field(26; "Request Date"; Date)
        {
        }
        field(27; "Employee Type"; Option)
        {
            OptionCaption = ',Permanent,Contract,Intern,Business Representative';
            OptionMembers = ,Permanent,Contract,Intern,"Business Representative";
        }
        field(28; "Department Code"; Code[30])
        {
            Editable = false;
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('DEPARTMENT'));
        }
        field(29; "Required Qualifications"; Text[250])
        {
        }
        field(30; "Expected Responsibilities"; Text[250])
        {
        }
        field(31; "HR Recommendation1"; Text[250])
        {

            trigger OnValidate();
            begin
                HR := USERID;
                "HR Approved Date" := TODAY;
            end;
        }
        field(32; "HR Recommendation2"; Text[250])
        {
        }
        field(33; "HR Recommendation3"; Text[250])
        {
        }
        field(34; "CEO Recommendation"; Text[250])
        {

            trigger OnValidate();
            begin
                CEO := USERID;
                "CEO Approved Date" := TODAY;
            end;
        }
        field(35; HR; Text[100])
        {
            Editable = false;
        }
        field(36; "HR Approved Date"; Date)
        {
            Editable = false;
        }
        field(37; CEO; Text[100])
        {
            Editable = false;
        }
        field(38; "CEO Approved Date"; Date)
        {
            Editable = false;
        }
        field(39; "Job Title Request"; Text[100])
        {
            Editable = false;
        }
        field(40; "Department Requested"; Code[20])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = filter('DEPARTMENT'));

            trigger OnValidate();
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Dimension Code", 'DEPARTMENT');
                DimensionValue.SETRANGE(Code, "Department Requested");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "Department Name" := DimensionValue.Name;
                END;
            end;
        }
        field(41; "Department Name"; Text[100])
        {
        }
        field(42; "No. of Years of Experience"; Decimal)
        {
        }
        field(43; "Level of Education"; Code[20])
        {
            TableRelation = Qualification WHERE("Qualification Type" = FILTER('Academic'));
        }
    }

    keys
    {
        key(Key1; "Recruitment Needs Code")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Recruitment Needs Code", "Job ID", "Job Title Request")
        {
        }
    }

    trigger OnInsert();
    begin
        IF "Recruitment Needs Code" = '' THEN BEGIN
            HRSetup.GET;
            HRSetup.TESTFIELD("Recruitment Needs Nos.");
            NoSeriesMgt.InitSeries(HRSetup."Recruitment Needs Nos.", xRec."No. series", 0D, "Recruitment Needs Code", "No. series");
        END;
        "Request Date" := TODAY;
        "Requested By" := USERID;
        UserSetup.GET(USERID);
        "Request Done By" := UserSetup."Employee No.";
        VALIDATE("Request Done By");
    end;

    var
        NoSeriesMgt: Codeunit 396;
        HRSetup: Record 5218;

        Employee: Record 5200;
        UserSetup: Record 91;
        Position: Record 50230;
        DimensionValue: Record 349;
        PositionQualification: Record 50232;
        PositionResponsibility: Record 50233;

    local procedure UpdateVacantPositions();
    begin
    end;
}

