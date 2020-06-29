table 52025 "Portfolio Transfer Entry"
{
    // version MC2.0


    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Transfer Date"; Date)
        {
        }
        field(3; "Loan No."; Code[20])
        {
        }
        field(4; Description; Text[50])
        {
        }
        field(5; "Member No."; Code[20])
        {
        }
        field(6; Name; Text[100])
        {
        }
        field(7; "Transferred Loan Amount"; Decimal)
        {
        }
        field(8; "Previous Loan Officer ID"; Code[20])
        {
        }
        field(9; "Current Loan Officer ID"; Code[20])
        {
        }
        field(10; "Previous Branch Code"; Code[10])
        {
        }
        field(11; "Current Branch Code"; Code[10])
        {
        }
        field(12; Type; Option)
        {
            OptionCaption = 'Client,Group,Loan,Loan Officer';
            OptionMembers = Client,Group,Loan,"Loan Officer";
        }
        field(13; "Entry No."; Integer)
        {
            AutoIncrement = true;
        }
    }

    keys
    {
        key(Key1; "No.", "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        MicroCreditMember: Record Member;
        LoanProductTypes: Record "Loan Product Type";
}

