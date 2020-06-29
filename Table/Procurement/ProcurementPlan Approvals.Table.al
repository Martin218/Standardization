table 50409 "Procurement Plan Approvals"
{

    fields
    {
        field(1; "Budget No."; Code[50])
        {
        }
        field(2; Sequence; Integer)
        {
        }
        field(3; Approver; Code[100])
        {
        }
        field(4; Status; Option)
        {
            OptionMembers = Open,Released;
        }
        field(5; Approved; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "Budget No.")
        {
        }
        key(Key2; Sequence)
        {
        }
    }

    fieldgroups
    {
    }
}

