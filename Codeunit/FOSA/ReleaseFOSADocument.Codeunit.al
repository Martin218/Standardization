codeunit 50002 "Release FOSA document"
{
    // version TL2.0


    trigger OnRun()
    begin
    end;

    var
        Text001: Label 'There is nothing to release for the document of type %1 with the number %2.';
        Text002: Label 'This document can only be released when the approval process is complete.';
        Text003: Label 'The approval process must be cancelled or completed to reopen this document.';
        Text004: Label 'Are you sure you want to confirm approval for this document?';
        Text005: Label '%1 %2 has been approved successfully.';
        NoSeriesManagement: Codeunit NoSeriesManagement;
        Text006: Label '%1 %2 has been rejected sucessfully.';
        RejectAction: Text[50];
        SelectedAction: Integer;
        Text007: Label 'Reset to New Stage,Reject Completely';
        Text008: Label 'Choose Reject Action';
        Text009: Label '%1 %2 has been reset to New Stage.';

    procedure PerformCheckAndReleaseMemberApplication(var MemberApplication: Record "Member Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with MemberApplication do begin
            If ApprovalsMgmt.IsMemberApplicationApprovalsWorkflowEnabled(MemberApplication) AND
              (MemberApplication.Status = MemberApplication.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, MemberApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseMemberApplication(MemberApplication);
            CreateMember(MemberApplication);
        end;
    end;

    procedure ReopenMemberApplication(var MemberApplication: Record "Member Application")
    begin
        with MemberApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMemberApplication(var MemberApplication: Record "Member Application")
    begin
        with MemberApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MemberApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MemberApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMemberApplication(var MemberApplication: Record "Member Application")
    begin
    end;

    local procedure CreateMember(var MemberApplication: Record "Member Application")
    var
        Member: Record Member;
        CBSSetup: Record "CBS Setup";
        NoSeriesManagement: Codeunit NoSeriesManagement;
        MemberNo: Code[20];
        Member2: Record Member;
    begin
        with MemberApplication do begin
            CBSSetup.GET;
            If CBSSetup."Member No. Format" = CBSSetup."Member No. Format"::"No. Series Only" then
                MemberNo := NoSeriesManagement.GetNextNo(CBSSetup."Member Nos.", TODAY, TRUE);
            If CBSSetup."Member No. Format" = CBSSetup."Member No. Format"::"Branch Code+No. Series" then
                MemberNo := "Global Dimension 1 Code" + NoSeriesManagement.GetNextNo(CBSSetup."Member Nos.", TODAY, TRUE);

            Member.TRANSFERFIELDS(MemberApplication);
            Member."No." := MemberNo;
            If Category = Category::Individual then begin
                Member2.Reset();
                Member2.SetRange("Application No.", "Group Link No.");
                If Member2.FindFirst() then
                    Member."Group Link No." := Member2."No.";
            end;
            Member."Application No." := MemberApplication."No.";
            Member.Status := Member.Status::Active;
            If Member.INSERT then
                CreateDefaultAccount(Member);
        end;
    end;

    local procedure CreateDefaultAccount(var Member: Record Member)
    var
        AccountType: Record "Account Type";
        CBSSetup: Record "CBS Setup";
        AccountNo: Code[20];
        Customer: Record Customer;
        Vendor: Record Vendor;

        documentNo: Code[20];

    begin
        CBSSetup.GET;
        with Member do begin
            AccountType.RESET;
            AccountType.SETRANGE("Open Automatically", TRUE);
            If AccountType.FINDSET then begin
                REPEAT
                    documentNo := NoSeriesManagement.GetNextNo(CBSSetup."Account Opening Nos.", TODAY, TRUE);
                    If CBSSetup."Account No. Format" = CBSSetup."Account No. Format"::"No. Series Only" then
                        AccountNo := documentNo;
                    If CBSSetup."Account No. Format" = CBSSetup."Account No. Format"::"Member No.+Account Type" then
                        AccountNo := "No." + AccountType.Code;


                    If ((AccountType.Type = AccountType.Type::Loan)) then begin
                        Customer.INIT;
                        Customer."No." := AccountNo;
                        Customer.Name := AccountType.Description;
                        Customer."Customer Posting Group" := AccountType."Posting Group";
                        Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        Customer."Phone No." := "Phone No.";
                        Customer."E-Mail" := "E-mail";
                        Customer."Account Type" := AccountType.Code;
                        Customer.Status := Customer.Status::Active;
                        Customer."Member No." := "No.";
                        Customer."Member Name" := "Full Name";
                        Customer.INSERT;
                    end ELSE begin
                        Vendor.INIT;
                        Vendor."No." := AccountNo;
                        Vendor.Name := AccountType.Description;
                        Vendor."Vendor Posting Group" := AccountType."Posting Group";
                        Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                        Vendor."Phone No." := "Phone No.";
                        Vendor."E-Mail" := "E-mail";
                        Vendor."Account Type" := AccountType.Code;
                        Vendor."Member No." := "No.";
                        Vendor.Status := Vendor.Status::Active;
                        Vendor."Member Name" := "Full Name";
                        Vendor.INSERT;
                    end;
                UNTIL AccountType.NEXT = 0;
            end;
        end;
    end;

    procedure PerformCheckAndReleaseAccountOpening(var AccountOpening: Record "Account Opening")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with AccountOpening do begin
            If ApprovalsMgmt.IsAccountOpeningApprovalsWorkflowEnabled(AccountOpening) AND
             (AccountOpening.Status = AccountOpening.Status::New) then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, AccountOpening.TABLECAPTION, "No.");
            end;
            OnAfterReleaseAccountOpening(AccountOpening);
            CreateAccount(AccountOpening);
        end;
    end;

    procedure ReopenAccountOpening(var AccountOpening: Record "Account Opening")
    begin
        with AccountOpening do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectAccountOpening(var AccountOpening: Record "Account Opening")
    begin
        with AccountOpening do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, AccountOpening.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, AccountOpening.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseAccountOpening(var AccountOpening: Record "Account Opening")
    begin
    end;

    procedure CreateAccount(var AccountOpening: Record "Account Opening")
    var
        Member: Record Member;
        AccountType: Record "Account Type";
        Customer: Record Customer;
        Vendor: Record Vendor;
    begin
        with AccountOpening do begin
            If Member.GET("Member No.") then;
            If AccountType.GET("Account Type") then
                If ((AccountType.Type = AccountType.Type::Loan)) then begin
                    Customer.INIT;
                    Customer."No." := "Account No.";
                    Customer.Name := Description;
                    Customer."Customer Posting Group" := AccountType."Posting Group";
                    Customer."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    Customer."Phone No." := Member."Phone No.";
                    Customer."E-Mail" := Member."E-mail";
                    Customer."Account Type" := "Account Type";
                    Customer.Status := Customer.Status::Active;
                    Customer."Member No." := "Member No.";
                    Customer."Member Name" := "Member Name";
                    Customer.INSERT;
                end ELSE begin
                    Vendor.INIT;
                    Vendor."No." := "Account No.";
                    Vendor.Name := Description;
                    Vendor."Vendor Posting Group" := AccountType."Posting Group";
                    Vendor."Global Dimension 1 Code" := "Global Dimension 1 Code";
                    Vendor."Phone No." := Member."Phone No.";
                    Vendor."E-Mail" := Member."E-mail";
                    Vendor."Account Type" := "Account Type";
                    Vendor."Member No." := "Member No.";
                    Vendor."Member Name" := "Member Name";
                    Vendor."Vendor Type" := Vendor."Vendor Type"::"FOSA";
                    Vendor.Status := Vendor.Status::Active;
                    Vendor.INSERT;
                end;
        end;
    end;

    procedure PerformCheckAndReleaseMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with MemberActivationHeader do begin
            If ApprovalsMgmt.IsMemberActivationDeactivationApprovalsWorkflowEnabled(MemberActivationHeader) AND
              (MemberActivationHeader.Status = MemberActivationHeader.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, MemberActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseMemberActivationDeactivation(MemberActivationHeader);
        end;
    end;

    procedure ReopenMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
        with MemberActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
        with MemberActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, MemberActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, MemberActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseMemberActivationDeactivation(var MemberActivationHeader: Record "Member Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseAccountActivationDeactivation(var AccountActivationHeader: Record "Account Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with AccountActivationHeader do begin
            If ApprovalsMgmt.IsAccountActivationDeactivationApprovalsWorkflowEnabled(AccountActivationHeader) AND
              (AccountActivationHeader.Status = AccountActivationHeader.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, AccountActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseAccountActivationDeactivation(AccountActivationHeader);
        end;
    end;

    procedure ReopenAccountActivationDeactivation(var AccountActivationHeader: Record "Account Activation Header")
    begin
        with AccountActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectAccountActivationDeactivation(var AccountActivationHeader: Record "Account Activation Header")
    begin
        with AccountActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, AccountActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, AccountActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseAccountActivationDeactivation(var AccountActivationHeader: Record "Account Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseSpotCashApplication(var SpotCashApplication: Record "SpotCash Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with SpotCashApplication do begin
            If ApprovalsMgmt.IsSpotCashApplicationApprovalsWorkflowEnabled(SpotCashApplication) AND
              (SpotCashApplication.Status = SpotCashApplication.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, SpotCashApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseSpotCashApplication(SpotCashApplication);
            CreateSpotCashMember(SpotCashApplication);
        end;
    end;

    procedure ReopenSpotCashApplication(var SpotCashApplication: Record "SpotCash Application")
    begin
        with SpotCashApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectSpotCashApplication(var SpotCashApplication: Record "SpotCash Application")
    begin
        with SpotCashApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, SpotCashApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, SpotCashApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseSpotCashApplication(var SpotCashApplication: Record "SpotCash Application")
    begin
    end;

    local procedure CreateSpotCashMember(var SpotCashAplication: Record "SpotCash Application")
    var
        SpotCashMember: Record "SpotCash Member";
    begin
        with SpotCashAplication do begin
            SpotCashMember.Init();
            SpotCashMember."Member No." := "Member No.";
            SpotCashMember."Member Name" := "Member Name";
            SpotCashMember."Account No." := "Account No.";
            SpotCashMember."Account Name" := "Account Name";
            SpotCashMember."Phone No." := "Phone No.";
            SpotCashMember.Status := SpotCashMember.Status::Active;
            SpotCashMember."Service Type" := "Service Type";
            SpotCashMember."Created By" := "Created By";
            SpotCashMember."Created Date" := Today;
            SpotCashMember."Created Time" := Time;
            SpotCashMember."Created By Host IP" := "Created By Host IP";
            SpotCashMember."Created By Host MAC" := "Created By Host MAC";
            SpotCashMember."Created By Host Name" := "Created By Host Name";
            GetHostInfo(HostName, HostIP, HostMac);
            SpotCashMember."Approved By Host IP" := HostIP;
            SpotCashMember."Approved By Host MAC" := HostMac;
            SpotCashMember."Approved By Host Name" := HostName;
            SpotCashMember.Insert();
        end;
    end;

    procedure PerformCheckAndReleaseSpotCashActivationDeactivation(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with SpotCashActivationHeader do begin
            If ApprovalsMgmt.IsSpotCashActivationDeactivationApprovalsWorkflowEnabled(SpotCashActivationHeader) AND
              (SpotCashActivationHeader.Status = SpotCashActivationHeader.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, SpotCashActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseSpotCashActivationDeactivation(SpotCashActivationHeader);
        end;
    end;

    procedure ReopenSpotCashActivationDeactivation(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    begin
        with SpotCashActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectSpotCashActivationDeactivation(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    begin
        with SpotCashActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, SpotCashActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, SpotCashActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseSpotCashActivationDeactivation(var SpotCashActivationHeader: Record "SpotCash Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseATMApplication(var ATMApplication: Record "ATM Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMApplication do begin
            If ApprovalsMgmt.IsATMApplicationApprovalsWorkflowEnabled(ATMApplication) AND
              (ATMApplication.Status = ATMApplication.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMApplication(ATMApplication);
        end;
    end;

    procedure ReopenATMApplication(var ATMApplication: Record "ATM Application")
    begin
        with ATMApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMApplication(var ATMApplication: Record "ATM Application")
    begin
        with ATMApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMApplication(var ATMApplication: Record "ATM Application")
    begin
    end;

    procedure PerformCheckAndReleaseATMCollection(var ATMCollection: Record "ATM Collection")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMCollection do begin
            If ApprovalsMgmt.IsATMCollectionApprovalsWorkflowEnabled(ATMCollection) AND
              (ATMCollection.Status = ATMCollection.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMCollection.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMCollection(ATMCollection);
            CreateATMMember(ATMCollection);
        end;
    end;

    procedure ReopenATMCollection(var ATMCollection: Record "ATM Collection")
    begin
        with ATMCollection do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMCollection(var ATMCollection: Record "ATM Collection")
    begin
        with ATMCollection do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMCollection.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMCollection.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMCollection(var ATMCollection: Record "ATM Collection")
    begin
    end;

    local procedure CreateATMMember(var ATMCollection: Record "ATM Collection")
    var
        ATMMember: Record "ATM Member";
        ATMApplication: Record "ATM Application";
    begin
        with ATMCollection do begin
            ATMMember.Init();
            ATMMember."Card No." := "Card No.";
            ATMMember."Member No." := "Member No.";
            ATMMember."Member Name" := "Member Name";
            ATMMember."Account No." := "Account No.";
            ATMMember."Account Name" := "Account Name";
            ATMMember.Status := ATMMember.Status::Active;
            IF ATMApplication.Get("Application No.") THEN begin
                ATMMember."SMS Alert on" := ATMApplication."SMS Alert on";
                ATMApplication."E-Mail Alert on" := ATMApplication."E-Mail Alert on";
            END;
            ATMMember."Application No." := "Application No.";
            ATMMember."Collection No." := "No.";
            ATMMember.Insert();
        end;
    end;


    procedure PerformCheckAndReleaseATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ATMActivationHeader do begin
            If ApprovalsMgmt.IsATMActivationDeactivationApprovalsWorkflowEnabled(ATMActivationHeader) AND
              (ATMActivationHeader.Status = ATMActivationHeader.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ATMActivationHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseATMActivationDeactivation(ATMActivationHeader);
        end;
    end;

    procedure ReopenATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        with ATMActivationHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
        with ATMActivationHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ATMActivationHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ATMActivationHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseATMActivationDeactivation(var ATMActivationHeader: Record "ATM Activation Header")
    begin
    end;

    procedure PerformCheckAndReleaseChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ChequeBookApplication do begin
            If ApprovalsMgmt.IsChequeBookApplicationApprovalsWorkflowEnabled(ChequeBookApplication) AND
              (ChequeBookApplication.Status = ChequeBookApplication.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ChequeBookApplication.TABLECAPTION, "No.");
            end;
            OnAfterReleaseChequeBookApplication(ChequeBookApplication);
            FlagChequeBook(ChequeBookApplication);
            FOSAManagement.PostChequeBook(ChequeBookApplication);
        end;
    end;

    procedure ReopenChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        with ChequeBookApplication do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
        with ChequeBookApplication do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ChequeBookApplication.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ChequeBookApplication.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseChequeBookApplication(var ChequeBookApplication: Record "Cheque Book Application")
    begin
    end;

    procedure FlagChequeBook(var ChequeBookApplication: Record "Cheque Book Application")
    var
        ChequeBook: Record "Cheque Book";
    begin
        with ChequeBookApplication do begin
            ChequeBook.Reset();
            ChequeBook.SetRange("No.", "Cheque Book No.");
            IF ChequeBook.FindFirst() THEN begin
                ChequeBook.Status := ChequeBook.Status::Issued;
                ChequeBook.Modify();
            END;
        end;
    end;

    procedure PerformCheckAndReleaseChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
    begin
        with ChequeClearanceHeader do begin
            If ApprovalsMgmt.IsChequeClearanceApprovalsWorkflowEnabled(ChequeClearanceHeader) AND
              (ChequeClearanceHeader.Status = ChequeClearanceHeader.Status::"Pending Approval") then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;

            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                If modify(true) then
                    MESSAGE(Text005, ChequeClearanceHeader.TABLECAPTION, "No.");
            end;
            OnAfterReleaseChequeClearance(ChequeClearanceHeader);
            FOSAManagement.PostChequeClearance(ChequeClearanceHeader);
        end;
    end;

    procedure ReopenChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        with ChequeClearanceHeader do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
        with ChequeClearanceHeader do begin
            RejectAction := Text007;
            SelectedAction := DIALOG.STRMENU(RejectAction, 1, Text008);
            CASE SelectedAction OF
                1:
                    begin
                        If Status = Status::New then
                            exit;
                        Status := Status::New;
                        If modify(true) then
                            MESSAGE(Text009, ChequeClearanceHeader.TABLECAPTION, "No.");
                    end;
                2:
                    begin
                        If Status = Status::Rejected then
                            exit;
                        Status := Status::Rejected;
                        If modify(true) then
                            MESSAGE(Text006, ChequeClearanceHeader.TABLECAPTION, "No.");
                    end;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseChequeClearance(var ChequeClearanceHeader: Record "Cheque Clearance Header")
    begin
    end;

    procedure GetHostInfo(var HName: Code[20]; var HIP: Code[20]; var HMac: Code[20])
    var
        Dns: dotNet Dns;
        GetIPMac2: dotNet GetIPMac;
        IPHostEntry: dotNet IPHostEntry;
        IPAddress: dotNet IPAddress;
    begin
        HName := Dns.GetHostName();
        Clear(GetIPMac2);
        GetIPMac2 := GetIPMac2.GetIPMac();
        HIP := GetIPMac2.GetIP(HName);
        HMac := GetIPMac2.GetMac();
    end;

    procedure PerformCheckAndReleaseTellerTransaction(var Transactions: Record Transaction);
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        TellerTransaction: Page "Teller Transaction";
    begin
        with Transactions do begin
            If ApprovalsMgmt.IsTellerTransactionWorkflowEnabled(Transactions) AND
              (Transactions.Status = Transactions.Status::New) then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                Authorised := Authorised::Yes;
                "Supervisor Checked" := TRUE;
                MODIfY;
            end;
            OnAfterReleaseTellerTransaction(Transactions);
        end;
    end;

    procedure ReopenTellerTransaction(var Transactions: Record Transaction);
    begin
        with Transactions do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectTellerTransaction(var Transactions: Record Transaction);
    begin
        with Transactions do begin
            If Status = Status::New then
                exit;
            Status := Status::Rejected;
            modify(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseTellerTransaction(var Transactions: Record Transaction);
    begin
    end;

    procedure PerformCheckAndReleaseCloseTill(var TreasuryTransaction: Record "Treasury Transaction");
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt Ext";
        TellerTransaction: Page "Teller Transaction";
    begin
        with TreasuryTransaction do begin
            If ApprovalsMgmt.IsCloseTillWorkflowEnabled(TreasuryTransaction) AND
              (TreasuryTransaction.Status = TreasuryTransaction.Status::New) then
                ERROR(Text002);
            If Status = Status::Approved then
                exit;
            If Status = Status::"Pending Approval" then begin
                Status := Status::Approved;
                MODIfY;
            end;
            OnAfterReleaseCloseTill(TreasuryTransaction);
        end;
    end;

    procedure ReopenCloseTill(var TreasuryTransaction: Record "Treasury Transaction");
    begin
        with TreasuryTransaction do begin
            If Status = Status::New then
                exit;
            Status := Status::New;
            modify(true);
        end;
    end;

    procedure RejectCloseTill(var TreasuryTransaction: Record "Treasury Transaction");
    begin
        with TreasuryTransaction do begin
            If Status = Status::New then
                exit;
            Status := Status::Rejected;
            modify(true);
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterReleaseCloseTill(var TreasuryTransaction: Record "Treasury Transaction");
    begin
    end;

    var
        HostName: Code[20];
        HostIP: Code[20];
        HostMac: Code[20];
        FOSAManagement: Codeunit "FOSA Management";
}

