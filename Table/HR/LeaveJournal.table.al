table 50224 "Leave Journal"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No"; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Posting Date"; Date)
        {
        }
        field(3; "Leave Period"; Code[10])
        {
            TableRelation = "Leave Period"."Period Code";
        }
        field(4; "Employee No."; Code[20])
        {
            TableRelation = Employee."No.";

            trigger OnValidate();
            begin
                //   IF Employee.GET("Employee No.") THEN
                //      "Employee Name" := Employee.FullName;
            end;
        }
        field(5; Description; Text[60])
        {
        }
        field(6; "Leave Type"; Code[10])
        {
            TableRelation = "Leave Type".Code;
        }
        field(7; "Entry Type"; Option)
        {
            OptionCaption = '" ,Positive,Negative"';
            OptionMembers = " ",Positive,Negative;
        }
        field(8; Days; Decimal)
        {
        }
        field(9; "Document No"; Code[20])
        {
        }
        field(10; "Employee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No", "Leave Period", "Employee No.", "Posting Date", Description, "Leave Type", "Entry Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Employee: Record 5200;
}

