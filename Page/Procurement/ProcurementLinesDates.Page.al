page 50712 "Procurement Lines Dates"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Procurement Plan Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Plan No"; "Plan No")
                {
                    Editable = true;
                    Visible = true;
                    ApplicationArea = All;
                }
                field("Current Budget"; "Current Budget")
                {
                    Editable = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Procurement Type"; "Procurement Type")
                {
                    ApplicationArea = All;
                }
                field("Procurement Sub Type"; "Procurement Sub Type")
                {
                    ApplicationArea = All;
                }
                field("Procurement Method"; "Procurement Method")
                {
                    ApplicationArea = All;
                }
                field("Expected Completion Date"; "Expected Completion Date")
                {
                    ApplicationArea = All;
                }
                field("Advertisement Date"; "Advertisement Date")
                {
                    ApplicationArea = All;
                }
                field("Document Opening Date"; "Document Opening Date")
                {
                    ApplicationArea = All;
                }
                field("Proposal Evaluation Date"; "Proposal Evaluation Date")
                {
                    ApplicationArea = All;
                }
                field("Award Approval Date"; "Award Approval Date")
                {
                    ApplicationArea = All;
                }
                field("Notification Of Award Date"; "Notification Of Award Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Signing Date"; "Contract Signing Date")
                {
                    ApplicationArea = All;
                }
                field("Negotiation Date"; "Negotiation Date")
                {
                    ApplicationArea = All;
                }
                field("Contract Completion Date"; "Contract Completion Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Update Plan Dates")
            {
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    TESTFIELD("Advertisement Date");
                    TESTFIELD("Procurement Method");
                    ProcurementManagement.ValidateProcurementDates(Rec);
                    //Rec.SETRECFILTER;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        UserSetup.GET(USERID);
        ProcurementSetup.GET;
        IF ProcurementSetup."Procurement Manager" <> USERID THEN
            CurrPage.EDITABLE(FALSE);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean;
    begin

        IF CloseAction IN [ACTION::OK, ACTION::LookupOK] THEN BEGIN
            CurrPage.EDITABLE(TRUE);
        END ELSE
            MESSAGE(CancelMessage);
    end;

    var
        CancelMessage: Label 'Page Closed';
        ProcurementManagement: Codeunit "Procurement Management";
        ForwardAction: Label 'Submit All,Submit Selected';
        ForwardTxt1: Label 'Plans submitted Successfully.';
        ForwardTxt2: Label 'Select the forwarding option.';
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementPlanLines: Record "Procurement Plan Line";
        ForwardErr1: Label 'Kindly select the lines to submit';
        ProcurementSetup: Record "Procurement Setup";
        UserSetup: Record "User Setup";

    local procedure ValidateVisibility();
    begin
    end;
}

