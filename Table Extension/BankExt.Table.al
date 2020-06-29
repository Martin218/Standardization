tableextension 50169 "Bank Ext" extends "Bank Account"
{
    fields
    {
        field(50000; "Account Type"; Option)
        {
            OptionCaption = 'Bank Account,Till Account,Treasury Account';
            OptionMembers = "Bank Account","Teller Account","Treasury Account";
        }
    }

    var
        myInt: Integer;
}