page 51030 "Supervisor File Approval Card1"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "File Issuance";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Request ID"; "Request ID")
                {
                }
                field("Request Date"; "Request Date")
                {
                }
                field("Required Date"; "Required Date")
                {
                    Editable = false;
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    Editable = false;
                }
                field("Due Date"; "Due Date")
                {
                }
                field("Requisiton By"; "Requisiton By")
                {
                }
                field(Reason; Reason)
                {
                    Editable = false;
                }
                field("Request Status"; "Request Status")
                {
                }
            }
            part("Registry Files Subform"; 50962)
            {
                Caption = 'Registry Files Request List';
                Editable = false;
                SubPageLink = "Request ID" = FIELD("Request ID");
                ApplicationArea = All;
            }
            group(Remarks)
            {
                field("Approval Comment"; "Approval Comment")
                {

                    trigger OnValidate();
                    begin
                        "Approver ID" := USERID;
                    end;
                }
                field("Approver ID"; "Approver ID")
                {
                }
                field("Approved Date"; "Approved Date")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Notify Registry")
            {
                Image = SendConfirmation;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.NotifyRegistry(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Reject Request")
            {
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.HODReject(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Send Approval Request")
            {
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.NotifyRegistry(Rec);
                    // IF ApprovalsMgmt.CheckRegistryFileApprovalPossible(Rec) THEN BEGIN
                    // ApprovalsMgmt.OnSendRegistryFileForApproval(Rec);
                    // END;
                    CurrPage.CLOSE;
                end;
            }
            action("Cancel Approval Request")
            {
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    // ApprovalsMgmt.OnCancelRegistryFileApprovalRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Approver ID" := USERID;
    end;

    trigger OnOpenPage();
    begin
        /*User.GET(USERID);
        IF User."HOD Approver(Registry)"=FALSE THEN BEGIN
          ERROR('You have not been set up as a HOD Approver for registry Requests');
        END;
        RequestsRec.Status2:=RequestsRec.Status2::"Pending Approval";
        */

    end;

    var
        FileRegistry: Record "Registry File Status";
        Simple: Boolean;
        User: Record "User Setup";
        ApprovedRequests: Integer;
        RequestsRec: Record "Registry Files Line";
        HODApproval: Boolean;
        FileNo: Code[10];
        FileName: Text;
        Comment: Text;
        smtprec: Record "SMTP Mail Setup";
        smtpcu: Codeunit "SMTP Mail";
        bddialog: Dialog;
        mailheader: Text;
        mailbody: Text;
        RegistryFilesLines: Record "Registry Files Line";
        RegistrySetUp: Record "Registry SetUp";
        RegisterLines: Record "Registry Files Line";
        ApprovedDate: Date;
        ApprovedTime: Time;
        RegistryManagement: Codeunit "Registry Management2";
    //ApprovalsMgmt: Codeunit ApprovalsMgmtExt;
}

