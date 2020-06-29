page 50600 "Cash Management Setup"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Cash Management Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("Primary Key"; "Primary Key")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("AP Journal Template Name"; "AP Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("PV Template Batch"; "PV Template")
                {
                    ApplicationArea = All;
                }
                field("AR Journal Template Name"; "AR Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt Template"; "Cash Receipt Template")
                {
                    ApplicationArea = All;
                }
                field("Imprest Template"; "Imprest Template")
                {
                    ApplicationArea = All;
                }
                field("Imprest Surrender Template"; "Imprest Surrender Template")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Template"; "Petty Cash Template")
                {
                    ApplicationArea = All;
                }
                field("Sales Journal Template Name"; "Sales Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Sales Batch Template Name"; "Sales Batch Template Name")
                {
                    ApplicationArea = All;
                }
                field("PV No."; "PV No.")
                {
                    ApplicationArea = All;
                }
                field("Imprest No."; "Imprest No.")
                {
                    ApplicationArea = All;
                }
                field("Imprest Code"; "Imprest Code")
                {
                    ApplicationArea = All;
                }
                field("Salary Advance Code"; "Salary Advance Code")
                {
                    ApplicationArea = All;
                }
                field("Imprest Surrender No."; "Imprest Surrender No.")
                {
                    ApplicationArea = All;
                }
                field("Claim No."; "Claim No.")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash No."; "Petty Cash No.")
                {
                    ApplicationArea = All;
                }
                field("Cash Receipt No."; "Cash Receipt No.")
                {
                    ApplicationArea = All;
                }
                field("Salary Advace"; "Salary Advace")
                {
                    ApplicationArea = All;
                }
                field("Tax Withheld Description"; "Tax Withheld Description")
                {
                    ApplicationArea = All;
                }
                field("VAT Withheld Description"; "VAT Withheld Description")
                {
                    ApplicationArea = All;
                }
                field("Imprest Path"; "Imprest Path")
                {
                    ApplicationArea = All;
                }
                field("Petty Cash Bank"; "Petty Cash Bank")
                {
                    ApplicationArea = All;
                }
                field("Budget Admin"; "Budget Admin")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    actions
    {
    }
    trigger OnOpenPage()
    begin
        CashManagementSetup.Reset();
        if not CashManagementSetup.FindFirst then begin
            if CashManagementSetup."Budget Admin" = '' then begin
                CashManagementSetup."Budget Admin" := UserId;
                CashManagementSetup.Insert();
                Message('Success!');
            end;
        end;
    end;

    var
        CashManagementSetup: Record "Cash Management Setup";
}

