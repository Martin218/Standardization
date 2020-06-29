table 50273 "Employee Deduction"
{
    // version TL2.0


    fields
    {
        field(1; No; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Employee No"; Code[20])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No") THEN BEGIN
                    "Employee Name" := Employee."Search Name";
                    "Employment Date" := Employee."Employment Date";
                    Branch := Employee."Branch Name";
                    Department := Employee."Department Name";
                    "Job Title" := Employee."Job Title";


                END;
            end;
        }
        field(3; "Employment Date"; Date)
        {
        }
        field(4; Branch; Text[50])
        {
        }
        field(5; Department; Text[70])
        {
        }
        field(6; "Job Title"; Text[100])
        {
        }
        field(7; Grade; Text[30])
        {
        }
        field(8; "Employee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; No)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
}

