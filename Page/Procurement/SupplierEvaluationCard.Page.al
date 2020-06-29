page 50760 "Supplier Evaluation Card"
{
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Card;
    SourceTable = "Procurement Process Evaluation";
    PromotedActionCategories = 'New,Process,Reports,Technical Evaluation,Financial Evaluation,Evaluation Completion';

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                }
                field("Vendor Name"; "Vendor Name")
                {
                    Editable = false;
                }
                field(Type; Type)
                {
                    Editable = false;
                }
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                    Editable = false;
                }
                field(Quantity; Quantity)
                {
                    Editable = false;
                }
                field("Quoted Amount"; "Quoted Amount")
                {
                    Editable = false;
                }
                field(Amount; Amount)
                {
                    Caption = 'Agreed Amount';
                }
                field("Category Description"; "Category Description")
                {
                    Editable = false;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                    Editable = false;
                }
                field("Quote Generated"; "Quote Generated")
                {
                    Editable = false;
                }
                field("Evaluation Complete"; "Evaluation Complete")
                {
                    Editable = false;
                }
                field(Awarded; Awarded)
                {
                    Editable = false;
                }
            }
            group(Scores)
            {
                field("Mandatory Score"; "Mandatory Score")
                {
                    Editable = false;
                }
                field("Mandatory Requirements Summary"; "Mandatory Requirements Summary")
                {
                    Editable = false;
                }
                field("Technical Score"; "Technical Score")
                {
                    Editable = false;
                }
                field("Technical Requirements Summary"; "Technical Requirements Summary")
                {
                    Editable = false;
                }
                field("Financial Score"; "Financial Score")
                {
                    Editable = false;
                }
                field("Financial Requirements Summary"; "Financial Requirements Summary")
                {
                    Editable = false;
                }
                field("Total Score"; "Total Score")
                {
                    Editable = false;
                    StyleExpr = StyleExpr;
                }
                field("Overall Requirements Summary"; "Overall Requirements Summary")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Mandatory Requirements")
            {
                Image = BreakpointsList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeMandatory;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewEvaluationRequirements(Rec, 1);
                end;
            }
            action("Generate Average Mandatory  Score")
            {
                Image = DeactivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeMandatory;

                trigger OnAction();
                begin
                    ProcurementManagement.GenerateAverageScore(Rec, 1);
                    //CurrPage.CLOSE;
                end;
            }
            action("Forward for Technical Evaluation")
            {
                Image = Debug;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeMandatory;

                trigger OnAction();
                begin
                    TESTFIELD("Mandatory Score");
                    TESTFIELD("Mandatory Requirements Summary", "Mandatory Requirements Summary"::Pass);
                    ProcurementManagement.ForwardToNextEvaluationStage(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Technical Requirements")
            {
                Image = AdministrationSalesPurchases;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeTechnical;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewEvaluationRequirements(Rec, 2);
                end;
            }
            action("Generate Average Technical Score")
            {
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeTechnical;

                trigger OnAction();
                begin
                    ProcurementManagement.GenerateAverageScore(Rec, 2);
                    //CurrPage.CLOSE;
                end;
            }
            action("Forward for Financial Evaluation")
            {
                Enabled = SeeTechnical2;
                Image = ExciseApplyToLine;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeTechnical;

                trigger OnAction();
                begin
                    TESTFIELD("Technical Score");
                    TESTFIELD("Technical Requirements Summary", "Technical Requirements Summary"::Pass);
                    ProcurementManagement.ForwardToNextEvaluationStage(Rec, 2);
                    CurrPage.CLOSE;
                end;
            }
            action("Financial Requirements")
            {
                Image = IssueFinanceCharge;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeFinancial;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewEvaluationRequirements(Rec, 3);
                end;
            }
            action("Generate Average Financial Score")
            {
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeFinancial;

                trigger OnAction();
                begin
                    ProcurementManagement.GenerateAverageScore(Rec, 3);
                    CurrPage.UPDATE;
                    //CurrPage.CLOSE;
                end;
            }
            action("Generate Average Total Score")
            {
                Enabled = SeeFinancial2;
                Image = CalculateDiscount;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeFinancial;

                trigger OnAction();
                begin
                    IF Amount = 0 THEN
                        Amount := "Quoted Amount";
                    MODIFY;
                    //TESTFIELD(Amount);
                    ProcurementManagement.GenerateAverageScore(Rec, 4);
                    //CurrPage.CLOSE;
                end;
            }
            action("Forward for Award")
            {
                Enabled = SeeFinancial2;
                Image = ExciseApplyToLine;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeFinancial;

                trigger OnAction();
                begin
                    TESTFIELD("Financial Requirements Summary", "Financial Requirements Summary"::Pass);
                    TESTFIELD("Total Score");
                    TESTFIELD("Overall Requirements Summary");
                    ProcurementManagement.ForwardToNextEvaluationStage(Rec, 3);
                    //CurrPage.UPDATE;
                    CurrPage.CLOSE;
                end;
            }
            action("All Requirements")
            {
                Image = BreakpointsList;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    SupplierEvaluation.RESET;
                    SupplierEvaluation.SETRANGE("Vendor No.", "Vendor No.");
                    SupplierEvaluation.SETRANGE("Process No.", "Process No.");
                    IF SupplierEvaluation.FINDSET THEN BEGIN
                        CLEAR(SupplierEvaluations);
                        SupplierEvaluations.SETTABLEVIEW(SupplierEvaluation);
                        SupplierEvaluations.SETRECORD(SupplierEvaluation);
                        SupplierEvaluations.LOOKUPMODE(TRUE);
                        SupplierEvaluations.RUNMODAL;
                    END;
                end;
            }
            action("Send Regret Letter")
            {
                Image = OverdueMail;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeRegretLetter;

                trigger OnAction();
                begin
                    ProcurementManagement.SendLetter(Rec, "Evaluation Stage");
                    CurrPage.CLOSE;
                end;
            }
            action("Complete Evaluation")
            {
                Image = CompleteLine;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    Rec.MARKEDONLY(TRUE);
                    ProcurementManagement.CompleteEvaluation(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Award Supplier")
            {
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
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

    trigger OnModifyRecord(): Boolean;
    begin
        ManageVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
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
        SupplierEvaluationspg: Page "Supplier Requirement Eval";
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementManagement: Codeunit "Procurement Management";
        SeeMandatory: Boolean;
        SeeMandatory2: Boolean;
        SeeTechnical: Boolean;
        SeeTechnical2: Boolean;
        SeeFinancial: Boolean;
        SeeFinancial2: Boolean;
        SupplierEvaluations: Page "Supplier Requirement Eval";
        SeeAllRequirements: Boolean;
        SeeRegretLetter: Boolean;
        SeeAwarding: Boolean;
        ProcurementRequest: Record "Procurement Request";
        SeeEvaluation: Boolean;
        //WshShell : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        StyleExpr: Text;

    local procedure ManageVisibility();
    begin
        SeeMandatory := FALSE;
        SeeMandatory2 := FALSE;
        SeeRegretLetter := TRUE;
        SeeAwarding := FALSE;
        IF "Evaluation Stage" = "Evaluation Stage"::Mandatory THEN BEGIN
            SeeMandatory := TRUE;
            SeeMandatory2 := TRUE;
        END;
        IF "Evaluation Stage" = "Evaluation Stage"::Technical THEN BEGIN
            SeeTechnical := TRUE;
            SeeTechnical2 := TRUE;
        END;
        IF "Evaluation Stage" = "Evaluation Stage"::Financial THEN BEGIN
            SeeFinancial := TRUE;
            SeeFinancial2 := TRUE;
        END;
        IF "Evaluation Stage" = "Evaluation Stage"::Awarding THEN BEGIN
            SeeRegretLetter := FALSE;
        END;
        IF ProcurementRequest.GET("Process No.") THEN BEGIN
            IF (ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::CEO) AND
              (ProcurementRequest.Status = ProcurementRequest.Status::Released) THEN BEGIN
                SeeAwarding := TRUE;
            END;
            IF ProcurementRequest."Process Status" = ProcurementRequest."Process Status"::Evaluation THEN BEGIN
                SeeEvaluation := TRUE;
            END;
        END;
        ProcurementProcessEvaluation.RESET;
        ProcurementProcessEvaluation.SETRANGE("Process No.", "Process No.");
        ProcurementProcessEvaluation.SETRANGE("Evaluation Stage", ProcurementProcessEvaluation."Evaluation Stage"::Awarding);
        ProcurementProcessEvaluation.SETCURRENTKEY("Total Score");
        ProcurementProcessEvaluation.SETASCENDING("Total Score", FALSE);
        IF ProcurementProcessEvaluation.FINDFIRST THEN BEGIN
            IF ProcurementProcessEvaluation."Vendor Name" <> "Vendor Name" THEN BEGIN
                StyleExpr := 'strongaccent';
            END ELSE BEGIN
                StyleExpr := 'favorable';
            END;
        END;

    end;

    /*local procedure RefreshPage();
    begin
        IF ISCLEAR(WshShell) THEN
          CREATE(WshShell,TRUE,TRUE);

        WshShell.SendKeys('{F5}');
    end;
    */
}

