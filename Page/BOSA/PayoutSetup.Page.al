page 50290 "Payout Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Payout Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'Charges';
                field("Charges Calculation Method"; "Charges Calculation Method")
                {
                    ApplicationArea = All;
                }
                group(Flat)
                {
                    Caption = '';
                    Visible = "Charges Calculation Method" = 1;
                    field("Flat Amount"; "Flat Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Percentage)
                {
                    Caption = '';
                    Visible = "Charges Calculation Method" = 0;
                    field("Charge %"; "Charge %")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Charges G/L Account"; "Charges G/L Account")
                {
                    ApplicationArea = All;
                }
                field("FOSA Account Type"; "FOSA Account Type")
                {
                    ApplicationArea = All;
                }
                field("Charge Witholding Tax"; "Charge Witholding Tax")
                {
                    ApplicationArea = All;
                }
                field("Charge Excise Duty"; "Charge Excise Duty")
                {
                    ApplicationArea = All;
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                field("Notify Member"; "Notify Member")
                {
                    ApplicationArea = All;
                }
                field("Notification Option"; "Notification Option")
                {
                    ApplicationArea = All;
                }
                field("SMS Template"; "SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Email Template"; "Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

