page 50204 "Loan Application List"
{
    // version TL2.0

    Caption = 'New Loan Applications';
    CardPageID = "Loan Application Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    SourceTable = "Loan Application";
    SourceTableView = WHERE(Status = CONST(New));
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
                field("Loan Product Type"; "Loan Product Type")
                {
                    Caption = 'Member No';
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Appraisal Date"; "Appraisal Date")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field("Total Arrears Amount"; "Total Arrears Amount")
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
        //LoanOffset: Record "loan off";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;

    local procedure SetActionVisible()
    begin
        /*
        IF ("FOSA Account"="FOSA Account"::"0")THEN BEGIN
            IsVisibleSendApprovalRequest:=TRUE;
            IsVisibleCancelApprovalRequest:=TRUE;
        END ELSE BEGIN
          IsVisibleSendApprovalRequest:=FALSE;
          IsVisibleCancelApprovalRequest:=FALSE;
        END;
        */

    end;
}

