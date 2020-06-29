page 50999 "Schedule Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "CEO Schedule";

    layout
    {
        area(content)
        {
            group("C.E.O/Board")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field("No of meetings"; "No of meetings")
                {
                    ApplicationArea = All;
                }
                field("Meeting Type"; "Meeting Type")
                {
                    ApplicationArea = All;
                }
                field("No of appointments"; "No of appointments")
                {
                    ApplicationArea = All;
                }
                field("Appointments type"; "Appointments type")
                {
                    ApplicationArea = All;
                }
                field(User; User)
                {
                    Caption = 'C.E.O';
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                }
                field(Schedule; Schedule)
                {
                    ApplicationArea = All;
                }
                field("Appointments time"; "Appointments time")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
            }
        }
        area(factboxes)
        {
            systempart(Outlook; Outlook)
            {
                ApplicationArea = All;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
            systempart(MyNotes; MyNotes)
            {
                ApplicationArea = All;
            }
            systempart(Links; Links)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Save Schedule Info")
            {
                ApplicationArea = all;
                Caption = 'Save Schedule Info';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.SaveCEOScheduleDetails(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        RegistryManagement: Codeunit "Registry Management2";
}

