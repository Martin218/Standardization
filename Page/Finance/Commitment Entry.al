page 50642 "Commitment Entry"
{
    // version TL 2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Commitment Entry";
    SourceTableView = WHERE("Fully Accounted for" = CONST(false));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; "Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Budget Name"; "Budget Name")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("Commitment Date"; "Commitment Date")
                {
                    ApplicationArea = All;
                }
                field("Commitment Type"; "Commitment Type")
                {
                    ApplicationArea = All;
                }
                field("Budget Line"; "Budget Line")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("User ID"; "User ID")
                {
                    ApplicationArea = All;
                }
                field("Time Stamp"; "Time Stamp")
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Source Type"; "Source Type")
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

            action("Reverse Budget Line")
            {
                ApplicationArea = All;
                Image = Comment;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction();
                begin
                    CommitmentEntry.RESET;
                    IF CommitmentEntry.GET("Entry No.") THEN BEGIN
                        CommitmentEntry.CALCFIELDS("Remaining Amount");
                        IF CommitmentEntry."Remaining Amount" >= 0 THEN BEGIN
                            BudgetManagement.CommitingBudgetLine(CommitmentTypes::IMPREST, Types::Reversal, CommitmentEntry."Budget Name", CommitmentEntry."Document No.", CommitmentEntry."Budget Line", CommitmentEntry."Remaining Amount"
                            , CommitmentEntry."Global Dimension 1 Code", CommitmentEntry."Global Dimension 2 Code");
                        END ELSE BEGIN
                            BudgetManagement.CommitingBudgetLine(CommitmentTypes::IMPREST, Types::Committed, CommitmentEntry."Budget Name", CommitmentEntry."Document No.", CommitmentEntry."Budget Line", ABS(CommitmentEntry."Remaining Amount")
                            , CommitmentEntry."Global Dimension 1 Code", CommitmentEntry."Global Dimension 2 Code");
                        END;
                        CurrPage.UPDATE;
                    END;
                end;
            }
        }
    }

    var
        CommitmentTypes: Option " ",LPO,LSO,IMPREST,ITEMS;
        Types: Option Committed,Reversal;
        CommitmentEntry: Record "Commitment Entry";
        BudgetManagement: Codeunit "Budget Management";
}

