table 50410 "Plan Approval Setup"
{

    fields
    {
        field(1; "Approval Sequence"; Integer)
        {
        }
        field(2; "Approver ID"; Code[100])
        {
            TableRelation = "User Setup"."User ID";
        }
        field(3; Description; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "Approval Sequence")
        {
        }
    }

    fieldgroups
    {
    }
}

