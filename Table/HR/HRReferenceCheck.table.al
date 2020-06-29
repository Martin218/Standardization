table 50211 "HR Reference Check"
{
    // version TL2.0


    fields
    {
        field(1;"Employee No.";Code[20])
        {
        }
        field(2;"Line No.";Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(3;"Referee Name";Text[100])
        {
        }
        field(4;"Phone No";Text[10])
        {
        }
        field(5;Email;Text[70])
        {
        }
        field(6;"Company Name";Text[100])
        {
        }
        field(7;"Years of Engagement";Text[30])
        {
        }
        field(8;Recommendation;Text[250])
        {
        }
        field(9;Recommend;Boolean)
        {
        }
        field(10;Remarks;Text[100])
        {
        }
    }

    keys
    {
        key(Key1;"Employee No.","Line No.")
        {
        }
    }

    fieldgroups
    {
    }
}

