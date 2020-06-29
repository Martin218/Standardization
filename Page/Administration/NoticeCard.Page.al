page 50994 "Notice Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = Notice;

    layout
    {
        area(content)
        {
            group(Notices)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field(Date; Date)
                {
                    Caption = 'Date of Notice Send';
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Agenda; Agenda)
                {
                    MultiLine = true;
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
            action("Attach Notice")
            {
                ApplicationArea = all;
                Caption = 'Attach Notice';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction();
                begin
                    RegistryManagement.AttachNotice(Rec);
                end;
            }
            action("Open Attached Notice")
            {
                Image = ViewCheck;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;

                trigger OnAction();
                var
                /* WSHShell2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
                 WSHExec2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{08FED190-BE19-11D3-A28B-00104BD35090}:'Windows Script Host Object Model'.IWshExec";
                 WSHTxt2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{0BB02EC0-EF49-11CF-8940-00A0C9054228}:'Windows Script Host Object Model'.TextStream";
                 WSHShell : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
                 WSHExec : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{08FED190-BE19-11D3-A28B-00104BD35090}:'Windows Script Host Object Model'.IWshExec";
             */
                begin
                    RegistryManagement.OpenAttachedNotice(Rec);
                end;
            }
            action("Save Notice Details")
            {
                Image = Warehouse;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction();
                begin
                    RegistryManagement.SaveNoticeDetails(Rec);
                end;
            }
        }
    }

    var
        ongoingbl: Boolean;
        appealedbl: Boolean;
        closedbl: Boolean;
        openbl: Boolean;
        RegistryManagement: Codeunit "Registry Management2";
}

