page 50016 "Account Type List"
{
    // version TL2.0

    Caption = 'Account Types';
    CardPageID = "Account Type Card";
    PageType = List;
    SourceTable = "Account Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Code; Code)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Minimum Balance"; "Minimum Balance")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Dormancy Period"; "Dormancy Period")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Maintenance Fee"; "Maintenance Fee")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Allow Withdrawal"; "Allow Withdrawal")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Allow Deposit"; "Allow Deposit")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Allow Payout"; "Allow Payout")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Allow ATM"; "Allow ATM")
                {
                    ApplicationArea = All;
                }
                field("Allow Spotcash"; "Allow Spotcash")
                {
                    ApplicationArea = All;
                }
                field("Allow Agency"; "Allow Agency")
                {
                    ApplicationArea = All;
                }
                field("Earns Interest"; "Earns Interest")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Posting Group"; "Posting Group")
                {
                    ApplicationArea = All;
                }

                field("Open Automatically"; "Open Automatically")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

