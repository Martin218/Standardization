page 50766 "Supplier Evaluation List"
{
    CardPageID = "Supplier Evaluation Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Procurement Process Evaluation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Process No."; "Process No.")
                {
                }
                field("Vendor Name"; "Vendor Name")
                {
                    StyleExpr = SelectedFirst;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                }
                field("Quoted Amount"; "Quoted Amount")
                {
                }
                field("Total Score"; "Total Score")
                {
                    StyleExpr = SelectedFirst;
                }
                field(Type; Type)
                {
                }
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field(Amount; Amount)
                {
                }
                field("Evaluation Complete"; "Evaluation Complete")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Complete Evaluation")
            {
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    ProcurementManagement.CompleteEvaluation(Rec, 2);
                    CurrPage.CLOSE;
                end;
            }
            action("Award Supplier")
            {
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = false;
                Visible = SeeAwarding;

                trigger OnAction();
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    Rec.MARKEDONLY(TRUE);
                    ProcurementManagement.CompleteEvaluation(Rec, 3);
                    CurrPage.CLOSE
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        ProcurementProcessEvaluation.RESET;
        ProcurementProcessEvaluation.COPYFILTERS(Rec);
        ProcurementProcessEvaluation.SETCURRENTKEY("Total Score");
        ProcurementProcessEvaluation.SETASCENDING("Total Score", FALSE);
        IF ProcurementProcessEvaluation.FINDFIRST THEN BEGIN
            IF (ProcurementProcessEvaluation."Vendor Name" = "Vendor Name") AND
              ("Total Score" > 0) THEN
                SelectedFirst := 'Favorable'
            ELSE
                SelectedFirst := '';
        END
    end;

    trigger OnOpenPage();
    begin
        ManageVisibility;
    end;

    var
        ProcurementManagement: Codeunit "Procurement Management";
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        SeeEvaluation: Boolean;
        SeeAwarding: Boolean;
        ProcurementRequest: Record "Procurement Request";
        SelectedFirst: Text;

    local procedure ManageVisibility();
    begin
        SeeEvaluation := FALSE;
        IF ProcurementRequest.GET("Process No.") THEN BEGIN
            IF ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::Award THEN BEGIN
                SeeAwarding := TRUE;
            END;
            IF ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::Evaluation THEN BEGIN
                SeeEvaluation := TRUE;
            END;
        END;





        //MESSAGE(ProcurementProcessEvaluation.GETFILTERS);
    end;
}

