table 50145 "Loan Rescheduling Setup"
{
    // version TL2.0


    fields
    {
        field(1; "Primary Key"; Code[20])
        {
        }
        field(2; "Attachment Mandatory"; Boolean)
        {
        }
        field(3; "Rescheduling Option"; Option)
        {
            OptionCaption = 'Repayment Period,Interest Rate,Repayment Frequency,All';
            OptionMembers = "Repayment Period","Interest Rate","Repayment Frequency",All;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }
}

