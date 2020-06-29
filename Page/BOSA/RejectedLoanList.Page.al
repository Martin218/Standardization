page 50217 "Rejected Loans List"
{
    // version TL2.0

    Caption = 'Rejected Loans';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER(Rejected));
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Period"; "Repayment Period")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Date"; "Appraisal Date")
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; "Requested Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Shares Amount"; "Total Shares Amount")
                {
                    ApplicationArea = All;
                }
                field("Refinance Another Loan"; "Refinance Another Loan")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Guarantors")
            {
                ApplicationArea = Basic, Suite;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    LoanGuarantor.FILTERGROUP(10);
                    LoanGuarantor.SETRANGE("Loan No.", Rec."No.");
                    LoanGuarantor.FILTERGROUP(0);
                    PAGE.RUN(50047, LoanGuarantor);
                end;
            }
            action("Loan Security")
            {
                ApplicationArea = Basic, Suite;
                Image = Lock;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    LoanSecurity.FILTERGROUP(10);
                    LoanSecurity.SETRANGE("Loan No.", Rec."No.");
                    LoanSecurity.FILTERGROUP(0);
                    PAGE.RUN(50046, LoanSecurity);
                end;
            }
            action("Loan Offset")
            {
                Image = CoupledCurrency;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    LoanOffset.FILTERGROUP(10);
                    LoanOffset.SETRANGE("Loan No.", Rec."No.");
                    LoanOffset.FILTERGROUP(0);
                    PAGE.RUN(50048, LoanOffset);
                end;
            }
        }
    }

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanSecurity: Record "Loan Security";
        LoanOffset: Record "Loan Refinancing Entry";
}

