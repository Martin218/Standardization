page 50436 "Leave Journal"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50224;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No"; "Entry No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No"; "Document No")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Leave Period"; "Leave Period")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {

                    trigger OnValidate();
                    begin
                        Employee.RESET;
                        Employee.SETRANGE("No.", "Employee No.");
                        IF Employee.FIND('-') THEN BEGIN
                            "Employee Name" := Employee."Search Name";
                        END;
                    end;
                }
                field("Employee Name"; "Employee Name")
                {
                    Caption = 'Employee Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Leave Type"; "Leave Type")
                {
                    ApplicationArea = All;
                }
                field("Entry Type"; "Entry Type")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field(Days; Days)
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
            action("Post Leave Data")
            {
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    HRManagement.PostLeaveJournal(Rec);
                end;
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean;
    begin
        "Leave Type" := 'ANNUAL';
    end;

    var
        SMTP: Codeunit 400;
        LeaveLedgerEntry: Record 50209;
        LeaveLedger: Record 50209;
        LastNumber: Integer;
        HRJournalLine: Record 50209;
        LeaveJournal: Record 50224;
        Employee: Record 5200;

        HRSetup: Record 5218;
        maiheader: Text;
        mailbody: Text;
        User: Record 91;
        Selected: Integer;
        HRManagement: Codeunit 50050;
}

