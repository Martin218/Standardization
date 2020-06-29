page 50713 "Submitted Plans - DG Approved"
{
    // version TL2.0

    Caption = 'Submitted Plans - DG Approved';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "G/L Budget Name";
    SourceTableView = WHERE("Forwarded To CEO?" = FILTER('Yes'),
                            "CEO Approved" = FILTER('Yes'));

    layout
    {
        area(content)
        {
            repeater(Group)
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
                    ProcurementManagement.ViewPlansNotSubmitted(Rec);
                    PlanSubmissionEntries2.RESET;
                    PlanSubmissionEntries2.SETRANGE(Submitted, FALSE);
                    PlanSubmissionEntries2.SETRANGE("Current Budget", Name);
                    IF PlanSubmissionEntries2.FINDSET THEN BEGIN
                        REPORT.RUN(50503, TRUE, FALSE, PlanSubmissionEntries2);
                    END;
                end;
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

