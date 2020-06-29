page 50755 "Request For Quotation Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Supplier Selection,RFQ Preparation,RFQ Pre-Opening,RFQ Opening,RFQ Evaluation,Evaluated RFQ,LPO Stage';
    SourceTable = "Procurement Request";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    Editable = false;
                }
                field(Description; Description)
                {
                }
                field("Requisition No."; "Requisition No.")
                {
                    Editable = EditRequisitionNo;
                }
                field("Vendor No."; "Vendor No.")
                {
                    Editable = false;
                }
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    Editable = false;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    Editable = false;
                }
                field("Global Dimension 2 Code"; "Global Dimension 2 Code")
                {
                    Editable = false;
                }
                field(Status; Status)
                {
                    Editable = false;
                }
                field("Advertisement Date"; "Advertisement Date")
                {
                }
                field("Category Code"; "Category Code")
                {
                }
                field("Category Description"; "Category Description")
                {
                    Editable = false;
                }
                field("Process Status"; "Process Status")
                {
                    Editable = false;
                }
                field("Created By"; "Created By")
                {
                }
                field("Assigned User"; "Assigned User")
                {
                    Visible = false;
                }
                field("Request Email Sent"; "Request Email Sent")
                {
                    Editable = false;
                }
                field("Forwarded to Opening"; "Forwarded to Opening")
                {
                    Editable = false;
                }
                field("Attached Opening Minutes"; "Attached Opening Minutes")
                {
                    Editable = false;
                }
                field("Opening Minutes Path"; "Opening Minutes Path")
                {
                    Editable = false;
                }
                field("Evaluation Complete"; "Evaluation Complete")
                {
                    Editable = false;
                }
                field("Attached Evaluation Minutes"; "Attached Evaluation Minutes")
                {
                    Editable = false;
                }
                field("Attached Professional Opinion"; "Attached Professional Opinion")
                {
                    Editable = false;
                }
                field("LPO Generated"; "LPO Generated")
                {
                    Editable = false;
                }
                field("LPO No."; "LPO No.")
                {
                    Editable = false;
                }
            }
            part(page; "Procurement Request Line")
            {
                Editable = false;
                SubPageLink = "Request No." = FIELD("No.");
            }
            group("Process Dates")
            {
                Caption = 'Process Dates';
                field("Created On"; "Created On")
                {
                    Editable = false;
                }
                field("Closing Date"; "Closing Date")
                {
                }
                field("Closing Time"; "Closing Time")
                {
                }
                field("Opening Date"; "Opening Date")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Select Suppliers")
            {
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = false;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    TESTFIELD("Category Code");
                    TESTFIELD(Description);
                    ProcurementManagement.SelectSuppliers(Rec);
                end;
            }
            action("View Selected Suppliers")
            {
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedSuppliers(Rec, 1);
                end;
            }
            action("Preview Quotations")
            {
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    TESTFIELD("Closing Date");
                    TESTFIELD("Closing Time");
                    ProcurementManagement.PreviewRFQ_Report(Rec);
                end;
            }
            action("Request For Quotations")
            {
                Image = SendEmailPDF;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = false;
                PromotedOnly = false;
                Visible = SeeNew;

                trigger OnAction();
                begin
                    TESTFIELD("Closing Date");
                    TESTFIELD("Closing Time");
                    ProcurementManagement.EmailDocumentRequestReport(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Attach Submitted Quotations")
            {
                Image = Attachments;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeePendingOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedSuppliers(Rec, 1);
                end;
            }
            action("View Submitted Quotations")
            {
                Image = CustomerList;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = false;
                Visible = SeeAllStages1;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedSuppliers(Rec, 2);
                end;
            }
            action("Select Opening Committee")
            {
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = SeePendingOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.SelectOpeningCommittee(Rec, 1);
                    //CurrPage.CLOSE;
                end;
            }
            action("View Opening Members")
            {
                Image = SocialSecurity;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Visible = SeeAllStages1;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedCommittee(Rec, 1);
                end;
            }
            action("Submit For Opening")
            {
                Image = UntrackedQuantity;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeePendingOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardForOpening(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Attach Opening Minutes")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.AttachSubmittedDocument(Rec, 1);
                end;
            }
            action("View Opening Minutes")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                Visible = SeeAllStages2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 1);
                end;
            }
            action("Select Evaluation Committee")
            {
                Image = TeamSales;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.SelectOpeningCommittee(Rec, 2);
                end;
            }
            action("View Evaluation Members")
            {
                Image = SocialSecurity;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                Visible = SeeAllStages2;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewSelectedCommittee(Rec, 2);
                end;
            }
            action("Submit For Evaluation")
            {
                Image = ActivateDiscounts;
                Promoted = true;
                PromotedCategory = Category7;
                Visible = SeeOpening;

                trigger OnAction();
                begin
                    ProcurementManagement.ForwardProcessToNextStage(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Quotation Evaluation")
            {
                Image = Troubleshoot;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    ProcurementManagement.StartEvaluationProcess(Rec, 1);
                end;
            }
            action("Attach Evaluation Minutes")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementManagement.AttachSubmittedDocument(Rec, 2);
                end;
            }
            action("View Evaluation Minutes")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeAllStages3;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 2);
                end;
            }
            action("Forward To Procurement Manager")
            {
                Image = DefaultFault;
                Promoted = true;
                PromotedCategory = Category8;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeEvaluation;

                trigger OnAction();
                begin
                    ProcurementManagement.CompleteEvaluation(Rec, 1);
                    CurrPage.CLOSE;
                end;
            }
            action("Return To Evaluation")
            {
                Enabled = SeeEvaluated2;
                Image = GetEntries;
                Promoted = true;
                PromotedCategory = Category9;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    ProcurementManagement.CompleteEvaluation(Rec, 2);
                    CurrPage.CLOSE;
                end;
            }
            action("Send Approval Request")
            {
                Enabled = SeeEvaluated2;
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    IF ApprovalsMgmtExt.CheckProcurementProcessApprovalPossible(Rec) THEN
                        ApprovalsMgmtExt.OnSendProcurementProcessForApproval(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Enabled = SeeEvaluated3;
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                Visible = SeeEvaluated;

                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelProcurementProcurementProcessRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action(Reject)
            {
                ApplicationArea = All;
                Caption = 'Reject';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action(Delegate)
            {
                ApplicationArea = All;
                Caption = 'Delegate';
                Image = Delegate;
                Promoted = true;
                PromotedCategory = Category9;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = SeeApprovals;

                trigger OnAction();
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;

                end;
            }
            action("Request Professional Opinion")
            {
                Enabled = SeeEvaluated2;
                Image = CustomerRating;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementManagement.RequestForProffesionalOpinion(Rec);
                end;
            }
            action("Attach Proffessional Opinion")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeCEO;

                trigger OnAction();
                begin
                    TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementManagement.AttachSubmittedDocument(Rec, 3);
                end;
            }
            action("View Proffessional Opinion")
            {
                Image = ExportAttachment;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeAllStages4;

                trigger OnAction();
                begin
                    ProcurementManagement.ViewAttachmentDocument(Rec, 3);
                end;
            }
            action("Forward To Award")
            {
                Image = NewCustomer;
                Promoted = true;
                PromotedCategory = Category9;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeCEO;

                trigger OnAction();
                begin
                    TESTFIELD("Attached Professional Opinion", TRUE);
                    ProcurementManagement.StartEvaluationProcess(Rec, 2);
                end;
            }
            action("Generate Purchase Order")
            {
                ApplicationArea = Application;
                Image = MakeOrder;
                Promoted = true;
                PromotedCategory = Category10;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeLPO;

                trigger OnAction();
                begin
                    ProcurementManagement.GenerateLPO(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("View Posted LPO")
            {
            }
        }
    }

    trigger OnAfterGetCurrRecord();
    begin
        ManageVisibility;
    end;

    trigger OnAfterGetRecord();
    begin
        ManageVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        "Procurement Option" := "Procurement Option"::"Request For Quotation";
        ProcurementMethod.RESET;
        ProcurementMethod.SETRANGE(Method, ProcurementMethod.Method::"Request For Quotation");
        IF ProcurementMethod.FINDFIRST THEN
            "Procurement Method" := ProcurementMethod.Code;
        ManageVisibility;
    end;

    trigger OnNextRecord(Steps: Integer): Integer;
    begin
        ManageVisibility;
    end;

    trigger OnOpenPage();
    begin
        ManageVisibility;
    end;

    var
        ProcurementManagement: Codeunit "Procurement Management";
        RequisitionLines: Record "Requisition Line";
        SeeGenerate: Boolean;
        ProcurementMethod: Record "Procurement Method";
        SeeNew: Boolean;
        SeePendingOpening: Boolean;
        // ApprovalsMgmtExt: Codeunit "Approvals Mgmt Ext";
        ApprovalEntry: Record "Approval Entry";
        ApprovalsMgmtExt: Codeunit "Approvals Mgmt Proc";
        SeeOpening: Boolean;
        SeePendingEvaluation: Boolean;
        SeeEvaluation: Boolean;
        SeeAllStages: Boolean;
        SeeAfterEvaluation: Boolean;
        SeeNew2: Boolean;
        SeeAllStages1: Boolean;
        SeeAllStages2: Boolean;
        SeeAllStages3: Boolean;
        SeeAllStages4: Boolean;
        EditRequisitionNo: Boolean;
        SeeEvaluated: Boolean;
        SeeApprovals: Boolean;
        SeeEvaluated2: Boolean;
        SeeLPO: Boolean;
        SeeEvaluated3: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        SeeCEO: Boolean;

    local procedure ManageVisibility();
    begin
        SeeGenerate := FALSE;
        SeeNew := TRUE;
        SeePendingOpening := FALSE;
        SeeCEO := FALSE;
        SeeOpening := FALSE;
        SeeEvaluation := FALSE;
        SeeAllStages := TRUE;
        SeeAllStages1 := FALSE;
        SeeAllStages2 := FALSE;
        SeeAllStages3 := FALSE;
        SeeAllStages4 := FALSE;
        SeeEvaluated3 := FALSE;
        SeeLPO := FALSE;
        SeeEvaluated := FALSE;
        EditRequisitionNo := TRUE;
        SeeEvaluated2 := FALSE;
        IF "Process Status" <> "Process Status"::New THEN BEGIN
            SeeNew := FALSE;
            CurrPage.EDITABLE(FALSE);
        END ELSE BEGIN
            IF "Request Email Sent" = TRUE THEN
                SeePendingOpening := TRUE
        END;
        IF "Process Status" = "Process Status"::"Pending Opening" THEN BEGIN
            SeePendingOpening := TRUE;
            SeeAllStages1 := TRUE;
        END;
        IF "Process Status" = "Process Status"::Opening THEN BEGIN
            SeeOpening := TRUE;
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
        END;
        IF "Process Status" = "Process Status"::Evaluation THEN BEGIN
            SeeOpening := FALSE;
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages3 := TRUE;
            SeeEvaluation := TRUE;
        END;
        IF ("Process Status" = "Process Status"::"Procurement Manager") OR ("Process Status" = "Process Status"::CEO) THEN BEGIN
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages3 := TRUE;
            SeeEvaluated := TRUE;
            //SeeAllStages4 := TRUE;
            SeeEvaluated2 := TRUE;
            IF Status = Status::"Pending Approval" THEN BEGIN
                SeeEvaluated3 := TRUE;
                SeeEvaluated2 := FALSE;
                SeeApprovals := TRUE;
            END
            ELSE
                IF Status = Status::Released THEN BEGIN
                    SeeCEO := TRUE;
                    SeeAllStages4 := TRUE;
                    SeeEvaluated2 := FALSE;
                    SeeEvaluated3 := FALSE;
                END;
        END;
        IF "Process Status" = "Process Status"::LPO THEN BEGIN
            SeeLPO := TRUE;
            SeeAllStages2 := TRUE;
            SeeAllStages1 := TRUE;
            SeeAllStages3 := TRUE;
            SeeAllStages4 := TRUE;
            IF "LPO Generated" THEN BEGIN
                SeeLPO := FALSE;
                SeeAllStages2 := TRUE;
                SeeAllStages1 := TRUE;
                SeeAllStages3 := TRUE;
                SeeAllStages4 := TRUE;
            END;
        END;
        IF "Auto Generated" THEN
            EditRequisitionNo := FALSE;
    end;
}

