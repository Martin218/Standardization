pageextension 50432 "General Ledger Setup Ext" extends "General Ledger Setup"
{
    layout
    {
        addafter("Show Amounts")
        {
            field("Disallow Own Approver"; "Disallow Own Approver")
            {
                ApplicationArea = All;
            }
            field("Current Bugdet"; "Current Bugdet")
            {
                ApplicationArea = All;
            }
            field("Current Budget Start Date"; "Current Budget Start Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
            field("Current Budget End Date"; "Current Budget End Date")
            {
                ApplicationArea = All;
                Editable = false;
            }
        }
    }
}