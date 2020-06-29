page 50027 "Transaction Charges"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'Transaction Charges';
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Transaction Charge";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Calculation Method"; "Calculation Method")
                {

                    trigger OnValidate()
                    begin
                        SetVisible;
                    end;
                }
                field("Minimum Amount"; "Minimum Amount")
                {ApplicationArea=All;
                }
                field("Maximum Amount"; "Maximum Amount")
                {ApplicationArea=All;
                }
                field("Settlement %"; "Settlement %")
                {
                    Visible = IsPercentColumnVisible;
                }
                field("Settlement Amount  (SACCO)"; "Settlement Amount  (SACCO)")
                {
                    Visible = IsFlatColumnVisible;
                }
                field("Settlement % (TL)"; "Settlement % (TL)")
                {
                    Visible = IsPercentColumnVisible;
                }
                field("Settlement Amount  (TL)"; "Settlement Amount  (TL)")
                {
                    Visible = IsFlatColumnVisible;
                }
                field("Settlement % (COOP)"; "Settlement % (COOP)")
                {
                    Visible = IsPercentColumnVisible;
                }
                field("Settlement Amount (COOP)"; "Settlement Amount (COOP)")
                {
                    Visible = IsFlatColumnVisible;
                }
                field("Settlement % (AGENT)"; "Settlement % (AGENT)")
                {
                    Visible = IsPercentColumnVisible;
                }
                field("Settlement Amount (AGENT)"; "Settlement Amount (AGENT)")
                {
                    Visible = IsFlatColumnVisible;
                }
                field("Apportionment Amount"; "Apportionment Amount")
                {
                    Visible = IsPercentColumnVisible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetVisible;
    end;

    trigger OnOpenPage()
    begin
        SetVisible;
    end;

    var
        IsPercentColumnVisible: Boolean;
        IsFlatColumnVisible: Boolean;

    local procedure SetVisible()
    begin
        IF "Calculation Method" = "Calculation Method"::"Based on %" THEN BEGIN
            IsPercentColumnVisible := TRUE;
            IsFlatColumnVisible := FALSE;
            CurrPage.UPDATE;
        END ELSE
            IF "Calculation Method" = "Calculation Method"::"Based Flat Amount" THEN BEGIN
                IsPercentColumnVisible := FALSE;
                IsFlatColumnVisible := TRUE;
                CurrPage.UPDATE;
            END;
    end;
}

