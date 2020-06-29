table 50200 "Employee Relation"
{
    // version TL2.0

    DataCaptionFields = "Employee No.", Relationship, "First Name", "Last Name", "Day Phone Number", "Evening Phone Number", "Postal Address", "Residential Address", "Type Of Contact";

    fields
    {
        field(1; "Employee No."; Code[20])
        {
            FieldClass = Normal;
            TableRelation = Employee."No.";
        }
        field(2; "Line No."; Integer)
        {
        }
        field(3; Relationship; Code[10])
        {
        }
        field(4; "First Name"; Text[30])
        {
        }
        field(6; "Last Name"; Text[30])
        {
            FieldClass = Normal;
        }
        field(8; "Day Phone Number"; Text[30])
        {
        }
        field(9; "Evening Phone Number"; Text[30])
        {
        }
        field(10; "Relative's Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(11; Comment; Boolean)
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(12; "Postal Address"; Text[30])
        {
        }
        field(13; "Residential Address"; Text[30])
        {
        }
        field(14; "Type Of Contact"; Option)
        {
            OptionCaption = ',Dependant,Emergency Contact,Next of Kin';
            OptionMembers = ,Dependant,"Emergency Contact","Next of Kin";
        }
        field(15; "Employee First Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Employee."First Name" WHERE("No." = FIELD("Employee No.")));

        }
        field(16; "Employee Last Name"; Text[30])
        {
            FieldClass = FlowField;
            CalcFormula = Lookup (Employee."Last Name" WHERE("No." = FIELD("Employee No.")));

        }
        field(17; "Postal Address2"; Text[30])
        {
        }
        field(18; "Postal Address3"; Text[20])
        {
        }
        field(19; "Residential Address2"; Text[30])
        {
        }
        field(20; "Residential Address3"; Text[20])
        {
        }
        field(21; Email; Text[30])
        {
        }
        field(22; "ID Number"; Text[10])
        {
        }
        field(23; "Date Of Birth"; Date)
        {
        }
        field(24; Occupation; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", Relationship, "First Name")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
}

