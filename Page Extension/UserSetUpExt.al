pageextension 50810 "User Setup Ext" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Employee No."; "Employee No.")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 1 Code"; "Global Dimension 1 Code")
            {
                ApplicationArea = All;
            }
            field("Global Dimension 2 Code"; "Global Dimension 2 Code")
            {
                ApplicationArea = All;
            }
            field("User Name"; "User Name")
            {
                ApplicationArea = All;
            }
            field(Signature; Signature)
            {
                ApplicationArea = All;
            }
        }
    }
}