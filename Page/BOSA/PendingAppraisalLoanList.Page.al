page 50205 "Pending Loan Applications List"
{
    // version TL2.0

    Caption = 'Loans Pending Appraisal';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));
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
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Requested Amount"; "Requested Amount")
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
        /*IF (("FOSA Account"="FOSA Account"::"1") OR ("FOSA Account"="FOSA Account"::"2") OR
            ("FOSA Account"="FOSA Account"::"3")) THEN BEGIN
            IsVisibleSendApprovalRequest:=FALSE;
            IsVisibleCancelApprovalRequest:=FALSE;
        END;
        */

    end;
}

