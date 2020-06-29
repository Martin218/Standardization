page 50963 "File Volume"
{
    // version TL2.0

    PageType = List;
    SourceTable = "File Volume";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                }
                field("File Location"; "File Location")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; "Date Created")
                {
                    ApplicationArea = All;
                }
                field("Previous File Number"; "Previous File Number")
                {
                    Caption = 'Previous Volume';
                    ApplicationArea = All;
                }
                field(No; No)
                {
                    ApplicationArea = All;
                }
                field(Select; Select)
                {
                    ApplicationArea = All;
                }
                field(MemberNo; MemberNo)
                {
                    ApplicationArea = All;
                }
                field(Volume2; Volume2)
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
            action("Uncheck All")
            {
                Image = Check;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction();
                begin
                    FileVolumes.RESET;
                    FileVolumes.SETRANGE(MemberNo, MemberNo);
                    IF FileVolumes.FINDSET THEN BEGIN
                        REPEAT
                            MESSAGE('found %1 %2', FileVolumes.Volume, FileVolumes.MemberNo);
                            FileVolumes.Select := TRUE;
                        UNTIL FileVolumes.NEXT = 0;
                    END;
                end;
            }
        }
    }

    var
        FileVolumes: Record "File Volume";
}

