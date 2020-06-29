page 50240 "Member Refund Subform"
{
    // version TL2.0

    PageType = ListPart;
    SourceTable = "Member Refund Line";
    AutoSplitKey = true;
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Account Category"; "Account Category")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("Account Ownership"; "Account Ownership")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Beneficiary Allocation")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    MemberRefundHeader.GET("Document No.");
                    MemberRefundHeader.TESTFIELD(Status, MemberRefundHeader.Status::"Pending Approval");

                    TESTFIELD("Account Ownership", "Account Ownership"::Self);
                    BeneficiaryAllocation.FILTERGROUP(10);
                    BeneficiaryAllocation.SETRANGE("Document No.", Rec."Document No.");
                    BeneficiaryAllocation.SETRANGE("Source Account No.", Rec."Account No.");
                    BeneficiaryAllocation.FILTERGROUP(0);
                    PAGE.RUN(50247, BeneficiaryAllocation);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        PageVisibility;
    end;

    var
        BeneficiaryAllocation: Record "Beneficiary Allocation";
        IsVisibleAllocation: Boolean;
        MemberRefundHeader: Record "Member Refund Header";

    local procedure PageVisibility()
    var
        MemberRefundHeader: Record "Member Refund Header";
    begin
        IF MemberRefundHeader.GET("Document No.") THEN BEGIN
            IF MemberRefundHeader.Status = MemberRefundHeader.Status::"Pending Approval" THEN BEGIN
                IF MemberRefundHeader."Created By" <> USERID THEN
                    IsVisibleAllocation := TRUE
                ELSE
                    IsVisibleAllocation := FALSE
            END ELSE
                IsVisibleAllocation := FALSE;
        END;
    end;
}

