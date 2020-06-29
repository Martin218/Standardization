table 50110 "Loan Repayment Schedule"
{
    // version TL2.0


    fields
    {
        field(1; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(2; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(3; "Member Name"; Text[200])
        {
        }
        field(4; "Loan Amount"; Decimal)
        {
        }
        field(6; "Repayment Date"; Date)
        {
        }
        field(7; "Instalment No."; Integer)
        {
        }
        field(8; "Principal Installment"; Decimal)
        {
        }
        field(9; "Interest Installment"; Decimal)
        {
        }
        field(10; "Total Installment"; Decimal)
        {
        }
    }

    keys
    {
        key(Key1; "Loan No.", "Instalment No.")
        {
        }
    }

    fieldgroups
    {
    }
}

