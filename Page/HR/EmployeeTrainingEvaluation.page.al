page 50497 "Employee Training Evaluation"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50275;

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
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Branch Name"; "Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Department Name"; "Department Name")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field("Course/Seminar Name"; "Course/Seminar Name")
                {
                    ApplicationArea = All;
                }
                field("Training Institution"; "Training Institution")
                {
                    ApplicationArea = All;
                }
                field(Venue; Venue)
                {
                    ApplicationArea = All;
                }
                field("Start Date"; "Start Date")
                {
                    ApplicationArea = All;
                }
                field("End Date"; "End Date")
                {
                    ApplicationArea = All;
                }
            }
            part("Selective Questions"; 50517)
            {
                Caption = 'Selective Questions';
                SubPageLink = "Evaluation No." = FIELD("No.");
                 ApplicationArea = All;
            }
            part("Narrative Questions"; 50518)
            {
                Caption = 'Narrative Questions';
                SubPageLink = "Evaluation No." = FIELD("No.");
                ApplicationArea = All;
            }



            group(Audit)
            {
                Caption = 'Audit';
                Editable = false;
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Submitted Date"; "Submitted Date")
                {
                    ApplicationArea = All;
                }
                field("Submitted Time"; "Submitted Time")
                {
                    ApplicationArea = All;
                }
                field("Submitted By"; "Submitted By")
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
            action("Submit Feedback")
            {
                Image = Completed;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = SeeSubmit;
                ApplicationArea = All;
                trigger OnAction();
                begin
                    IF CONFIRM(Text000) THEN BEGIN
                        Submitted := TRUE;
                        "Submitted By" := USERID;
                        "Submitted Date" := TODAY;
                        "Submitted Time" := TIME;
                        MODIFY;
                        MESSAGE(Text001);
                    END;
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    trigger OnOpenPage();
    begin
        Visibility;
    end;

    var
        Text000: Label 'Are you sure you want to submit your feedback?';
        Text001: Label 'Your feedback has been submitted successfully!';
        SeeSubmit: Boolean;

    local procedure Visibility();
    begin
        IF Submitted THEN BEGIN
            SeeSubmit := FALSE;
            CurrPage.EDITABLE(FALSE);
        END ELSE BEGIN
            SeeSubmit := TRUE;
            CurrPage.EDITABLE(TRUE);
        END;
    end;
}

