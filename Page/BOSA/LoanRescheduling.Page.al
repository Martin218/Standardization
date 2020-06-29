page 50260 "Loan Rescheduling"
{
    // version TL2.0
    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Posting,Category7';
    SourceTable = "Loan Rescheduling";

    layout
    {
        area(content)
        {
            group(General)
            {
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Loan No."; "Loan No.")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        ReschedulingOptionVisibility;
                    end;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                group(ApprovedBy)
                {
                    Caption = 'Approved By';
                    field("Approved By"; "Approved By")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Approved Date"; "Approved Date")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Approved Time"; "Approved Time")
                    {
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }
            }
            group(Rescheduling)
            {
                Caption = 'Rescheduling';
                //The GridLayout property is only supported on controls of type Grid
                //GridLayout = Columns;
                field("Approved Loan Amount"; "Approved Loan Amount")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Loan Balance"; "Outstanding Loan Balance")
                {
                    ApplicationArea = All;
                }
                field("Rescheduling Option"; "Rescheduling Option")
                {
                    ApplicationArea = All;
                }
                group(RepaymentPeriod)
                {
                    Caption = '';
                    Visible = IsRepaymentPeriodVisible;
                    field("Current Repayment Period"; "Current Repayment Period")
                    {
                        ApplicationArea = All;
                    }
                    field("New Repayment Period"; "New Repayment Period")
                    {
                        ApplicationArea = All;
                    }
                }
                group(RepaymentFrequency)
                {
                    Caption = '';
                    Visible = IsRepaymentFrequencyVisible;
                    field("Current Repayment Frequency"; "Current Repayment Frequency")
                    {
                        ApplicationArea = All;
                    }
                    field("New Repayment Frequency"; "New Repayment Frequency")
                    {
                        ApplicationArea = All;
                    }
                }
                group(InterestRate)
                {
                    Caption = '';
                    Visible = IsInterestRateVisible;
                    field("Current Interest Rate"; "Current Interest Rate")
                    {
                        ApplicationArea = All;
                    }
                    field("New Interest Rate"; "New Interest Rate")
                    {
                        ApplicationArea = All;
                    }
                }
                field(Remarks; Remarks)
                {
                    ColumnSpan = 1;
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(AttachmentFactBox; 50265)
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Send an approval request.';
                Visible = IsVisibleSendApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    ValidateReschedulingOption;
                    //ValidateAttachment;
                    TESTFIELD(Remarks);
                    IF ApprovalsMgmt.CheckLoanReschedulingApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendLoanReschedulingForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = IsVisibleCancelApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    ApprovalsMgmt.OnCancelLoanReschedulingApprovalRequest(Rec);
                end;
            }
            action(Approve)
            {
                ApplicationArea = Suite;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = IsVisibleApproveAction;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN begin
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    end;
                end;
            }
            action(Reject)
            {
                ApplicationArea = Suite;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = IsVisibleRejectAction;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN begin
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    end;
                end;
            }
            action(Delegate)
            {
                ApplicationArea = Suite;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = IsVisibleDelegateAction;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN begin
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    end
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.AttachmentFactBox.PAGE.SetParameter(Rec.RECORDID, Rec."No.");
    end;

    trigger OnOpenPage()
    begin
        PageVisibility;
        PageEditable;
    end;

    var
        IsVisibleCancelApprovalRequest: Boolean;
        IsVisibleSendApprovalRequest: Boolean;
        IsVisiblePost: Boolean;
        IsVisibleApproveAction: Boolean;
        IsVisibleRejectAction: Boolean;
        IsVisibleDelegateAction: Boolean;
        IsRepaymentPeriodVisible: Boolean;
        IsRepaymentFrequencyVisible: Boolean;
        IsInterestRateVisible: Boolean;

    local procedure PageVisibility()
    begin
        IF Status = Status::New THEN BEGIN
            IsVisibleCancelApprovalRequest := TRUE;
            IsVisibleSendApprovalRequest := TRUE;
            IsVisiblePost := FALSE;
        END ELSE BEGIN
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleSendApprovalRequest := FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            IsVisibleApproveAction := TRUE;
            IsVisibleRejectAction := TRUE;
            IsVisibleDelegateAction := TRUE;
        END ELSE BEGIN
            IsVisibleApproveAction := FALSE;
            IsVisibleRejectAction := FALSE;
            IsVisibleDelegateAction := FALSE;
        END;
        IF Status = Status::Approved THEN BEGIN
            IsVisiblePost := TRUE;
        END;
        ReschedulingOptionVisibility;
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE
        ELSE
            CurrPage.EDITABLE := FALSE;
    end;

    local procedure ReschedulingOptionVisibility()
    begin
        IF ("Rescheduling Option" = "Rescheduling Option"::"Repayment Period") OR
           ("Rescheduling Option" = "Rescheduling Option"::All) THEN
            IsRepaymentPeriodVisible := TRUE
        ELSE
            IsRepaymentPeriodVisible := FALSE;
        IF ("Rescheduling Option" = "Rescheduling Option"::"Repayment Frequency") OR
           ("Rescheduling Option" = "Rescheduling Option"::All) THEN
            IsRepaymentFrequencyVisible := TRUE
        ELSE
            IsRepaymentFrequencyVisible := FALSE;
        IF ("Rescheduling Option" = "Rescheduling Option"::"Interest Rate") OR
           ("Rescheduling Option" = "Rescheduling Option"::All) THEN
            IsInterestRateVisible := TRUE
        ELSE
            IsInterestRateVisible := FALSE;
    end;
}

