page 50203 "Loan Application Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Security,Approval Request,Category 6,Category 7,Category 8';
    RefreshOnActivate = true;
    SourceTable = "Loan Application";

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
                field("Member Category"; "Member Category")
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
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Loan Product Type"; "Loan Product Type")
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        ValidateLoanProduct;
                    end;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Repayment Method"; "Repayment Method")
                {
                    ApplicationArea = All;
                }
                field("Repayment Frequency"; "Repayment Frequency")
                {
                    ApplicationArea = All;
                }
                field("External Loan"; "External Loan")
                {
                    ApplicationArea = All;
                }
                group("")
                {
                    Visible = "External Loan" = TRUE;

                    field("Institution Name"; "Institution Name")
                    {
                        ApplicationArea = All;
                    }
                    field("Institution Branch Name"; "Institution Branch Name")
                    {
                        ApplicationArea = All;
                    }

                }
                group(Savings)
                {
                    Caption = '';
                    Visible = IsSavingsVisible;
                    field("Total Savings Amount"; "Total Savings Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Shares)
                {
                    Caption = '';
                    Visible = IsSharesVisible;
                    field("Total Shares Amount"; "Total Shares Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group("   ")
                {
                    Visible = IsDepositsVisible;
                    field("Total Deposits Amount"; "Total Deposits Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                group(Repayment)
                {
                    Caption = '';
                    Editable = "Status" = 0;
                    field("Repayment Period"; "Repayment Period")
                    {
                        ApplicationArea = All;
                    }
                    field("Requested Amount"; "Requested Amount")
                    {
                        ApplicationArea = All;
                    }
                    field("Mode of Disbursement"; "Mode of Disbursement")
                    {
                        ApplicationArea = All;
                    }
                    group(FOSAAccount)
                    {
                        Caption = '';
                        Visible = "Mode of Disbursement" = 0;
                        field("FOSA Account No."; "FOSA Account No.")
                        {
                            ApplicationArea = All;
                        }
                        field("FOSA Account Name"; "FOSA Account Name")
                        {
                            ApplicationArea = All;
                        }
                    }
                    group(MobileBanking)
                    {
                        Caption = '';
                        Visible = "Mode of Disbursement" = 1;
                        field("Phone No."; "Phone No.")
                        {
                            ApplicationArea = All;
                        }
                    }
                    group(RTGS)
                    {
                        Caption = '';
                        Visible = "Mode of Disbursement" = 2;
                        field("External Account No."; "External Account No.")
                        {
                            ApplicationArea = All;
                        }
                    }
                }
                field("No. of Guarantors"; "No. of Guarantors")
                {
                    ApplicationArea = All;
                }
                field("Total Guaranteed Amount"; "Total Guaranteed Amount")
                {
                    ApplicationArea = All;
                }
                field("No. of Other Securities"; "No. of Other Securities")
                {
                    ApplicationArea = All;
                }
                field("Total Security Amount"; "Total Security Amount")
                {
                    ApplicationArea = All;
                }
                group(Approved)
                {
                    Caption = '';
                    Visible = "Status" = 1;
                    field("Approved Amount"; "Approved Amount")
                    {
                        ApplicationArea = All;
                    }
                    field(Remarks; Remarks)
                    {
                        ApplicationArea = All;
                    }
                }
                group(Refinance)
                {
                    Caption = '';
                    Editable = "Status" = 0;
                    field("Refinance Another Loan"; "Refinance Another Loan")
                    {
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            IF "Refinance Another Loan" THEN
                                GetLoansToRefinance
                            ELSE
                                ClearRefinancingEntry;
                        end;
                    }
                }
                group(RefinanceInfo)
                {
                    Caption = '';
                    Visible = "Refinance Another Loan" = TRUE;
                    field("No. of Loans Refinanced"; "No. of Loans Refinanced")
                    {
                        ApplicationArea = All;
                    }
                    field("Total Refinanced Amount"; "Total Refinanced Amount")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Next Due Date"; "Next Due Date")
                {
                    ApplicationArea = All;
                }
                field("Date of Completion"; "Date of Completion")
                {
                    ApplicationArea = All;
                }
                field("Outstanding Balance"; "Outstanding Balance")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Salary Analysis")
            {
                Caption = 'Salary Analysis';
                Visible = IsSalaryAnalysisVisible;
                field("Basic Salary"; "Basic Salary")
                {
                    ApplicationArea = All;
                }
                field("Total Deduction Amount"; "Total Deduction Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Amount"; "Net Amount")
                {
                    ApplicationArea = All;
                }
                group(Payroll)
                {
                    Caption = '';
                    Visible = "Member Category" = 0;
                    field("Payroll No."; "Payroll No.")
                    {
                        ApplicationArea = All;
                    }
                }
                field("Company Name"; "Company Name")
                {
                    ApplicationArea = All;
                }
            }
            group("Payout Analysis")
            {
                Caption = 'Payout Analysis';
                Visible = IsPayoutAnalysisVisible;
                field("No. of KG"; "No. of KG")
                {
                    ApplicationArea = All;
                }
                field("Rate per KG"; "Rate per KG")
                {
                    ApplicationArea = All;
                }
                field("View Payout History"; "View Payout History")
                {
                    ApplicationArea = All;
                }
                field("Total Payout Amount"; "Total Payout Amount")
                {
                    ApplicationArea = All;
                }
            }
            group(CreatedBy)
            {
                Caption = 'Created By';
                Visible = "Status" = 0;
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
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(AppraisedBy)
            {
                Caption = 'Appraised By';
                Visible = "Status" = 1;
                field("Appraised By"; "Appraised By")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Date"; "Appraisal Date")
                {
                    ApplicationArea = All;
                }
                field("Appraisal Time"; "Appraisal Time")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host Name"; "Appraised By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host IP"; "Appraised By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Appraised By Host MAC"; "Appraised By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(ApprovedBy)
            {
                Caption = 'Approved By';
                Visible = "Status" = 2;
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Time"; "Approved Time")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host Name"; "Approved By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host IP"; "Approved By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Approved By Host MAC"; "Approved By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
            group(DisbursedBy)
            {
                Caption = 'Disbursed By';
                Visible = "Posted" = TRUE;
                field("Disbursed By"; "Disbursed By")
                {
                    ApplicationArea = All;
                }
                field("Disbursal Date"; "Disbursal Date")
                {
                    ApplicationArea = All;
                }
                field("Disbursal Time"; "Disbursal Time")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host Name"; "Disbursed By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host IP"; "Disbursed By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Disbursed By Host MAC"; "Disbursed By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            part(Page; 50196)
            {
                ApplicationArea = All;
                SubPageLink = "No." = FIELD("No.");
            }
            part(AttachmentFactBox; "Attachement FactBox")
            {
                Caption = 'Attachment';
                ApplicationArea = All;
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Loan Guarantors")
            {
                ApplicationArea = All;
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                begin
                    LoanGuarantor.FILTERGROUP(10);
                    LoanGuarantor.SETRANGE("Loan No.", Rec."No.");
                    LoanGuarantor.FILTERGROUP(0);
                    PAGE.RUN(50210, LoanGuarantor);
                end;
            }
            action("Loan Security")
            {
                ApplicationArea = All;
                Image = Lock;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    LoanSecurity.FILTERGROUP(10);
                    LoanSecurity.SETRANGE("Loan No.", Rec."No.");
                    LoanSecurity.FILTERGROUP(0);
                    PAGE.RUN(50209, LoanSecurity);
                end;
            }
        }
        area(processing)
        {
            action(SendApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = IsVisibleSendApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    TESTFIELD("Requested Amount");
                    // ValidateAttachment;

                    IF LoanProductType.GET("Loan Product Type") THEN BEGIN
                        IF ((LoanProductType."Security Type" = LoanProductType."Security Type"::"Guarantors Only") OR
                           (LoanProductType."Security Type" = LoanProductType."Security Type"::Both)) THEN BEGIN
                            IF NOT GetGuarantors THEN
                                ERROR(Error000)
                            ELSE BEGIN
                                CALCFIELDS("No. of Guarantors");
                                IF "No. of Guarantors" < CheckMinimumGuarantors THEN
                                    ERROR(Error001, CheckMinimumGuarantors);
                                IF GetTotalSecurityAmount < "Requested Amount" THEN
                                    ERROR(Error004, "No.");
                            END;
                        END;
                        IF ((LoanProductType."Security Type" = LoanProductType."Security Type"::"Security Only") OR
                           (LoanProductType."Security Type" = LoanProductType."Security Type"::Both)) THEN BEGIN
                            IF NOT GetSecurities THEN
                                ERROR(Error005);
                        END;
                        IF LoanProductType."Security Type" = LoanProductType."Security Type"::Either THEN BEGIN
                            IF GetTotalSecurityAmount < "Requested Amount" THEN
                                ERROR(Error004, "No.");
                        END;

                        IF "Refinance Another Loan" THEN BEGIN
                            CALCFIELDS("No. of Loans Refinanced", "Total Refinanced Amount");
                            TESTFIELD("No. of Loans Refinanced");
                            TESTFIELD("Total Refinanced Amount");
                        END;
                    END;
                    IF ApprovalsMgmt.CheckLoanApplicationApprovalPossible(Rec) THEN
                        ApprovalsMgmt.OnSendLoanApplicationForApproval(Rec);
                end;
            }
            action(CancelApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                Visible = IsVisibleCancelApprovalRequest;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    ApprovalsMgmt.OnCancelLoanApplicationApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);
                end;
            }
            action("Preview Schedule")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    IF NOT Posted THEN BEGIN
                        TESTFIELD("Requested Amount");
                        BOSAManagement.CalculateRepaymentSchedule("No.", "Requested Amount");
                        COMMIT;
                    END;

                    LoanApplication.GET("No.");
                    LoanApplication.SETRECFILTER;
                    REPORT.RUN(REPORT::"Loan Repament Schedule", TRUE, FALSE, LoanApplication);
                end;
            }
            action(Post)
            {
                Image = CashFlow;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsPostVisible;
                ApplicationArea = All;

                trigger OnAction()
                begin
                    TESTFIELD("FOSA Account No.");
                    IF CONFIRM(Text000, TRUE) THEN
                        BOSAManagement.PostLoan(Rec)
                    ELSE
                        EXIT;
                end;
            }
            action(Approve)
            {
                ApplicationArea = All;
                Caption = 'Approve';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Approve the requested changes.';
                Visible = IsApproveVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    TESTFIELD("Approved Amount");
                    TESTFIELD(Remarks);

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
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Scope = Repeater;
                ToolTip = 'Reject the approval request.';
                Visible = IsRejectVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    TESTFIELD("Approved Amount");
                    TESTFIELD(Remarks);

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
                PromotedCategory = Process;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'Delegate the approval to a substitute approver.';
                Visible = IsDelegateVisible;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    TESTFIELD("Approved Amount");
                    TESTFIELD(Remarks);

                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    CurrPage.CLOSE;
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
        ValidateLoanProduct;
    end;

    var
        LoanGuarantor: Record "Loan Guarantor";
        LoanSecurity: Record "Loan Security";
        IsVisibleSendApprovalRequest: Boolean;
        IsVisibleCancelApprovalRequest: Boolean;
        Error000: Label 'Guarantors are required';
        Error001: Label 'You must have at least %1 guarantors';
        Error002: Label 'Total guaranteed amount cannot be zero!';
        Error003: Label 'Total security amount cannot be zero!';
        Error004: Label 'Loan No. %1 is not fully guaranteed.';
        Error005: Label 'Loan Securities are required';
        LoanProductType: Record "Loan Product Type";
        IsSavingsVisible: Boolean;
        IsSharesVisible: Boolean;
        IsDepositsVisible: Boolean;
        BOSAManagement: Codeunit "BOSA Management";
        IsApproveVisible: Boolean;
        IsRejectVisible: Boolean;
        IsDelegateVisible: Boolean;
        IsPostVisible: Boolean;
        IsMobileVisible: Boolean;
        IsFOSAVisible: Boolean;
        Text000: Label 'Do you to disburse this Loan?';
        IsSalaryAnalysisVisible: Boolean;
        IsPayoutAnalysisVisible: Boolean;
        LoanApplication: Record "Loan Application";

    local procedure PageVisibility()
    begin
        IF Status = Status::New THEN BEGIN
            IsVisibleSendApprovalRequest := TRUE;
            IsVisibleCancelApprovalRequest := TRUE;
        END ELSE BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
        END;

        IF Status = Status::"Pending Approval" THEN BEGIN
            IsApproveVisible := TRUE;
            IsRejectVisible := TRUE;
            IsDelegateVisible := TRUE;
        END ELSE BEGIN
            IsApproveVisible := FALSE;
            IsRejectVisible := FALSE;
            IsDelegateVisible := FALSE;
        END;

        IF Status = Status::Approved THEN
            IsPostVisible := TRUE
        ELSE
            IsPostVisible := FALSE;
        IF Posted THEN
            IsPostVisible := FALSE
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::Approved THEN
            CurrPage.EDITABLE := FALSE
        ELSE
            CurrPage.EDITABLE := TRUE;
    end;

    local procedure ValidateLoanProduct()
    begin
        IF LoanProductType.GET("Loan Product Type") THEN BEGIN
            IF LoanProductType."Based on Savings" THEN
                IsSavingsVisible := TRUE
            ELSE
                IsSavingsVisible := FALSE;

            IF LoanProductType."Based on Shares" THEN
                IsSharesVisible := TRUE
            ELSE
                IsSharesVisible := FALSE;

            IF LoanProductType."Based on Deposits" THEN
                IsDepositsVisible := TRUE
            ELSE
                IsDepositsVisible := FALSE;

            // IF LoanProductType."Mode of Disbursement" = LoanProductType."Mode of Disbursement"::"FOSA Account" THEN
            //     IsFOSAVisible := TRUE
            // ELSE
            //     IsFOSAVisible := FALSE;

            // IF LoanProductType."Mode of Disbursement" = LoanProductType."Mode of Disbursement"::"Mobile Banking" THEN
            //     IsMobileVisible := TRUE
            // ELSE
            //     IsMobileVisible := FALSE;


        END;
    end;

    local procedure ClearRefinancingEntry()
    var
        LoanRefinancingEntry: Record "Loan Refinancing Entry";
    begin
        LoanRefinancingEntry.RESET;
        LoanRefinancingEntry.SETRANGE("Loan No.", "No.");
        LoanRefinancingEntry.DELETEALL;
    end;
}

