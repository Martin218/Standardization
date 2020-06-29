page 50765 "Supplier Requirement Eval"
{
    PageType = List;
    SourceTable = "Supplier Evaluation";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Vendor No."; "Vendor No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Evaluation Stage"; "Evaluation Stage")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Evaluation Code"; "Evaluation Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Evaluation Description"; "Evaluation Description")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Needs Attachment"; "Needs Attachment")
                {
                    ApplicationArea = All;
                }
                field("Document Attached"; "Document Attached")
                {
                    ApplicationArea = All;
                }
                field("Score(%)"; "Score(%)")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field("Evaluating UserID"; "Evaluating UserID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Generate Average Score")
            {
                ApplicationArea = All;
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    /*SupplierEvaluation.COPYFILTERS(Rec);
                    ProcurementManagement.GenerateAverageScore(SupplierEvaluation,1);
                    CurrPage.CLOSE;
                    */

                end;
            }
        }
    }

    var
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementManagement: Codeunit "Procurement Management";
}

