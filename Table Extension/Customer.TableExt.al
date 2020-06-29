tableextension 50001 CustomerExt extends Customer
{
    fields
    {
        // Add changes to table fields here
        field(50000; "Member No."; Code[20])
        {
            TableRelation = Member;

        }
        field(50001; "Member Name"; Text[50])
        {


        }
        field(50002; "Account Type"; Code[20])
        {
            TableRelation = "Account Type";

        }
        field(50003; Status; Option)
        {
            OptionMembers = Active,Blocked,Dormant;
            OptionCaption = 'Active,Blocked,Dormant';

        }
        field(50004; "CustomerType"; Code[20])
        {
            // OptionMembers = Normal,Loan;
            //OptionCaption = 'Normal,Loan';

        }
    }
    var
        myInt: Integer;
}