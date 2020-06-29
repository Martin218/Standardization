codeunit 50060 "Procurement Management"
{
    // version TL2.0


    trigger OnRun();
    begin
        UpdatePostedLPO;
    end;

    var
        ProcurementPlanLines: Record "Procurement Plan Line";
        ProcurementSetup: Record "Procurement Setup";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Text01: Label 'Approval Request has been Cancelled successfully.';
        RejectCaption: Text;
        RejectTxt1: Label 'Reset status to New,Reject Completely';
        RejectTxt2: Label 'Choose the Action To Perfom';
        RejectTxt3: Label 'Status Reset Successful.';
        RejectTxt4: Label 'Document has been Rejected Successfully';
        SelectedOption: Integer;
        CommentErr1: Label 'Please fill in the Reject Comment.';
        ProcurementMgrErr: Label 'Only the Procurement Manager can perform this Action!';
        LowValueExcessAmountErr: Label 'The amount on header exceeds the limit allowable to create a %1 Process.';
        LPOGeneratedErr: Label '%1 has already been generated for this process.';
        ContractGeneratedErr: Label 'Contract %1 has already been generated for this process.';
        AddUserMsg: Label 'User %1 assigned successfully.';
        PrequalifiedUpdateSuccessMsg: Label 'Prequalified suppliers Updated Successfully.';
        NoPrequalifiedSupplierErr: Label 'No Supplier has been Selected.';
        MailHeader: Text;
        MailBody: Text;
        RFQMailHdrTxt: Label 'REQUEST FOR QUOTATION, %1 , %2';
        RFQBodyTxt: Label 'Dear %1, <br><br>Please Find Attached Request For Quotation.<br><br>Fill it up and drop it at our institution before the requested date and time.<br><br>';
        RFQBodyTxt2: Label 'Kind Regards<br><br>%1';
        MailOpenDialogTxt: Label 'Sending email to ##1########';
        EmailDialog: Dialog;
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        EmailSuccessTxt: Label 'Email to %1 Sent Successfully.';
        EmailMembers: List of [Text];
        FileName: Text;
        FileName2: Text;
        NoAttachmentErr: Label 'No attachment exist for %1.';
        AttachmentSuccessMsg: Label 'Document Attached Successfully.';
        PendingOpeningErr: Label 'This request is in Pending Opening stage, you cannot select other Suppliers!!';
        UserSetup: Record "User Setup";
        ProfOpinionMailHdrTxt: Label 'REQUEST FOR PROFFESIONAL OPINION,';
        ProfOpinionBodyTxt: Label 'Dear %1, <br><br>Please share your professional Opinion in regards to the %2 number %3.<br><br>';
        ProfOpinionBodyTxt2: Label 'Kind Regards<br><br>%1';
        ForwardSuccessTxt2: Label 'Request forwarded successfully.';

    ////[Scope('Personalization')]
    procedure OnSubmitNewProcurementPlan(ProcurementPlanHeader: Record "Procurement Plan Header");
    begin
        WITH ProcurementPlanHeader DO BEGIN
            IF ProcurementPlanHeader."Budget Per Branch?" = TRUE THEN BEGIN
                ProcurementPlanHeader.TESTFIELD("Global Dimension 1 Code");
            END;
            IF ProcurementPlanHeader."Budget Per Department?" = TRUE THEN BEGIN
                ProcurementPlanHeader.TESTFIELD("Global Dimension 2 Code");
            END;
            ValidateProcurementLines(ProcurementPlanHeader);
        END;
    end;

    local procedure ValidateProcurementLines(ProcurementPlanHeader2: Record "Procurement Plan Header");
    var
        ZeroAmountErr: Label 'Kindly capture the estimated amounts on the Plan Lines.';
        NoLinesErr: Label 'Kindly fill in the lines.';
    begin
        WITH ProcurementPlanHeader2 DO BEGIN
            ProcurementPlanLines.RESET;
            ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader2."No.");
            IF ProcurementPlanLines.FINDSET THEN BEGIN
                REPEAT
                    ProcurementPlanLines.TESTFIELD("No.");
                    ProcurementPlanLines.TESTFIELD(Quantity);
                    ProcurementPlanLines.TESTFIELD("Unit Price");
                    ProcurementPlanLines.TESTFIELD("Expected Completion Date");
                UNTIL ProcurementPlanLines.NEXT = 0;
                IF GetAmountsOnPlanLines(ProcurementPlanHeader2) = 0 THEN
                    ERROR(ZeroAmountErr)
            END ELSE BEGIN
                ERROR(NoLinesErr);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure GetAmountsOnPlanLines(ProcurementPlanHeader: Record "Procurement Plan Header") AmountOnLines: Decimal;
    begin
        AmountOnLines := 0;
        ProcurementPlanLines.RESET;
        ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader."No.");
        IF ProcurementPlanLines.FINDSET THEN BEGIN
            REPEAT
                AmountOnLines += ProcurementPlanLines."Estimated Cost";
            UNTIL ProcurementPlanLines.NEXT = 0;
        END;
        EXIT(AmountOnLines);
    end;

    //[Scope('Personalization')]
    procedure ViewSubmittedPlans(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementPlanLines: Record "Procurement Plan Line";
        PlanNoText: Text;
        ProcurementPlanLinesPage: Page "Procurement Lines";
    begin
        ProcurementPlanLines.RESET;
        ProcurementPlanLines.SETRANGE("Current Budget", GLBudgetName.Name);
        ProcurementPlanLines.SETRANGE(Submitted, TRUE);
        IF ProcurementPlanLines.FIND('-') THEN BEGIN
            CLEAR(ProcurementPlanLinesPage);
            ProcurementPlanLinesPage.SETTABLEVIEW(ProcurementPlanLines);
            ProcurementPlanLinesPage.SETRECORD(ProcurementPlanLines);
            ProcurementPlanLinesPage.LOOKUPMODE := TRUE;
            IF GLBudgetName."Forwarded To CEO?" = TRUE THEN
                ProcurementPlanLinesPage.RUN
            ELSE
                ProcurementPlanLinesPage.RUNMODAL;
            COMMIT;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewPlansNotSubmitted(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementPlanLines: Record "Procurement Plan Line";
        PlanNoText: Text;
        ProcurementPlanLinesPage: Page "Procurement Plan Lines";
        PlanSubmissionEntries2: Record "Plan Submission Entries";
    begin
        WITH GLBudgetName DO BEGIN
            UpdatePlansNotSubmitted(GLBudgetName);
            COMMIT;
        END;
    end;

    //[Scope('Personalization')]
    procedure RequestPlanSubmission(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
        ProcurementPlanLines: Record "Procurement Plan Line";
        PlanNoText: Text;
        ProcurementPlanLinesPage: Page "Procurement Plan Lines";
        DimensionHeads: Record "Dimension Heads";
        PlanSubmissionEntries: Record "Plan Submission Entries";
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        EmailSubject: Label 'REQUEST FOR PROCUREMENT PLAN SUBMISSION';
        EmailBody: Label 'Dear %1,<br><br> Kindly create your procurement plan for the budget %2. <br><br> Please note that the submission deadline is %3. <br><br>Kind Regards <br><br> Procurement Office';
        ProcurementSetup: Record "Procurement Setup";
        Window: Dialog;
        WindowText1: Label 'Sending Email... \User.###1########';
        WindowText2: Label 'Email Sent Successfully.';
    begin
        WITH GLBudgetName DO BEGIN
            ProcurementPlanHeader.RESET;
            ProcurementPlanHeader.SETRANGE("Current Budget", GLBudgetName.Name);
            ProcurementPlanHeader.SETRANGE(Status, ProcurementPlanHeader.Status::Approved);
            IF ProcurementPlanHeader.FINDSET THEN BEGIN
                ClearSubmissionEntries(ProcurementPlanHeader);
                REPEAT
                    UpdateSubmittedPlans(ProcurementPlanHeader);
                UNTIL ProcurementPlanHeader.NEXT = 0;
                UpdatePlansNotSubmitted(GLBudgetName);
            END ELSE BEGIN
                UpdatePlansNotSubmitted(GLBudgetName);
            END;
            COMMIT;

            ProcurementSetup.GET();
            PlanSubmissionEntries.RESET;
            PlanSubmissionEntries.SETRANGE("Current Budget", GLBudgetName.Name);
            PlanSubmissionEntries.SETRANGE(Submitted, FALSE);
            IF PlanSubmissionEntries.FINDSET THEN BEGIN
                Window.OPEN(WindowText1);
                REPEAT
                    DimensionHeads.RESET;
                    DimensionHeads.SETRANGE("Global Dimension 1 Code", PlanSubmissionEntries."Global Dimension 1 Code");
                    DimensionHeads.SETRANGE("Global Dimension 2 Code", PlanSubmissionEntries."Global Dimension 2 Code");
                    IF DimensionHeads.FINDFIRST THEN BEGIN
                        IF GLBudgetName."Budget Per Branch?" = TRUE THEN BEGIN
                            IF UserSetup.GET(DimensionHeads."Dimension 1 Head") THEN BEGIN
                                UserSetup.TESTFIELD("E-Mail");
                                SendMail(UserSetup."E-Mail", EmailSubject, STRSUBSTNO(EmailBody, DimensionHeads."Dimension 1 Head", GLBudgetName.Name, ProcurementSetup."Procurement Plan Deadline"));
                            END;
                            Window.UPDATE(1, DimensionHeads."Dimension 1 Head");
                        END;
                        IF (GLBudgetName."Budget Per Branch?" = FALSE) AND (GLBudgetName."Budget Per Department?" = TRUE) THEN BEGIN
                            IF UserSetup2.GET(DimensionHeads."Dimension 2 Head") THEN BEGIN
                                UserSetup2.TESTFIELD("E-Mail");
                                SendMail(UserSetup2."E-Mail", EmailSubject, STRSUBSTNO(EmailBody, DimensionHeads."Dimension 2 Head", GLBudgetName.Name, ProcurementSetup."Procurement Plan Deadline"));
                            END;
                            Window.UPDATE(1, DimensionHeads."Dimension 2 Head");
                        END;
                    END;
                UNTIL PlanSubmissionEntries.NEXT = 0;
            END;
        END;
        Window.CLOSE();
        MESSAGE(WindowText2);
    end;

    //[Scope('Personalization')]
    procedure UpdateSubmittedPlans(ProcurementPlanHeader: Record "Procurement Plan Header");
    var
        PlanSubmissionEntries: Record "Plan Submission Entries";
        PlanSubmissionEntries2: Record "Plan Submission Entries";
        PlanSubmissionEntries3: Record "Plan Submission Entries";
        GLBudgetName: Record "G/L Budget Name";
    begin
        WITH ProcurementPlanHeader DO BEGIN
            PlanSubmissionEntries.INIT;
            PlanSubmissionEntries."Budget Per Branch?" := "Budget Per Branch?";
            PlanSubmissionEntries."Budget Per Department?" := "Budget Per Department?";
            PlanSubmissionEntries."Global Dimension 1 Code" := "Global Dimension 1 Code";
            PlanSubmissionEntries."Global Dimension 2 Code" := "Global Dimension 2 Code";
            PlanSubmissionEntries."Current Budget" := "Current Budget";
            PlanSubmissionEntries."Created By" := "Created By";
            PlanSubmissionEntries."Created On" := "Created On";
            PlanSubmissionEntries."Created Time" := "Created Time";
            PlanSubmissionEntries.Submitted := TRUE;
            PlanSubmissionEntries."Plan No." := "No.";
            PlanSubmissionEntries3.RESET;
            PlanSubmissionEntries3.SETFILTER("Line No", '<>%1', 0);
            IF PlanSubmissionEntries3.FINDSET THEN
                PlanSubmissionEntries."Line No" := GetLastLine(PlanSubmissionEntries3)
            ELSE
                PlanSubmissionEntries."Line No" := 1;
            PlanSubmissionEntries.INSERT;
        END;
    end;

    //[Scope('Personalization')]
    procedure ClearSubmissionEntries(ProcurementPlanHeader: Record "Procurement Plan Header");
    var
        PlanSubmissionEntries: Record "Plan Submission Entries";
        PlanSubmissionEntries2: Record "Plan Submission Entries";
        PlanSubmissionEntries3: Record "Plan Submission Entries";
        GLBudgetName: Record "G/L Budget Name";
    begin
        WITH ProcurementPlanHeader DO BEGIN
            PlanSubmissionEntries.RESET;
            PlanSubmissionEntries.SETRANGE("Current Budget", "Current Budget");
            // PlanSubmissionEntries.SETRANGE("Plan No.","No.");
            IF PlanSubmissionEntries.FINDSET THEN BEGIN
                PlanSubmissionEntries.DELETEALL;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdatePlansNotSubmitted(GLBudgetName: Record "G/L Budget Name");
    var
        PlanSubmissionEntries: Record "Plan Submission Entries";
        DimensionValue: Record "Dimension Value";
        PlanSubmissionEntries2: Record "Plan Submission Entries";
        DimensionValue2: Record "Dimension Value";
        ProcurementPlanHeader: Record "Procurement Plan Header";
    begin
        WITH GLBudgetName DO BEGIN
            IF ("Budget Per Branch?" = FALSE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue.FINDSET THEN BEGIN
                    REPEAT
                        PlanSubmissionEntries.RESET;
                        PlanSubmissionEntries.SETRANGE("Current Budget", Name);
                        PlanSubmissionEntries.SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                        IF NOT PlanSubmissionEntries.FINDSET THEN BEGIN
                            InsertIntoSubmissionEntries(GLBudgetName, '', DimensionValue.Code);
                        END;
                    UNTIL DimensionValue.NEXT = 0;
                END;
            END;

            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = FALSE) THEN BEGIN
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                IF DimensionValue.FINDSET THEN BEGIN
                    REPEAT
                        PlanSubmissionEntries.RESET;
                        PlanSubmissionEntries.SETRANGE("Current Budget", Name);
                        PlanSubmissionEntries.SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                        IF NOT PlanSubmissionEntries.FINDSET THEN BEGIN
                            InsertIntoSubmissionEntries(GLBudgetName, DimensionValue.Code, '');
                        END;
                    UNTIL DimensionValue.NEXT = 0;
                END;
            END;
            IF ("Budget Per Branch?" = TRUE) AND ("Budget Per Department?" = TRUE) THEN BEGIN
                DimensionValue.RESET;
                DimensionValue.SETRANGE("Global Dimension No.", 1);
                IF DimensionValue.FINDSET THEN BEGIN
                    REPEAT
                        DimensionValue2.RESET;
                        DimensionValue2.SETRANGE("Global Dimension No.", 2);
                        IF DimensionValue2.FINDSET THEN BEGIN
                            REPEAT
                                PlanSubmissionEntries.RESET;
                                PlanSubmissionEntries.SETRANGE("Current Budget", Name);
                                PlanSubmissionEntries.SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                                PlanSubmissionEntries.SETRANGE("Global Dimension 2 Code", DimensionValue2.Code);
                                IF NOT PlanSubmissionEntries.FINDSET THEN BEGIN
                                    InsertIntoSubmissionEntries(GLBudgetName, DimensionValue.Code, DimensionValue2.Code);
                                END;
                            UNTIL DimensionValue2.NEXT = 0;
                        END;
                    UNTIL DimensionValue.NEXT = 0;
                END;
            END;
        END
    end;

    local procedure InsertIntoSubmissionEntries(GLBudgetName: Record "G/L Budget Name"; Dimension1Code: Code[20]; Dimension2Code: Code[20]);
    var
        PlanSubmissionEntries2: Record "Plan Submission Entries";
        PlanSubmissionEntries: Record "Plan Submission Entries";
    begin
        WITH GLBudgetName DO BEGIN
            PlanSubmissionEntries2.INIT;
            PlanSubmissionEntries2."Budget Per Branch?" := "Budget Per Branch?";
            PlanSubmissionEntries2."Budget Per Department?" := "Budget Per Department?";
            PlanSubmissionEntries2."Global Dimension 1 Code" := Dimension1Code;
            PlanSubmissionEntries2."Global Dimension 2 Code" := Dimension2Code;
            PlanSubmissionEntries2."Current Budget" := Name;
            PlanSubmissionEntries2."Created By" := '';
            PlanSubmissionEntries2."Created On" := 0D;
            PlanSubmissionEntries2."Created Time" := 0T;
            PlanSubmissionEntries2.Submitted := FALSE;
            PlanSubmissionEntries.RESET;
            PlanSubmissionEntries.SETFILTER("Line No", '<>%1', 0);
            IF PlanSubmissionEntries.FINDSET THEN
                PlanSubmissionEntries2."Line No" := GetLastLine(PlanSubmissionEntries)
            ELSE
                PlanSubmissionEntries2."Line No" := 1;
            PlanSubmissionEntries2.INSERT;
        END;
    end;

    //[Scope('Personalization')]
    procedure ApprovePlan(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanApprovals: Record "Procurement Plan Approvals";
        PlanApprovalSetup: Record "Plan Approval Setup";
        ProcurementPlanApprovals2: Record "Procurement Plan Approvals";
        ApproverErr: Label 'You are not the current Approver';
        NextSequence: Integer;
    begin
        WITH GLBudgetName DO BEGIN
            NextSequence := 0;
            ProcurementPlanApprovals.RESET;
            ProcurementPlanApprovals.SETRANGE("Budget No.", Name);
            IF NOT ProcurementPlanApprovals.FINDFIRST THEN BEGIN
                CreateApprovalEntries(GLBudgetName);
            END ELSE BEGIN
                ProcurementPlanApprovals2.RESET;
                ProcurementPlanApprovals2.SETRANGE("Budget No.", Name);
                ProcurementPlanApprovals2.SETRANGE(Status, ProcurementPlanApprovals2.Status::Open);
                ProcurementPlanApprovals2.SETCURRENTKEY(Sequence);
                IF ProcurementPlanApprovals2.FINDFIRST THEN BEGIN
                    IF ProcurementPlanApprovals2.Approver <> USERID THEN
                        ERROR(ApproverErr);
                    ProcurementPlanApprovals2.Status := ProcurementPlanApprovals2.Status::Released;
                    ProcurementPlanApprovals2.Approved := TRUE;
                    ProcurementPlanApprovals2.MODIFY;

                    NextSequence := ProcurementPlanApprovals2.Sequence + 1;

                    ProcurementPlanApprovals.RESET;
                    ProcurementPlanApprovals.SETRANGE("Budget No.", Name);
                    ProcurementPlanApprovals.SETRANGE(Sequence, NextSequence);
                    IF NOT ProcurementPlanApprovals.FINDFIRST THEN BEGIN
                        "Procurement Plan Approved" := TRUE;
                        MODIFY;
                        UpdatePlanHeader(Name, 2);
                    END;
                END;
            END;
        END;
    end;

    local procedure CreateApprovalEntries(GLBudgetName: Record "G/L Budget Name");
    var
        ProcurementPlanApprovals: Record "Procurement Plan Approvals";
        PlanApprovalSetup: Record "Plan Approval Setup";
    begin
        WITH GLBudgetName DO BEGIN
            PlanApprovalSetup.RESET;
            PlanApprovalSetup.SETCURRENTKEY("Approval Sequence");
            IF PlanApprovalSetup.FINDSET THEN BEGIN
                REPEAT
                    ProcurementPlanApprovals.INIT;
                    ProcurementPlanApprovals."Budget No." := Name;
                    ProcurementPlanApprovals.Sequence := PlanApprovalSetup."Approval Sequence";
                    ProcurementPlanApprovals.Approver := PlanApprovalSetup."Approver ID";
                    ProcurementPlanApprovals.Status := ProcurementPlanApprovals.Status::Open;
                    ProcurementPlanApprovals.Approved := FALSE;
                    ProcurementPlanApprovals.INSERT;
                //ProcurementPlanApprovals.s
                UNTIL PlanApprovalSetup.NEXT = 0;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ForwardToCEO(ProcurementPlanLines: Record "Procurement Plan Line");
    var
        ProcurementPlanHeader: Record "Procurement Plan Header";
    begin
        WITH ProcurementPlanLines DO BEGIN
            ValidateLinesToCEO(ProcurementPlanLines);
            "Forwarded To CEO" := TRUE;
            MODIFY;
        END;
    end;

    local procedure ValidateLinesToCEO(ProcurementPlanLines: Record "Procurement Plan Line");
    var
        ZeroAmountErr: Label 'Kindly capture the estimated amounts on the Plan Lines.';
        NoLinesErr: Label 'Kindly fill in the lines.';
    begin
        WITH ProcurementPlanLines DO BEGIN
            TESTFIELD("Advertisement Date");
            TESTFIELD("Procurement Method");
            TESTFIELD("Procurement Type");
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdateGLBudget(GLBudgetName1: Record "G/L Budget Name"; Stage: Integer);
    var
        ZeroAmountErr: Label 'Kindly capture the estimated amounts on the Plan Lines.';
        NoLinesErr: Label 'Kindly fill in the lines.';
        ProcurementPlanHeader1: Record "Procurement Plan Header";
        ApprovalTxt: Label 'Procurement Plan %1 Approved Successfully.';
        RejectTxt: Label 'Procurement Plan %1 Rejected Successfully.';
        ForwardTxt: Label 'Plan forwarded to the CEO Successfully';
        ApprovalConfTxt: Label 'Are you sure you want to Approve Submitted Procurement Plans?';
        RejectConfTxt: Label 'Are you sure you want to Reject Submitted Procurement Plans?';
        ForwardConfTxt: Label 'Are you sure you want to Foward Submitted Procurement Plans to the CEO?';
    begin
        WITH GLBudgetName1 DO BEGIN
            CASE Stage OF
                1:
                    BEGIN
                        IF CONFIRM(ForwardConfTxt) THEN BEGIN
                            "Forwarded To CEO?" := TRUE;
                            "Procurement Plan Status" := "Procurement Plan Status"::"Pending Approval";
                            MODIFY;
                            UpdatePlanHeader(GLBudgetName1.Name, 1);
                            MESSAGE(ForwardTxt);
                        END;
                    END;
                2:
                    BEGIN
                        IF CONFIRM(ApprovalConfTxt) THEN BEGIN
                            "CEO Approved" := TRUE;
                            "Procurement Plan Approved" := TRUE;
                            "Procurement Plan Status" := "Procurement Plan Status"::Released;
                            MODIFY;
                            UpdatePlanHeader(Name, 2);
                            UpdateGLBudgetEntries(GLBudgetName1);
                            MESSAGE(ApprovalTxt, GLBudgetName1.Name);
                        END;
                    END;
                3:
                    BEGIN
                        IF CONFIRM(RejectConfTxt) THEN BEGIN
                            "Forwarded To CEO?" := FALSE;
                            "Procurement Plan Status" := "Procurement Plan Status"::Open;
                            MODIFY;
                            UpdatePlanHeader(Name, 3);
                            MESSAGE(RejectTxt, GLBudgetName1.Name);
                        END;
                    END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdatePlanHeader(CurrentBudget: Code[20]; Stage: Integer);
    var
        ZeroAmountErr: Label 'Kindly capture the estimated amounts on the Plan Lines.';
        NoLinesErr: Label 'Kindly fill in the lines.';
        ProcurementPlanHeader1: Record "Procurement Plan Header";
    begin
        ProcurementPlanHeader1.RESET;
        ProcurementPlanHeader1.SETRANGE("Current Budget", CurrentBudget);
        IF ProcurementPlanHeader1.FINDSET THEN BEGIN
            REPEAT
                CASE Stage OF
                    1:
                        BEGIN
                            ProcurementPlanHeader1."Forwarded To CEO" := TRUE;
                            ProcurementPlanHeader1.MODIFY(TRUE);
                        END;
                    2:
                        BEGIN
                            ProcurementPlanHeader1."CEO Approved" := TRUE;
                            ProcurementPlanHeader1.MODIFY(TRUE);
                            ProcurementPlanLines.RESET;
                            ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader1."No.");
                            ProcurementPlanLines.SETRANGE("Forwarded To CEO", TRUE);
                            IF ProcurementPlanLines.FINDSET THEN BEGIN
                                REPEAT
                                    ProcurementPlanLines.Approved := TRUE;
                                    ProcurementPlanLines.MODIFY(TRUE);
                                UNTIL ProcurementPlanLines.NEXT = 0;
                            END;
                        END;
                    3:
                        BEGIN
                            ProcurementPlanHeader1."Forwarded To CEO" := FALSE;
                            ProcurementPlanHeader1.MODIFY(TRUE);
                            ProcurementPlanLines.RESET;
                            ProcurementPlanLines.SETRANGE("Plan No", ProcurementPlanHeader1."No.");
                            ProcurementPlanLines.SETRANGE("Forwarded To CEO", TRUE);
                            IF ProcurementPlanLines.FINDSET THEN BEGIN
                                REPEAT
                                    ProcurementPlanLines."Forwarded To CEO" := FALSE;
                                    ProcurementPlanLines.MODIFY(TRUE);
                                UNTIL ProcurementPlanLines.NEXT = 0;
                            END;
                        END;
                END;
            UNTIL ProcurementPlanHeader1.NEXT = 0;
        END;
    end;

    local procedure UpdateGLBudgetEntries(GLBudgetName: Record "G/L Budget Name");
    var
        GLBudgetEntry: Record "G/L Budget Entry";
        ProcurementPlanLines: Record "Procurement Plan Line";
    begin
        WITH GLBudgetName DO BEGIN
            ProcurementPlanLines.RESET;
            ProcurementPlanLines.SETRANGE("Current Budget", Name);
            ProcurementPlanLines.SETRANGE(Approved, TRUE);
            IF ProcurementPlanLines.FINDSET THEN BEGIN
                REPEAT
                    IF GLBudgetEntry.GET(ProcurementPlanLines."Source Of Funds") THEN BEGIN
                        GLBudgetEntry.Approved := TRUE;
                        GLBudgetEntry.MODIFY;
                    END;
                UNTIL ProcurementPlanLines.NEXT = 0;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewProcurementDates(ProcurementPlanLines: Record "Procurement Plan Line");
    var
        ProcurementLinesDates: Page "Procurement Lines Dates";
        ProcurementPlanLines2: Record "Procurement Plan Line";
    begin
        WITH ProcurementPlanLines DO BEGIN
            CLEAR(ProcurementLinesDates);
            ProcurementLinesDates.SETTABLEVIEW(ProcurementPlanLines);
            ProcurementLinesDates.SETRECORD(ProcurementPlanLines);
            ProcurementLinesDates.LOOKUPMODE := TRUE;
            ProcurementLinesDates.RUNMODAL;
            COMMIT;
        END;
    end;

    local procedure GetLastLine(PlanSubmissionEntries: Record "Plan Submission Entries"): Integer;
    begin
        WITH PlanSubmissionEntries DO BEGIN
            SETCURRENTKEY("Line No");
            SETASCENDING("Line No", FALSE);
            IF FINDFIRST THEN
                EXIT("Line No" + 1)
            ELSE
                EXIT(1);
        END;
    end;

    //[Scope('Personalization')]
    procedure PopluateDimensionHeads();
    var
        DimensionHeads: Record "Dimension Heads";
        DimensionHeads2: Record "Dimension Heads";
        DimensionValue: Record "Dimension Value";
        DimensionValue2: Record "Dimension Value";
    begin
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.", 1);
        IF DimensionValue.FINDSET THEN BEGIN
            REPEAT
                DimensionValue2.RESET;
                DimensionValue2.SETRANGE("Global Dimension No.", 2);
                IF DimensionValue2.FINDSET THEN BEGIN
                    REPEAT
                        DimensionHeads.RESET;
                        DimensionHeads.SETRANGE("Global Dimension 1 Code", DimensionValue.Code);
                        DimensionHeads.SETRANGE("Global Dimension 2 Code", DimensionValue2.Code);
                        IF NOT DimensionHeads.FIND('-') THEN BEGIN
                            DimensionHeads2.INIT;
                            DimensionHeads2."Global Dimension 1 Code" := DimensionValue.Code;
                            DimensionHeads2."Global Dimension 2 Code" := DimensionValue2.Code;
                            DimensionHeads2.INSERT;
                        END;
                    UNTIL DimensionValue2.NEXT = 0;
                END;
            UNTIL DimensionValue.NEXT = 0;
        END;
        DimensionHeads.RESET
    end;

    procedure SendMail(Recipient: Text; Subject: Text; Body: Text);
    var
        SMTPMailSetup: Record "SMTP Mail Setup";
        SMTPMail: Codeunit "SMTP Mail";
        CompanyInformation: Record "Company Information";
    begin
        CompanyInformation.GET;
        ProcurementSetup.GET;
        SMTPMailSetup.GET;
        SMTPMail.CreateMessage(CompanyInformation.Name, SMTPMailSetup."User ID", Recipient, Subject, Body, TRUE);
        //SMTPMail.AddCC(ProcurementSetup."Procurement Email");
        EmailMembers.Add(ProcurementSetup."Procurement Email");
        SMTPMail.AddCC(EmailMembers);
        SMTPMail.Send;
    end;

    //[Scope('Personalization')]
    procedure ValidateProcurementDates(Variant: Variant);
    var
        ProcurementMethod: Record "Procurement Method";
        AdvertDateErr: Label 'Kindly Capture All the Advertisement Dates.';
        ProcurementPlanLine: Record "Procurement Plan Line";
        RecRef: RecordRef;
        ProcurementRequest: Record "Procurement Request";
        AdvertisementDate: Date;
        ProcurementRequest2: Record "Procurement Request";
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Plan Line":
                BEGIN
                    ProcurementPlanLine := Variant;
                    IF ProcurementMethod.GET(ProcurementPlanLine."Procurement Method") THEN BEGIN
                        IF ProcurementPlanLine."Advertisement Date" <> 0D THEN BEGIN
                            IF FORMAT(ProcurementMethod."Document Open Period") <> '0D' THEN
                                ProcurementPlanLine."Document Opening Date" := CALCDATE(ProcurementMethod."Document Open Period", ProcurementPlanLine."Advertisement Date");
                            IF FORMAT(ProcurementMethod."Process Evaluation Period") <> '0D' THEN
                                ProcurementPlanLine."Proposal Evaluation Date" := CALCDATE(ProcurementMethod."Process Evaluation Period", ProcurementPlanLine."Advertisement Date");
                            IF FORMAT(ProcurementMethod."Award Approval") <> '0D' THEN
                                ProcurementPlanLine."Award Approval Date" := CALCDATE(ProcurementMethod."Award Approval", ProcurementPlanLine."Advertisement Date");
                            IF FORMAT(ProcurementMethod."Notification Of Award") <> '0D' THEN
                                ProcurementPlanLine."Notification Of Award Date" := CALCDATE(ProcurementMethod."Notification Of Award", ProcurementPlanLine."Advertisement Date");
                            IF FORMAT(ProcurementMethod."Time For Contract signature") <> '0D' THEN
                                ProcurementPlanLine."Contract Signing Date" := CALCDATE(ProcurementMethod."Time For Contract Completion", ProcurementPlanLine."Advertisement Date");
                            ProcurementPlanLine.MODIFY;
                        END ELSE
                            ERROR(AdvertDateErr);
                    END;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    ProcurementRequest.TESTFIELD("Advertisement Date");
                    AdvertisementDate := ProcurementRequest."Advertisement Date";
                    IF ProcurementMethod.GET(ProcurementRequest."Procurement Method") THEN BEGIN
                        IF FORMAT(ProcurementMethod."Document Open Period") <> '0D' THEN
                            ProcurementRequest."Opening Date" := CALCDATE(ProcurementMethod."Document Open Period", AdvertisementDate);
                        IF FORMAT(ProcurementMethod."Process Evaluation Period") <> '0D' THEN
                            ProcurementRequest."Evaluation Date" := CALCDATE(ProcurementMethod."Process Evaluation Period", AdvertisementDate);
                        IF FORMAT(ProcurementMethod."Award Approval") <> '0D' THEN
                            ProcurementRequest."Award Approval Date" := CALCDATE(ProcurementMethod."Award Approval", AdvertisementDate);
                        IF FORMAT(ProcurementMethod."Notification Of Award") <> '0D' THEN
                            ProcurementRequest."Notification of Award Date" := CALCDATE(ProcurementMethod."Notification Of Award", AdvertisementDate);
                        IF FORMAT(ProcurementMethod."Time For Contract signature") <> '0D' THEN
                            ProcurementRequest."Contract Signing Date" := CALCDATE(ProcurementMethod."Time For Contract Completion", AdvertisementDate);
                        IF FORMAT(ProcurementMethod."Closing Period") <> '0D' THEN
                            ProcurementRequest."Closing Date" := CALCDATE(ProcurementMethod."Closing Period", AdvertisementDate);
                        ProcurementRequest."Closing Time" := 120000T;
                        ProcurementRequest.MODIFY;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure OnSendRequisitionsForApproval(RequisitionHeader: Record "Requisition Header");
    var
        RequisitionLines: Record "Requisition Header Line";
        NoLinesErr: Label 'Kindly fill in the Lines.';
    begin
        WITH RequisitionHeader DO BEGIN
            TESTFIELD(Description);
            RequisitionLines.RESET;
            RequisitionLines.SETRANGE("Requisition No.", "No.");
            IF RequisitionLines.FINDSET THEN BEGIN
                REPEAT
                    ValidateRequisitionLines(RequisitionLines);
                UNTIL RequisitionLines.NEXT = 0;
            END ELSE BEGIN
                ERROR(NoLinesErr);
            END;
        END;
    end;

    local procedure ValidateRequisitionLines(RequisitionLines: Record "Requisition Header Line");
    var
        RequisitionHeader: Record "Requisition Header";
        RemarksErr: Label 'Kindly fill in comments for less Quantity Returned!';
    begin
        WITH RequisitionLines DO BEGIN
            ProcurementSetup.GET;
            TESTFIELD(Type);
            TESTFIELD(No);
            TESTFIELD(Quantity);
            TESTFIELD(Amount);
            IF RequisitionLines."Requisition Type" = RequisitionLines."Requisition Type"::"Purchase Requisition" THEN BEGIN
                IF ProcurementSetup."Purchase Req. From Plan" THEN BEGIN
                    TESTFIELD("Procurement Plan");
                    TESTFIELD("Procurement Plan Item");
                END;
            END;
            IF RequisitionLines."Requisition Type" = RequisitionLines."Requisition Type"::"Store Return" THEN BEGIN
                TESTFIELD("Quantity Returned");
                IF "Quantity Returned" < Quantity THEN
                    IF Remarks = '' THEN
                        ERROR(RemarksErr);
            END;
            TESTFIELD(Description);
            TESTFIELD("Requisition No.");
        END;
    end;

    //[Scope('Personalization')]
    procedure GetCurrentDocumentApprover(Document_ID: Code[10]): Code[80];
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.RESET;
        ApprovalEntry.SETRANGE("Document No.", Document_ID);
        ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.FINDFIRST;
        EXIT(ApprovalEntry."Approver ID");
    end;

    //[Scope('Personalization')]
    procedure ValidateItemJournalLine(RequisitionHeader: Record "Requisition Header");
    var
        ConfirmCreateItemJnlTxt: Label 'Are you sure you want to post this request?';
        RequisitionLines: Record "Requisition Header Line";
        LinesCreatedTxt: Label 'Item Lines created successfully.';
        IssuedSuccessTxt: Label 'Item Issued Successfully.';
        ReturnSuccessTxt: Label 'Item Returned Successfully.';
        ItemJournalLine: Record "Item Journal Line";
        ItemJournal: Page "Item Journal";
        PostOptionTxt1: Label 'Proceed to post,View created lines';
        PostOptionTxt2: Label 'Select the option to proceed before posting.';
        EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        Item: Record Item;
        ToReturn: Integer;
        ExcessQuantityErr: Label 'Kindly note that the quantity requested of %1 is more than the available quantity of %2';
        LessQuantityErr: Label 'Kindly note that the quantity returned of %1 on line %2 is less than the issued of %3';
    begin
        WITH RequisitionHeader DO BEGIN
            IF CONFIRM(ConfirmCreateItemJnlTxt) THEN BEGIN
                ToReturn := 0;
                ProcurementSetup.GET;
                ProcurementSetup.TESTFIELD("Item Journal Template");
                ProcurementSetup.TESTFIELD("Item Journal Batch");
                //ClearBatch(ProcurementSetup."Item Journal Template",ProcurementSetup."Item Journal Batch");
                ClearItemJournalLines(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch");
                RequisitionLines.RESET;
                RequisitionLines.SETRANGE("Requisition No.", "No.");
                IF RequisitionLines.FINDSET THEN BEGIN
                    REPEAT
                        ValidateRequisitionLines(RequisitionLines);
                        IF "Requisition Type" = "Requisition Type"::"Store Requisition" THEN BEGIN
                            IF RequisitionLines."Item Category" = RequisitionLines."Item Category"::"Non Consumable" THEN
                                ToReturn += 1;

                            IF CheckItemQuantity(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch", RequisitionLines.No, 1) < RequisitionLines.Quantity THEN
                                ERROR(ExcessQuantityErr, RequisitionLines.Quantity, CheckItemQuantity(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch", RequisitionLines.No, 1));

                            CreateItemJournalLine("No.", EntryType::"Negative Adjmt.", RequisitionLines.No, RequisitionLines.Description,
                            RequisitionLines.Quantity, RequisitionLines."Unit of Measure", RequisitionLines."Unit Price", RequisitionLines."Global Dimension 1 Code");
                        END;
                        IF "Requisition Type" = "Requisition Type"::"Store Return" THEN BEGIN
                            /*IF RequisitionLines."Quantity Returned" < RequisitionLines.Quantity THEN
                              ERROR(LessQuantityErr,RequisitionLines."Quantity Returned",RequisitionLines."Line No",RequisitionLines.Quantity);
                            */

                            CreateItemJournalLine("No.", EntryType::"Positive Adjmt.", RequisitionLines.No, RequisitionLines.Description,
                            RequisitionLines."Quantity Returned", RequisitionLines."Unit of Measure", RequisitionLines."Unit Price", RequisitionLines."Global Dimension 1 Code");
                        END;
                    UNTIL RequisitionLines.NEXT = 0;
                    PostItemJournalLines(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch");

                    //SelectedOption := DIALOG.STRMENU(PostOptionTxt1, 1, PostOptionTxt2);
                    /* CASE SelectedOption OF
                        1:
                            BEGIN
                                PostItemJournalLines(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch");
                            END;
                        2:
                            BEGIN
                                ItemJournalLine.RESET;
                                ItemJournalLine.SETRANGE("Journal Template Name", ProcurementSetup."Item Journal Template");
                                ItemJournalLine.SETRANGE("Journal Batch Name", ProcurementSetup."Item Journal Batch");
                                IF ItemJournalLine.FINDSET THEN BEGIN
                                    CLEAR(ItemJournal);
                                    ItemJournal.SETTABLEVIEW(ItemJournalLine);
                                    ItemJournal.SETRECORD(ItemJournalLine);
                                    ItemJournal.LOOKUPMODE := TRUE;
                                    ItemJournal.RUN;
                                    COMMIT;
                                END;
                            END;
                    END; */
                    IF "Requisition Type" = "Requisition Type"::"Store Return" THEN BEGIN
                        "Issuance Status" := "Issuance Status"::Returned;
                        Status := Status::Returned;
                        "Return Date" := TODAY;
                        "Return Received By" := USERID;
                        Message(ReturnSuccessTxt);
                    END ELSE BEGIN
                        "Issuance Status" := "Issuance Status"::Issued;
                        Status := Status::Issued;
                        RequisitionLines.FINDSET;
                        RequisitionLines.SETRANGE("Requisition No.", "No.");
                        RequisitionLines.SETRANGE("Item Category", RequisitionLines."Item Category"::"Non Consumable");
                        IF RequisitionLines.FINDFIRST THEN BEGIN
                            "Has Item To Return" := TRUE;
                            "Issuance Status" := "Issuance Status"::"Pending Return";
                        END;
                        "Issue Date" := TODAY;
                        "Issued By" := USERID;
                        Message(IssuedSuccessTxt);
                    END;
                    MODIFY(TRUE);
                END;
            END;
        END;

    end;

    local procedure CreateItemJournalLine(Document_No: Code[20]; Entry_Type: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output"; Item_No: Code[20]; Description: Text; Quantity: Decimal; "Unit_Of_ Measure": Code[20]; Unit_Amount: Decimal; Location: Code[10]);
    var
        ItemJournalLine: Record "Item Journal Line";
        Item: Record Item;
        PostingGrp: Label 'GENERAL';
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        ProcurementSetup.GET;
        Item.GET(Item_No);
        ItemJnlBatch.GET(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch");
        //add applies to entries once Goods are received
        ItemJournalLine.INIT;
        ItemJournalLine."Journal Batch Name" := ProcurementSetup."Item Journal Batch";
        ItemJournalLine."Journal Template Name" := ProcurementSetup."Item Journal Template";
        ;
        ItemJournalLine."Posting Date" := TODAY;
        ItemJournalLine."Entry Type" := Entry_Type;
        ItemJournalLine."Document No." := NoSeriesMgt.GetNextNo(ItemJnlBatch."No. Series", ItemJournalLine."Posting Date", FALSE);
        ItemJournalLine."External Document No." := Document_No;
        ItemJournalLine."Item No." := Item_No;
        ItemJournalLine.VALIDATE("Item No.", Item_No);
        ItemJournalLine.Description := Description;
        //ItemJournalLine."Location Code":=Location;
        ItemJournalLine.Quantity := Quantity;
        ItemJournalLine."Source Type" := ItemJournalLine."Source Type"::Item;
        ItemJournalLine.VALIDATE(Quantity);
        ItemJournalLine."Unit of Measure Code" := "Unit_Of_ Measure";
        ItemJournalLine."Unit Amount" := Unit_Amount;
        ItemJournalLine.VALIDATE("Unit Amount");
        ItemJournalLine.VALIDATE("Shortcut Dimension 1 Code", Location);
        ItemJournalLine."Gen. Bus. Posting Group" := Item."Gen. Prod. Posting Group";
        ItemJournalLine."Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
        ItemJournalLine."Line No." := GetItemLineNo(ProcurementSetup."Item Journal Template", ProcurementSetup."Item Journal Batch");
        ItemJournalLine.INSERT;
    end;

    local procedure ClearBatch(BatchTemplate: Code[20]; BatchCode: Code[20]);
    var
        GenJournalBatch: Record "Gen. Journal Batch";
    begin
        IF GenJournalBatch.GET(BatchTemplate, BatchCode) THEN
            GenJournalBatch.DELETE;
    end;

    local procedure ClearItemJournalLines(ItemJnlTemplate: Code[20]; ItemJnlBatch: Code[20]);
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", ItemJnlTemplate);
        ItemJournalLine.SETRANGE("Journal Batch Name", ItemJnlBatch);
        IF ItemJournalLine.FINDSET THEN BEGIN
            ItemJournalLine.DELETEALL;
        END;
    end;

    local procedure GetItemLineNo(ItemJnlTemplate: Code[20]; ItemJnlBatch: Code[20]): Integer;
    var
        ItemJournalLine: Record "Item Journal Line";
    begin
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", ItemJnlTemplate);
        ItemJournalLine.SETRANGE("Journal Batch Name", ItemJnlBatch);
        ItemJournalLine.SETCURRENTKEY("Line No.");
        ItemJournalLine.SETASCENDING("Line No.", FALSE);
        IF ItemJournalLine.FINDFIRST THEN BEGIN
            EXIT(ItemJournalLine."Line No." + 10000);
        END ELSE
            EXIT(10000);
    end;

    local procedure PostItemJournalLines(ItemJnlTemplate: Code[20]; ItemJnlBatch: Code[20]);
    var
        ItemJournalLine: Record "Item Journal Line";
        RequisitionHeader: Record "Requisition Header";
        RequisitionLines: Record "Requisition Header Line";
    begin
        ItemJournalLine.RESET;
        ItemJournalLine.SETRANGE("Journal Template Name", ItemJnlTemplate);
        ItemJournalLine.SETRANGE("Journal Batch Name", ItemJnlBatch);
        IF ItemJournalLine.FINDSET THEN BEGIN
            CODEUNIT.RUN(CODEUNIT::"Item Jnl.-Post", ItemJournalLine);
        END;
    end;

    local procedure CheckItemQuantity(ItemJnlTemplate: Code[20]; ItemJnlBatch: Code[20]; ItemNo: Code[20]; CheckCode: Integer): Decimal;
    var
        Item: Record Item;
        InventoryCount: array[5] of Integer;
        ItemJournalLine: Record "Item Journal Line";
    begin
        InventoryCount[1] := 0;
        InventoryCount[2] := 0;
        InventoryCount[3] := 0;
        CASE CheckCode OF
            1:
                BEGIN
                    ItemJournalLine.RESET;
                    ItemJournalLine.SETRANGE("Journal Template Name", ItemJnlTemplate);
                    ItemJournalLine.SETRANGE("Journal Batch Name", ItemJnlBatch);
                    ItemJournalLine.SETRANGE("Entry Type", ItemJournalLine."Entry Type"::"Negative Adjmt.");
                    ItemJournalLine.SETRANGE("No.", ItemNo);
                    IF ItemJournalLine.FINDSET THEN BEGIN
                        REPEAT
                            InventoryCount[1] += ItemJournalLine.Quantity;
                        UNTIL ItemJournalLine.NEXT = 0;
                    END;

                    IF Item.GET(ItemNo) THEN BEGIN
                        Item.CALCFIELDS(Inventory);
                        InventoryCount[2] := Item.Inventory;
                    END;

                    InventoryCount[3] := InventoryCount[1] + InventoryCount[2];

                    EXIT(InventoryCount[3]);
                END;
            2:
                BEGIN
                END;
        END;
    end;

    local procedure CheckIfPostingDone(ExtDocument_No: Code[20]): Boolean;
    var
        Item: Record Item;
        ItemJournalLine: Record "Item Journal Line";
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.RESET;
        ItemLedgerEntry.SETRANGE("External Document No.", ExtDocument_No);
        ItemLedgerEntry.SETRANGE("Entry Type", ItemLedgerEntry."Entry Type"::"Negative Adjmt.");
        IF ItemLedgerEntry.FINDSET THEN
            EXIT(TRUE)
        ELSE
            EXIT(FALSE);
    end;

    //[Scope('Personalization')]
    procedure CreateNewStoreReturnRequest(RequisitionHeader: Record "Requisition Header");
    var
        RequisitionLines: Record "Requisition Header Line";
        ItemJournalLine: Record "Item Journal Line";
        ItemJournal: Page "Item Journal";
        EntryType: Option Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        Item: Record Item;
        ToReturn: Integer;
        RequisitionHeader2: Record "Requisition Header";
        RequisitionHeader3: Record "Requisition Header";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NewNo: Code[20];
        RequisitionLines2: Record "Requisition Header Line";
        NewStoreReturnTxt: Label 'Store Return %1 nas been Created Successfully.';
    begin
        WITH RequisitionHeader DO BEGIN
            NewNo := '';
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Store Return No.");
            RequisitionHeader2.INIT;
            //RequisitionHeader2.TRANSFERFIELDS(RequisitionHeader,TRUE);
            NoSeriesManagement.InitSeries(ProcurementSetup."Store Return No.", "No. Series", 0D, RequisitionHeader2."No.", RequisitionHeader2."No. Series");
            RequisitionHeader2."Requisition Type" := RequisitionHeader2."Requisition Type"::"Store Return";
            RequisitionHeader2."Store Requisition No." := "No.";
            RequisitionHeader2."Issued By" := RequisitionHeader."Issued By";
            RequisitionHeader2."Issue Date" := RequisitionHeader."Issue Date";
            NewNo := RequisitionHeader2."No.";
            RequisitionHeader2.INSERT(TRUE);

            RequisitionHeader3.ValidateFieldsOnInsert(RequisitionHeader2);

            RequisitionLines.RESET;
            RequisitionLines.SETRANGE("Requisition No.", "No.");
            RequisitionLines.SETRANGE("Item Category", RequisitionLines."Item Category"::"Non Consumable");
            IF RequisitionLines.FINDSET THEN BEGIN
                REPEAT
                    RequisitionLines2.INIT;
                    RequisitionLines2.TRANSFERFIELDS(RequisitionLines);
                    RequisitionLines2."Requisition No." := NewNo;
                    RequisitionLines2."Requisition Type" := RequisitionLines2."Requisition Type"::"Store Return";
                    RequisitionLines2.INSERT(TRUE);
                UNTIL RequisitionLines.NEXT = 0;
            END;
            "Store Return No." := NewNo;
            "Issuance Status" := "Issuance Status"::"Pending Return";
            Status := Status::"Pending Return";
            MODIFY(TRUE);
            Sleep(500);
            MESSAGE(NewStoreReturnTxt, NewNo);
        END;
    end;

    local procedure GenerateDocumentNo(): Code[20];
    begin

    end;

    //[Scope('Personalization')]
    procedure AssignUser(Variant: Variant);
    var
        ProcurementRequest: Record "Procurement Request";
        RequisitionLines: Record "Requisition Header Line";
        ProcurementMethod: Record "Procurement Method";
        TotalLines: Integer;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NoAssignedUserConfirm: Label 'Kindly Note that you have not assigned a user to proceed with this requisition. Do you wish to proceed with it?';
        SelectUserOpt: Label 'Select User,Proceed as Assigned User';
        SelectOptionText: Label 'Kindly Assign a user to proceed with this request';
        SelectedOption: Integer;
        RequisitionHeader: Record "Requisition Header";
        RecRef: RecordRef;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        UserRecID: Code[80];
        DifferentProcurementMethodsErr: Label 'There are different procurement methods on the lines. Kindly select a procurement method.';
        ProcMethodErr: Label 'Kindly Select a procurement method to process this Requisition.';
        ProceedWithMethodConf: Label 'Do you wish to proceed with the procurement Method on the Request Line of %1?';
        ProceedText2: Text;
    begin
        RecRef.GETTABLE(Variant);
        ProcurementSetup.GET;
        IF ProcurementSetup."Procurement Manager" <> USERID THEN
            ERROR(ProcurementMgrErr);
        UserSetup.GET(ProcurementSetup."Procurement Manager");
        CASE RecRef.NUMBER OF
            DATABASE::"Requisition Header":
                BEGIN
                    RequisitionHeader := Variant;
                    SelectedOption := DIALOG.STRMENU(SelectUserOpt, 1, SelectOptionText);
                    CASE SelectedOption OF
                        1:
                            BEGIN
                                UserSetup2.RESET;
                                UserSetup2.SETRANGE("Global Dimension 2 Code", UserSetup."Global Dimension 2 Code");
                                IF UserSetup2.FINDSET THEN BEGIN
                                    IF PAGE.RUNMODAL(50745, UserSetup2) = ACTION::LookupOK THEN BEGIN
                                        UserRecID := UserSetup2."User ID";
                                        RequisitionHeader."Assigned User ID" := UserRecID;
                                        RequisitionHeader."Date of Assignment" := TODAY;
                                    END;
                                END;
                            END;
                        2:
                            BEGIN
                                RequisitionHeader."Assigned User ID" := USERID;
                                RequisitionHeader."Date of Assignment" := TODAY;
                            END;
                    END;
                    RequisitionHeader.MODIFY;
                    IF RequisitionHeader."Assigned User ID" <> '' THEN
                        MESSAGE(AddUserMsg, RequisitionHeader."Assigned User ID");
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    RecRef.SETTABLE(ProcurementRequest);
                    ProcurementRequest.TESTFIELD("Requisition No.");
                    ProcurementRequest.TESTFIELD("Vendor No.");
                    ProcurementRequest.TESTFIELD(Description);
                    GenerateLPO(ProcurementRequest);
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateProcurementProcess(Variant: Variant);
    var
        ProcurementRequest: Record "Procurement Request";
        RequisitionLines: Record "Requisition Header Line";
        ProcurementMethod: Record "Procurement Method";
        TotalLines: Integer;
        NoSeriesManagement: Codeunit NoSeriesManagement;
        NoAssignedUserConfirm: Label 'Kindly Note that you have not assigned a user to proceed with this requisition. Do you wish to proceed with it?';
        SelectUserOpt: Label 'Select User,Proceed as Assigned User';
        SelectOptionText: Label 'Kindly Assign a user to proceed with this request';
        SelectedOption: Integer;
        RequisitionHeader: Record "Requisition Header";
        RecRef: RecordRef;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
        UserRecID: Code[80];
        DifferentProcurementMethodsErr: Label 'There are different procurement methods on the lines. Kindly select a procurement method.';
        ProcMethodErr: Label 'Kindly Select a procurement method to process this Requisition.';
        ProceedWithMethodConf: Label 'Do you wish to proceed with the procurement Method on the Request Line of %1?';
        ProceedText2: Text;
    begin
        RecRef.GETTABLE(Variant);
        ProcurementSetup.GET;
        IF ProcurementSetup."Procurement Manager" <> USERID THEN
            ERROR(ProcurementMgrErr);
        UserSetup.GET(ProcurementSetup."Procurement Manager");
        CASE RecRef.NUMBER OF
            DATABASE::"Requisition Header":
                BEGIN
                    RequisitionHeader := Variant;
                    RequisitionHeader.TESTFIELD("Assigned User ID");
                    IF RequisitionHeader."Procurement Method" = '' THEN BEGIN
                        ProcurementSetup.GET;
                        RequisitionLines.RESET;
                        RequisitionLines.SETRANGE("Requisition No.", RequisitionHeader."No.");
                        IF RequisitionLines.FINDSET THEN BEGIN
                            TotalLines := RequisitionLines.COUNT;
                            IF TotalLines > 1 THEN BEGIN
                                ERROR(ProcMethodErr);
                            END ELSE
                                IF TotalLines = 1 THEN BEGIN
                                    IF RequisitionLines."Procurement Method" = '' THEN
                                        ERROR(ProcMethodErr);
                                    IF ProcurementMethod.GET(RequisitionLines."Procurement Method") THEN BEGIN
                                        ProceedText2 := STRSUBSTNO(ProceedWithMethodConf, ProcurementMethod.Description);
                                        IF CONFIRM(ProceedText2) THEN
                                            CreateNewProcurementProcess(RequisitionHeader, ProcurementMethod.Method);
                                    END;
                                END;
                        END;
                    END ELSE BEGIN
                        IF ProcurementMethod.GET(RequisitionHeader."Procurement Method") THEN BEGIN
                            CreateNewProcurementProcess(RequisitionHeader, ProcurementMethod.Method);
                        END;
                    END;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    RecRef.SETTABLE(ProcurementRequest);
                    ProcurementRequest.TESTFIELD("Requisition No.");
                    ProcurementRequest.TESTFIELD("Vendor No.");
                    ProcurementRequest.TESTFIELD(Description);
                    GenerateLPO(ProcurementRequest);
                END;
        END;
    end;

    local procedure CreateNewProcurementProcess(RequisitionHeader: Record "Requisition Header"; ProcurementOption: Option ,Direct,"Low Value","Open Tender","Restricted Tender","Request For Quotation","Request For Proposal","International Open Tender","National Open Tender");
    var
        ProcurementRequest: Record "Procurement Request";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        ProcurementMethod: Record "Procurement Method";
        NewProcurementProcessMessage: Label 'A new %1 of Code %2 has been created Successfully.';
        NewNo: Code[10];
        ProcessDescription: Text;
        RequisitionLines: Record "Requisition Header Line";
        ProcurementRequest2: Record "Procurement Request";
    begin
        WITH RequisitionHeader DO BEGIN
            ProcurementSetup.GET;
            NewNo := '';
            ProcurementRequest.INIT;
            CASE ProcurementOption OF
                ProcurementOption::Direct:
                    BEGIN
                        ProcurementSetup.TESTFIELD("Direct Procurement No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Direct Procurement No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::Direct;
                    END;
                ProcurementOption::"Low Value":
                    BEGIN
                        ProcurementSetup.TESTFIELD("Low Value No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Low Value No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::"Low Value";
                    END;
                ProcurementOption::"Request For Quotation":
                    BEGIN
                        ProcurementSetup.TESTFIELD("Request For Quotation No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Request For Quotation No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::"Request For Quotation";
                    END;
                ProcurementOption::"Request For Proposal":
                    BEGIN
                        ProcurementSetup.TESTFIELD("Request For Proposal No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Request For Proposal No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::"Request For Proposal";
                    END;
                ProcurementOption::"Open Tender":
                    BEGIN
                        ProcurementSetup.TESTFIELD("Open Tender No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Open Tender No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::"Open Tender";
                    END;
                ProcurementOption::"Restricted Tender":
                    BEGIN
                        ProcurementSetup.TESTFIELD("Restricted Tender No.");
                        NoSeriesManagement.InitSeries(ProcurementSetup."Restricted Tender No.", ProcurementRequest."No. Series", 0D, ProcurementRequest."No.", ProcurementRequest."No. Series");
                        ProcurementRequest."Procurement Option" := ProcurementRequest."Procurement Option"::"Restricted Tender";
                    END;
            END;
            ProcurementRequest."Global Dimension 1 Code" := "Global Dimension 1 Code";
            ProcurementRequest."Global Dimension 2 Code" := "Global Dimension 2 Code";
            ProcurementRequest."Current Budget" := "Procurement Plan";
            ProcurementRequest."Procurement Plan No." := "Procurement Plan";
            ProcurementRequest."Created On" := TODAY;
            ProcurementRequest."Created By" := USERID;
            ProcurementRequest."Requisition No." := "No.";
            ProcurementRequest."Assigned User" := "Assigned User ID";
            IF ProcurementRequest."Requisition No." <> '' THEN
                ProcurementRequest."Auto Generated" := TRUE;
            //ProcurementRequest.VALIDATE("Requisition No.");
            ProcurementMethod.RESET;
            ProcurementMethod.SETRANGE(Method, ProcurementOption);
            IF ProcurementMethod.FINDFIRST THEN BEGIN
                ProcurementRequest."Procurement Method" := ProcurementMethod.Code;
                ProcessDescription := ProcurementMethod.Description;
            END;
            NewNo := ProcurementRequest."No.";
            ProcurementRequest.INSERT;

            RequisitionLines.RESET;
            IF NewNo <> '' THEN
                IF ProcurementRequest2.GET(NewNo) THEN BEGIN
                    PopulateProcurementRequestLine(ProcurementRequest2);
                    MESSAGE(NewProcurementProcessMessage, ProcessDescription, ProcurementRequest."No.");
                END;
            "Procurement Process Initiated" := TRUE;
            "Procurement Process No." := NewNo;
            MODIFY(TRUE);
        END;
    end;

    //[Scope('Personalization')]
    procedure PopulateProcurementRequestLine(ProcurementRequest: Record "Procurement Request");
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionHeaderLine: Record "Requisition Header Line";
        ProcurementRequestLine: Record "Procurement Request Line";
    begin
        WITH ProcurementRequest DO BEGIN
            IF RequisitionHeader.GET("Requisition No.") THEN BEGIN
                RequisitionHeaderLine.RESET;
                RequisitionHeaderLine.SETRANGE("Requisition No.", "Requisition No.");
                IF RequisitionHeaderLine.FINDSET THEN BEGIN
                    REPEAT
                        ProcurementRequestLine.INIT;
                        ProcurementRequestLine.TRANSFERFIELDS(RequisitionHeaderLine);
                        ProcurementRequestLine."Request No." := "No.";
                        ProcurementRequestLine.INSERT;
                    UNTIL RequisitionHeaderLine.NEXT = 0;
                END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure GenerateLPO(Variant: Variant);
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionHeaderLine: Record "Requisition Header Line";
        ProcurementRequestLine: Record "Procurement Request Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LPO_No: Code[20];
        PurchaseHeader2: Record "Purchase Header";
        LPOSuccessTxt: Label '%1 has been generated Successfully.';
        GenerateTxt: Label 'Do you want To generate a Purchase Order for this Request?';
        ProcurementRequest: Record "Procurement Request";
        RecRef: RecordRef;
        ContractHeader: Record "Contract Header";
        ProcurementPaymentTerms: Record "Procurement Payment Terms";
        GenerateTxt2: Label 'Do you want To generate a Purchase Order for this Request?\Kindly note that the Purchase Order will be on the full Amount on this Contract.';
        GenerateTxt3: Label 'Do you want To generate a Purchase Order for this Payment Term?';
    begin
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    WITH ProcurementRequest DO BEGIN
                        IF "LPO Generated" THEN
                            ERROR(LPOGeneratedErr, "LPO No.");
                        ProcurementSetup.GET;
                        ProcurementSetup.TESTFIELD("Purchase Order No.");
                        LPO_No := '';
                        PurchaseHeader.INIT;
                        PurchaseHeader."Buy-from Vendor No." := "Vendor No.";
                        PurchaseHeader."Pay-to Vendor No." := "Vendor No.";
                        PurchaseHeader.VALIDATE("Buy-from Vendor No.");
                        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
                        NoSeriesManagement.InitSeries(ProcurementSetup."Purchase Order No.", PurchaseHeader."No. Series", 0D, PurchaseHeader."No.", PurchaseHeader."No. Series");
                        PurchaseHeader."Requisition No." := "Requisition No.";
                        PurchaseHeader.VALIDATE("Pay-to Vendor No.", "Vendor No.");
                        PurchaseHeader."Assigned User ID" := "Assigned User";
                        PurchaseHeader."Process No." := "No.";
                        PurchaseHeader."Document Date" := TODAY;
                        PurchaseHeader."Posting Date" := TODAY;
                        PurchaseHeader."Shortcut Dimension 1 Code" := ProcurementRequest."Global Dimension 1 Code";
                        PurchaseHeader."Shortcut Dimension 2 Code" := ProcurementRequest."Global Dimension 2 Code";
                        DocumentType := PurchaseHeader."Document Type";
                        LPO_No := PurchaseHeader."No.";
                        PurchaseHeader.INSERT;

                        IF PurchaseHeader2.GET(DocumentType, LPO_No) THEN BEGIN
                            PopulatePurchaseLine(PurchaseHeader2);
                        END;
                        IF LPO_No <> '' THEN BEGIN
                            "LPO No." := LPO_No;
                            "LPO Generated" := TRUE;
                            Status := Status::Released;
                            MODIFY(TRUE);
                            MESSAGE(LPOSuccessTxt, LPO_No);
                        END;
                    END;
                END;
            DATABASE::"Contract Header":
                BEGIN
                    ContractHeader := Variant;
                    WITH ContractHeader DO BEGIN
                        TESTFIELD(Amount);
                        IF CONFIRM(GenerateTxt2) THEN BEGIN
                            IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                GenerateLPO(ProcurementRequest);
                            END;
                        END;
                    END;
                END;
            DATABASE::"Procurement Payment Terms":
                BEGIN
                    ProcurementPaymentTerms := Variant;
                    WITH ProcurementPaymentTerms DO BEGIN
                        IF "Payment Option" = "Payment Option"::"Fixed Amount" THEN
                            TESTFIELD("Fixed Amount")
                        ELSE
                            TESTFIELD("Percentage Amount");
                        IF "Payment Type" = "Payment Type"::"One Off" THEN BEGIN
                            IF CONFIRM(GenerateTxt3) THEN BEGIN
                                IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                    GenerateLPO(ProcurementRequest);
                                    OnAfterPostLPO(ProcurementPaymentTerms, 1);
                                END;
                            END;
                        END ELSE BEGIN
                            IF CONFIRM(GenerateTxt3) THEN BEGIN
                                IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                    GenerateLPO(ProcurementRequest);
                                    OnAfterPostLPO(ProcurementPaymentTerms, 2);
                                END;
                            END;
                        END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure GenerateContract(ProcurementRequest: Record "Procurement Request");
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionHeaderLine: Record "Requisition Header Line";
        ProcurementRequestLine: Record "Procurement Request Line";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        LPOSuccessTxt: Label '%1 has been generated Successfully.';
        ContractHeader: Record "Contract Header";
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        DescriptionInst: InStream;
        DescriptionTxt: Text;
        Contract_No: Code[20];
    begin
        WITH ProcurementRequest DO BEGIN
            IF "Contract Generated" THEN
                ERROR(ContractGeneratedErr, "Contract No.");
            Contract_No := '';
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Contract No.");
            ProcurementProcessEvaluation.RESET;
            ProcurementProcessEvaluation.SETRANGE("Process No.", "No.");
            ProcurementProcessEvaluation.SETRANGE(Awarded, TRUE);
            IF ProcurementProcessEvaluation.FINDFIRST THEN BEGIN
                ContractHeader.INIT;
                NoSeriesManagement.InitSeries(ProcurementSetup."Contract No.", ContractHeader."No. Series", 0D, ContractHeader."No.", ContractHeader."No. Series");
                Contract_No := ContractHeader."No.";
                ContractHeader."Vendor No." := ProcurementProcessEvaluation."Vendor No.";
                ContractHeader."Vendor Name" := ProcurementProcessEvaluation."Vendor Name";
                ContractHeader."Process No." := "No.";
                CALCFIELDS("Process Summary");
                "Process Summary".CREATEINSTREAM(DescriptionInst);
                DescriptionInst.READ(DescriptionTxt);
                ContractHeader.Description := DescriptionTxt;
                ContractHeader.Amount := ProcurementProcessEvaluation.Amount;
                ContractHeader."Award Date" := "Award Approval Date";
                ProcurementRequestLine.RESET;
                ProcurementRequestLine.SETRANGE("Request No.", "No.");
                IF ProcurementRequestLine.FINDFIRST THEN BEGIN
                    ContractHeader."Procurement Plan" := ProcurementRequestLine."Procurement Plan";
                    ContractHeader."Procurement Plan Item No." := ProcurementRequestLine."Procurement Plan Item";
                END;

                ContractHeader.INSERT;
            END;

            IF Contract_No <> '' THEN BEGIN
                "Contract No." := Contract_No;
                "Contract Generated" := TRUE;
                Status := Status::Released;
                MODIFY(TRUE);
                MESSAGE(LPOSuccessTxt, Contract_No);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewContractDocument(ProcurementRequest: Record "Procurement Request");
    var
        ContractHeader: Record "Contract Header";
        ProcurementContractListpg: Page "Procurement Contract List";
    begin
        WITH ProcurementRequest DO BEGIN
            ContractHeader.RESET;
            ContractHeader.SETRANGE("Process No.", "No.");
            IF ContractHeader.FINDFIRST THEN BEGIN
                CLEAR(ProcurementContractListpg);
                ProcurementContractListpg.SETTABLEVIEW(ContractHeader);
                ProcurementContractListpg.SETRECORD(ContractHeader);
                ProcurementContractListpg.LOOKUPMODE(TRUE);
                ProcurementContractListpg.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure OnAfterPostLPO(Variant: Variant; StageNo: Integer);
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionHeaderLine: Record "Requisition Header Line";
        ProcurementRequestLine: Record "Procurement Request Line";
        ProcurementRequest: Record "Procurement Request";
        ContractHeader: Record "Contract Header";
        ProcurementPaymentTerms: Record "Procurement Payment Terms";
        RecRef: RecordRef;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Request":
                BEGIN
                END;
            DATABASE::"Contract Header":
                BEGIN
                    ContractHeader := Variant;
                    WITH ContractHeader DO BEGIN

                    END;
                END;
            DATABASE::"Procurement Payment Terms":
                BEGIN
                    ProcurementPaymentTerms := Variant;
                    WITH ProcurementPaymentTerms DO BEGIN
                        BEGIN
                            PurchaseHeader.RESET;
                            PurchaseHeader.SETRANGE("Process No.", "Process No.");
                            PurchaseHeader.SETCURRENTKEY("No.");
                            PurchaseHeader.SETASCENDING("No.", FALSE);
                            IF PurchaseHeader.FINDFIRST THEN BEGIN
                                PurchaseLine.RESET;
                                PurchaseLine.SETRANGE("Document No.", PurchaseHeader."No.");
                                IF PurchaseLine.FINDFIRST THEN BEGIN
                                    IF "Payment Option" = "Payment Option"::"Fixed Amount" THEN BEGIN
                                        PurchaseLine.VALIDATE(Amount, "Fixed Amount")
                                    END ELSE BEGIN
                                        PurchaseLine.VALIDATE(Amount, "Percentage Amount");
                                    END;
                                    PurchaseLine."Description 2" := Description;
                                    PurchaseLine.MODIFY;
                                    IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                        ProcurementRequest."LPO Generated" := FALSE;
                                        ProcurementRequest.MODIFY(TRUE);
                                    END;
                                    "LPO Generated" := TRUE;
                                    IF StageNo = 1 THEN
                                        "LPO No." := PurchaseHeader."No.";
                                    MODIFY(TRUE);
                                END;
                            END;
                        END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewLPOGenerated(Variant: Variant);
    var
        RequisitionHeader: Record "Requisition Header";
        RequisitionHeaderLine: Record "Requisition Header Line";
        ProcurementRequestLine: Record "Procurement Request Line";
        ProcurementRequest: Record "Procurement Request";
        ContractHeader: Record "Contract Header";
        ProcurementPaymentTerms: Record "Procurement Payment Terms";
        RecRef: RecordRef;
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseOrderListPg: Page "Purchase Order List";
    begin
        RecRef.GETTABLE(Variant);

        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    WITH ProcurementRequest DO BEGIN
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("Process No.", "No.");
                        IF PurchaseHeader.FINDSET THEN BEGIN
                            CLEAR(PurchaseOrderListPg);
                            PurchaseOrderListPg.SETTABLEVIEW(PurchaseHeader);
                            PurchaseOrderListPg.SETRECORD(PurchaseHeader);
                            PurchaseOrderListPg.LOOKUPMODE(TRUE);
                            PurchaseOrderListPg.RUN;
                        END;
                    END;
                END;
            DATABASE::"Contract Header":
                BEGIN
                    ContractHeader := Variant;
                    WITH ContractHeader DO BEGIN
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("Process No.", "Process No.");
                        IF PurchaseHeader.FINDSET THEN BEGIN
                            CLEAR(PurchaseOrderListPg);
                            PurchaseOrderListPg.SETTABLEVIEW(PurchaseHeader);
                            PurchaseOrderListPg.SETRECORD(PurchaseHeader);
                            PurchaseOrderListPg.LOOKUPMODE(TRUE);
                            PurchaseOrderListPg.RUN;
                        END;
                    END;
                END;
            DATABASE::"Procurement Payment Terms":
                BEGIN
                    ProcurementPaymentTerms := Variant;
                    WITH ProcurementPaymentTerms DO BEGIN
                        PurchaseHeader.RESET;
                        PurchaseHeader.SETRANGE("Process No.", "Process No.");
                        IF PurchaseHeader.FINDFIRST THEN BEGIN
                            CLEAR(PurchaseOrderListPg);
                            PurchaseOrderListPg.SETTABLEVIEW(PurchaseHeader);
                            PurchaseOrderListPg.SETRECORD(PurchaseHeader);
                            PurchaseOrderListPg.LOOKUPMODE(TRUE);
                            PurchaseOrderListPg.RUN;
                        END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure SelectProcurementMethod(RequisitionHeader: Record "Requisition Header");
    var
        ProcurementMethod: Record "Procurement Method";
        ProcurementMethodSelected: Code[30];
        ProcurementMethodsPage: Page "Procurement Methods";
        RequisitionHeaderLine: Record "Requisition Header Line";
        MethodApplyOnLinesConf: Label 'Please note that the procurement process Selected will apply to the requisition lines. Proceed?';
        MethodSelectTxt: Label 'Procurement Method updated successfully.';
        AmountOnHeader: Decimal;
    begin
        WITH RequisitionHeader DO BEGIN
            ProcurementMethod.RESET;
            IF ProcurementMethod.FINDSET THEN BEGIN
                IF PAGE.RUNMODAL(50805, ProcurementMethod) = ACTION::LookupOK THEN BEGIN
                    ProcurementMethodSelected := ProcurementMethod.Code;
                    ValidateSelectedProcurementMethod(RequisitionHeader, ProcurementMethodSelected);

                    IF CONFIRM(MethodApplyOnLinesConf) THEN BEGIN
                        "Procurement Method" := ProcurementMethod.Code;
                        MODIFY(TRUE);

                        RequisitionHeaderLine.RESET;
                        RequisitionHeaderLine.SETRANGE("Requisition No.", "No.");
                        IF RequisitionHeaderLine.FINDSET THEN BEGIN
                            REPEAT
                                RequisitionHeaderLine."Procurement Method" := ProcurementMethodSelected;
                                RequisitionHeaderLine.MODIFY;
                            UNTIL RequisitionHeaderLine.NEXT = 0;
                        END;
                        MESSAGE(MethodSelectTxt);
                    END;
                END
            END;
        END;
    end;

    local procedure PopulatePurchaseLine(PurchaseHeader: Record "Purchase Header");
    var
        ProcurementRequest: Record "Procurement Request";
        ProcurementRequestLine: Record "Procurement Request Line";
        PurchaseLine: Record "Purchase Line";
    begin
        WITH PurchaseHeader DO BEGIN
            ProcurementRequestLine.RESET;
            ProcurementRequestLine.SETRANGE("Request No.", "Process No.");
            IF ProcurementRequestLine.FINDSET THEN BEGIN
                REPEAT
                    PurchaseLine.INIT;
                    PurchaseLine."Document Type" := "Document Type";
                    PurchaseLine."Document No." := "No.";
                    PurchaseLine."Shortcut Dimension 1 Code" := ProcurementRequestLine."Global Dimension 1 Code";
                    PurchaseLine."Shortcut Dimension 2 Code" := ProcurementRequestLine."Global Dimension 2 Code";
                    PurchaseLine."Line No." := ProcurementRequestLine."Line No.";
                    IF ProcurementRequestLine.Type = ProcurementRequestLine.Type::Item THEN BEGIN
                        PurchaseLine.Type := PurchaseLine.Type::Item;
                    END ELSE
                        IF ProcurementRequestLine.Type = ProcurementRequestLine.Type::"Fixed Asset" THEN BEGIN
                            PurchaseLine.Type := PurchaseLine.Type::"Fixed Asset";
                        END ELSE
                            IF ProcurementRequestLine.Type = ProcurementRequestLine.Type::"G/L Account" THEN BEGIN
                                PurchaseLine.Type := PurchaseLine.Type::"G/L Account";
                            END;
                    PurchaseLine."No." := ProcurementRequestLine."No.";
                    PurchaseLine.VALIDATE("No.");
                    PurchaseLine.Description := ProcurementRequestLine.Description;
                    PurchaseLine.Quantity := ProcurementRequestLine.Quantity;
                    PurchaseLine.VALIDATE(Quantity);
                    PurchaseLine."Unit of Measure" := ProcurementRequestLine."Unit of Measure";
                    PurchaseLine.Amount := ProcurementRequestLine.Amount;
                    PurchaseLine."Direct Unit Cost" := ProcurementRequestLine."Unit Price";
                    //PurchaseLine."Location Code" := ProcurementRequestLine.
                    PurchaseLine.INSERT;
                UNTIL ProcurementRequestLine.NEXT = 0;
            END;
        END;
    end;

    local procedure RequestHeaderTotalAmount(RequisitionHeader: Record "Requisition Header"): Decimal;
    begin
        WITH RequisitionHeader DO BEGIN
            RequisitionHeader.CALCFIELDS(Amount);
            EXIT(RequisitionHeader.Amount);
        END;
    end;

    local procedure ValidateSelectedProcurementMethod(RequisitionHeader: Record "Requisition Header"; SelectedMethod: Code[30]);
    var
        ProcurementMethod: Record "Procurement Method";
        RequisitionHeaderLine: Record "Requisition Header Line";
        AmountOnHeader: Decimal;
    begin
        WITH RequisitionHeader DO BEGIN
            AmountOnHeader := RequestHeaderTotalAmount(RequisitionHeader);
            ProcurementSetup.GET;
            IF ProcurementMethod.GET(SelectedMethod) THEN BEGIN
                CASE ProcurementMethod.Method OF
                    ProcurementMethod.Method::"Low Value":
                        BEGIN
                            ProcurementSetup.TESTFIELD("Max. Low Value Limit");
                            IF AmountOnHeader > ProcurementSetup."Max. Low Value Limit" THEN
                                ERROR(LowValueExcessAmountErr, ProcurementMethod.Code);
                        END;
                    ProcurementMethod.Method::"Request For Quotation":
                        BEGIN
                            IF AmountOnHeader > ProcurementSetup."Max. RFQ Limit" THEN
                                ERROR(LowValueExcessAmountErr, ProcurementMethod.Code);
                        END;
                END;
            END;
        END;
    end;

    local procedure UpdatePostedLPO();
    var
        Handled: Boolean;
        ProcurementRequest: Record "Procurement Request";
        VendLedgEntry: Record "Vendor Ledger Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
    begin
        ProcurementRequest.RESET;
        ProcurementRequest.SETRANGE(Status, ProcurementRequest.Status::Released);
        ProcurementRequest.SETRANGE("LPO Generated", TRUE);
        ProcurementRequest.SETRANGE("LPO Posted", FALSE);
        IF ProcurementRequest.FINDSET THEN BEGIN
            REPEAT
                PurchInvHeader.RESET;
                PurchInvHeader.SETRANGE("Order No.", ProcurementRequest."LPO No.");
                PurchInvHeader.SETRANGE("Pay-to Vendor No.", ProcurementRequest."Vendor No.");
                IF PurchInvHeader.FINDFIRST THEN BEGIN
                    VendLedgEntry.RESET;
                    VendLedgEntry.SETCURRENTKEY("External Document No.");
                    VendLedgEntry.SETRANGE("External Document No.", PurchInvHeader."Vendor Invoice No.");
                    VendLedgEntry.SETRANGE("Vendor No.", ProcurementRequest."Vendor No.");
                    VendLedgEntry.SETRANGE(Reversed, FALSE);
                    IF VendLedgEntry.FINDFIRST THEN BEGIN
                        ProcurementRequest."LPO Posted" := TRUE;
                        ProcurementRequest."LPO Posting Date" := VendLedgEntry."Posting Date";
                        ProcurementRequest.MODIFY;
                    END;
                END;
            UNTIL ProcurementRequest.NEXT = 0;
        END;
    end;

    //[Scope('Personalization')]
    procedure CheckMandatoryFields(ProcurementRequest: Record "Procurement Request");
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MissingEntry: Label 'Receipt %1 does not exist.';
        TenderFeeErr: Label 'Amount on Receipt is not equal to the Tender Fee';
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementVendorListpg: Page "Procurement Vendor List";
        Vendor: Record Vendor;
    begin
        WITH ProcurementRequest DO BEGIN
            TESTFIELD(Description);
            TESTFIELD("Category Code");
            TESTFIELD("Requisition No.");
            IF ("Procurement Option" = "Procurement Option"::"Open Tender") OR ("Procurement Option" = "Procurement Option"::"Restricted Tender") THEN BEGIN
                TESTFIELD("Advertisement Date");
                TESTFIELD("Tender Fee");
                TESTFIELD("Attached Process Details");
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdatePrequalifiedSupplierOnVendor();
    var
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        Vendor: Record Vendor;
    begin
        PrequalifiedSuppliers.RESET;
        IF PrequalifiedSuppliers.FINDSET THEN BEGIN
            REPEAT
                IF Vendor.GET(PrequalifiedSuppliers."Vendor No.") THEN BEGIN
                    Vendor."Pre-Qualified" := TRUE;
                    Vendor."Prequalified Category Code" := PrequalifiedSuppliers."Category Code";
                    Vendor."Prequalified Category Desc" := PrequalifiedSuppliers."Category Description";
                    Vendor.MODIFY;
                END;
            UNTIL PrequalifiedSuppliers.NEXT = 0;
        END;
        MESSAGE(PrequalifiedUpdateSuccessMsg);
    end;

    //[Scope('Personalization')]
    procedure SelectSuppliers(ProcurementRequest: Record "Procurement Request");
    var
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        Vendor: Record Vendor;
        SupplierSelectionMsg: Label 'Select the option to get the supplier list from.';
        SupplierSelectOptionMsg: Label 'Pre-Qualified Supplier List';
        SupplierSelectOption: Integer;
        PreQualifiedSupSelection: Page "Pre-Qualified Sup. Selection";
        PreQualifiedSupplierList: Page "Pre-Qualified Supplier List";
        SelectedPrequalifiedSuppliers: Record "Prequalified Suppliers";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        VendorNo: Code[20];
        AllVendors: Text;
        PrequalifiedSuppliers2: Record "Prequalified Suppliers";
    begin
        WITH ProcurementRequest DO BEGIN
            TESTFIELD("Category Code");
            IF "Process Status" = "Process Status"::"Pending Opening" THEN
                ERROR(PendingOpeningErr);
            PrequalifiedSuppliers.RESET;
            PrequalifiedSuppliers.SETRANGE("Category Code", "Category Code");
            IF PrequalifiedSuppliers.FINDSET THEN BEGIN
                REPEAT
                    PrequalifiedSuppliers.Select := FALSE;
                    PrequalifiedSuppliers.MODIFY(TRUE);
                UNTIL PrequalifiedSuppliers.NEXT = 0;
                COMMIT;
                CLEAR(PreQualifiedSupplierList);
                PreQualifiedSupplierList.SETTABLEVIEW(PrequalifiedSuppliers);
                PreQualifiedSupplierList.SETRECORD(PrequalifiedSuppliers);
                PreQualifiedSupplierList.LOOKUPMODE := TRUE;
                IF PreQualifiedSupplierList.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    SelectedPrequalifiedSuppliers := PrequalifiedSuppliers;
                    ClearSupplierSelection(PrequalifiedSuppliers, "No.");
                    PreQualifiedSupplierList.SetSelection(SelectedPrequalifiedSuppliers, "No.", "Category Code");
                    //SelectedPrequalifiedSuppliers.MARKEDONLY(FALSE);
                    MESSAGE(PrequalifiedUpdateSuccessMsg);
                END;
            END ELSE BEGIN
                ERROR(NoPrequalifiedSupplierErr);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure PopulateSelectedSuppliers(PrequalifiedSuppliers: Record "Prequalified Suppliers"; ProcessNo: Code[20]);
    var
        Vendor: Record Vendor;
        SupplierSelectOption: Integer;
        PreQualifiedSupSelection: Page "Pre-Qualified Sup. Selection";
        PreQualifiedSupplierList: Page "Pre-Qualified Supplier List";
        SelectedPrequalifiedSuppliers: Record "Prequalified Suppliers";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        VendorNo: Code[20];
        AllVendors: Text;
    begin
        WITH PrequalifiedSuppliers DO BEGIN
            IF NOT ProcurementSupplierSelection.GET("Vendor No.", ProcessNo) THEN BEGIN
                ProcurementSupplierSelection.INIT;
                ProcurementSupplierSelection.TRANSFERFIELDS(PrequalifiedSuppliers, TRUE);
                ProcurementSupplierSelection."Process No." := ProcessNo;
                ProcurementSupplierSelection.INSERT;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ClearSupplierSelection(PrequalifiedSuppliers: Record "Prequalified Suppliers"; ProcessNo: Code[20]);
    var
        Vendor: Record Vendor;
        SupplierSelectOption: Integer;
        PreQualifiedSupSelection: Page "Pre-Qualified Sup. Selection";
        PreQualifiedSupplierList: Page "Pre-Qualified Supplier List";
        SelectedPrequalifiedSuppliers: Record "Prequalified Suppliers";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        VendorNo: Code[20];
        AllVendors: Text;
    begin
        ProcurementSupplierSelection.RESET;
        ProcurementSupplierSelection.SETRANGE("Process No.", ProcessNo);
        IF ProcurementSupplierSelection.FINDSET THEN BEGIN
            ProcurementSupplierSelection.DELETEALL;
        END;
    end;

    //[Scope('Personalization')]
    procedure CheckIfSuppliersSelected(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        PreQualifiedSupSelectionPg: Page "Pre-Qualified Sup. Selection";
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE(Select, TRUE);
            IF "Procurement Option" = "Procurement Option"::"Request For Proposal" THEN BEGIN
                IF "Process Status" = "Process Status"::"Pending Opening" THEN BEGIN
                    ProcurementSupplierSelection.SETRANGE("Proceed To Proposal", TRUE);
                END;
            END;
            IF NOT ProcurementSupplierSelection.FINDSET THEN BEGIN
                ERROR(NoPrequalifiedSupplierErr);
            END ELSE BEGIN
                REPEAT
                    ProcurementSupplierSelection.TESTFIELD(Name);
                    ProcurementSupplierSelection.TESTFIELD("E-Mail");
                UNTIL ProcurementSupplierSelection.NEXT = 0;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewSelectedSuppliers(ProcurementRequest: Record "Procurement Request"; ViewType: Integer);
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        PrequalifiedSuppliers: Record "Prequalified Suppliers";
        PreQualifiedSupSelectionPg: Page "Pre-Qualified Sup. Selection";
    begin
        WITH ProcurementRequest DO BEGIN
            IF (ViewType <> 4) AND (ViewType <> 5) THEN
                CheckIfSuppliersSelected(ProcurementRequest);
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            IF ViewType <> 4 THEN
                ProcurementSupplierSelection.SETRANGE(Select, TRUE);
            IF ViewType = 2 THEN
                ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
            IF ViewType = 3 THEN
                ProcurementSupplierSelection.SETRANGE("Proceed To Proposal", TRUE);
            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                CLEAR(PreQualifiedSupSelectionPg);
                PreQualifiedSupSelectionPg.SETTABLEVIEW(ProcurementSupplierSelection);
                PreQualifiedSupSelectionPg.SETRECORD(ProcurementSupplierSelection);
                PreQualifiedSupSelectionPg.LOOKUPMODE := TRUE;
                PreQualifiedSupSelectionPg.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure RequestForQuotations(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
    begin
        WITH ProcurementRequest DO BEGIN
            CheckIfSuppliersSelected(ProcurementRequest);
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                EmailDialog.OPEN(MailOpenDialogTxt);
                REPEAT
                    EmailDialog.UPDATE(1, ProcurementSupplierSelection.Name);
                    ProcurementSupplierSelection.TESTFIELD("E-Mail");
                    ProcurementSetup.GET;
                    MailHeader := '';
                    MailBody := '';
                    MailHeader := STRSUBSTNO(RFQMailHdrTxt, Description, ProcurementSupplierSelection.Name);
                    MailBody := STRSUBSTNO(RFQBodyTxt, ProcurementSupplierSelection.Name);
                    MailBody += STRSUBSTNO(RFQBodyTxt2, ProcurementSetup."Procurement Manager");
                    SendMail(ProcurementSupplierSelection."E-Mail", MailHeader, MailBody);
                UNTIL ProcurementSupplierSelection.NEXT = 0;
            END;
            EmailDialog.CLOSE;
        END;
    end;

    //[Scope('Personalization')]
    procedure PreviewRFQ_Report(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
    begin
        WITH ProcurementRequest DO BEGIN
            CheckIfSuppliersSelected(ProcurementRequest);
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE(Select, TRUE);
            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                RFQ_Report.SETTABLEVIEW(ProcurementSupplierSelection);
                RFQ_Report.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure EmailDocumentRequestReport(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        AllSelected: Integer;
        InvitationInstr: InStream;
        InvitationTitleMsg: Text;
        TermsOfRefTxt: Label 'Terms Of Reference';
        ProposalDocTxt: Label 'Proposal Document';
        InvitationMessage: Text;
    begin
        WITH ProcurementRequest DO BEGIN
            CheckIfSuppliersSelected(ProcurementRequest);
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Procurement Manager");
            ProcurementSetup.TESTFIELD("Procurement Email");
            IF "Procurement Option" = "Procurement Option"::"Request For Quotation" THEN BEGIN
                CASE ProcurementSetup."RFQ Request Option" OF
                    ProcurementSetup."RFQ Request Option"::"All Selected":
                        BEGIN
                            ProcurementSupplierSelection.RESET;
                            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
                            ProcurementSupplierSelection.SETRANGE("Request Email Sent", FALSE);
                            ProcurementSupplierSelection.SETRANGE(Select, TRUE);
                            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                                REPEAT
                                    SendDocumentRequestEmailReport(ProcurementRequest, ProcurementSupplierSelection);
                                UNTIL ProcurementSupplierSelection.NEXT = 0;
                            END;
                        END;
                    ProcurementSetup."RFQ Request Option"::"In Batch":
                        BEGIN
                            ProcurementSetup.TESTFIELD("RFQ Request Batch");
                            ProcurementSupplierSelection.RESET;
                            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
                            ProcurementSupplierSelection.SETRANGE("Request Email Sent", FALSE);
                            ProcurementSupplierSelection.SETRANGE(Select, TRUE);
                            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                                IF ProcurementSupplierSelection.COUNT > ProcurementSetup."RFQ Request Batch" THEN BEGIN
                                    FOR AllSelected := 1 TO ProcurementSetup."RFQ Request Batch" DO BEGIN
                                        SendDocumentRequestEmailReport(ProcurementRequest, ProcurementSupplierSelection);
                                    END;
                                END ELSE BEGIN
                                    REPEAT
                                        SendDocumentRequestEmailReport(ProcurementRequest, ProcurementSupplierSelection);
                                    UNTIL ProcurementSupplierSelection.NEXT = 0;
                                END;
                            END;
                        END;
                END;
            END;
            IF "Procurement Option" = "Procurement Option"::"Request For Proposal" THEN BEGIN
                IF StageNo = 1 THEN BEGIN //Request for EOI
                    CheckIfSuppliersSelected(ProcurementRequest);
                    CALCFIELDS("Process Summary");
                    TESTFIELD("Process Summary");
                    "Process Summary".CREATEINSTREAM(InvitationInstr);
                    InvitationInstr.READ(InvitationMessage);
                    MailBody := '';
                    MailHeader := '';
                    MailHeader := "Invitation Title";
                    ProcurementSupplierSelection.RESET;
                    ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
                    ProcurementSupplierSelection.SETRANGE("Request Email Sent", FALSE);
                    ProcurementSupplierSelection.SETRANGE(Select, TRUE);
                    IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                        REPEAT
                            MailBody := 'Dear ' + ProcurementSupplierSelection.Name + '<br><br>';
                            MailBody += InvitationMessage;
                            SMTPMailSetup.GET;
                            SMTPMail.CreateMessage(ProcurementSetup."Procurement Manager", ProcurementSetup."Procurement Email", ProcurementSupplierSelection."E-Mail", MailHeader, MailBody, TRUE);
                            //SMTPMail.AddAttachment("Terms Of Reference Path", TermsOfRefTxt);
                            EmailMembers.Add(ProcurementSetup."Procurement Email");
                            SMTPMail.AddCC(EmailMembers);
                            SMTPMail.Send;
                            ProcurementSupplierSelection."Request Email Sent" := TRUE;
                            ProcurementSupplierSelection.MODIFY(TRUE);
                            MESSAGE(EmailSuccessTxt, ProcurementSupplierSelection.Name);
                        UNTIL ProcurementSupplierSelection.NEXT = 0;
                        UpdateOnSendDocumentRequest(ProcurementRequest, ProcurementSupplierSelection, 2);
                    END ELSE
                        UpdateOnSendDocumentRequest(ProcurementRequest, ProcurementSupplierSelection, 2);
                END;
                IF StageNo = 2 THEN BEGIN //Request For Proposal
                    CheckIfSuppliersSelected(ProcurementRequest);
                    CALCFIELDS("Process Summary");
                    TESTFIELD("Process Summary");
                    TESTFIELD("Attached Process Details");
                    "Process Summary".CREATEINSTREAM(InvitationInstr);
                    InvitationInstr.READ(InvitationMessage);
                    MailBody := '';
                    MailHeader := '';
                    MailHeader := "Invitation Title";
                    ProcurementSupplierSelection.RESET;
                    ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
                    ProcurementSupplierSelection.SETRANGE("Proceed To Proposal", TRUE);
                    ProcurementSupplierSelection.SETRANGE(Select, TRUE);
                    IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                        REPEAT
                            MailBody := 'Dear ' + ProcurementSupplierSelection.Name + '<br><br>';
                            MailBody += InvitationMessage;
                            SMTPMailSetup.GET;
                            SMTPMail.CreateMessage(ProcurementSetup."Procurement Manager", ProcurementSetup."Procurement Email", ProcurementSupplierSelection."E-Mail", MailHeader, MailBody, TRUE);
                            //SMTPMail.AddAttachment("Terms Of Reference Path", TermsOfRefTxt);
                            //SMTPMail.AddAttachment("Process Detail path", ProposalDocTxt);
                            //SMTPMail.AddCC(Add(ProcurementSetup."Procurement Email"));
                            EmailMembers.Add(ProcurementSetup."Procurement Email");
                            SMTPMail.AddCC(EmailMembers);
                            SMTPMail.Send;
                            ProcurementSupplierSelection."Request Email Sent" := TRUE;
                            ProcurementSupplierSelection.MODIFY(TRUE);
                            MESSAGE(EmailSuccessTxt, ProcurementSupplierSelection.Name);
                        UNTIL ProcurementSupplierSelection.NEXT = 0;
                        UpdateOnSendDocumentRequest(ProcurementRequest, ProcurementSupplierSelection, 1);
                    END ELSE
                        UpdateOnSendDocumentRequest(ProcurementRequest, ProcurementSupplierSelection, 1);
                END;
            END;
        END;
    end;

    local procedure SendDocumentRequestEmailReport(ProcurementRequest: Record "Procurement Request"; ProcurementSupplierSelection: Record "Procurement Supplier Selection");
    var
        RFQ_Report: Report "Request for Quotation";
        MailBodyEmailRFQ1: Label 'Please Find Attached Request for Quotation.<br><br>';
        MailBodyEmailRFQ2: Label 'Fill it up and drop it at our institutioni as Indicated<br><br>';
        MailBodyEmailRFQ3: Label 'Kind Regards <br><br>';
    begin
        ProcurementSetup.GET;
        ProcurementSetup.GET;
        ProcurementSetup.TESTFIELD("Procurement Documents Path");
        WITH ProcurementRequest DO BEGIN
            FileName := FormatFileName("No.");
            CLEAR(RFQ_Report);
            RFQ_Report.SETTABLEVIEW(ProcurementSupplierSelection);
            FileName2 := (FORMAT(FileName) + '_' + ProcurementSupplierSelection.Name) + '.pdf';
            RFQ_Report.SAVEASPDF(ProcurementSetup."Procurement Documents Path" + (FORMAT(FileName) + '_' + 'RFQ DOC_' + ProcurementSupplierSelection.Name) + '.pdf');
            MailHeader := '';
            MailBody := '';
            MailHeader := STRSUBSTNO(RFQMailHdrTxt, Description, ProcurementSupplierSelection.Name);
            MailBody := MailBodyEmailRFQ1 + MailBodyEmailRFQ2;
            MailBody += STRSUBSTNO(RFQBodyTxt2, ProcurementSetup."Procurement Manager");
            SMTPMailSetup.GET;
            SMTPMail.CreateMessage(ProcurementSetup."Procurement Manager", ProcurementSetup."Procurement Email", ProcurementSupplierSelection."E-Mail", MailHeader, MailBody, TRUE);
            //SMTPMail.AddAttachment(ProcurementSetup."Procurement Documents Path" + FORMAT(FileName) + '_' + 'RFQ DOC_' + ProcurementSupplierSelection.Name + '.pdf', FileName2);
            SMTPMail.Send; //mail not woring
            ProcurementSupplierSelection."Request Email Sent" := TRUE;
            ProcurementSupplierSelection.MODIFY;
            MESSAGE(EmailSuccessTxt, ProcurementSupplierSelection.Name);
            UpdateOnSendDocumentRequest(ProcurementRequest, ProcurementSupplierSelection, 1);
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdateOnSendDocumentRequest(ProcurementRequest: Record "Procurement Request"; ProcurementSupplierSelection: Record "Procurement Supplier Selection"; StageNo: Integer);
    var
        RFQ_Report: Report "Request for Quotation";
        MailBodyEmailRFQ1: Label 'Please Find Attached Request for Quotation.<br><br>';
        MailBodyEmailRFQ2: Label 'Fill it up and drop it at our institutioni as Indicated<br><br>';
        MailBodyEmailRFQ3: Label 'Kind Regards <br><br>';
    begin
        ProcurementSetup.GET;
        WITH ProcurementRequest DO BEGIN
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE(Select, TRUE);
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE("Request Email Sent", FALSE);
            IF NOT ProcurementSupplierSelection.FINDFIRST THEN BEGIN
                CASE StageNo OF
                    1:
                        BEGIN
                            "Process Status" := "Process Status"::"Pending Opening";
                            //"Forwarded to Opening" := TRUE;
                            "Issued Date" := TODAY;
                            "Request Email Sent" := TRUE;
                            "Issued Time" := TIME;
                            MODIFY;
                        END;
                    2:
                        BEGIN
                            "Process Status" := "Process Status"::"EOI Invitation";
                            MODIFY;
                        END;
                END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure AttachSubmittedDocument(Variant: Variant; DocType: Integer);
    var
        AttachQuotationMsg: Label 'Attach the submitted Quotation';
        QuotationDocMsg: Label 'Quotation Document';
        RecRef: RecordRef;
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementRequest: Record "Procurement Request";
        DocumentText: Text;
        DocumentTitle: Text;
        AttachOpenMinutesMsg: Label 'Attach the Opening Minutes';
        OpeningMinutesMsg: Label 'Opening Minutes';
        AttachEvaluationMinutesMsg: Label 'Attach the Evaluation Minutes';
        EvaluationMinutesMsg: Label 'Evaluation Minutes';
        AttachProffesionalOpinionMsg: Label 'Attach the Proffessional Opinion';
        ProfessionalOpinionMsg: Label 'Proffessional Opinion';
        AttachTORMsg: Label 'Attach the Terms Of Reference';
        TermsOfReferenceMsg: Label 'Terms Of Reference';
        AttachEOIMsg: Label 'Attach the Expression Of Interest';
        ExpressionOfInterestMsg: Label 'Expression Of Interest';
        AttachProcessRequirementsMsg: Label 'Attach the Process Requirements';
        ProcessRequirementsMsg: Label 'Process Requirements';
        AttachContractMsg: Label 'Attach Signed Contract';
        ContractMsg: Label 'Signed Contract';
        SelectedCommitteeMember: Record "Selected Committee Member";
        NotCommitteeMemberErr: Label 'You are not a member of the Opening Committee for this Process';
        NotChairErr: Label 'Only the commitee chair is allowed to attach the Opening Minutes';
        FileManagement: Codeunit "File Management";
        AttachDocTxt: Label 'Select the file to attach.';
        AttachFormatTxt: Label 'PDF Files (*.PDF)|*.PDF|All Files (*.*)|*.*';
        FileNameTxt01: Text[250];
        FileNameTxt02: Text[250];
        TempFile: File;
        NewStream: InsTream;
        Outstr: OutStream;
        ToFileName: Variant;
    begin
        ProcurementSetup.GET;
        ProcurementSetup.TESTFIELD("Procurement Documents Path");
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Supplier Selection":
                BEGIN
                    ProcurementSupplierSelection := Variant;
                    IF DocType = 1 THEN BEGIN //Submitted Documents
                        IF ProcurementRequest.GET(ProcurementSupplierSelection."Process No.") THEN
                            IF (ProcurementRequest."Procurement Option" <> ProcurementRequest."Procurement Option"::"Open Tender") AND (ProcurementRequest."Procurement Option" <> ProcurementRequest."Procurement Option"::"Restricted Tender") THEN
                                ProcurementRequest.TESTFIELD("Request Email Sent", TRUE);
                        FileName := '';
                        FileName2 := '';
                        FileName := FormatFileName(FORMAT(ProcurementSupplierSelection."Vendor No.") + '_' + FORMAT(ProcurementSupplierSelection."Process No."));
                        /* FileName2 := AttachProcurementDocument(FileName, AttachQuotationMsg, QuotationDocMsg, ProcurementSetup."Procurement Documents Path");
                        IF FileName2 <> '' THEN BEGIN
                            ProcurementSupplierSelection."Attach Procurement Document" := TRUE;
                            ProcurementSupplierSelection."Procurement Document File" := FileName2;
                            ProcurementSupplierSelection.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        END; */
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementSupplierSelection."Attached Procurement Document".CreateOutStream(Outstr);
                            ProcurementSupplierSelection."Attach Procurement Document" := TRUE;
                            ProcurementSupplierSelection."Procurement Document File" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementSupplierSelection.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 2 THEN BEGIN //EOI
                        FileName := '';
                        FileName2 := '';
                        FileName := FormatFileName(FORMAT(ProcurementSupplierSelection."Vendor No.") + '_' + FORMAT(ProcurementSupplierSelection."Process No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachEOIMsg, ExpressionOfInterestMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementSupplierSelection."Attached EOI".CreateOutStream(Outstr);
                            ProcurementSupplierSelection."Attach Expression Of Interest" := TRUE;
                            ProcurementSupplierSelection."Expression On Interest File" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementSupplierSelection.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    FileName := '';
                    FileName2 := '';
                    IF DocType = 1 THEN BEGIN //Opening Minutes
                        SelectedCommitteeMember.RESET;
                        SelectedCommitteeMember.SETRANGE("Process No.", ProcurementRequest."No.");
                        SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Opening);
                        SelectedCommitteeMember.SETRANGE("User ID", USERID);
                        IF SelectedCommitteeMember.FINDFIRST THEN BEGIN
                            IF SelectedCommitteeMember.Position <> SelectedCommitteeMember.Position::"Chair Person" THEN
                                ERROR(NotChairErr);
                        END ELSE BEGIN
                            ERROR(NotCommitteeMemberErr);
                        END;

                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachOpenMinutesMsg, OpeningMinutesMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached Opening Minutes Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Opening Minutes" := TRUE;
                            ProcurementRequest."Opening Minutes Path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 2 THEN BEGIN //Evaluation Minutes
                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachEvaluationMinutesMsg, EvaluationMinutesMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached Eval Minutes Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Evaluation Minutes" := TRUE;
                            ProcurementRequest."Evaluation Minutes Path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 3 THEN BEGIN //Profesional Opinion
                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachProffesionalOpinionMsg, ProfessionalOpinionMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached Professional Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Professional Opinion" := TRUE;
                            ProcurementRequest."Professional Opinion Path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 4 THEN BEGIN //Terms Of Reference
                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachTORMsg, TermsOfReferenceMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached TOR Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Terms Of Reference" := TRUE;
                            ProcurementRequest."Terms Of Reference Path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 5 THEN BEGIN //Proposal File
                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachProcessRequirementsMsg, ProcessRequirementsMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached Proposal Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Process Details" := TRUE;
                            ProcurementRequest."Process Detail path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                    IF DocType = 6 THEN BEGIN //Contract
                        FileName := FormatFileName(FORMAT(ProcurementRequest."No."));
                        //FileName2 := AttachProcurementDocument(FileName, AttachContractMsg, ContractMsg, ProcurementSetup."Procurement Documents Path");
                        if UploadIntoStream(AttachDocTxt, Format(ProcurementSetup."Procurement Documents Path"), 'All Files (*.*)|*.*', FileNameTxt01, NewStream) then begin
                            ProcurementRequest."Attached Contract Doc.".CreateOutStream(Outstr);
                            ProcurementRequest."Attached Contract" := TRUE;
                            ProcurementRequest."Contract Path" := FileNameTxt01;
                            CopyStream(Outstr, NewStream);
                            ProcurementRequest.MODIFY(TRUE);
                            MESSAGE(AttachmentSuccessMsg);
                        end;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure AttachProcurementDocument(DocName: Text; DocTitleTxt: Text; DocTitleTxt1: Text; FilePathTxt: Text): Text;
    var
        FileManagement: Codeunit "File Management";
        AttachDocTxt: Label 'Select the file to attach.';
        AttachFormatTxt: Label 'PDF Files (*.PDF)|*.PDF|All Files (*.*)|*.*';
        FileNameTxt01: Text[250];
        FileNameTxt02: Text[250];
        TempFile: File;
        NewStream: InsTream;
        ToFileName: Variant;
    begin
        FileNameTxt02 := '';
        IF (DocName <> '') AND (DocTitleTxt <> '') AND (DocTitleTxt1 <> '') AND (FilePathTxt <> '') THEN BEGIN
            FileNameTxt01 := FileManagement.OpenFileDialog(DocTitleTxt, DocTitleTxt1, AttachFormatTxt);
            FileNameTxt02 := FilePathTxt + DocName + '_' + DocTitleTxt1 + '_' + FileManagement.GetFileName(FileNameTxt01);
            //FileManagement.CopyClientFile(FileNameTxt01, FileNameTxt02, TRUE);
            TempFile.CREATETEMPFILE();
            TempFile.WRITE(FileNameTxt01);
            TempFile.CREATEINSTREAM(NewStream);
            ToFileName := DocName + '_' + DocTitleTxt1 + '_' + FileManagement.GetFileName(FileNameTxt01);
            //DOWNLOADFROMSTREAM(NewStream, 'Export', FilePathTxt, 'All Files (*.*)|*.*', ToFileName);
            UPLOADINTOSTREAM('Import', FilePathTxt, ' All Files (*.*)|*.*', ToFileName, NewStream);
        END;
        EXIT(FileNameTxt02);
    end;

    local procedure FormatFileName(FileNameTxt: Text) FileNameTxtFormatted: Text;
    begin
        FileNameTxtFormatted := '';
        FileNameTxtFormatted := FileNameTxt;
        FileNameTxtFormatted := CONVERTSTR(FileNameTxtFormatted, '/', '_');
        FileNameTxtFormatted := CONVERTSTR(FileNameTxtFormatted, '\', '_');
        EXIT(FileNameTxtFormatted);
    end;

    //[Scope('Personalization')]
    procedure ViewAttachmentDocument(Variant: Variant; DocType: Integer);
    var
        DocText: Label 'Attach the submitted Quotation';
        DocTitle: Label 'Quotation Document';
        RecRef: RecordRef;
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementRequest: Record "Procurement Request";
        FileNameTxt01: Text[250];
        FileNameTxt02: Text[250];
        TempFile: File;
        NewStream: InsTream;
        Outstr: OutStream;
        ToFileName: Variant;
        ErrorAttachment: Label 'No Attachment Found';
    begin
        ProcurementSetup.GET;
        ProcurementSetup.TESTFIELD("Procurement Documents Path");
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Supplier Selection":
                BEGIN
                    ProcurementSupplierSelection := Variant;
                    IF DocType = 1 THEN BEGIN
                        IF ProcurementSupplierSelection."Procurement Document File" <> '' THEN BEGIN
                            if ProcurementSupplierSelection."Attached Procurement Document".HasValue then begin
                                ProcurementSupplierSelection.CalcFields("Attached Procurement Document");
                                ProcurementSupplierSelection."Attached Procurement Document".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementSupplierSelection."Procurement Document File");
                            end
                            else
                                Error(ErrorAttachment);
                            //ViewAttachedDocument(ProcurementSupplierSelection."Procurement Document File");
                        END ELSE
                            ERROR(NoAttachmentErr, ProcurementSupplierSelection.Name);
                    END;
                    IF DocType = 2 THEN BEGIN
                        IF ProcurementSupplierSelection."Expression On Interest File" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementSupplierSelection."Expression On Interest File");
                            if ProcurementSupplierSelection."Attached EOI".HasValue then begin
                                ProcurementSupplierSelection.CalcFields("Attached EOI");
                                ProcurementSupplierSelection."Attached EOI".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementSupplierSelection."Expression On Interest File");
                            end
                            else
                                Error(ErrorAttachment);
                        END ELSE
                            ERROR(NoAttachmentErr, ProcurementSupplierSelection.Name);
                    END;
                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    IF DocType = 1 THEN BEGIN
                        IF ProcurementRequest."Opening Minutes Path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Opening Minutes Path");
                            if ProcurementRequest."Attached Opening Minutes Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached Opening Minutes Doc.");
                                ProcurementRequest."Attached Opening Minutes Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Opening Minutes Path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                    IF DocType = 2 THEN BEGIN
                        IF ProcurementRequest."Evaluation Minutes Path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Evaluation Minutes Path");
                            if ProcurementRequest."Attached Eval Minutes Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached Eval Minutes Doc.");
                                ProcurementRequest."Attached Eval Minutes Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Evaluation Minutes Path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                    IF DocType = 3 THEN BEGIN
                        IF ProcurementRequest."Professional Opinion Path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Professional Opinion Path");
                            if ProcurementRequest."Attached Professional Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached Professional Doc.");
                                ProcurementRequest."Attached Professional Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Professional Opinion Path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                    IF DocType = 4 THEN BEGIN
                        IF ProcurementRequest."Terms Of Reference Path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Terms Of Reference Path");
                            if ProcurementRequest."Attached TOR Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached TOR Doc.");
                                ProcurementRequest."Attached Professional Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Terms Of Reference Path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                    IF DocType = 5 THEN BEGIN
                        IF ProcurementRequest."Process Detail path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Process Detail path");
                            if ProcurementRequest."Attached Proposal Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached Proposal Doc.");
                                ProcurementRequest."Attached Proposal Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Process Detail path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                    IF DocType = 6 THEN BEGIN//Contract
                        IF ProcurementRequest."Contract Path" <> '' THEN BEGIN
                            //ViewAttachedDocument(ProcurementRequest."Contract Path");
                            if ProcurementRequest."Attached Contract Doc.".HasValue then begin
                                ProcurementRequest.CalcFields("Attached Contract Doc.");
                                ProcurementRequest."Attached Contract Doc.".CreateInStream(NewStream);
                                DOWNLOADFROMSTREAM(NewStream, 'Export', '', 'All Files (*.*)|*.*', ProcurementRequest."Contract Path");
                            end
                            else
                                Error(ErrorAttachment);
                        END;
                    END;
                END;
        END;
    end;

    local procedure ViewAttachedDocument(FilePathTxt: Text);
    begin
        IF FilePathTxt <> '' THEN
            HYPERLINK(FilePathTxt);
    end;

    //[Scope('Personalization')]
    procedure ForwardForOpening(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        MissingQuotationsErr: Label 'No Supplier has submitted their quotations.';
        ForwardSuccessTxt: Label 'Request forwarded for Opening successfully.';
        AlreadyInOpeningMsg: Label 'Request already submitted for Opening';
        MissingProposalDocsErr: Label 'No Supplier has submitted their Proposal Document';
        MissingTenderDocsErr: Label 'No Supplier has submitted their Tender Document';
    begin
        WITH ProcurementRequest DO BEGIN
            IF "Process Status" = "Process Status"::Opening THEN
                MESSAGE(AlreadyInOpeningMsg);

            CheckIfSuppliersSelected(ProcurementRequest);
            ValidateCommitteeMembers(ProcurementRequest, 1);

            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
            IF NOT ProcurementSupplierSelection.FINDSET THEN BEGIN
                IF "Procurement Option" = "Procurement Option"::"Request For Quotation" THEN
                    ERROR(MissingQuotationsErr);
                IF "Procurement Option" = "Procurement Option"::"Request For Proposal" THEN
                    ERROR(MissingProposalDocsErr);
                IF ("Procurement Option" = "Procurement Option"::"Open Tender") OR ("Procurement Option" = "Procurement Option"::"Restricted Tender") THEN
                    ERROR(MissingTenderDocsErr);
            END ELSE BEGIN
                "Process Status" := "Process Status"::Opening;
                "Forwarded to Opening" := TRUE;
                MODIFY(TRUE);
                MESSAGE(ForwardSuccessTxt);
            END;
        END;
    end;

    local procedure ValidateCommitteeMembers(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        ProcurementCommitteeSetup: Record "Procurement Committee Setup";
        SelectedCommitteeMember: Record "Selected Committee Member";
        LessCommiteeMbrsErr: Label 'The selected Committee Members ,of %1 ,are less than the prescribed members of %2.';
        NoCommiteeMbrsErr: Label 'Kindly select %1 to proceed with the process.';
        SelectedCommitteeMember2: Record "Selected Committee Member";
        CommiteeChairPersonErr: Label 'Kindly choose a Chair Person from the Commitee Selected.';
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementCommitteeSetup.RESET;
            IF StageNo = 1 THEN
                ProcurementCommitteeSetup.SETRANGE("Process Stage", ProcurementCommitteeSetup."Process Stage"::Opening)
            ELSE
                IF StageNo = 2 THEN
                    ProcurementCommitteeSetup.SETRANGE("Process Stage", ProcurementCommitteeSetup."Process Stage"::Evaluation);
            IF ProcurementCommitteeSetup.FINDFIRST THEN BEGIN
                SelectedCommitteeMember.RESET;
                SelectedCommitteeMember.SETRANGE("Process No.", "No.");
                SelectedCommitteeMember.SETRANGE("Process Stage", ProcurementCommitteeSetup."Process Stage");
                IF SelectedCommitteeMember.FINDSET THEN BEGIN
                    IF ProcurementCommitteeSetup."Minimum Members" <> 0 THEN BEGIN
                        IF SelectedCommitteeMember.COUNT < ProcurementCommitteeSetup."Minimum Members" THEN
                            ERROR(LessCommiteeMbrsErr, SelectedCommitteeMember.COUNT, ProcurementCommitteeSetup."Minimum Members");
                    END;
                    SelectedCommitteeMember2.RESET;
                    SelectedCommitteeMember2.COPYFILTERS(SelectedCommitteeMember);
                    SelectedCommitteeMember2.SETRANGE(Position, SelectedCommitteeMember2.Position::"Chair Person");
                    IF NOT SelectedCommitteeMember2.FINDFIRST THEN BEGIN
                        ERROR(CommiteeChairPersonErr);
                    END;
                END ELSE BEGIN
                    ERROR(NoCommiteeMbrsErr, ProcurementCommitteeSetup.Description);
                END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure SelectOpeningCommittee(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        SelectedCommitteeMembers: Page "Selected Committee Members";
        ProcurementUsers: Page "Procurement Users";
    begin
        WITH ProcurementRequest DO BEGIN
            UserSetup.RESET;
            IF UserSetup.FINDSET THEN BEGIN
                CLEAR(ProcurementUsers);
                ProcurementUsers.SETTABLEVIEW(UserSetup);
                ProcurementUsers.SETRECORD(UserSetup);
                ProcurementUsers.LOOKUPMODE := TRUE;
                IF ProcurementUsers.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ProcurementUsers.SetSelection(UserSetup, "No.", StageNo);
                END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure PopulateSelectedCommiteeMembers(UserSetup: Record "User Setup"; ProcessNo: Code[20]; StageNo: Integer);
    var
        SelectedCommitteeMember: Record "Selected Committee Member";
        SelectedCommitteeMember2: Record "Selected Committee Member";
        ProcurementCommitteeSetup: Record "Procurement Committee Setup";
    begin
        WITH UserSetup DO BEGIN
            ProcurementCommitteeSetup.RESET;
            IF StageNo = 1 THEN
                ProcurementCommitteeSetup.SETRANGE("Process Stage", ProcurementCommitteeSetup."Process Stage"::Opening);
            IF StageNo = 2 THEN
                ProcurementCommitteeSetup.SETRANGE("Process Stage", ProcurementCommitteeSetup."Process Stage"::Evaluation);
            IF ProcurementCommitteeSetup.FINDFIRST THEN BEGIN
                IF NOT SelectedCommitteeMember.GET(UserSetup."User ID", ProcessNo, ProcurementCommitteeSetup.Code) THEN BEGIN
                    SelectedCommitteeMember2.INIT;
                    SelectedCommitteeMember2."User ID" := "User ID";
                    SelectedCommitteeMember2."Process No." := ProcessNo;
                    SelectedCommitteeMember2."Employee No." := "Employee No.";
                    SelectedCommitteeMember2."Process Stage" := ProcurementCommitteeSetup."Process Stage";
                    SelectedCommitteeMember2."Committee Code" := ProcurementCommitteeSetup.Code;
                    SelectedCommitteeMember2.VALIDATE("Committee Code");
                    SelectedCommitteeMember2.INSERT;
                END;
            END
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewSelectedCommittee(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        SelectedCommitteeMemberpg: Page "Selected Committee Members";
        ProcurementUsers: Page "Procurement Users";
        SelectedCommitteeMember: Record "Selected Committee Member";
    begin
        WITH ProcurementRequest DO BEGIN
            SelectedCommitteeMember.RESET;
            SelectedCommitteeMember.SETRANGE("Process No.", "No.");
            IF StageNo = 1 THEN
                SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Opening)
            ELSE
                IF StageNo = 2 THEN
                    SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Evaluation);
            IF SelectedCommitteeMember.FINDSET THEN BEGIN
                CLEAR(SelectedCommitteeMemberpg);
                SelectedCommitteeMemberpg.SETTABLEVIEW(SelectedCommitteeMember);
                SelectedCommitteeMemberpg.SETRECORD(SelectedCommitteeMember);
                SelectedCommitteeMemberpg.LOOKUPMODE(TRUE);
                SelectedCommitteeMemberpg.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateCommitteeMemberPosition(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        SelectedCommitteeMemberpg: Page "Selected Committee Members";
        ProcurementUsers: Page "Procurement Users";
        SelectedCommitteeMember: Record "Selected Committee Member";
        NoChairPersonErr: Label 'Kindly Select a Chair Person for the Evaluation Commitee.';
        NotChairPersonErr: Label 'You are not allowed to perform this Activity.\Kindly liase with the evaluation Comittee Chair Person';
    begin
        WITH ProcurementRequest DO BEGIN
            CASE StageNo OF
                1:
                    BEGIN
                        SelectedCommitteeMember.RESET;
                        SelectedCommitteeMember.SETRANGE("Process No.", "No.");
                        SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Evaluation);
                        SelectedCommitteeMember.SETRANGE(Position, SelectedCommitteeMember.Position::"Chair Person");
                        IF NOT SelectedCommitteeMember.FINDFIRST THEN BEGIN
                            ERROR(NoChairPersonErr);
                        END ELSE BEGIN
                            IF SelectedCommitteeMember."User ID" <> USERID THEN
                                ERROR(NotChairPersonErr);
                        END;
                    END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ForwardProcessToNextStage(Variant: Variant; ForwardStage: Integer);
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        IncompleteProcessErr: Label 'Complete the process before proceeding.';
        ForwardSuccessTxt: Label 'Request moved to Evaluation successfully.';
        AlreadyInEvaluationMsg: Label 'Request has already been submitted for Evaluation';
        SelectedCommitteeMember: Record "Selected Committee Member";
        ProcurementRequest: Record "Procurement Request";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        RecRef: RecordRef;
        ProcurementSupplierSelection2: Record "Procurement Supplier Selection";
        MissingEOIErr: Label 'No Supplier has submitted their Expression of Interest Document';
        EOIEvaluationCloseTxt: Label 'Expression Of Interest Opening has been closed Successfully.';
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    CASE ForwardStage OF
                        1:
                            BEGIN
                                IF ProcurementRequest."Forwarded to Evaluation" = TRUE THEN
                                    ERROR(AlreadyInEvaluationMsg);
                                CheckSupplierMandatoryRequirements(ProcurementRequest, 1);

                                ProcurementRequest.TESTFIELD("Attached Opening Minutes", TRUE);
                                ProcurementRequest.TESTFIELD("Opening Minutes Path");
                                ValidateCommitteeMembers(ProcurementRequest, 2);
                                CreateEvaluationEntries(ProcurementRequest);

                                ProcurementRequest."Process Status" := ProcurementRequest."Process Status"::Evaluation;
                                ProcurementRequest."Forwarded to Evaluation" := TRUE;
                                ProcurementRequest.MODIFY(TRUE);
                                MESSAGE(ForwardSuccessTxt);
                            END;
                    END;
                END;
            DATABASE::"Procurement Supplier Selection":
                BEGIN
                    ProcurementSupplierSelection := Variant;
                    CASE ForwardStage OF
                        1:
                            BEGIN
                                ProcurementSupplierSelection.TESTFIELD("Attach Expression Of Interest", TRUE);
                                ProcurementSupplierSelection."Proceed To Proposal" := TRUE;
                                ProcurementSupplierSelection.MODIFY(TRUE);
                                MESSAGE(ForwardSuccessTxt2);
                            END;
                        2:
                            BEGIN
                                ProcurementSupplierSelection2.RESET;
                                ProcurementSupplierSelection2.SETRANGE("Process No.", ProcurementSupplierSelection."Process No.");
                                ProcurementSupplierSelection2.SETRANGE("Proceed To Proposal", TRUE);
                                IF ProcurementSupplierSelection2.FINDSET THEN BEGIN
                                    IF ProcurementRequest.GET(ProcurementSupplierSelection."Process No.") THEN BEGIN
                                        ProcurementRequest."Process Status" := ProcurementRequest."Process Status"::Proposal;
                                        ProcurementRequest.MODIFY(TRUE);
                                    END;
                                    MESSAGE(EOIEvaluationCloseTxt);
                                END ELSE BEGIN
                                END;
                            END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure CheckSupplierMandatoryRequirements(Variant: Variant; ValidationStage: Integer);
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        IncompleteProcessErr: Label 'Complete the process before proceeding.';
        ForwardSuccessTxt: Label 'Request moved to Evaluation successfully.';
        AlreadyInEvaluationMsg: Label 'Request has already been submitted for Evaluation';
        SelectedCommitteeMember: Record "Selected Committee Member";
        ProcurementRequest: Record "Procurement Request";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        RecRef: RecordRef;
        ProcurementSupplierSelection2: Record "Procurement Supplier Selection";
        MissingEOIErr: Label 'No Supplier has submitted their Expression of Interest Document';
        EOIEvaluationCloseTxt: Label 'Expression Of Interest Opening has been closed Successfully.';
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    CASE ValidationStage OF
                        1:
                            BEGIN
                                ProcurementSupplierSelection.RESET;
                                ProcurementSupplierSelection.SETRANGE("Process No.", ProcurementRequest."No.");
                                ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
                                IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                                    REPEAT
                                        ProcurementSupplierSelection.TESTFIELD("Quoted Amount");
                                    UNTIL ProcurementSupplierSelection.NEXT = 0;
                                END;
                            END;
                    END;
                END;
            DATABASE::"Procurement Supplier Selection":
                BEGIN
                    ProcurementSupplierSelection := Variant;

                END;
        END;
    end;

    local procedure CreateEvaluationEntries(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        SelectedCommitteeMember: Record "Selected Committee Member";
        ProcurementRequestLine: Record "Procurement Request Line";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        ProcurementProcessEvaluation3: Record "Procurement Process Evaluation";
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementRequestLine.RESET;
            ProcurementRequestLine.SETRANGE("Request No.", "No.");
            IF ProcurementRequestLine.FINDSET THEN BEGIN
                ProcurementSupplierSelection.RESET;
                ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
                ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
                IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                    REPEAT
                        IF NOT ProcurementProcessEvaluation.GET(ProcurementSupplierSelection."Vendor No.", "No.") THEN BEGIN
                            ProcurementProcessEvaluation2.INIT;
                            ProcurementProcessEvaluation2.TRANSFERFIELDS(ProcurementRequestLine);
                            ProcurementProcessEvaluation2."Unit Amount" := 0;
                            ProcurementProcessEvaluation2.Amount := 0;
                            ProcurementProcessEvaluation2."Vendor No." := ProcurementSupplierSelection."Vendor No.";
                            ProcurementProcessEvaluation2."Vendor Name" := ProcurementSupplierSelection.Name;
                            ProcurementProcessEvaluation2."Quote Generated" := TRUE;
                            ProcurementProcessEvaluation2."Quoted Amount" := ProcurementSupplierSelection."Quoted Amount";
                            ProcurementProcessEvaluation2."Category Code" := "Category Code";
                            ProcurementProcessEvaluation2."Category Description" := "Category Description";
                            ProcurementProcessEvaluation2."Contract Signing Date" := "Contract Signing Date";
                            ProcurementProcessEvaluation2."Evaluation Stage" := ProcurementProcessEvaluation2."Evaluation Stage"::Mandatory;
                            //ProcurementProcessEvaluation2."Evaluation Date" := "Evaluation Date";
                            ProcurementProcessEvaluation2."Procurement Option" := "Procurement Option";
                            ProcurementProcessEvaluation2.Email := ProcurementSupplierSelection."E-Mail";
                            IF ProcurementProcessEvaluation2.INSERT THEN BEGIN
                                ProcurementSupplierSelection."Forwarded For Evaluation" := TRUE;
                                ProcurementSupplierSelection.MODIFY;
                            END;
                            COMMIT;
                            IF ProcurementProcessEvaluation3.GET(ProcurementSupplierSelection."Vendor No.", "No.") THEN
                                MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation3, 1);
                        END ELSE
                            MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation, 1);
                    UNTIL ProcurementSupplierSelection.NEXT = 0;
                END;
            END;
            ValidateEvaluationEntries(ProcurementRequest);

        END;
    end;

    local procedure ValidateEvaluationEntries(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        SelectedCommitteeMember: Record "Selected Committee Member";
        ProcurementRequestLine: Record "Procurement Request Line";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        SupplierEvaluation: Record "Supplier Evaluation";
        NoSuppliersErr: Label 'No Supplier has been submitted for Evaluation';
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementProcessEvaluation.RESET;
            ProcurementProcessEvaluation.SETRANGE("Process No.", "No.");
            IF NOT ProcurementProcessEvaluation.FINDSET THEN BEGIN
                ERROR(NoSuppliersErr);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; StageNo: Integer);
    var
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        SelectedCommitteeMember: Record "Selected Committee Member";
        SupplierEvaluation: Record "Supplier Evaluation";
        SupplierEvaluation2: Record "Supplier Evaluation";
        ProcurementRequirementSetup: Record "Procurement Requirement Setup";
        AllCommiteeMembers: Integer;
        i: Integer;
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            ProcurementSetup.GET;
            AllCommiteeMembers := 0;
            IF ProcurementSetup."Evaluation Based On" = ProcurementSetup."Evaluation Based On"::Group THEN BEGIN
                AllCommiteeMembers := 1;
            END ELSE BEGIN
                SelectedCommitteeMember.RESET;
                SelectedCommitteeMember.SETRANGE("Process No.", "Process No.");
                SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Evaluation);
                IF SelectedCommitteeMember.FINDSET THEN BEGIN
                    AllCommiteeMembers := SelectedCommitteeMember.COUNT;
                END;
            END;
            i := 0;
            SelectedCommitteeMember.RESET;
            SelectedCommitteeMember.SETRANGE("Process No.", "Process No.");
            SelectedCommitteeMember.SETRANGE("Process Stage", SelectedCommitteeMember."Process Stage"::Evaluation);
            IF ProcurementSetup."Evaluation Based On" = ProcurementSetup."Evaluation Based On"::Group THEN
                SelectedCommitteeMember.SETRANGE(Position, SelectedCommitteeMember.Position::"Chair Person");
            IF SelectedCommitteeMember.FINDSET THEN BEGIN
                REPEAT
                    ProcurementRequirementSetup.RESET;
                    ProcurementRequirementSetup.SETFILTER("Procurement Option", '%1|%2', ProcurementRequirementSetup."Procurement Option"::All, "Procurement Option");
                    IF StageNo = 1 THEN
                        ProcurementRequirementSetup.SETRANGE("Evaluation Stage", ProcurementRequirementSetup."Evaluation Stage"::Mandatory)
                    ELSE
                        IF StageNo = 2 THEN
                            ProcurementRequirementSetup.SETRANGE("Evaluation Stage", ProcurementRequirementSetup."Evaluation Stage"::Technical)
                        ELSE
                            IF StageNo = 3 THEN
                                ProcurementRequirementSetup.SETRANGE("Evaluation Stage", ProcurementRequirementSetup."Evaluation Stage"::Financial);
                    IF ProcurementRequirementSetup.FINDSET THEN BEGIN
                        REPEAT
                            IF NOT SupplierEvaluation.GET("Vendor No.", ProcurementRequirementSetup.Code, "Process No.") THEN BEGIN
                                SupplierEvaluation2.INIT;
                                SupplierEvaluation2."Vendor No." := "Vendor No.";
                                SupplierEvaluation2."Process No." := "Process No.";
                                SupplierEvaluation2."Evaluating UserID" := SelectedCommitteeMember."User ID";
                                SupplierEvaluation2."Evaluation Stage" := ProcurementRequirementSetup."Evaluation Stage";
                                SupplierEvaluation2."Evaluation Code" := ProcurementRequirementSetup.Code;
                                SupplierEvaluation2."Success Option" := SupplierEvaluation2."Success Option"::" ";
                                SupplierEvaluation2."Evaluation Description" := ProcurementRequirementSetup.Description;
                                SupplierEvaluation2."Needs Attachment" := ProcurementRequirementSetup."Needs Attachment";
                                SupplierEvaluation2.INSERT;
                            END;
                        UNTIL ProcurementRequirementSetup.NEXT = 0;
                    END;
                UNTIL SelectedCommitteeMember.NEXT = 0;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ViewEvaluationRequirements(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; ViewNo: Integer);
    var
        SupplierEvaluation: Record "Supplier Evaluation";
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        SupplierEvaluations: Page "Supplier Requirement Eval";
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            SupplierEvaluation.RESET;
            SupplierEvaluation.SETRANGE("Evaluating UserID", USERID);
            IF ViewNo = 1 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Mandatory)
            ELSE
                IF ViewNo = 2 THEN
                    SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Technical)
                ELSE
                    IF ViewNo = 3 THEN
                        SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Financial);
            SupplierEvaluation.SETRANGE("Vendor No.", "Vendor No.");
            SupplierEvaluation.SETRANGE("Process No.", "Process No.");
            IF SupplierEvaluation.FINDSET THEN BEGIN
                CLEAR(SupplierEvaluations);
                SupplierEvaluations.SETTABLEVIEW(SupplierEvaluation);
                SupplierEvaluations.SETRECORD(SupplierEvaluation);
                SupplierEvaluations.LOOKUPMODE(TRUE);
                SupplierEvaluations.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure StartEvaluationProcess(ProcurementRequest: Record "Procurement Request"; ViewNo: Integer);
    var
        SupplierEvaluation: Record "Supplier Evaluation";
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        SupplierEvaluations: Page "Supplier Requirement Eval";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementProcessEvaluation.RESET;
            ProcurementProcessEvaluation.SETRANGE("Process No.", "No.");
            IF ViewNo = 2 THEN BEGIN
                ProcurementProcessEvaluation.SETRANGE("Evaluation Complete", TRUE);
                ProcurementProcessEvaluation.SETRANGE("Evaluation Stage", ProcurementProcessEvaluation."Evaluation Stage"::Awarding);
                ProcurementProcessEvaluation.SETCURRENTKEY("Total Score");
                ProcurementProcessEvaluation.SETASCENDING("Total Score", FALSE);
            END;
            IF ProcurementProcessEvaluation.FINDSET THEN BEGIN
                CLEAR(SupplierEvaluationListPg);
                SupplierEvaluationListPg.SETTABLEVIEW(ProcurementProcessEvaluation);
                SupplierEvaluationListPg.SETRECORD(ProcurementProcessEvaluation);
                SupplierEvaluationListPg.LOOKUPMODE := TRUE;
                SupplierEvaluationListPg.RUN;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ForwardToNextEvaluationStage(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; StageNo: Integer);
    var
        SupplierEvaluation: Record "Supplier Evaluation";
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        SupplierEvaluations: Page "Supplier Requirement Eval";
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        MandatoryErr: Label 'The overall Summary on the Mandatory must be filled before proceeding to technical.';
        ProcurementRequest: Record "Procurement Request";
        ForwardToNextStageMsg: Label 'Forward Successful.';
        FailedMandatoryErr: Label 'Vendor %1 cannot proceed to Technical.';
        FailedTechnicalErr: Label 'Vendor %1 cannot proceed to Financial.';
        FailedFinancialErr: Label 'Vendor %1 cannot proceed to Award Stage';
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            ValidateEvaluationRequirements(ProcurementProcessEvaluation, StageNo);
            //ProcurementProcessEvaluation.TESTFIELD("Evaluation Complete",FALSE);
            ProcurementProcessEvaluation2.RESET;
            ProcurementProcessEvaluation2.SETRANGE("Vendor No.", "Vendor No.");
            ProcurementProcessEvaluation2.SETRANGE("Process No.", "Process No.");
            IF ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                CASE StageNo OF
                    1:
                        BEGIN
                            TESTFIELD("Mandatory Requirements Summary");
                            TESTFIELD("Mandatory Score");
                            IF "Mandatory Requirements Summary" = "Mandatory Requirements Summary"::Fail THEN
                                ERROR(FailedMandatoryErr, "Vendor No.");
                            IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation, StageNo + 1);
                                MESSAGE(ForwardToNextStageMsg);
                            END;
                            "Evaluation Stage" := "Evaluation Stage"::Technical;
                        END;
                    2:
                        BEGIN
                            TESTFIELD("Technical Requirements Summary");
                            TESTFIELD("Technical Score");
                            IF "Technical Requirements Summary" = "Technical Requirements Summary"::Fail THEN
                                ERROR(FailedTechnicalErr, "Vendor No.");
                            IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation, StageNo + 1);
                                MESSAGE(ForwardToNextStageMsg);
                            END;
                            "Evaluation Stage" := "Evaluation Stage"::Financial;
                        END;
                    3:
                        BEGIN
                            TESTFIELD("Financial Requirements Summary");
                            TESTFIELD("Financial Score");
                            IF "Technical Requirements Summary" = "Financial Requirements Summary"::Fail THEN
                                ERROR(FailedFinancialErr, "Vendor No.");
                            IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                MakeEvaluationEntriesForCommiteeMembers(ProcurementProcessEvaluation, StageNo + 1);
                                MESSAGE(ForwardToNextStageMsg);
                            END;
                            "Evaluation Stage" := "Evaluation Stage"::Awarding;
                            "Evaluation Complete" := TRUE;
                            ProcurementProcessEvaluation2.RESET;
                            ProcurementProcessEvaluation2.SETRANGE("Process No.", "Process No.");
                            ProcurementProcessEvaluation2.SETRANGE("Evaluation Complete", FALSE);
                            IF NOT ProcurementProcessEvaluation2.FINDSET THEN BEGIN
                                IF ProcurementRequest.GET("Process No.") THEN BEGIN
                                    ProcurementRequest."Evaluation Complete" := TRUE;
                                    ProcurementRequest.MODIFY(TRUE);
                                END;
                            END;
                        END;
                END;
                MODIFY(TRUE);
                //MESSAGE(ForwardToNextStageMsg);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateEvaluationRequirements(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; StageNo: Integer);
    var
        SupplierEvaluation: Record "Supplier Evaluation";
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        MissingScoreErr: Label 'Kindly note that this Commitee member %1 has not submitted a score on %2 for Vendor %3.';
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            SupplierEvaluation.RESET;
            SupplierEvaluation.SETRANGE("Process No.", "Process No.");
            IF StageNo = 1 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Mandatory);
            IF StageNo = 2 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Technical);
            IF StageNo = 3 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Financial);
            SupplierEvaluation.SETRANGE("Vendor No.", "Vendor No.");
            IF SupplierEvaluation.FINDSET THEN BEGIN
                REPEAT
                    IF SupplierEvaluation."Score(%)" = 0 THEN
                        ERROR(MissingScoreErr, SupplierEvaluation."Evaluating UserID", SupplierEvaluation."Evaluation Description", SupplierEvaluation."Vendor No.");
                UNTIL SupplierEvaluation.NEXT = 0;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure GenerateAverageScore(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; StageNo: Integer);
    var
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        MissingScoreErr: Label 'Kindly note that Commitee member %1 has not submitted the score or remark on %2.';
        SupplierEvaluation2: Record "Supplier Evaluation";
        AllSubmitted: Integer;
        TotalScore: array[5] of Decimal;
        SupplierEvaluation: Record "Supplier Evaluation";
        GenerateSuccessfulMsg: Label 'Score Generated Successfully.';
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            ProcurementSetup.GET;
            SupplierEvaluation.RESET;
            SupplierEvaluation.SETRANGE("Process No.", "Process No.");
            IF StageNo = 1 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Mandatory);
            IF StageNo = 2 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Technical);
            IF StageNo = 3 THEN
                SupplierEvaluation.SETRANGE("Evaluation Stage", SupplierEvaluation."Evaluation Stage"::Financial);
            SupplierEvaluation.SETRANGE("Vendor No.", "Vendor No.");
            IF SupplierEvaluation.FINDSET THEN BEGIN
                REPEAT
                    IF (SupplierEvaluation."Score(%)" = 0) AND (SupplierEvaluation.Remarks = '') THEN
                        ERROR(MissingScoreErr, SupplierEvaluation."Evaluating UserID", SupplierEvaluation."Evaluation Description");
                UNTIL SupplierEvaluation.NEXT = 0;
            END;
            AllSubmitted := 0;
            TotalScore[1] := 0;
            TotalScore[2] := 0;
            SupplierEvaluation2.RESET;
            SupplierEvaluation2.SETRANGE("Process No.", "Process No.");
            IF StageNo = 1 THEN
                SupplierEvaluation2.SETRANGE("Evaluation Stage", SupplierEvaluation2."Evaluation Stage"::Mandatory);
            IF StageNo = 2 THEN
                SupplierEvaluation2.SETRANGE("Evaluation Stage", SupplierEvaluation2."Evaluation Stage"::Technical);
            IF StageNo = 3 THEN
                SupplierEvaluation2.SETRANGE("Evaluation Stage", SupplierEvaluation2."Evaluation Stage"::Financial);
            SupplierEvaluation2.SETFILTER("Score(%)", '<>%1', 0);
            SupplierEvaluation2.SETRANGE("Vendor No.", "Vendor No.");
            SupplierEvaluation2.SETRANGE("Evaluating UserID", USERID);
            IF SupplierEvaluation2.FINDSET THEN BEGIN
                AllSubmitted := SupplierEvaluation2.COUNT;
                REPEAT
                    TotalScore[1] += SupplierEvaluation2."Score(%)";
                UNTIL SupplierEvaluation2.NEXT = 0;
            END;
            IF AllSubmitted <> 0 THEN
                TotalScore[2] := TotalScore[1] / AllSubmitted;
            ProcurementProcessEvaluation2.RESET;
            ProcurementProcessEvaluation2.SETRANGE("Vendor No.", "Vendor No.");
            ProcurementProcessEvaluation2.SETRANGE("Process No.", "Process No.");
            IF ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                CASE StageNo OF
                    1:
                        BEGIN
                            ProcurementSetup.TESTFIELD("Mandatory Pass Limit(%)");
                            ProcurementProcessEvaluation2."Mandatory Score" := TotalScore[2];
                            IF ProcurementSetup."Mandatory Pass Limit(%)" > TotalScore[2] THEN
                                ProcurementProcessEvaluation2."Mandatory Requirements Summary" := ProcurementProcessEvaluation2."Mandatory Requirements Summary"::Fail
                            ELSE
                                ProcurementProcessEvaluation2."Mandatory Requirements Summary" := ProcurementProcessEvaluation2."Mandatory Requirements Summary"::Pass;
                        END;
                    2:
                        BEGIN
                            ProcurementSetup.TESTFIELD("Technical Pass Limit(%)");
                            ProcurementProcessEvaluation2."Technical Score" := TotalScore[2];
                            IF ProcurementSetup."Technical Pass Limit(%)" > TotalScore[2] THEN
                                ProcurementProcessEvaluation2."Technical Requirements Summary" := ProcurementProcessEvaluation2."Technical Requirements Summary"::Fail
                            ELSE
                                ProcurementProcessEvaluation2."Technical Requirements Summary" := ProcurementProcessEvaluation2."Technical Requirements Summary"::Pass;
                        END;
                    3:
                        BEGIN
                            ProcurementSetup.TESTFIELD("Financial Pass Limit(%)");
                            ProcurementProcessEvaluation2."Financial Score" := TotalScore[2];
                            IF ProcurementSetup."Financial Pass Limit(%)" > TotalScore[2] THEN
                                ProcurementProcessEvaluation2."Financial Requirements Summary" := ProcurementProcessEvaluation2."Financial Requirements Summary"::Fail
                            ELSE
                                ProcurementProcessEvaluation2."Financial Requirements Summary" := ProcurementProcessEvaluation2."Financial Requirements Summary"::Pass;
                        END;
                    4:
                        BEGIN
                            ProcurementSetup.TESTFIELD("Overall Pass Limit(%)");
                            TotalScore[3] := ("Mandatory Score" + "Technical Score" + "Financial Score") / 3;
                            ProcurementProcessEvaluation2."Total Score" := TotalScore[3];
                            IF ProcurementSetup."Overall Pass Limit(%)" > TotalScore[3] THEN
                                ProcurementProcessEvaluation2."Overall Requirements Summary" := ProcurementProcessEvaluation2."Overall Requirements Summary"::Fail
                            ELSE
                                ProcurementProcessEvaluation2."Overall Requirements Summary" := ProcurementProcessEvaluation2."Overall Requirements Summary"::Pass;
                        END;
                END;
                ProcurementProcessEvaluation2.MODIFY;
                MESSAGE(GenerateSuccessfulMsg);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure SendLetter(ProcurementProcessEvaluation: Record "Procurement Process Evaluation"; EvaluationStage: Option " ",Mandatory,Technical,Financial,Awarding);
    var
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        MissingScoreErr: Label 'Kindly note that Commitee member %1 has not submitted the score on %2.';
        SupplierEvaluation2: Record "Supplier Evaluation";
        AllSubmitted: Integer;
        TotalScore: array[5] of Decimal;
        SupplierEvaluation: Record "Supplier Evaluation";
        GenerateSuccessfulMsg: Label 'Score Generated Successfully.';
        RegretMsg: Text;
        MsgInstream: InStream;
        MsgOutstream: OutStream;
        EmailSuccessMsg: Label 'Email Sent Successfully.';
        AwardMsg: Text;
        EmailConfirmTxt: Label 'Are you Sure you want to Send a %1 email to %2.';
        EmailConfCaption: Text;
    begin
        WITH ProcurementProcessEvaluation DO BEGIN
            ProcurementSetup.GET;
            TESTFIELD(Email);
            IF "Evaluation Stage" = "Evaluation Stage"::Awarding THEN BEGIN
                EmailConfCaption := STRSUBSTNO(EmailConfirmTxt, 'Success', "Vendor Name");
            END ELSE BEGIN
                EmailConfCaption := STRSUBSTNO(EmailConfirmTxt, 'Regret', "Vendor Name");
            END;
            IF CONFIRM(EmailConfCaption) THEN BEGIN
                IF EvaluationStage <> EvaluationStage::Awarding THEN BEGIN
                    TESTFIELD("Evaluation Complete", FALSE);
                    ProcurementSetup.CALCFIELDS("Failed Supplier Regret Msg");
                    ProcurementSetup."Failed Supplier Regret Msg".CREATEINSTREAM(MsgInstream);
                    MsgInstream.READ(RegretMsg);
                    MailHeader := 'Dear ' + FORMAT("Vendor Name") + ' ,';
                    MailBody := STRSUBSTNO(RegretMsg, "Process No.");
                    //SendMail(Email,MailHeader,MailBody);
                    MESSAGE(EmailSuccessMsg);
                    "Evaluation Complete" := TRUE;
                    "Letter Type" := "Letter Type"::Regret;
                    "Overall Requirements Summary" := "Overall Requirements Summary"::Fail;
                    "Letter Sent" := TRUE;
                END
                ELSE BEGIN
                    ProcurementProcessEvaluation.TESTFIELD("Evaluation Complete", TRUE);
                    ProcurementProcessEvaluation.TESTFIELD("Evaluation Stage", ProcurementProcessEvaluation."Evaluation Stage"::Awarding);
                    ProcurementSetup.CALCFIELDS("Evaluation Success Msg");
                    ProcurementSetup."Evaluation Success Msg".CREATEINSTREAM(MsgInstream);
                    MsgInstream.READ(AwardMsg);
                    MailHeader := 'Dear ' + FORMAT("Vendor Name") + ' ,';
                    MailBody := STRSUBSTNO(AwardMsg, "Process No.");
                    //SendMail(Email,MailHeader,MailBody);
                    MESSAGE(EmailSuccessMsg);
                    "Letter Type" := "Letter Type"::Success;
                    "Letter Sent" := TRUE;
                END;
                MODIFY;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure CompleteEvaluation(Variant: Variant; EvaluationStage: Integer);
    var
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        MissingScoreErr: Label 'Kindly note that Commitee member %1 has not submitted the score on %2.';
        SupplierEvaluation2: Record "Supplier Evaluation";
        AllSubmitted: Integer;
        TotalScore: array[10] of Decimal;
        SupplierEvaluation: Record "Supplier Evaluation";
        GenerateSuccessfulMsg: Label 'Score Generated Successfully.';
        RegretEmailSuccessMsg: Label 'Email Sent Successfully.';
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        ProcurementRequest: Record "Procurement Request";
        RegretEmailSendReqErr: Label 'Kindly send a Regret Email to Supplier %1.';
        EvaluationCompleteMsg: Label 'Evaluation Completed Successfully.';
        RecRef: RecordRef;
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        AwardingConfMsg: Label '"Are You sure you want to Award %1, process %2? "';
        AwardSuccessMsg: Label 'Award successful to Vendor %1.';
        AwardEmailSuccessMsg: Label 'Award Email Sent to %1';
        AwardEmailConfMsg: Label 'Do you want to send an award Message to Vendor %1?';
        AwardMsg1: Text;
        AwardEmailMsg1: Text;
        AlreadyAwardedSupplierMsg: Label 'This request is already awarded to Vendor %1. \Do you wish to Award Vendor %2?';
        NoQualifiedSupplier: Label 'Kindly note that no supplier has reached the Awarding Stage';
        QualifiedOnStage: Label 'Kindly note that the selected supplier has qualified in %1 stage and is eligible for %2 Stage.\Click Yes to Complete the Evaluation or No to proceed with Evaluation.';
        FieldRef: FieldRef;
        EvalOptionString: Text;
        SelectedOption: Text;
        EvaluationIncompleteErr: Label 'Please Note that Supplier %1 Evaluaton is not complete';
        AwardedToTxt1: Text;
        ForwardToPMConf: Label 'Are you sure you want to submit the Evaluation to the Procurement Manager?';
        ReturnToEvaluationConf: Label 'Are you sure you want to Return this process to Evaluation Stage?\Kindly Note Evaluation Entries will be Recreated!';
        ReturnToEvaluationSuccessMsg: Label 'Return to Evaluation Successful.';
        NotHighestScoreVendor: Label 'Kindly Note that Vendor %1 has the Highest Score of %2.\Do you wish to award Vendor %3 having a score of %4?';
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Process Evaluation":
                BEGIN
                    ProcurementProcessEvaluation := Variant;
                    CASE EvaluationStage OF
                        1:
                            BEGIN
                                FieldRef := RecRef.FIELD(106);
                                EvalOptionString := FieldRef.OPTIONSTRING;

                                IF ProcurementRequest.GET(ProcurementProcessEvaluation."Process No.") THEN BEGIN
                                    IF ProcurementProcessEvaluation."Evaluation Stage" = ProcurementProcessEvaluation."Evaluation Stage"::Mandatory THEN BEGIN
                                        IF ProcurementProcessEvaluation."Overall Requirements Summary" <> ProcurementProcessEvaluation."Overall Requirements Summary"::" " THEN
                                            ProcurementProcessEvaluation.TESTFIELD("Mandatory Score");
                                        IF ProcurementProcessEvaluation."Mandatory Requirements Summary" = ProcurementProcessEvaluation."Mandatory Requirements Summary"::Fail THEN BEGIN
                                            IF ProcurementProcessEvaluation."Letter Sent" = FALSE THEN
                                                ERROR(RegretEmailSendReqErr, ProcurementProcessEvaluation."Vendor Name");
                                        END ELSE BEGIN
                                            SelectedOption := STRSUBSTNO(QualifiedOnStage, SELECTSTR(2, EvalOptionString), SELECTSTR(3, EvalOptionString));
                                            IF CONFIRM(SelectedOption) THEN BEGIN
                                                ProcurementProcessEvaluation."Evaluation Complete" := TRUE;
                                                ProcurementProcessEvaluation.MODIFY;
                                            END;
                                        END;
                                    END;
                                    IF ProcurementProcessEvaluation."Evaluation Stage" = ProcurementProcessEvaluation."Evaluation Stage"::Technical THEN BEGIN
                                        IF ProcurementProcessEvaluation."Overall Requirements Summary" <> ProcurementProcessEvaluation."Overall Requirements Summary"::" " THEN
                                            ProcurementProcessEvaluation.TESTFIELD("Technical Score");
                                        IF ProcurementProcessEvaluation."Technical Requirements Summary" = ProcurementProcessEvaluation."Technical Requirements Summary"::Fail THEN BEGIN
                                            IF ProcurementProcessEvaluation."Letter Sent" = FALSE THEN
                                                ERROR(RegretEmailSendReqErr, ProcurementProcessEvaluation."Vendor Name");
                                        END ELSE BEGIN
                                            SelectedOption := STRSUBSTNO(QualifiedOnStage, SELECTSTR(3, EvalOptionString), SELECTSTR(4, EvalOptionString));
                                            IF CONFIRM(SelectedOption) THEN BEGIN
                                                ProcurementProcessEvaluation."Evaluation Complete" := TRUE;
                                                ProcurementProcessEvaluation.MODIFY;
                                            END;
                                        END;
                                    END;
                                    IF ProcurementProcessEvaluation."Evaluation Stage" = ProcurementProcessEvaluation."Evaluation Stage"::Financial THEN BEGIN
                                        IF ProcurementProcessEvaluation."Overall Requirements Summary" <> ProcurementProcessEvaluation."Overall Requirements Summary"::" " THEN
                                            ProcurementProcessEvaluation.TESTFIELD("Financial Score");
                                        IF ProcurementProcessEvaluation."Financial Requirements Summary" = ProcurementProcessEvaluation."Financial Requirements Summary"::Fail THEN BEGIN
                                            IF ProcurementProcessEvaluation."Letter Sent" = FALSE THEN
                                                ERROR(RegretEmailSendReqErr, ProcurementProcessEvaluation."Vendor Name");
                                        END ELSE BEGIN
                                            SelectedOption := STRSUBSTNO(QualifiedOnStage, SELECTSTR(4, EvalOptionString), SELECTSTR(5, EvalOptionString));
                                            IF CONFIRM(SelectedOption) THEN BEGIN
                                                ProcurementProcessEvaluation."Evaluation Complete" := TRUE;
                                                ProcurementProcessEvaluation.MODIFY;
                                            END;
                                        END;
                                    END;
                                END;
                            END;
                        2:
                            BEGIN
                                ProcurementProcessEvaluation2.RESET;
                                ProcurementProcessEvaluation2.SETRANGE("Process No.", ProcurementProcessEvaluation."Process No.");
                                ProcurementProcessEvaluation2.SETRANGE("Evaluation Complete", FALSE);
                                IF ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                                    ERROR(EvaluationIncompleteErr, ProcurementProcessEvaluation2."Vendor Name");
                                END;
                                ProcurementProcessEvaluation2.RESET;
                                ProcurementProcessEvaluation2.SETRANGE("Process No.", ProcurementProcessEvaluation."Process No.");
                                ProcurementProcessEvaluation2.SETRANGE("Evaluation Stage", ProcurementProcessEvaluation2."Evaluation Stage"::Awarding);
                                IF NOT ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                                    ERROR(NoQualifiedSupplier);
                                END;
                                ProcurementProcessEvaluation2.RESET;
                                ProcurementProcessEvaluation2.SETRANGE("Process No.", ProcurementProcessEvaluation."Process No.");
                                IF ProcurementProcessEvaluation2.FINDSET THEN BEGIN
                                    REPEAT
                                        CompleteEvaluation(ProcurementProcessEvaluation2, 1);
                                    UNTIL ProcurementProcessEvaluation2.NEXT = 0;
                                END;
                                IF ProcurementRequest.GET(ProcurementProcessEvaluation."Process No.") THEN BEGIN
                                    ProcurementRequest."Evaluation Complete" := TRUE;
                                    ProcurementRequest.MODIFY(TRUE);
                                END;
                                MESSAGE(EvaluationCompleteMsg);
                            END;
                        3:
                            BEGIN
                                ProcurementProcessEvaluation2.RESET;
                                ProcurementProcessEvaluation2.SETRANGE("Process No.", ProcurementProcessEvaluation."Process No.");
                                ProcurementProcessEvaluation2.SETRANGE(Awarded, TRUE);
                                IF ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                                    AwardedToTxt1 := STRSUBSTNO(AlreadyAwardedSupplierMsg, ProcurementProcessEvaluation2."Vendor Name", ProcurementProcessEvaluation."Vendor Name");
                                    IF ProcurementProcessEvaluation."Vendor Name" <> ProcurementProcessEvaluation2."Vendor Name" THEN BEGIN
                                        IF CONFIRM(AwardedToTxt1) THEN BEGIN
                                            AwardSupplier(ProcurementProcessEvaluation, 1);
                                            ProcurementProcessEvaluation2.Awarded := FALSE;
                                            ProcurementProcessEvaluation2."Award Approval Date" := 0D;
                                            ProcurementProcessEvaluation2.MODIFY(TRUE);
                                        END ELSE
                                            ERROR(AlreadyAwardedSupplierMsg, ProcurementProcessEvaluation2."Vendor Name", ProcurementProcessEvaluation."Vendor Name");
                                    END ELSE BEGIN
                                        AwardSupplier(ProcurementProcessEvaluation, 1);
                                    END;
                                END ELSE BEGIN
                                    ProcurementProcessEvaluation2.RESET;
                                    ProcurementProcessEvaluation2.SETRANGE("Process No.", ProcurementProcessEvaluation."Process No.");
                                    ProcurementProcessEvaluation2.SETRANGE("Evaluation Stage", ProcurementProcessEvaluation2."Evaluation Stage"::Awarding);
                                    ProcurementProcessEvaluation2.SETCURRENTKEY("Total Score");
                                    ProcurementProcessEvaluation2.SETASCENDING("Total Score", FALSE);
                                    IF ProcurementProcessEvaluation2.FINDFIRST THEN BEGIN
                                        IF ProcurementProcessEvaluation."Vendor Name" <> ProcurementProcessEvaluation2."Vendor Name" THEN BEGIN
                                            TotalScore[1] := ROUND(ProcurementProcessEvaluation2."Total Score", 0.01, '>');
                                            TotalScore[2] := ROUND(ProcurementProcessEvaluation."Total Score", 0.01, '>');
                                            AwardedToTxt1 := STRSUBSTNO(NotHighestScoreVendor, ProcurementProcessEvaluation2."Vendor Name", TotalScore[1], ProcurementProcessEvaluation."Vendor Name", TotalScore[2]);
                                            IF CONFIRM(AwardedToTxt1) THEN BEGIN
                                                AwardSupplier(ProcurementProcessEvaluation, 1);
                                            END;
                                        END ELSE BEGIN
                                            AwardedToTxt1 := STRSUBSTNO(AwardingConfMsg, ProcurementProcessEvaluation."Vendor Name", ProcurementProcessEvaluation."Process No.");
                                            IF CONFIRM(AwardedToTxt1) THEN BEGIN
                                                AwardSupplier(ProcurementProcessEvaluation, 1);
                                            END;
                                        END;
                                    END;
                                END;
                            END;
                    END;

                END;
            DATABASE::"Procurement Request":
                BEGIN
                    ProcurementRequest := Variant;
                    CASE EvaluationStage OF
                        1:
                            BEGIN
                                IF CONFIRM(ForwardToPMConf) THEN BEGIN
                                    ProcurementRequest.TESTFIELD("Attached Evaluation Minutes");
                                    ProcurementRequest."Process Status" := ProcurementRequest."Process Status"::"Procurement Manager";
                                    ProcurementRequest."Evaluation Complete" := TRUE;
                                    ProcurementRequest.MODIFY;
                                    MESSAGE(EvaluationCompleteMsg);
                                END;
                            END;
                        2:
                            BEGIN
                                IF CONFIRM(ReturnToEvaluationConf) THEN BEGIN
                                    ClearEvaluationEntries(ProcurementRequest, 1);
                                END;
                            END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ClearEvaluationEntries(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        SelectedCommitteeMemberpg: Page "Selected Committee Members";
        ProcurementUsers: Page "Procurement Users";
        SelectedCommitteeMember: Record "Selected Committee Member";
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        SupplierEvaluation: Record "Supplier Evaluation";
        ProcurementRequirementSetup: Record "Procurement Requirement Setup";
    begin
        WITH ProcurementRequest DO BEGIN
            "Forwarded to Evaluation" := FALSE;
            "Evaluation Complete" := FALSE;
            MODIFY(TRUE);

            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                REPEAT
                    SupplierEvaluation.RESET;
                    SupplierEvaluation.SETRANGE("Process No.", "No.");
                    SupplierEvaluation.SETRANGE("Vendor No.", ProcurementSupplierSelection."Vendor No.");
                    IF SupplierEvaluation.FINDSET THEN BEGIN
                        SupplierEvaluation.DELETEALL;
                    END;
                    IF ProcurementProcessEvaluation.GET(ProcurementSupplierSelection."Vendor No.", "No.") THEN BEGIN
                        ProcurementProcessEvaluation.DELETE;
                    END;
                UNTIL ProcurementSupplierSelection.NEXT = 0;
            END;
            ForwardProcessToNextStage(ProcurementRequest, 1);
        END;
    end;

    //[Scope('Personalization')]
    procedure AwardSupplier(Variant: Variant; EvaluationStage: Integer);
    var
        SupplierEvaluationListPg: Page "Supplier Evaluation List";
        MissingScoreErr: Label 'Kindly note that Commitee member %1 has not submitted the score on %2.';
        SupplierEvaluation2: Record "Supplier Evaluation";
        AllSubmitted: Integer;
        TotalScore: array[5] of Decimal;
        SupplierEvaluation: Record "Supplier Evaluation";
        GenerateSuccessfulMsg: Label 'Score Generated Successfully.';
        RegretEmailSuccessMsg: Label 'Email Sent Successfully.';
        ProcurementProcessEvaluation: Record "Procurement Process Evaluation";
        ProcurementRequest: Record "Procurement Request";
        RegretEmailSendReqErr: Label 'Kindly send a Regret Email to Supplier %1.';
        EvaluationCompleteMsg: Label 'Evaluation Completed Successfully.';
        RecRef: RecordRef;
        ProcurementProcessEvaluation2: Record "Procurement Process Evaluation";
        AwardingConfMsg: Label '"Are You sure you want to Award %1, process %2? "';
        AwardSuccessMsg: Label 'Award successful to Vendor %1.';
        AwardEmailSuccessMsg: Label 'Award Email Sent to %1';
        AwardEmailConfMsg: Label 'Do you want to send an award Message to Vendor %1?';
        AwardMsg1: Text;
        AwardEmailMsg1: Text;
        AlreadyAwardedSupplierMsg: Label 'This request is already awarded to Vendor %1. \Do you wish to Award Vendor %2?';
        NoQualifiedSupplier: Label 'Kindly note that no supplier has reached the Awarding Stage';
        QualifiedOnStage: Label 'Kindly note that the selected supplier has qualified in %1 stage and is eligible for %2 Stage.\Click Yes to Complete the Evaluation or No to proceed with Evaluation.';
        FieldRef: FieldRef;
        EvalOptionString: Text;
        SelectedOption: Text;
        EvaluationIncompleteErr: Label 'Please Note that Supplier %1 Evaluaton is not complete';
        AwardedToTxt1: Text;
    begin
        RecRef.GETTABLE(Variant);
        CASE RecRef.NUMBER OF
            DATABASE::"Procurement Process Evaluation":
                BEGIN
                    ProcurementProcessEvaluation := Variant;
                    CASE EvaluationStage OF
                        1:
                            BEGIN
                                IF ProcurementRequest.GET(ProcurementProcessEvaluation."Process No.") THEN
                                    ProcurementRequest.TESTFIELD("Evaluation Complete", TRUE);
                                //AwardMsg1 := STRSUBSTNO(AwardingConfMsg,ProcurementProcessEvaluation."Vendor Name",ProcurementProcessEvaluation."Process No.");
                                //IF CONFIRM(AwardMsg1) THEN BEGIN
                                ProcurementProcessEvaluation.Awarded := TRUE;
                                ProcurementProcessEvaluation."Award Approval Date" := TODAY;
                                ProcurementProcessEvaluation.MODIFY(TRUE);

                                SendLetter(ProcurementProcessEvaluation, ProcurementProcessEvaluation."Evaluation Stage"::Awarding);
                                IF ProcurementRequest.GET(ProcurementProcessEvaluation."Process No.") THEN BEGIN
                                    ProcurementRequest."Vendor No." := ProcurementProcessEvaluation."Vendor No.";
                                    ProcurementRequest."Award Initiated" := TRUE;
                                    ProcurementRequest."Process Status" := ProcurementRequest."Process Status"::LPO;
                                    ProcurementRequest.MODIFY;
                                END;
                                MESSAGE(AwardSuccessMsg, ProcurementProcessEvaluation."Vendor Name");
                                //END;
                            END;
                    END;
                END;
        END;
    end;

    //[Scope('Personalization')]
    procedure RequestForProffesionalOpinion(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementMethod: Record "Procurement Method";
        RequestSuccessMsg: Label 'Request sent Successfully.';
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("CEO's Account");
            IF UserSetup.GET(ProcurementSetup."CEO's Account") THEN
                UserSetup.TESTFIELD("E-Mail");
            IF ProcurementMethod.GET("Procurement Method") THEN BEGIN
                EmailDialog.OPEN(MailOpenDialogTxt);
                EmailDialog.UPDATE(1, ProcurementSetup."CEO's Account");
                MailHeader := '';
                MailBody := '';
                MailHeader := STRSUBSTNO(ProfOpinionMailHdrTxt);
                MailBody := STRSUBSTNO(ProfOpinionBodyTxt, ProcurementSetup."CEO's Account", ProcurementMethod.Description, "No.");
                //SendMail(ProcurementSupplierSelection."E-Mail",MailHeader,MailBody);
                EmailDialog.CLOSE;
                "Process Status" := "Process Status"::CEO;
                MODIFY(TRUE);
                MESSAGE(RequestSuccessMsg);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure UpdateTenderApplication(ProcurementRequest: Record "Procurement Request");
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MissingEntry: Label 'Receipt %1 does not exist.';
        TenderFeeErr: Label 'Amount on Receipt is not equal to the Tender Fee';
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementVendorListpg: Page "Procurement Vendor List";
        Vendor: Record Vendor;
    begin
        WITH ProcurementRequest DO BEGIN
            Vendor.RESET;
            Vendor.SETRANGE("Vendor Type", Vendor."Vendor Type"::Normal);
            IF Vendor.FINDSET THEN BEGIN
                CLEAR(ProcurementVendorListpg);
                ProcurementVendorListpg.SETTABLEVIEW(Vendor);
                ProcurementVendorListpg.SETRECORD(Vendor);
                ProcurementVendorListpg.LOOKUPMODE := TRUE;
                IF ProcurementVendorListpg.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    ProcurementVendorListpg.UpdateSupplierSelection(Vendor, "No.");
                END;
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure MakeVendorSelectionEntries(Vendor: Record Vendor; ProcessNo: Code[10]);
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MissingEntry: Label 'Receipt %1 does not exist.';
        TenderFeeErr: Label 'Amount on Receipt is not equal to the Tender Fee';
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        ProcurementVendorListpg: Page "Procurement Vendor List";
        ProcurementRequest: Record "Procurement Request";
        AdditionSuccessMsg: Label 'Supplier %1 added successfully.';
    begin
        WITH Vendor DO BEGIN
            IF NOT ProcurementSupplierSelection.GET("No.", ProcessNo) THEN BEGIN
                ProcurementSupplierSelection.INIT;
                ProcurementSupplierSelection."Vendor No." := "No.";
                ProcurementSupplierSelection.Name := Name;
                ProcurementSupplierSelection."Process No." := ProcessNo;
                ProcurementSupplierSelection."Bank Account" := "Bank Account";
                ProcurementSupplierSelection."Bank Code" := "Bank Code";
                ProcurementSupplierSelection.Address := Address;
                ProcurementSupplierSelection."Company PIN No." := '';
                ProcurementSupplierSelection."Phone No." := "Phone No.";
                ProcurementSupplierSelection."E-Mail" := "E-Mail";
                //ProcurementSupplierSelection.Picture := Picture;
                ProcurementSupplierSelection."Post Code" := "Post Code";
                ProcurementSupplierSelection."Home Page" := "Home Page";
                ProcurementSupplierSelection."Category Code" := "Prequalified Category Code";
                ProcurementSupplierSelection."Category Description" := "Prequalified Category Desc";
                ProcurementSupplierSelection.INSERT;
                COMMIT;
                MESSAGE(AdditionSuccessMsg, Name);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateTenderReceipt(ProcurementSupplierSelection: Record "Procurement Supplier Selection"; ProcessNo: Code[10]): Decimal;
    var
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        MissingEntry: Label 'Receipt %1 does not exist.';
        TenderFeeErr: Label 'Amount on Receipt is not equal to the Tender Fee';
        ProcurementVendorListpg: Page "Procurement Vendor List";
        ProcurementRequest: Record "Procurement Request";
        GLEntry: Record "G/L Entry";
        AmountPaid: Decimal;
    begin
        WITH ProcurementSupplierSelection DO BEGIN
            AmountPaid := 0;
            TESTFIELD("Tender Receipt No.");
            ProcurementSetup.GET;
            ProcurementSetup.TESTFIELD("Tender Fee G/L");
            GLEntry.RESET;
            GLEntry.SETRANGE("G/L Account No.", ProcurementSetup."Tender Fee G/L");
            GLEntry.SETRANGE("Document No.", "Tender Receipt No.");
            GLEntry.SETFILTER(Amount, '<%1', 0);
            IF GLEntry.FINDFIRST THEN BEGIN
                AmountPaid := ABS(GLEntry.Amount);
            END;
        END;
        EXIT(AmountPaid);
    end;

    //[Scope('Personalization')]
    procedure CloseTenderSubmission(ProcurementRequest: Record "Procurement Request"; StageNo: Integer);
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        RFQ_Report: Report "Request for Quotation";
        AllSelected: Integer;
        InvitationInstr: InStream;
        InvitationTitleMsg: Text;
        TermsOfRefTxt: Label 'Terms Of Reference';
        ProposalDocTxt: Label 'Proposal Document';
        InvitationMessage: Text;
        CloseSuccessTxt: Label 'Tender submission has been closed successfully.';
        TenderCloseConfMsg: Label 'Do you want to Close the Tender Submission process?';
    begin
        WITH ProcurementRequest DO BEGIN
            CheckIfSuppliersSelected(ProcurementRequest);
            ValidateTenderSubmissionEntries(ProcurementRequest);
            //ValidateTenderSubmissionAttachments(ProcurementRequest);
            IF CONFIRM(TenderCloseConfMsg) THEN BEGIN
                ProcurementSetup.GET;
                "Process Status" := "Process Status"::"Pending Opening";
                MODIFY(TRUE);
                MESSAGE(CloseSuccessTxt);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateTenderSubmissionEntries(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        LessSubmissionErr: Label 'Kindly Note that the Tender submission(s) are %1 which does not meet the needed submission of %2.\ Do you wish to Proceed?';
        NoSubmissionErr: Label 'Kindly note that no Supplier has cleared the tender fee!!';
        SubmissionsTxt: array[5] of Text;
        LessSubmissionErr2: Label 'Kindly make sure the tender submissions meet the needed Threshhold of %1 Submissions!!';
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE("Tender Fee Paid", TRUE);
            IF ProcurementSupplierSelection.FINDSET THEN BEGIN
                IF ProcurementSupplierSelection.COUNT < "Minimum Tender Submissions" THEN BEGIN
                    SubmissionsTxt[1] := STRSUBSTNO(LessSubmissionErr, ProcurementSupplierSelection.COUNT, "Minimum Tender Submissions");
                    SubmissionsTxt[2] := STRSUBSTNO(LessSubmissionErr2, "Minimum Tender Submissions");
                    IF NOT CONFIRM(SubmissionsTxt[1]) THEN
                        ERROR(SubmissionsTxt[2]);
                END;
                REPEAT
                    ProcurementSupplierSelection.TESTFIELD(Name);
                    ProcurementSupplierSelection.TESTFIELD("E-Mail");
                UNTIL ProcurementSupplierSelection.NEXT = 0;
            END ELSE BEGIN
                ERROR(NoSubmissionErr);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure ValidateTenderSubmissionAttachments(ProcurementRequest: Record "Procurement Request");
    var
        ProcurementSupplierSelection: Record "Procurement Supplier Selection";
        LessSubmissionErr: Label 'Kindly Note that the Tender submission(s) are %1 which does not meet the needed submission of %2.\ Do you wish to Proceed?';
        NoSubmissionErr: Label 'Kindly note that no Supplier has their Tender Document Attached!!';
        SubmissionsTxt: array[5] of Text;
        LessSubmissionErr2: Label 'Kindly make sure the tender submissions meet the needed Threshhold of %1 Submissions!!';
    begin
        WITH ProcurementRequest DO BEGIN
            ProcurementSupplierSelection.RESET;
            ProcurementSupplierSelection.SETRANGE("Process No.", "No.");
            ProcurementSupplierSelection.SETRANGE("Attach Procurement Document", TRUE);
            IF NOT ProcurementSupplierSelection.FINDSET THEN BEGIN
                ERROR(NoSubmissionErr);
            END;
        END;
    end;

    //[Scope('Personalization')]
    procedure OpenProcurementRequest(ProcessNo: Code[20]);
    var
        TermsOfRefTxt: Label 'Terms Of Reference';
        ProposalDocTxt: Label 'Proposal Document';
        CloseSuccessTxt: Label 'Tender submission has been closed successfully.';
        TenderCloseConfMsg: Label 'Do you want to Close the Tender Submission process?';
        ProcurementRequest: Record "Procurement Request";
        OpenTenderCardPg: Page "Open Tender Card";
        RequestForProposalCardPg: Page "Request For Proposal Card";
        RestrictedTenderCardPg: Page "Restricted Tender Card";
    begin
        IF ProcurementRequest.GET(ProcessNo) THEN BEGIN
            CASE ProcurementRequest."Procurement Option" OF
                ProcurementRequest."Procurement Option"::"Open Tender":
                    BEGIN
                        CLEAR(OpenTenderCardPg);
                        OpenTenderCardPg.SETTABLEVIEW(ProcurementRequest);
                        OpenTenderCardPg.SETRECORD(ProcurementRequest);
                        OpenTenderCardPg.LOOKUPMODE(TRUE);
                        OpenTenderCardPg.RUN;
                    END;
                ProcurementRequest."Procurement Option"::"Request For Proposal":
                    BEGIN
                        CLEAR(RequestForProposalCardPg);
                        RequestForProposalCardPg.SETTABLEVIEW(ProcurementRequest);
                        RequestForProposalCardPg.SETRECORD(ProcurementRequest);
                        RequestForProposalCardPg.LOOKUPMODE(TRUE);
                        RequestForProposalCardPg.RUN;
                    END;
                ProcurementRequest."Procurement Option"::"Restricted Tender":
                    BEGIN
                        CLEAR(RestrictedTenderCardPg);
                        RestrictedTenderCardPg.SETTABLEVIEW(ProcurementRequest);
                        RestrictedTenderCardPg.SETRECORD(ProcurementRequest);
                        RestrictedTenderCardPg.LOOKUPMODE(TRUE);
                        RestrictedTenderCardPg.RUN;
                    END;
            END;
        END;
    end;
}

