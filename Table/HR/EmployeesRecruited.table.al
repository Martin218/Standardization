table 50247 "Employee Recruited"
{
    // version TL2.0


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Recruitment Code"; Code[10])
        {
        }
        field(3; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee.FullName;
                    Branch := Employee."Branch Name";
                    Department := Employee."Department Name";
                    "Job Title" := Employee."Job Title";
                    "Employment Date" := Employee."Employment Date";
                END;
            end;
        }
        field(4; "Employee Name"; Text[100])
        {
        }
        field(5; Branch; Text[50])
        {
        }
        field(6; Department; Text[70])
        {
        }
        field(7; "Job Title"; Text[70])
        {
        }
        field(8; "Employment Date"; Date)
        {
        }
    }

    keys
    {
        key(Key1; No, "Recruitment Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
}

