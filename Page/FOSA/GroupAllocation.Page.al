page 55035 "Group Allocation"
{
    // version MC2.0

    PageType = Document;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Posting,Category7';
    RefreshOnActivate = true;
    SourceTable = "Group Allocation Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Current Meeting Date"; "Current Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
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
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Total Collected Amount"; "Total Collected Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Allocated Amount"; "Total Allocated Amount")
                {
                    ApplicationArea = All;
                }
                field("Total Remaining Amount"; "Total Remaining Amount")
                {
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
                field(Status; Status)
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
            }
            part("Group Allocation Subform"; "Group Allocation Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
            }
        }
        area(factboxes)
        {
            part(AttachmentFactBox; "Attachement FactBox")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    IF NOT CheckAllocationEntriesExist THEN
                        ERROR(Error000);

                    CALCFIELDS("Total Remaining Amount");
                    TESTFIELD("Total Remaining Amount", 0);
                    IF ApprovalsMgmt.CheckGroupAllocationApprovalPossible(Rec) THEN begin
                        ApprovalsMgmt.OnSendGroupAllocationForApproval(Rec);

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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    ApprovalsMgmt.OnCancelGroupAllocationApprovalRequest(Rec);
                    CurrPage.CLOSE;
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
                    // MicroCreditManagement.PostGroupAllocation(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisiblePrint;

                trigger OnAction()
                begin
                    SETRANGE("No.", "No.");
                    REPORT.RUN(55003, TRUE, FALSE, Rec);
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
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        begin
                            ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                            CurrPage.CLOSE;
                        end;
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
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
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
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                        CurrPage.CLOSE;
                    end;
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
        IsVisiblePrint: Boolean;
        IsVisibleApproveAction: Boolean;
        IsVisibleRejectAction: Boolean;
        IsVisibleDelegateAction: Boolean;
        // MicroCreditManagement: Codeunit "55001";
        Error000: Label 'No Allocation Entries exist';
        UserSetup: Record "User Setup";

    local procedure PageVisibility()
    begin
        IF Status = Status::New THEN BEGIN
            IsVisibleCancelApprovalRequest := TRUE;
            IsVisibleSendApprovalRequest := TRUE;
            IsVisiblePrint := FALSE;
            IsVisiblePost := FALSE;
        END ELSE BEGIN
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleSendApprovalRequest := FALSE;
        END;
        IF Status = Status::Approved THEN
            IsVisiblePost := TRUE
        ELSE
            IsVisiblePost := FALSE;
        IF Posted THEN BEGIN
            IsVisiblePrint := TRUE;
            IsVisiblePost := FALSE;//
        END ELSE BEGIN
            IsVisiblePrint := FALSE;
            // IsVisiblePost:=FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            /* IF ((MicroCreditManagement.CheckSenderApprovalEntryExist(Rec."No.")) AND (NOT MicroCreditManagement.CheckApproverApprovalEntryExist(Rec."No."))) THEN BEGIN
                IsVisibleApproveAction := FALSE;
                IsVisibleRejectAction := FALSE;
                IsVisibleDelegateAction := FALSE;
            END ELSE BEGIN
                IsVisibleApproveAction := TRUE;
                IsVisibleRejectAction := TRUE;
                IsVisibleDelegateAction := TRUE;
            END; */
        END ELSE BEGIN
            IsVisibleApproveAction := FALSE;
            IsVisibleRejectAction := FALSE;
            IsVisibleDelegateAction := FALSE;
        END;
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE
        ELSE
            CurrPage.EDITABLE := FALSE;
    end;
}

