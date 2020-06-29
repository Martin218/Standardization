table 50152 "Loan Default Entry"
{
    // version TL2.0


    fields
    {
        field(1; "Entry No."; Integer)
        {
        }
        field(4; "Loan No."; Code[20])
        {
            TableRelation = "Loan Application";
        }
        field(5; Description; Text[50])
        {
        }
        field(6; "Member No."; Code[20])
        {
            TableRelation = Member;
        }
        field(7; "Member Name"; Text[50])
        {
        }
        field(8; "Approved Amount"; Decimal)
        {
        }
        field(9; "Repayment Method"; Option)
        {
            OptionCaption = 'Straight Line,Reducing Balance,Amortization';
            OptionMembers = "Straight Line","Reducing Balance",Amortization;
        }
        field(10; "Repayment Period"; Decimal)
        {
        }
        field(11; "Remaining Period"; Decimal)
        {
        }
        field(12; "Remaining Principal Amount"; Decimal)
        {
        }
        field(13; "Remaining Interest Amount"; Decimal)
        {
        }
        field(14; "Principal Installment"; Decimal)
        {
        }
        field(15; "Interest Installment"; Decimal)
        {
        }
        field(16; "Total Installment"; Decimal)
        {
        }
        field(17; "Principal Arrears Amount"; Decimal)
        {
        }
        field(18; "Interest Arrears Amount"; Decimal)
        {
        }
        field(19; "Total Arrears Amount"; Decimal)
        {
        }
        field(20; "Outstanding Balance"; Decimal)
        {
        }
        field(22; "Classification Class"; Code[20])
        {
        }
        field(23; "Repayment Frequency"; Option)
        {
            OptionCaption = 'Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually';
            OptionMembers = Daily,Weekly,Fortnightly,Monthly,Quarterly,Annually;
        }
        field(24; "No. of Days in Arrears"; Integer)
        {
        }
        field(25; "Last Payment Date"; Date)
        {
        }
        field(26; "No. of Defaulted Installment"; Integer)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

