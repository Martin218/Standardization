table 50201 "Employment History"
{
    // version TL2.0


    fields
    {
        field(1; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";
        }
        field(2; FromDate; Date)
        {
            NotBlank = true;
        }
        field(3; ToDate; Date)
        {
            NotBlank = true;
        }
        field(4; "Company Name"; Text[150])
        {
            NotBlank = true;
        }
        field(5; "Postal Address"; Text[80])
        {
        }
        field(6; "Address 2"; Text[80])
        {
        }
        field(7; "Job Title"; Text[100])
        {
        }
        field(8; "Key Experience"; Text[250])
        {
        }
        field(9; "Salary On Leaving"; Decimal)
        {
        }
        field(10; "Reason For Leaving"; Text[250])
        {
        }
        field(11; "Code"; Code[20])
        {
            TableRelation = "Employment History";

            trigger OnValidate();
            begin
                /*   EmploymentHistory.RESET;
                   EmploymentHistory.SETRANGE(EmploymentHistory.Code, Code);
                   IF EmploymentHistory.FIND('-') THEN
                       "Job Title" := EmploymentHistory.Description;*/
            end;
        }
        field(16; Comment; Text[250])
        {
            Editable = false;
        }
        field(17; Grade; Code[10])
        {
            //TableRelation = Table51511173.Field1;
        }
        field(18; Details; Text[250])
        {
        }
        field(19; "Position Held"; Text[100])
        {
        }
        field(20; "Application No"; Text[30])
        {
        }
        field(21; LineNo; Integer)
        {
            AutoIncrement = true;
        }
        field(22; "Member No"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Employee No.", LineNo)
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
        OK: Boolean;
        EmploymentHistory: Record 50201;
}

