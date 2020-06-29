table 50209 "Leave Ledger Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
        field(2; "Leave Period"; Code[10])
        {
        }
        field(3; Closed; Boolean)
        {
        }
        field(4; "Employee No."; Code[10])
        {
            TableRelation = Employee;

            trigger OnValidate();
            begin
                IF Employee.GET("Employee No.") THEN;
                //   "Employee Name" := Employee.FullName;
            end;
        }
        field(5; "Posting Date"; Date)
        {
        }
        field(7; "User ID"; Code[50])
        {
        }
        field(8; "Leave Code"; Code[30])
        {
            TableRelation = "Leave Type";
        }
        field(9; Days; Decimal)
        {
        }
        field(10; "Document No"; Code[20])
        {
        }
        field(11; Description; Text[100])
        {
        }
        field(12; "Entry Type"; Option)
        {
            OptionCaption = ',Positive,Negative';
            OptionMembers = ,Positive,Negative;
        }
        field(13; "Lost Days"; Boolean)
        {
        }
        field(14; "Earned Leave Days"; Boolean)
        {
        }
        field(15; "Balance Brought Forward"; Boolean)
        {
        }
        field(16; Recall; Boolean)
        {
        }
        field(17; "Added Back Days"; Boolean)
        {
        }
        field(18; Modified; Boolean)
        {
        }
        field(19; "Employee Name"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        LeaveLedgerEntry.RESET;
        IF LeaveLedgerEntry.FINDLAST THEN
            "Entry No." := LeaveLedgerEntry."Entry No." + 1;
    end;

    var
        Employee: Record 5200;
        LeaveLedgerEntry: Record 50209;
}

