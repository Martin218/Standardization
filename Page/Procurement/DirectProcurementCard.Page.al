page 50739 "Direct Procurement Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Procurement Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Requisition No."; "Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Created On"; "Created On")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Assigned User"; "Assigned User")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("LPO Generated"; "LPO Generated")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("LPO No."; "LPO No.")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part(Page; "Procurement Request Line")
            {
                Editable = false;
                SubPageLink = "Request No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Purchase Order")
            {
                ApplicationArea = All;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeGenerate;

                trigger OnAction();
                begin
                    ProcurementManagement.AssignUser(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        ManageVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Procurement Option" := "Procurement Option"::Direct;
        ManageVisibility;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ManageVisibility;
    end;

    trigger OnOpenPage();
    begin
        ManageVisibility;
    end;

    var
        ProcurementManagement: Codeunit "Procurement Management";
        RequisitionLines: Record "Requisition Line";
        SeeGenerate: Boolean;

    local procedure ManageVisibility();
    begin
        SeeGenerate := TRUE;
        IF "LPO Generated" THEN BEGIN
            SeeGenerate := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
    end;
}

