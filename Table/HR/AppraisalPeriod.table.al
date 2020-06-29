table 50260 "Appraisal Period"
{
    // version TL2.0


    fields
    {
        field(1;Year;Integer)
        {
        }
        field(2;"Code";Text[50])
        {
        }
        field(3;Description;Text[100])
        {
        }
        field(4;"Start Date";Date)
        {
        }
        field(5;"End Date";Date)
        {
        }
        field(6;Deadline;Date)
        {
        }
        field(7;Closed;Boolean)
        {
        }
        field(8;Active;Boolean)
        {
        }
        field(9;"Entry No";Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;Year,"Code",Description)
        {
        }
    }
}

