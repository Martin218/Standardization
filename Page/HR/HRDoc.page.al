page 50440 "Human Resource Doc"
{
    // version TL2.0

    PageType = List;
    SourceTable = 50226;
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Document Name"; "Document Name")
                {
                    ApplicationArea = All;
                }
                field("Upload date"; "Upload date")
                {
                    ApplicationArea = All;
                }
                field("Upload By"; "Upload By")
                {
                    ApplicationArea = All;
                }
                field("Upload Time"; "Upload Time")
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
            action("Attach HR Documents")
            {
                Image = Attach;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    HRManagement.AttachHRDocs(Rec);
                end;
            }
            action("View HR Documents")
            {
                Image = View;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    HRManagement.ViewHRDocs(Rec);
                end;
            }
        }
    }

    var
        HRManagement: Codeunit 50050;
}

