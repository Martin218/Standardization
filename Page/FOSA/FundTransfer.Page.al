page 50219 "Fund Transfer"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Posting,Category7';
    SourceTable = "Fund Transfer";

    layout
    {
        area(content)
        {
            group(Source)
            {
                Caption = 'Source';
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
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
                field("Source Account Type"; "Source Account Type")
                {
                    ApplicationArea = All;
                }
                field("Source Account No."; "Source Account No.")
                {
                    ApplicationArea = All;
                }
                field("Source Account Name"; "Source Account Name")
                {
                    ApplicationArea = All;
                }
                field("Source Account Balance"; "Source Account Balance")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
            }
            group(Destination)
            {
                Caption = 'Destination';
                field("Destination Account Ownership"; "Destination Account Ownership")
                {
                    ApplicationArea = All;
                }
                field("Destination Member No."; "Destination Member No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Member Name"; "Destination Member Name")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Type"; "Destination Account Type")
                {
                    ApplicationArea = All;
                }
                field("Destination Account No."; "Destination Account No.")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Name"; "Destination Account Name")
                {
                    ApplicationArea = All;
                }
                field("Destination Account Balance"; "Destination Account Balance")
                {
                    ApplicationArea = All;
                }
                group(Arrears)
                {
                    Caption = '';
                    Visible = "Destination Account Type" = 1;
                    field("Principal Arrears"; "Principal Arrears")
                    {
                        ApplicationArea = All;
                    }
                    field("Interest Arrears"; "Interest Arrears")
                    {
                        ApplicationArea = All;
                    }
                    field("Total Arrears"; "Total Arrears")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Overpayment)
                {
                    Caption = '';
                    Visible = "Source Account Type" = 1;
                    field("Overpayment-Principal"; "Overpayment-Principal")
                    {
                    }
                    field("Overpayment-Interest"; "Overpayment-Interest")
                    {
                    }
                    field("Overpayment-Total"; "Overpayment-Total")
                    {
                    }
                }
                field("Amount to Transfer"; "Amount to Transfer")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
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
                    TESTFIELD("Member No.");
                    TESTFIELD("Source Account No.");
                    TESTFIELD("Destination Member No.");
                    TESTFIELD("Destination Account No.");
                    TESTFIELD("Amount to Transfer");
                    TESTFIELD(Remarks);
                    IF ApprovalsMgmt.CheckFundTransferApprovalPossible(Rec) THEN begin
                        ApprovalsMgmt.OnSendFundTransferForApproval(Rec);
                        CurrPage.CLOSE;
                    end;

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
                    ApprovalsMgmt.OnCancelFundTransferApprovalRequest(Rec);
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
                    end
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
                    IF ApprovalEntry.FINDFIRST then begin
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    END;
                end;
            }
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                Visible = IsVisiblePost;

                trigger OnAction()
                begin
                    TESTFIELD("Member No.");
                    TESTFIELD("Source Account No.");
                    TESTFIELD("Destination Member No.");
                    TESTFIELD("Destination Account No.");
                    TESTFIELD("Amount to Transfer");
                    BOSAManagement.PostFundTransfer(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageEditable;
        PageVisibility;
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
        BOSAManagement: Codeunit "BOSA Management";
        Error000: Label '%1 cannot exceed %2';
        Text000: Label 'Fund Transfer';
        Error003: Label 'Loan to Loan Transfer is not allowed';
        Error004: Label '%1 must be a Loan Account';
        Error005: Label '%1 must NOT be a Loan Account';
        Error006: Label 'Loan %1 has no overpayment';
        Error007: Label '%1 cannot exceed the %2';
        Error008: Label '%1 must be %2 %3';
        Error009: Label '%1 must NOT be %2 %3';
        Error010: Label '%1 and %2 cannot be the same';
        Customer: Record Customer;
        Vendor: Record Vendor;
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;

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
        IF Posted THEN
            IsVisiblePost := FALSE;
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE
        ELSE
            CurrPage.EDITABLE := FALSE;
    end;


}

