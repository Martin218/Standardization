pageextension 50194 "Bank Account Ext" extends "Bank Account Card"
{
    layout
    {
        addafter(Blocked)
        {
            field("Account Type"; "Account Type")
            {

            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
        myInt: Integer;
}