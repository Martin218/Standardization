page 50970 "File Queue"
{
    // version TL2.0

    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Transfer Files Line";
    SourceTableView = WHERE(Returned = filter('No'),
                            "SentRet Note" = filter('No'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transfer ID"; "Transfer ID")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field("Member No"; "Member No")
                {
                    ApplicationArea = All;
                }
                field("ID No"; "ID No")
                {
                    ApplicationArea = All;
                }
                field("Payroll No"; "Payroll No")
                {
                    ApplicationArea = All;
                }
                field("File Volume"; "File Volume")
                {
                    ApplicationArea = All;
                }
                field("Time Received"; "Time Received")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                    StyleExpr = StyleText;
                }
                field(sentreturnnote; sentreturnnote)
                {
                    ApplicationArea = All;
                    Caption = 'sentreturnnote';
                }
                field("SentRet Note"; "SentRet Note")
                {
                    ApplicationArea = All;
                }
                field("File No"; "File No")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Send Return Note")
            {
                Image = Note;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    RegistryManagement.SendReturnNote(Rec);
                end;
            }
            action("Transfer File")
            {
                Image = BOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    CurrPage.SETSELECTIONFILTER(Rec);
                    RegistryManagement.TransferFile(Rec);
                end;
            }
        }
    }

    trigger OnAfterGetRecord();
    begin
        IF CURRENTDATETIME > "Due Date" THEN BEGIN
            StyleText := 'Unfavorable';
        END;
    end;

    trigger OnOpenPage();
    begin
        User.GET(USERID);
        FILTERGROUP(2);
        SETRANGE("Received By", USERID);
        SETRANGE("SentRet Note", FALSE);
        FILTERGROUP(0);
    end;

    var
        User: Record "User Setup";
        Overdue: Boolean;
        StyleText: Text[20];
        FileReturn: Record "File Return";
        TransferFilesLines: Record "Transfer Files Line";
        NoSetup: Record "Registry SetUp";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        sentreturnnote: Boolean;
        TransferRegistryFiles: Record "Transfer Registry File";
        TransferFilesLines2: Record "Transfer Files Line";
        RegistryManagement: Codeunit "Registry Management2";
}

