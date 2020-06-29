page 50445 "Employee Movement"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50229;


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
                field(Type; Type)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("ID Number"; "ID Number")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field(Branch; "Current Branch")
                {
                    ApplicationArea = All;
                }
                field(Department; "Current Department")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Current Job Tiltle")
                {
                    ApplicationArea = All;
                }
                field(Grade; "Current Grade")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
            }
            group("Transfer Details")
            {
                Caption = 'Transfer Details';
                field("New Branch Code"; "New Branch Code")
                {
                    ApplicationArea = All;
                }
                field("New Branch Name"; "New Branch Name")
                {
                    ApplicationArea = All;
                }
                field("New Department Code"; "New Department Code")
                {
                    ApplicationArea = All;
                }
                field("New Department Name"; "New Department Name")
                {
                    ApplicationArea = All;
                }
                field("New Job Title"; "New Job Title")
                {
                    ApplicationArea = All;
                }
                field("New Grade"; "New Grade")
                {
                    ApplicationArea = All;
                }
                field("New Salary"; "New Salary")
                {
                    ApplicationArea = All;
                }
            }
            group(Audit)
            {
                Caption = 'Audit';
                Editable = false;
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
                field("Posted By"; "Posted By")
                {
                    ApplicationArea = All;
                }
                field("Posted Date"; "Posted Date")
                {
                    ApplicationArea = All;
                }
                field("Posted Time"; "Posted Time")
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
            action(Post)
            {
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeePost;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        HRManagement.PostStaffMovement(Rec);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean);
    begin
        Type := Type::Transfer;
    end;

    trigger OnOpenPage();
    begin
        Visibility;
    end;

    var
        Text000: Label 'Are you sure you want to post the staff transfer?';
        HRManagement: Codeunit 50050;
        SeePost: Boolean;

    local procedure Visibility();
    begin
        IF Status = Status::Open THEN BEGIN
            SeePost := TRUE;
            CurrPage.EDITABLE(TRUE);
        END ELSE BEGIN
            SeePost := FALSE;
            CurrPage.EDITABLE(FALSE);
        END;
    end;
}

