page 50265 "Attachement FactBox"
{
    // version TL2.0

    Caption = 'Attachment';
    PageType = ListPart;
    SourceTable = "CBS Attachment";

    layout
    {
        area(content)
        {
            repeater(R1)
            {
                field("File Name"; "File Name")
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
            action(AttachFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Attach File';
                Image = Attach;
                ToolTip = 'Attach a file to the loan';

                trigger OnAction()
                var
                    FileManagement: Codeunit "File Management";
                    FileName: Text;
                    ClientFileName: Text;
                begin
                    FileName := FileManagement.UploadFile(SelectPictureTxt, ClientFileName);
                    FileName := FileManagement.GetFileName(FileName);
                    IF FileName = '' THEN
                        EXIT;
                    BOSAManagement.AddAttachment(FORMAT(RecID), DocNo, FileName);
                end;
            }
            action(ViewFile)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'View File';
                Image = ViewOrder;
                Scope = Repeater;
                ToolTip = 'View the file that is attached to the incoming document record.';

                trigger OnAction()
                begin
                    CBSAttachment.RESET;
                    CBSAttachment.SETRANGE("Entry No.", Rec."Entry No.");
                    IF CBSAttachment.FINDFIRST THEN BEGIN
                        CBSAttachment.CALCFIELDS(Attachment);
                        //TempBlob.Blob := CBSAttachment.Attachment;
                        FileManagement.BLOBExport(TempBlob, "File Name", TRUE);
                    END;
                end;
            }
        }
    }

    var
        CBSAttachment: Record "CBS Attachment";
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        RecID: RecordID;
        DocNo: Code[20];
        SelectPictureTxt: Label 'Select a file to upload';
        BOSAManagement: Codeunit "BOSA Management";

    procedure SetParameter(RecordID: RecordID; DocumentNo: Code[20])
    begin
        RecID := RecordID;
        DocNo := DocumentNo;
    end;
}

