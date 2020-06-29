page 50206 "Pending Disbursal Loan List"
{
    // version TL2.0

    Caption = 'Loans Pending Disbursal';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER(Approved),
                            Posted = FILTER(false));
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
    }

    trigger OnOpenPage()
    begin
        SetActionVisible;
    end;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanSecurity: Record "Loan Security";
        //LoanOffset: Record "50106";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;

    local procedure SetActionVisible()
    begin
    end;
}

