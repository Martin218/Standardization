page 50485 "Job Application Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = 50277;

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
                field("Application Date"; "Application Date")
                {
                    ApplicationArea = All;
                }
                field("Recruitment Request No."; "Recruitment Request No.")
                {
                    ApplicationArea = All;
                }
                field("Job ID"; "Job ID")
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field(Name; Name)
                {
                    ApplicationArea = All;
                }
                field("National ID/Passport No."; "National ID/Passport No.")
                {
                    ApplicationArea = All;
                }
                field(Gender; Gender)
                {
                    ApplicationArea = All;
                }
                field(Email; Email)
                {
                    ApplicationArea = All;
                }
                field("Mobile Phone No."; "Mobile Phone No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("No. Years of Experience"; "No. Years of Experience")
                {
                    ApplicationArea = All;
                }
                field("Level of Education"; "Level of Education")
                {
                    ApplicationArea = All;
                }
            }
        }
        area(Factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50277),
                              "No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';
                RunObject = page "Document Attachment Details";
                RunPageLink = "No." = field("No.");

            }
        }

    }

    var
        DocAttach: Record "Document Attachment";
        JobApplications: Record "Job Application";
}

