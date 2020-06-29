page 50995 "Notice Approval"
{
    // version TL2.0

    PageType = List;
    SourceTable = notice;
    SourceTableView = WHERE(Status = CONST(Pending));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    ApplicationArea = All;
                }
                field(Agenda; Agenda)
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Approval Remarks"; "Approval Remarks")
                {
                    ApplicationArea = All;
                }
                field(User; User)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Approve Notices")
            {
                ApplicationArea = all;
                Caption = 'Approve Notice';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.ApproveNotice(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Reject Notices")
            {
                ApplicationArea = All;
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    RegistryManagement.RejectNotice(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("View Notice Card")
            {
                ApplicationArea = All;
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    Notices.SETRANGE("No.", "No.");
                    IF Notices.FIND('-') THEN BEGIN
                        PAGE.RUN(50992, Notices);
                    END;
                end;
            }
        }
    }

    var
        // CurrentUser : Record "91";
        Notices: Record Notice;
        Employee: Record Employee;
        RegistryManagement: Codeunit "Registry Management2";
}

