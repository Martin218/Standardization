page 55027 "Group Attendance"
{
    // version MC2.0

    PageType = Document;
    SourceTable = "Group Attendance Header";

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
                field("Meeting Venue"; "Meeting Venue")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Last Meeting Date"; "Last Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Current Meeting Date"; "Current Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Current Meeting Time"; "Current Meeting Time")
                {
                    ApplicationArea = All;
                }
                field("Actual Meeting Date"; "Actual Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Actual Meeting Time"; "Actual Meeting Time")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            part("Group Attendance List"; "Group Attendance Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
                ApplicationArea = All;
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
                field("Validated By"; "Validated By")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Validated Date"; "Validated Date")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
                field("Validated Time"; "Validated Time")
                {
                    Importance = Additional;
                    ApplicationArea = All;
                }
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
            action("Validate Attendance")
            {
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = IsVisibleValidateAttendance;

                trigger OnAction()
                begin
                    IF CONFIRM(Text000, TRUE, "No.") THEN BEGIN
                        // MicroCreditManagement.ValidateGroupAttendance(Rec) THEN
                        //  MESSAGE(Text001, "No.");
                    END;
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

                trigger OnAction()
                begin
                    RESET;
                    SETRANGE("No.", "No.");
                    REPORT.RUN(55000, TRUE, FALSE, Rec);
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
        Text000: Label 'Are you sure you want to validate attendance %1?';
        Member: Record Member;
        Text001: Label 'Attendance %1 has been validated successfully';
        // MicroCreditManagement: Codeunit "55001";
        GroupAttendanceLine: Record "Group Attendance Line";
        IsVisibleValidateAttendance: Boolean;

    local procedure PageVisibility()
    begin
        IF Status = Status::New THEN
            IsVisibleValidateAttendance := TRUE
        ELSE
            IsVisibleValidateAttendance := FALSE;
    end;

    local procedure PageEditable()
    begin
        IF Status = Status::New THEN
            CurrPage.EDITABLE := TRUE
        ELSE
            CurrPage.EDITABLE := FALSE;
    end;
}

