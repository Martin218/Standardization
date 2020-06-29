table 50245 "Employee HR Audit Trail"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(2; "User ID"; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(3; Type; Option)
        {
            OptionCaption = ',View,Change';
            OptionMembers = ,View,Change;
        }
        field(4; "Employee No"; Code[20])
        {
            TableRelation = Employee;
        }
        field(5; "Employee Name"; Text[100])
        {
        }
        field(6; "Field Caption"; Text[100])
        {
        }
        field(7; "Old Value"; Text[100])
        {
        }
        field(8; "New Value"; Text[30])
        {
        }
        field(9; "Change Date"; Date)
        {
        }
        field(10; "Change Time"; Time)
        {
        }
        field(11; Status; Option)
        {
            OptionCaption = 'N/A,New,Approval Pending,Approved,Rejected';
            OptionMembers = "N/A",New,"Approval Pending",Approved,Rejected;
        }
        field(12; Approver; Code[100])
        {
            TableRelation = "User Setup";
        }
        field(13; "Approval Date"; Date)
        {
        }
        field(14; "Approval Time"; Time)
        {
        }
        field(19; "Change Type"; Option)
        {
            OptionCaption = ',First Name,Middle Name,Last Name,Phone,ID,Date of Birth,Employment Date,Job Title,Grade,Branch,Department,PIN,NSSF,NHIF,HELB,Salary,Car Allowance,Phone No,Employee Type,Gender,Email,Employment Status,Marital Status,Staff Category,Company Email,Alternative Phone No,Title';
            OptionMembers = ,"First Name","Middle Name","Last Name",Phone,ID,"Date of Birth","Employment Date","Job Title",Grade,Branch,Department,PIN,NSSF,NHIF,HELB,Salary,"Car Allowance","Phone No","Employee Type",Gender,Email,"Employment Status","Marital Status","Staff Category","Company Email","Alternative Phone No",Title;
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
        HRAuditTrail.RESET;
        IF HRAuditTrail.FINDLAST THEN BEGIN
            "Entry No." := HRAuditTrail."Entry No." + 1;
        END ELSE BEGIN
            "Entry No." := 1;
        END;
    end;

    var
        HRAuditTrail: Record 50245;
}

