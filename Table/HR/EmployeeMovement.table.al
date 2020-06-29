table 50229 "Employee Movement"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[10])
        {
            Editable = false;
        }
        field(2; "Employee No."; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    "ID Number" := Employee."ID Number";
                    Gender := Employee.Gender;
                    "Employment Date" := Employee."Employment Date";
                    "Current Branch" := Employee."Global Dimension 1 Code";
                    "Current Department" := Employee."Global Dimension 2 Code";
                    "Current Job Tiltle" := Employee."Job Title";
                END;
            end;
        }
        field(3; "Employee Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "ID Number"; Text[10])
        {
            Editable = false;
        }
        field(5; Gender; Option)
        {
            Editable = false;
            OptionCaption = '" ,Female,Male"';
            OptionMembers = " ",Female,Male;
        }
        field(6; "Employment Date"; Date)
        {
            Editable = false;
        }
        field(7; "Current Branch"; Code[50])
        {
            Editable = false;
        }
        field(8; "Current Department"; Code[50])
        {
            Editable = false;
        }
        field(9; "Current Job Tiltle"; Text[100])
        {
            Editable = false;
        }
        field(10; "Current Grade"; Code[10])
        {
            Editable = false;
        }
        field(11; "New Branch Code"; Code[50])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('BRANCH'));

            trigger OnValidate();
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "New Branch Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "New Branch Name" := DimensionValue.Name;
                END;
            end;
        }
        field(12; "New Department Code"; Code[50])
        {
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('DEPARTMENT'));

            trigger OnValidate();
            begin
                DimensionValue.RESET;
                DimensionValue.SETRANGE(Code, "New Department Code");
                IF DimensionValue.FINDFIRST THEN BEGIN
                    "New Department Name" := DimensionValue.Name;
                END;
            end;
        }
        field(13; "New Job Title"; Text[100])
        {
            TableRelation = Position."Job Title";
        }
        field(14; "New Grade"; Code[10])
        {
            TableRelation = Grade;
        }
        field(15; "New Salary"; Decimal)
        {
        }
        field(16; Date; Date)
        {
        }
        field(17; Status; Option)
        {
            Editable = false;
            OptionCaption = 'Open,Posted';
            OptionMembers = Open,Posted;
        }
        field(18; "Created By"; Code[50])
        {
            Editable = false;
        }
        field(19; "Created Date"; Date)
        {
            Editable = false;
        }
        field(20; "Created Time"; Time)
        {
            Editable = false;
        }
        field(21; "Posted By"; Code[50])
        {
            Editable = false;
        }
        field(22; "Posted Date"; Date)
        {
            Editable = false;
        }
        field(23; "Posted Time"; Time)
        {
            Editable = false;
        }
        field(24; "New Branch Name"; Code[50])
        {
            Editable = false;
        }
        field(25; "New Department Name"; Code[50])
        {
            Editable = false;
        }
        field(26; Type; Option)
        {
            //Editable = false;
            OptionCaption = ',Posting,Promotion,Transfer';
            OptionMembers = ,Posting,Promotion,Transfer;
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

    trigger OnInsert();
    begin
        HumanResourcesSetup.GET;
        "No." := NoSeriesManagement.GetNextNo(HumanResourcesSetup."Staff Transfer Nos.", 0D, TRUE);
        "Created By" := USERID;
        "Created Date" := TODAY;
        "Created Time" := TIME;
    end;

    var
        NoSeriesManagement: Codeunit 396;
        HumanResourcesSetup: Record 5218;

        Employee: Record 5200;
        DimensionValue: Record 349;
}

