page 50997 "Minutes Template Card"
{
    // version TL2.0

    PageType = Card;
    SourceTable = MinuteTemplate;

    layout
    {
        area(content)
        {
            group("Minutes Template")
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Day of meeting"; "Day of meeting")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field(user; user)
                {
                    ApplicationArea = All;
                    Caption = 'Minutes Attached By';
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Import Minutes")
            {
                ApplicationArea = all;
                Caption = 'Import Minutes';
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = true;

                trigger OnAction();
                begin
                    RegistryManagement.AttachMinutes(Rec);
                end;
            }
            action("View Attached Minutes")
            {
                ApplicationArea = All;
                Image = Opportunity;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                /* WSHShell2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
                 WSHExec2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{08FED190-BE19-11D3-A28B-00104BD35090}:'Windows Script Host Object Model'.IWshExec";
                 WSHTxt2 : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{0BB02EC0-EF49-11CF-8940-00A0C9054228}:'Windows Script Host Object Model'.TextStream";
                 WSHShell : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{72C24DD5-D70A-438B-8A42-98424B88AFB8}:'Windows Script Host Object Model'.WshShell";
                 WSHExec : Automation "{F935DC20-1CF0-11D0-ADB9-00C04FD58A0B} 1.0:{08FED190-BE19-11D3-A28B-00104BD35090}:'Windows Script Host Object Model'.IWshExec";
             */
                begin
                    RegistryManagement.OpenAttachedMinutes(Rec);
                end;
            }
            action("Save Minute Details")
            {
                ApplicationArea = All;
                Image = WageLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction();
                begin
                    RegistryManagement.SaveMinuteDetails(Rec);
                    CurrPage.CLOSE;
                end;
            }
            action("Generate Minutes Template")
            {
                ApplicationArea = All;
                Image = Revenue;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                var
                    TempFile: File;
                    FileName: Text[250];
                    IStream: InStream;
                    ToFile: Text[250];
                begin
                    /* CLEAR(MinuteTemplate);
                     TempFile.TEXTMODE(FALSE);
                     TempFile.WRITEMODE(TRUE);
                     FileName := 'C:\Temp\Minutes.xls';
                     TempFile.CREATE(FileName);
                     TempFile.CLOSE;

                     MinuteTemplate.SAVEASEXCEL(FileName);
                     TempFile.OPEN(FileName);
                     TempFile.CREATEINSTREAM(IStream);
                     ToFile := "No."+'.xls';
                     DOWNLOADFROMSTREAM(IStream,'Save file to client','','Excel File *.xls| *.xls',ToFile);
                     TempFile.CLOSE();
                     */
                end;
            }
        }
    }

    var
        ongoingbl: Boolean;
        appealedbl: Boolean;
        closedbl: Boolean;
        openbl: Boolean;
        //MinuteTemplate : Report "50559";
        TempFile: Text;
        RegistryManagement: Codeunit "Registry Management2";
}

