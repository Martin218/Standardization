pageextension 50506 "G/L Budget Names Ext" extends "G/L Budget Names"
{
    layout
    {
        addafter(Description)
        {
            field("Budget Period"; "Budget Period")
            {
                ApplicationArea = All;
            }
            field("Budget Per Branch?"; "Budget Per Branch?")
            {
                ApplicationArea = All;
            }
            field("Budget Per Department?"; "Budget Per Department?")
            {
                ApplicationArea = All;
            }
            field("Budget Start Date"; "Budget Start Date")
            {
                ApplicationArea = All;
            }
            field("Budget End Date"; "Budget End Date")
            {
                ApplicationArea = All;
            }

        }
    }
}