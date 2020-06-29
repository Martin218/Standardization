page 50184 "Standing Order Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Standing Order Setup";
    UsageCategory = Administration;
    ApplicationArea = All;
    layout
    {
        area(content)
        {
            group(Transactions)
            {
                Caption = 'Transactions';
                field("Charge Transaction"; "Charge Transaction")
                {
                    ApplicationArea = All;
                }
                field("Transaction Calculation Method"; "Transaction Calculation Method")
                {
                    ApplicationArea = All;
                }
                group(TransFlatAmount)
                {
                    Caption = '';
                    Visible = "Transaction Calculation Method" = 1;
                    field("Transaction Flat Amount"; "Transaction Flat Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group(TransPercent)
                {
                    Visible = "Transaction Calculation Method" = 0;
                    field("Transaction %"; "Transaction %")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Transaction G/L Account"; "Transaction G/L Account")
                {
                    ApplicationArea = All;
                }
                field("Charge Option"; "Charge Option")
                {
                    ApplicationArea = All;
                }
            }
            group(Penalty)
            {
                Caption = 'Penalty';
                field("Charge Penalty"; "Charge Penalty")
                {
                    ApplicationArea = All;
                }
                field("Penalty Calculation Method"; "Penalty Calculation Method")
                {
                    ApplicationArea = All;
                }
                group(PenaltyFlatAmount)
                {
                    Caption = '';
                    group(PenaltyPercent)
                    {
                        Caption = '';
                        Visible = "Penalty Calculation Method" = 0;
                        field("Penalty %"; "Penalty %")
                        {
                            ApplicationArea = All;
                        }
                    }
                    group(PenaltyFlat)
                    {
                        Caption = '';
                        Visible = "Penalty Calculation Method" = 1;
                        field("Penalty Flat Amount"; "Penalty Flat Amount")
                        {
                            ApplicationArea = All;
                        }
                    }
                    field("Penalty G/L Account"; "Penalty G/L Account")
                    {
                        ApplicationArea = All;
                    }
                    field("Penalty Option"; "Penalty Option")
                    {
                        ApplicationArea = All;
                    }
                }
            }
            group(Notification)
            {
                Caption = 'Notification';
                field("Notify Source Member"; "Notify Source Member")
                {
                    ApplicationArea = All;
                }
                field("Source SMS Template"; "Source SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Source Email Template"; "Source Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notify Destination Member"; "Notify Destination Member")
                {
                    ApplicationArea = All;
                }
                field("Destination SMS Template"; "Destination SMS Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Destination Email Template"; "Destination Email Template")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Notify on External"; "Notify on External")
                {
                    ApplicationArea = All;
                }
                field(ExternalEmailTemplate; ExternalEmailTemplate)
                {
                    Caption = 'External Email Template';
                    MultiLine = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetEmailTemplate(ExternalEmailTemplate);
                    end;
                }
                field("External Email Address"; "External Email Address")
                {
                    ApplicationArea = All;
                }
                field(ExternalSMSTemplate; ExternalSMSTemplate)
                {
                    Caption = 'External SMS Template';
                    MultiLine = true;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetSMSTemplate(ExternalSMSTemplate);
                    end;
                }
                field("External Phone No."; "External Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Notification Option"; "Notification Option")
                {
                    ApplicationArea = All;
                }
            }
            group("Control Account")
            {
                Caption = 'External';
                field("Bank Control Account"; "Bank Control Account")
                {
                    ApplicationArea = All;
                }
            }
            group(Additional)
            {
                Caption = 'Additional';
                field("Allow Partial Deduction"; "Allow Partial Deduction")
                {
                    ApplicationArea = All;
                }
                field("Allow Overdrawing"; "Allow Overdrawing")
                {
                    ApplicationArea = All;
                }
                group(OverdrawingOption)
                {
                    Caption = '';
                    Visible = "Allow Overdrawing" = TRUE;

                    field("Overdrawing Option"; "Overdrawing Option")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Recover Source Arrears"; "Recover Source Arrears")
                {
                    ApplicationArea = All;
                }
                field("Recover Destination Arrears"; "Recover Destination Arrears")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        ExternalEmailTemplate := GetEmailTemplate;
        ExternalSMSTemplate := GetSMSTemplate;
    end;

    var
        ExternalEmailTemplate: Text;
        ExternalSMSTemplate: Text;
}

