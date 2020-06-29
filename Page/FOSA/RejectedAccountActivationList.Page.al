page 50102 "Rejected Account Activ. List"
{
    // version TL2.0

    Caption = 'Rejected Account Activations';
    CardPageID = "Account Activation";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Related Information,Approval Request,Comments,Category 7,Category 8';
    SourceTable = "Account Activation Header";
    SourceTableView = WHERE(Status = FILTER(Rejected));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field("Request Date"; "Request Date")
                {ApplicationArea=All;
                }
                field("Requested By"; "Requested By")
                {ApplicationArea=All;
                }
                field(Status; Status)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Comments)
            {
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                Scope = Repeater;
                ToolTip = 'View or add comments for the record.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecRef: RecordRef;
                begin
                    ApprovalCommentLine.FILTERGROUP(10);
                    ApprovalCommentLine.SETRANGE("Document No.", Rec."No.");
                    ApprovalCommentLine.FILTERGROUP(0);
                    ApprovalComments.SETTABLEVIEW(ApprovalCommentLine);
                    ApprovalComments.EDITABLE(FALSE);
                    ApprovalComments.RUN;
                end;
            }
        }
    }

    var
        ApprovalCommentLine: Record "Approval Comment Line";
        ApprovalComments: Page "Approval Comments";
}

