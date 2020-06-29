page 50639 "Budget Creation"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "G/L Budget Name";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Budget Period"; "Budget Period")
                {
                    ApplicationArea = All;
                }
                field("Budget Start Date"; "Budget Start Date")
                {
                    ApplicationArea = All;
                }
                field("Budget End Date"; "Budget End Date")
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
                }
            }
        }
    }

    actions
    {
        area(creation)
        {

            action("Budget Creation Lines")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Budget Creation Header";
                RunPageLink = "Budget Name" = FIELD(Name);
            }
            action("Post Budget")
            {
                ApplicationArea = All;
                Image = PostedMemo;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    BudgetManagement.PostingBudgetLines(Rec);
                end;
            }
            action("Submitted Budget")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Submited Budget";
                RunPageLink = "Budget Name" = FIELD(Name);
            }
            action("Consolidated Budget")
            {
                ApplicationArea = All;
                Image = CreateLedgerBudget;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Consolidated Budget";
                RunPageLink = "Budget Name" = FIELD(Name);
            }
            action("Send For Consolidation")
            {
                ApplicationArea = All;
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    BudgetManagement.SendForConsolidation(Rec);
                end;
            }
        }
        area(reporting)
        {
            action("Budget Report")
            {
                Image = "Report";
                ApplicationArea = All;
                trigger OnAction();
                begin

                    Rec.RESET;
                    Rec.SETRANGE(Name, Name);
                    REPORT.RUN(50449, TRUE, TRUE, Rec);
                    Rec.RESET;
                    CurrPage.UPDATE;
                end;
            }
            action("Budget Variance  Report")
            {
                Image = "Report";
                ApplicationArea = All;
                trigger OnAction();
                begin
                    Rec.RESET;
                    Rec.SETRANGE(Name, Name);
                    REPORT.RUN(50450, TRUE, TRUE, Rec);
                    Rec.RESET;
                    CurrPage.UPDATE;
                end;
            }
        }
    }

    var
        BudgetManagement: Codeunit "Budget Management";
}

