page 50183 "Standing Order Ex. Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    Caption = 'External STO Subform';
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Standing Order Line";
    SourceTableView = WHERE ("Destination Type" = FILTER (External));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Destination Account No."; "Destination Account No.")
{ApplicationArea = All;
                }
                field("Destination Account Name"; "Destination Account Name")
{ApplicationArea = All;
                }
                field("Destination Bank Name"; "Destination Bank Name")
{ApplicationArea = All;
                }
                field("Destination Branch Name"; "Destination Branch Name")
{ApplicationArea = All;
                }
                field("Swift Code"; "Swift Code")
{ApplicationArea = All;
                }
                field("Line Amount"; "Line Amount")
{ApplicationArea = All;
                }
                field(Priority; Priority)
{ApplicationArea = All;
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

