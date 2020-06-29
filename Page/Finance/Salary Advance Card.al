page 50636 "Salary Advance Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Imprest Management";
    SourceTableView = SORTING("Imprest No.")
                      ORDER(Ascending)
                      WHERE("Transaction Type" = CONST("Salary Advance"));

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'Employee Information';
                field("Imprest No."; "Imprest No.")
                {
                    ApplicationArea = All;
                    Caption = 'Request No.';
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Employee No"; "Employee No")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Staff A/C"; "Staff A/C")
                {
                    ApplicationArea = All;
                }
                field("Staff Name"; "Staff Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; "Department Name")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Posted; Posted)
                {
                    ApplicationArea = All;
                }
                field(Cleared; Cleared)
                {
                    ApplicationArea = All;
                }
            }
            group("Payroll Information")
            {
                Caption = 'Payroll Information';
                field("Last Pay Month"; "Last Pay Month")
                {
                }
                field("Gross Pay"; "Gross Pay")
                {
                }
                field("Basic Salary"; "Basic Salary")
                {
                }
                field("Net Pay"; "Net Pay")
                {
                }
                field("1/3 of Basic Pay"; "1/3 of Basic Pay")
                {
                }
                field("Maximum Advance Allowed"; "Maximum Advance Allowed")
                {
                    Caption = 'Maximum Advance Per Month Allowed';
                }
            }
            group("Salary Advance Information")
            {
                Caption = 'Salary Advance Information';
                field("Requested Amount"; "Requested Amount")
                {
                    ShowMandatory = true;
                }
                field("No. Of Months"; "No. Of Months")
                {
                    ShowMandatory = true;
                }
                field("Monthly Repayment"; "Monthly Repayment")
                {
                }
                field(Description; Description)
                {
                    Caption = 'Reason For Request';
                    ShowMandatory = true;
                }
                field("Amount Approved"; "Amount Approved")
                {
                    Visible = false;
                }
                field(RepaidAmount; RepaidAmount)
                {
                    Caption = 'Repaid Amount';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {

            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Rec.SETRANGE("Imprest No.", "Imprest No.");
                    REPORT.RUN(50448, TRUE, TRUE, Rec);
                end;
            }
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    CashManagement.SalaryRequiredFields(Rec);
                    // IF ApprovalsMgmt.CheckImprestApprovalPossible(Rec)  THEN BEGIN
                    //  ApprovalsMgmt.OnSendImprestForApproval(Rec);
                    //END;
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    //ApprovalsMgmt.OnCancelImprestApprovalRequest(Rec);
                end;
            }
            action(Post)
            {
                Image = PostDocument;
                Visible = false;

                trigger OnAction();
                begin
                    CashManagement.PostingPettyCash(Rec);
                end;
            }
        }
        area(processing)
        {

            group(Approval)
            {
                Caption = 'Approval';
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Approve the requested changes.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.ApproveRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    Promoted = true;
                    PromotedCategory = Category4;
                    PromotedIsBig = true;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.RejectRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(RECORDID);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    Promoted = true;
                    PromotedCategory = Category4;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistForCurrUser;

                    trigger OnAction();
                    var
                        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        OpenApprovalEntriesExistForCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(RECORDID);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(RECORDID);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(RECORDID);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(RECORDID, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        IF Status <> Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
        END;
        IF Status = Status::Open THEN BEGIN
            ModifyFields := TRUE;
        END;
        IF Posted = TRUE THEN BEGIN
            RepaidAmount := ABS(CashManagement.GetVendDocumentBalance("Paying Document", "Staff A/C") - "Amount Approved");
        END;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Transaction Type" := "Transaction Type"::"Salary Advance";
    end;

    trigger OnOpenPage();
    begin
        CanRequestApprovalForFlow := TRUE;
        IF Status <> Status::Open THEN BEGIN
            CanRequestApprovalForFlow := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
        IF Status = Status::Released THEN BEGIN
            IF Posted = FALSE THEN BEGIN
                PostingImprest := TRUE;
            END;
        END;
    end;

    var
        CashManagement: Codeunit "Cash Management";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CanCancelApprovalForRecord: Boolean;
        CanRequestApprovalForFlow: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanCancelApprovalForFlow: Boolean;
        OpenApprovalEntriesExistForCurrUser: Boolean;
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        ModifyFields: Boolean;
        //PaymentRemittanceAdvise : Report "50441";
        PostingImprest: Boolean;
        RepaidAmount: Decimal;
}

