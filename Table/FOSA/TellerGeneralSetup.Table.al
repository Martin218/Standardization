table 50021 "Teller General Setup"
{
    // version TL2.0


    fields
    {
        field(1; "No."; Code[30])
        {
        }
        field(2; "Teller Maximum Withholding"; Decimal)
        {
        }
        field(3; "Teller Replenishing Level"; Decimal)
        {
        }
        field(4; "Treasury Maximum Withholding"; Decimal)
        {
        }
        field(5; "Cash Deposit Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(6; "Cheque Deposit Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(7; "Cash Withdrawal Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(8; "Cheque Withdrawal Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(9; "Inter-Account Nos."; Code[20])
        {
            TableRelation = "No. Series";
        }
        field(10; "Teller Notification Level"; Decimal)
        {
        }
        field(11; "Approve Return To Treasury"; Boolean)
        {
        }
        field(12; "Approve Close Till"; Boolean)
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }
}

