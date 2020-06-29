page 50706 "Submitted Procurement Plans"
{
    // version TL2.0

    Caption = 'Submitted Procurement Plans.';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "G/L Budget Name";
    SourceTableView = WHERE("Forwarded To CEO?" = FILTER('No'));

    layout
    {
        area(content)
        {
            repeater("")
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the name of the general ledger budget.';
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies a description of the general ledger budget name.';
                }
                field("Budget Period"; "Budget Period")
                {
                    ApplicationArea = All;
                }
                field("Budget Per Branch?"; "Budget Per Branch?")
                {
                    ApplicationArea = All;
                }
                field("Budget Per Department?"; "Budget Per Department?")
                {
                    ApplicationArea = All;
                }
                field(Blocked; Blocked)
                {
                    ApplicationArea = All;
                    ToolTip = '"Specifies that entries cannot be created for the budget. "';
                }
                field("Forwarded To CEO?"; "Forwarded To CEO?")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart("Links"; Links)
            {
                Visible = false;
            }
            systempart("Notes"; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("View Submitted Plan")
            {
                ApplicationArea = All;
                Caption = 'View Submitted Plans';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                var
                    Budget: Page Budget;
                begin
                    ProcurementPlanHeader1.RESET;
                    ProcurementPlanHeader1.SETRANGE("Current Budget", Name);
                    ProcurementPlanHeader1.SETRANGE(Status, ProcurementPlanHeader1.Status::Approved);
                    IF ProcurementPlanHeader1.FINDSET THEN BEGIN
                        CLEAR(ProcurementPlanListPage);
                        ProcurementPlanListPage.SETTABLEVIEW(ProcurementPlanHeader1);
                        ProcurementPlanListPage.SETRECORD(ProcurementPlanHeader1);
                        ProcurementPlanLinesPage.RUN;//MODAL;
                    END;
                end;
            }
            action("View Submitted Plan Lines")
            {
                ApplicationArea = All;
                Caption = 'View Submitted Plan Lines';
                Image = RegisterPutAway;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';
                //Visible = false;
                trigger OnAction();
                var
                    Budget: Page Budget;
                begin
                    PlanNoText := '';
                    ProcurementManagement.ViewSubmittedPlans(Rec);
                end;
            }
            action("View Plans Not Submitted")
            {
                ApplicationArea = All;
                Caption = 'View Plans Not Submitted';
                Image = EditLines;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'Return';

                trigger OnAction();
                var
                    Budget: Page Budget;
                begin
                    ProcurementPlanHeader.RESET;
                    ProcurementPlanHeader.SETRANGE("Current Budget", Rec.Name);
                    ProcurementPlanHeader.SETRANGE(Status, ProcurementPlanHeader.Status::Approved);
                    IF ProcurementPlanHeader.FINDSET THEN BEGIN
                        ProcurementManagement.ClearSubmissionEntries(ProcurementPlanHeader);
                        REPEAT
                            ProcurementManagement.UpdateSubmittedPlans(ProcurementPlanHeader);
                        UNTIL ProcurementPlanHeader.NEXT = 0;
                    END;
                    COMMIT;

                    ProcurementManagement.ViewPlansNotSubmitted(Rec);
                    PlanSubmissionEntries2.RESET;
                    PlanSubmissionEntries2.SETRANGE(Submitted, FALSE);
                    PlanSubmissionEntries2.SETRANGE("Current Budget", Name);
                    IF PlanSubmissionEntries2.FINDSET THEN BEGIN
                        REPORT.RUN(50503, TRUE, FALSE, PlanSubmissionEntries2);
                    END;
                end;
            }
            action("Request Plan Submission")
            {
                ApplicationArea = All;
                Image = Absence;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ProcurementManagement.RequestPlanSubmission(Rec);
                end;
            }
            action("Forward To CEO")
            {
            }
        }
    }

    trigger OnOpenPage();
    begin
        GLSetup.GET;
        FILTERGROUP(2);
        SETRANGE(Name, GLSetup."Current Bugdet");
        FILTERGROUP(0);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementPlanHeader1: Record "Procurement Plan Header";
        ProcurementPlanLines: Record "Procurement Plan Line";
        PlanNoText: Text;
        ProcurementPlanLinesPage: Page "Procurement Plan Lines";
        DimensionValuesPage: Page "Dimension Values";
        ProcurementPlanListPage: Page "Procurement  Plan List";
        ProcurementManagement: Codeunit "Procurement Management";
        PlanSubmissionEntries2: Record "Plan Submission Entries";

    //[Scope('Internal')]
    procedure GetSelectionFilter(): Text;
    var
        GLBudgetName: Record "G/L Budget Name";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        CurrPage.SETSELECTIONFILTER(GLBudgetName);
        EXIT(SelectionFilterManagement.GetSelectionFilterForGLBudgetName(GLBudgetName));
    end;
}

