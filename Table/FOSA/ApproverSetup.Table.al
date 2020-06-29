table 50005 "Approver Setup"
{
    // version TL2.0


    fields
    {
        field(1; "User ID"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(2; "Approver ID"; Code[30])
        {
            TableRelation = "User Setup";
        }
        field(3; "Sequence No."; Integer)
        {
        }
        field(4; "Entry Type"; Option)
        {
            OptionCaption = 'Member Application,Account Opening,Loan Application';
            OptionMembers = "Member Application","Account Opening","Loan Application";
        }
    }

    keys
    {
        key(Key1; "User ID", "Entry Type", "Sequence No.")
        {
        }
    }

    fieldgroups
    {
    }
}

