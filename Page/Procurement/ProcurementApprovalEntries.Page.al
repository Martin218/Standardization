page 50729 "Procurement Approval Entries"
{
    // version TL2.0

    Caption = 'Requests to Approve';
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Approval Entry";
    SourceTableView = SORTING("Due Date")
                      ORDER(Ascending)
                      WHERE("Document Type" = FILTER('Store Requisition' | 'Store Return' | 'Purchase Requisition'));

    layout
    {
        area(content)
        {
            repeater(group)
            {
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field(Details; RecordDetails)
                {
                    ApplicationArea = All;
                    Caption = 'Details';
                    ToolTip = 'Specifies details about the approval request, such as what and who the request is about.';
                    Width = 50;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    HideValue = NOT Comment;
                    ToolTip = 'Specifies whether there are comments relating to the approval of the record. If you want to read the comments, choose the field to open the Approval Comment Sheet window.';
                }
                field("Sender ID"; "Sender ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the ID of the user who sent the approval request for the document to be approved.';
                }
                field("Approver ID"; "Approver ID")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    StyleExpr = DateStyle;
                    ToolTip = 'Specifies when the record must be approved, by one or more approvers.';
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the approval status for the entry:';
                }
            }
        }
        area(factboxes)
        {
            part(CommentsFactBox; 9104)
            {
                ApplicationArea = All;
                Visible = ShowCommentFactbox;
            }
            part(Change; 1527)
            {
                ApplicationArea = All;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                UpdatePropagation = SubPart;
                Visible = ShowChangeFactBox;
            }
            systempart("Links"; Links)
            {
                Visible = false;
                ApplicationArea = All;
            }
            systempart("Notes"; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Show)
            {
                Caption = 'Show';
                Image = View;
                action("Record")
                {
                    ApplicationArea = All;
                    Caption = 'Open Record';
                    Enabled = ShowRecCommentsEnabled;
                    Image = Document;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'Open the document, journal line, or card that the approval is requested for.';

                    trigger OnAction();
                    begin
                        ShowRecord;
                    end;
                }
                action(Comments)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Enabled = ShowRecCommentsEnabled;
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Scope = Repeater;
                    ToolTip = 'View or add comments for the record.';

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                        RecRef: RecordRef;
                    begin
                        RecRef.GET("Record ID to Approve");
                        CLEAR(ApprovalsMgmt);
                        ApprovalsMgmt.GetApprovalCommentForWorkflowStepInstanceID(RecRef, "Workflow Step Instance ID");
                    end;
                }
            }
        }
        area(processing)
        {
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';

                trigger OnAction();
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    IF CONFIRM(Text001) THEN BEGIN
                        CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    END;
                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';

                trigger OnAction();
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';

                trigger OnAction();
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CurrPage.SETSELECTIONFILTER(ApprovalEntry);
                    ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                end;
            }
            group(View)
            {
                Caption = 'View';
                action(OpenRequests)
                {
                    ApplicationArea = All;
                    Caption = 'Open Requests';
                    Image = Approvals;
                    ToolTip = 'Open the approval requests that remain to be approved or rejected.';

                    trigger OnAction();
                    begin
                        SETRANGE(Status, Status::Open);
                        ShowAllEntries := FALSE;
                    end;
                }
                action(AllRequests)
                {
                    ApplicationArea = All;
                    Caption = 'All Requests';
                    Image = AllLines;
                    ToolTip = 'View all approval requests that are assigned to you.';

                    trigger OnAction();
                    begin
                        SETRANGE(Status);
                        ShowAllEntries := TRUE;
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    var
        RecRef: RecordRef;
    begin
        ShowChangeFactBox := CurrPage.Change.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowCommentFactbox := CurrPage.CommentsFactBox.PAGE.SetFilterFromApprovalEntry(Rec);
        ShowRecCommentsEnabled := RecRef.GET("Record ID to Approve");
    end;

    trigger OnAfterGetRecord();
    begin
        SetDateStyle;
    end;

    trigger OnOpenPage();
    begin
        FILTERGROUP(2);
        //SETRANGE("Approver ID",USERID);
        FILTERGROUP(0);
        SETRANGE(Status, Status::Open);
    end;

    var
        DateStyle: Text;
        ShowAllEntries: Boolean;
        ShowChangeFactBox: Boolean;
        ShowRecCommentsEnabled: Boolean;
        ShowCommentFactbox: Boolean;
        Text001: Label 'Approve this document?';

    local procedure SetDateStyle();
    begin
        DateStyle := '';
        IF IsOverdue THEN
            DateStyle := 'Attention';
    end;
}

