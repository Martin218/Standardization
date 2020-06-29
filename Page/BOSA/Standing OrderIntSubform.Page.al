page 50182 "Standing Order Int. Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Internal STO Subform';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Standing Order Line";
    SourceTableView = WHERE("Destination Type" = FILTER(Internal));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    OptionCaption = '<G/L Account,Customer,Vendor,Bank Account,Fixed Asset,IC Partner';
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Line Amount"; "Line Amount")
                {
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        //PageVisibility;
    end;

    var
        IsInternalVisible: Boolean;
        IsExternalVisible: Boolean;
        StandingOrderCard: Page "Standing Order Card";

    local procedure PageVisibility()
    begin
        IF "Destination Type" = "Destination Type"::Internal THEN
            IsInternalVisible := TRUE
        ELSE
            IsInternalVisible := FALSE;

        IF "Destination Type" = "Destination Type"::External THEN
            IsExternalVisible := TRUE
        ELSE
            IsExternalVisible := FALSE;
    end;
}

