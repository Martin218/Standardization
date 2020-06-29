page 50018 "Account Opening Card"
{
    // version TL2.0

    PageType = Card;
    PromotedActionCategories = 'New,Process,Reports,Related,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Account Opening";

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
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        SetVisible;
                    end;
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
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {

                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        CurrPage.UPDATE;
                    end;
                }
                field("SMS Alert on"; "SMS Alert on")
                {
                    ApplicationArea = All;
                }
                field("E-Mail Alert on"; "E-Mail Alert on")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }

            }
            group("Junior Account  Details")
            {
                Visible = IsVisibleJuniorAccount;
                field("Child's Name"; "Child's Name")
                {
                    ApplicationArea = All;
                }
                field("Child's Gender"; "Child's Gender")
                {
                    ApplicationArea = All;
                }
                field("Child,s Date of Birth"; "Child,s Date of Birth")
                {
                    ApplicationArea = All;
                }
                field("Child's Birth Cert No."; "Child's Birth Cert No.")
                {
                    ApplicationArea = All;
                }
                field("Relationship with Child"; "Relationship with Child")
                {
                    ApplicationArea = All;
                }
            }
            group("Fixed Deposit Details")
            {
                Visible = IsVisibleFDAccount;
                field("FD Expected Interest"; "FD Expected Interest")
                {
                    ApplicationArea = All;
                }
                field("FD Total Expected"; "FD Total Expected")
                {
                    ApplicationArea = All;
                }
                field("Period in Months"; "Period in Months")
                {
                    ApplicationArea = All;
                }
                field("Initial Amount"; "Initial Amount")
                {
                    ApplicationArea = All;
                }
                field("Posted Interest"; "Posted Interest")
                {
                    ApplicationArea = All;
                }
                field("Maturity FOSA Account"; "Maturity FOSA Account")
                {
                    ApplicationArea = All;
                }
                field("FD Amount"; "FD Amount")
                {
                    ApplicationArea = All;
                }
                field("Fixed Deposit Status"; "Fixed Deposit Status")
                {
                    ApplicationArea = All;
                }
                field("FD Posted"; "FD Posted")
                {
                    ApplicationArea = All;
                }
                field("Interest Capitalization Date"; "Interest Capitalization Date")
                {
                    ApplicationArea = All;
                }
                field("Interest Rate"; "Interest Rate")
                {
                    ApplicationArea = All;
                }
                field("Expected Maturity Date"; "Expected Maturity Date")
                {
                    ApplicationArea = All;
                }
                field("Effective Date"; "Effective Date")
                {
                    ApplicationArea = All;
                }
                field("Effected Date"; "Effected Date")
                {
                    ApplicationArea = All;
                }
            }
            group(Audit)
            {
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
                field("Created By Host IP"; "Created By Host IP")
                {
                    ApplicationArea = All;
                }
                field("Created By Host Name"; "Created By Host Name")
                {
                    ApplicationArea = All;
                }
                field("Created By Host MAC"; "Created By Host MAC")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            //   part(AccountMemberList;)
            //  {
            //      ApplicationArea = All;SubPageLink = Document "No."=FIELD("No.");
            //  } 
        }
    }

    actions
    {
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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                begin
                    //ValidateFields;
                    IF ApprovalsMgmt.CheckAccountOpeningApprovalPossible(Rec) THEN begin
                        ApprovalsMgmt.OnSendAccountOpeningForApproval(Rec);
                        CurrPage.Close();
                    end;
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
                    ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
                    WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
                begin
                    ApprovalsMgmt.OnCancelAccountOpeningApprovalRequest(Rec);
                    WorkflowWebhookMgt.FindAndCancel(RECORDID);

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
                Visible = IsVisibleApprove;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    END;
                    CurrPage.CLOSE;
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
                Visible = IsVisibleReject;

                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.Reset();
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    END;
                    CurrPage.CLOSE;
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
                Visible = IsVisibleDelegate;


                trigger OnAction()
                var
                    ApprovalEntry: Record "Approval Entry";
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", Rec."No.");
                    ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.DelegateApprovalRequests(ApprovalEntry);
                    END;
                    CurrPage.CLOSE;
                end;
            }
            action("Post Fixed Deposit")
            {
                ApplicationArea = All;
                Image = DepositLines;
            }
            action("Revoke Fixed Deposit")
            {
                ApplicationArea = All;
                Enabled = true;
                Image = ReverseRegister;
                Visible = true;
            }
            action("Mature Fixed Deposit")
            {
                Enabled = true;
                Image = MakeAgreement;
                Visible = true;
            }
            action("Generate Account No.")
            {
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    TESTFIELD("Member No.");
                    TESTFIELD("Account Type");
                    TESTFIELD("Global Dimension 1 Code");
                    CBSSetup.GET;
                    IF CBSSetup."Account No. Format" = CBSSetup."Account No. Format"::"No. Series Only" THEN
                        AccountNo := "No."
                    ELSE
                        IF CBSSetup."Account No. Format" = CBSSetup."Account No. Format"::"Member No.+Account Type" THEN
                            AccountNo := "Member No." + "Account Type";

                    "Account No." := AccountNo;
                    VALIDATE("Account No.");
                    IF "Account No." <> '' THEN
                        MESSAGE(Text004, "Account No.");
                end;
            }
        }
        area(navigation)
        {


        }
    }

    trigger OnOpenPage()
    begin
        SetVisible;
        SetEditable;
    end;

    var
        IsVisibleSendApprovalRequest: Boolean;
        Text000: Label 'Are you sure you want to send account %1 for approval?';
        Text001: Label 'Are you sure you want to cancel account %1?';
        Text002: Label 'Account %1 has been submitted successfully';
        Text003: Label 'Account %1 has been cancelled successfully';
        IsVisibleCancelApprovalRequest: Boolean;
        //ApprovalsMgmt: Codeunit "1535";
        AccountNo: Code[20];
        CBSSetup: Record "CBS Setup";
        Text004: Label 'Account %1 has been created.';
        IsVisibleJuniorAccount: Boolean;
        IsVisibleFDAccount: Boolean;
        AccountType: Record "Account Type";

        IsGAVisible: Boolean;
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";
        IsVisibleApprove: Boolean;
        IsVisibleReject: Boolean;
        IsVisibleDelegate: Boolean;

    local procedure SetVisible()
    begin
        IF AccountType.GET("Account Type") THEN BEGIN
            IF AccountType.Type = AccountType.Type::Deposit THEN BEGIN
                IsVisibleFDAccount := FALSE;
                IsVisibleJuniorAccount := FALSE;
                IsGAVisible := TRUE;
            END ELSE
                IF AccountType.Type = AccountType.Type::"Fixed Deposit" THEN BEGIN
                    IsVisibleFDAccount := TRUE;
                    IsVisibleJuniorAccount := FALSE;
                END ELSE
                    IF AccountType.Type = AccountType.Type::Loan THEN BEGIN
                        IsVisibleFDAccount := FALSE;
                        IsVisibleJuniorAccount := FALSE;
                    END ELSE
                        IF AccountType.Type = AccountType.Type::Savings THEN BEGIN
                            IsVisibleFDAccount := FALSE;
                            IsVisibleJuniorAccount := FALSE;
                        END ELSE
                            IF AccountType.Type = AccountType.Type::"Share Capital" THEN BEGIN
                                IsVisibleFDAccount := FALSE;
                                IsVisibleJuniorAccount := FALSE;
                            END
        END;
        IF Status = Status::New THEN BEGIN
            IsVisibleSendApprovalRequest := TRUE;
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleApprove := false;
            IsVisibleDelegate := false;
            IsVisibleReject := false;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := TRUE;
            IsVisibleApprove := true;
            IsVisibleDelegate := true;
            IsVisibleReject := true;
        END;
        IF Status = Status::Approved THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleApprove := false;
            IsVisibleDelegate := false;
            IsVisibleReject := false;
        END;
        IF Status = Status::Rejected THEN BEGIN
            IsVisibleSendApprovalRequest := FALSE;
            IsVisibleCancelApprovalRequest := FALSE;
            IsVisibleApprove := false;
            IsVisibleDelegate := false;
            IsVisibleReject := false;
        END;
    end;

    local procedure SetEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE
        ELSE
            IF Status = Status::"Pending Approval" THEN
                CurrPage.EDITABLE := FALSE
            ELSE
                IF Status = Status::Approved THEN
                    CurrPage.EDITABLE := FALSE;
    end;
}

