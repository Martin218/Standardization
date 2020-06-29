page 50931 "Performance Review Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50286;

    layout
    {
        area(content)
        {
            group(General)
            {
                Editable = EditEmployeeComments;
                field(Period; Period)
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("First Name"; "First Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Middle Name"; "Middle Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Last Name"; "Last Name")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employee Position"; "Employee Position")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Department Code"; "Department Code")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Appraiser Employee No."; "Appraiser Employee No.")
                {
                    Caption = 'Appraiser''s Employee No.';
                    ApplicationArea = All;
                }
                field("Appraiser Name"; "Appraiser Name")
                {
                    Caption = 'Appraiser''s Name';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("Appraiser Job Title"; "Appraiser Job Title")
                {
                    Caption = 'Appraiser''s Title';
                    Editable = false;
                    ApplicationArea = All;
                }
                field("JD Updated"; "JD Updated")
                {
                    Caption = 'Job Description Updated';
                    ApplicationArea = All;
                }
            }
            part("Performance Assessment"; "Performance Competency Lines")
            {
                Caption = 'Performance Assessment';
                SubPageLink = "Review No." = FIELD("Review No.");
                ApplicationArea = All;
            }
            group("Career and Development Needs")
            {
                Caption = 'Career and Development Needs';
                field("Career Plan Employee"; "Career Plan Employee")
                {
                    Caption = 'Career Plan';
                    Editable = EditEmployeeComments;
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Career Plan"; "Career Plan")
                {
                    Caption = 'Appraiser Comments';
                    MultiLine = true;
                    Visible = SeeAppraiserComments;
                    ApplicationArea = All;
                }
                field("Development Needs Employee"; "Development Needs Employee")
                {
                    Caption = 'Development Needs';
                    Editable = EditEmployeeComments;
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Development Needs"; "Development Needs")
                {
                    Caption = 'Appraiser Comments';
                    MultiLine = true;
                    Visible = SeeAppraiserComments;
                    ApplicationArea = All;
                }
            }
            group("Other Comments")
            {
                Caption = 'Other Comments';
                field("Employees Comments"; "Employees Comments")
                {
                    Editable = EditEmployeeComments;
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Appraisers Comments"; "Appraisers Comments")
                {
                    MultiLine = true;
                    Visible = SeeAppraiserComments;
                    ApplicationArea = All;
                }
            }
            group("Overall Rating")
            {
                Caption = 'Overall Rating';

                field("Score is Final"; "Score is Final")
                {
                    ApplicationArea = All;
                }
                field("Total Score"; "Total Score")
                {
                    ApplicationArea = All;
                }

                field("KPI Score"; "KPI Score")
                {
                    Caption = 'KPI Achievement';
                    MultiLine = false;
                    Visible = false;
                    ApplicationArea = All;
                }
                field("KPI Description"; "KPI Description")
                {
                    Caption = 'KPI Achievement Description';
                    Editable = false;
                    Visible = false;
                    MultiLine = false;
                    ApplicationArea = All;
                }
                field("KPI Comments"; "KPI Comments")
                {
                    Caption = 'Reviewer Recommendation';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Overall Reviewer Recommend"; "Overall Reviewer Recommend")
                {
                    Caption = 'Overall Reviewer Recommendation';
                    MultiLine = true;
                    ApplicationArea = All;
                }
                field("Appraisal Agreement Reached"; "Appraisal Agreement Reached")
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
            action("Forward to Appraiser")
            {
                Image = CoupledUsers;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeForwardtoAppraiser;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        TESTFIELD("Employee No.");
                        TESTFIELD("Appraiser Employee No.");
                        "Released to Appraiser" := TRUE;
                        MODIFY;
                        MESSAGE(Text001);
                        CurrPage.CLOSE;
                    END;
                end;
            }
            action("Forward to HR")
            {
                Image = PersonInCharge;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeForwardtoHR;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    IF CONFIRM(Text002) THEN BEGIN
                        "Released to HR Admin" := TRUE;
                        MODIFY;
                        MESSAGE(Text003);
                        CurrPage.CLOSE;
                    END;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        SetVisibility;
    end;

    var
        SeeAppraiserComments: Boolean;
        UserSetup: Record 91;
        SeeForwardtoAppraiser: Boolean;
        SeeForwardtoHR: Boolean;
        EditEmployeeComments: Boolean;
        Text000: Label 'Are you sure you want to submit this review to your appraiser?';
        Text001: Label 'Submitted successfully!';
        Text002: Label 'Are you sure you want to forward this review to HR?';
        Text003: Label 'Forwarded successfully!';

    local procedure SetVisibility();
    begin
        IF UserSetup.GET(USERID) THEN BEGIN
            /*     IF UserSetup."Employee No." = "Employee No." THEN BEGIN
                     SeeAppraiserComments := FALSE;
                     EditEmployeeComments := TRUE;
                 END ELSE BEGIN
                     IF UserSetup."Employee No." = "Appraiser Employee No." THEN BEGIN
                         SeeAppraiserComments := TRUE;
                         EditEmployeeComments := FALSE;
                     END ELSE
                         SeeAppraiserComments := FALSE;
                     EditEmployeeComments := FALSE;
                 END;*/

            IF NOT "Released to Appraiser" AND NOT "Released to HR Admin" THEN BEGIN
                SeeForwardtoHR := FALSE;
                SeeForwardtoAppraiser := TRUE;
                EditEmployeeComments := TRUE;
                SeeAppraiserComments := FALSE;
            END;
            IF "Released to Appraiser" AND NOT "Released to HR Admin" THEN BEGIN
                SeeForwardtoAppraiser := FALSE;
                SeeForwardtoHR := TRUE;
                EditEmployeeComments := FALSE;
                SeeAppraiserComments := True;
            END;
            IF "Released to HR Admin" THEN BEGIN
                SeeAppraiserComments := TRUE;
                EditEmployeeComments := FALSE;
                CurrPage.EDITABLE(FALSE);
            END;
        END;
    end;
}

