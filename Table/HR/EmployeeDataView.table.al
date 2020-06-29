table 50244 "Employee Data View"
{
    // version TL2.0


    fields
    {
        field(1;No;Integer)
        {
            AutoIncrement = true;
        }
        field(2;User;Code[100])
        {
        }
        field(3;"Employee No";Code[20])
        {
        }
        field(4;"Employee Name";Text[100])
        {
        }
        field(5;Date;Date)
        {
        }
        field(6;Time;Time)
        {
        }
    }

    keys
    {
        key(Key1;No)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert();
    begin
        IF EmployeeDataView.FINDLAST THEN BEGIN
           lastno:=EmployeeDataView.No+1;
        END;
    end;

    var
        lastno : Integer;
        EmployeeDataView : Record 50244;
}

