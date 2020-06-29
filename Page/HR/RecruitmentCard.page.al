page 50478 "Recruitment Card"
{
    // version TL2.0

    DeleteAllowed = false;
    PageType = Card;
    SourceTable = 50246;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Recruitment Needs Code"; "Recruitment Needs Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Type"; "Employee Type")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Date"; "Recruitment Date")
                {
                    Caption = 'Date Employee is Required';
                    ApplicationArea = All;
                }
                field("Department Requested"; "Department Requested")
                {
                    Caption = 'Department.';
                    ApplicationArea = All;
                }
                field("Job ID"; "Job ID")
                {
                    ApplicationArea = All;
                }
                field("Job Title Request"; "Job Title Request")
                {
                    Caption = 'Job Title.';
                    ApplicationArea = All;
                }
                field(Priority; Priority)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Requested Positions"; "Requested Positions")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Type"; "Recruitment Type")
                {
                    ApplicationArea = All;
                }
                field("Need Source"; "Need Source")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Required Qualifications"; "Required Qualifications")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Expected Responsibilities"; "Expected Responsibilities")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
            }
            group("HR Recommendation")
            {
                Caption = 'HR Recommendation';
                Visible = ShowComments;
                field("HR Recommendation1"; "HR Recommendation1")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(HR; HR)
                {
                    ApplicationArea = All;
                }
                field("HR Approved Date"; "HR Approved Date")
                {
                    ApplicationArea = All;
                }
            }
            group("CEO Recommendation/Approval")
            {
                Caption = 'CEO Recommendation/Approval';
                Visible = ShowComments;
                field("CEO Recommendation"; "CEO Recommendation")
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(CEO; CEO)
                {
                    ApplicationArea = All;
                }
                field("CEO Approved Date"; "CEO Approved Date")
                {
                    ApplicationArea = All;
                }
            }
            group("Request Details")
            {
                Caption = 'Request Details';
                field("Request Done By"; "Request Done By")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
                {
                    ApplicationArea = All;
                }
                field("Approved positions"; "Approved positions")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    Editable = false;
                    ApplicationArea = All;
                }
            }
            part("Recruited Employees"; "Employees Recruited")
            {
                SubPageLink = "Recruitment Code" = FIELD("Recruitment Needs Code");
                Visible = false;
                ApplicationArea = All;
            }
            group("Shortlisting Criteria")
            {
                Caption = 'Shortlisting Criteria';
                field("No. of Years of Experience"; "No. of Years of Experience")
                {
                    ApplicationArea = All;
                }
                field("Level of Education"; "Level of Education")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Recruitment Approval Report")
            {
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    /*Recruitment.RESET;
                    Recruitment.SETRANGE("Recruitment Needs Code","Recruitment Needs Code");
                    IF Recruitment.FIND('-') THEN BEGIN
                       REPORT.RUN(75095,TRUE,FALSE,Recruitment);
                    END;*/

                end;
            }
            action(SendRecruitmentApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Send A&pproval Request';
                Image = SendApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Request approval of the document.';
                Visible = ShowSendForApproval;

                trigger OnAction();
                begin
                    if Confirm(Text000) THEN begin
                        IF ApprovalsMgmtExt.CheckRecruitmentRequestApprovalPossible(Rec) THEN BEGIN
                            ApprovalsMgmtExt.OnSendRecruitmentRequestForApproval(Rec);
                            Message(Text001);
                        end;
                    end;
                    CurrPage.CLOSE;
                end;
            }
            action(CancelRecruitmentApprovalRequest)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Cancel Approval Re&quest';
                Image = CancelApprovalRequest;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ToolTip = 'Cancel the approval request.';
                // Visible = ShowCancelApprovalRequest;

                trigger OnAction();
                begin
                    ApprovalsMgmtExt.OnCancelRecruitmentRequestApprovalRequest(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action(Approve)
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                 Visible = ShowApprove;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "Recruitment Needs Code");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                      ApprovalEntry.SETRANGE("Approver ID", USERID);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.ApproveApprovalRequests(ApprovalEntry);
                    END ELSE BEGIN
                        ERROR(Error000);
                    END;
                end;
            }
            action(Reject)
            {
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                  Visible = ShowReject;

                trigger OnAction();
                begin
                    ApprovalEntry.RESET;
                    ApprovalEntry.SETRANGE("Document No.", "Recruitment Needs Code");
                    ApprovalEntry.SETRANGE(Status, ApprovalEntry.Status::Open);
                     ApprovalEntry.SETRANGE("Approver ID", USERID);
                    IF ApprovalEntry.FINDFIRST THEN BEGIN
                        ApprovalsMgmt.RejectApprovalRequests(ApprovalEntry);
                    END ELSE BEGIN
                        ERROR(Error001);
                    END;
                end;
            }
            action("Employees Recruited")
            {
                Image = Employee;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page 50479;
                ApplicationArea = All;
                RunPageLink = "Recruitment Code" = FIELD("Recruitment Needs Code");
                Visible = SeeRecruitedEmployees;
            }
            action("Shortlist Applicants")
            {
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                Visible = SeeShortlist;

                trigger OnAction();
                begin
                    HRManagement."Shortlist Applicants"("Recruitment Needs Code");
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Visibility;
    end;

    var
        Error000: Label 'There is no record to approve!';
        Error001: Label 'There is no record to reject!';

        Text000: Label 'Are you sure you want to send this request for approval?';

        Text001: Label 'Request submitted successfully';
        ApprovalEntry: Record 454;
        ApprovalsMgmt: Codeunit 1535;
        ApprovalsMgmtExt: Codeunit 50054;
        HRManagement: Codeunit 50050;
        ShowSendForApproval: Boolean;
        ShowCancelApprovalRequest: Boolean;
        ShowApprove: Boolean;
        ShowReject: Boolean;
        SeeRecruitedEmployees: Boolean;
        ShowComments: Boolean;
        SeeShortlist: Boolean;


    local procedure Visibility();
    begin
        IF Status = Status::Open THEN BEGIN
            CurrPage.EDITABLE(TRUE);
            ShowSendForApproval := TRUE;
            ShowCancelApprovalRequest := FALSE;
            ShowReject := FALSE;
            ShowApprove := FALSE;
            SeeRecruitedEmployees := FALSE;
            ShowComments := FALSE;
            SeeShortlist := FALSE;
        END;
        IF Status = Status::"Pending Approval" THEN BEGIN
            CurrPage.EDITABLE(FALSE);
            SeeShortlist := FALSE;
            ShowSendForApproval := FALSE;
            SeeRecruitedEmployees := FALSE;
            ShowComments := TRUE;
            IF "Requested By" = USERID THEN BEGIN
                ShowCancelApprovalRequest := TRUE;
                ShowReject := FALSE;
                ShowApprove := FALSE;
            END ELSE BEGIN
                ShowCancelApprovalRequest := FALSE;
                ShowReject := TRUE;
                ShowApprove := TRUE;
            END;
        END;
        IF (Status = Status::Rejected) OR (Status = Status::Released) THEN BEGIN
            SeeShortlist := TRUE;
            CurrPage.EDITABLE(FALSE);
            ShowSendForApproval := FALSE;
            ShowCancelApprovalRequest := FALSE;
            SeeRecruitedEmployees := TRUE;
            ShowComments := FALSE;
            ShowReject := FALSE;
            ShowApprove := FALSE;
        END;
    end;
}

