page 55039 "Approved GP Allocations List"
{
    // version MC2.0

    Caption = 'Approved Group Allocations';
    CardPageID = "Group Allocation";
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Related Information,Posting,Category7';
    SourceTable = "Group Allocation Header";
    SourceTableView = WHERE(Status = FILTER(Approved),
                            Posted = FILTER(false));

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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
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
            action(Post)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'P&ost';
                Ellipsis = true;
                Image = PostApplication;
                Promoted = true;
                PromotedCategory = Category6;
                PromotedIsBig = true;
                PromotedOnly = true;
                ShortCutKey = 'F9';
                ToolTip = 'Finalize the document or journal by posting the amounts and quantities to the related accounts in your company books.';
                Visible = false;

                trigger OnAction()
                begin
                    // MicroCreditManagement.PostGroupAllocation(Rec);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        FILTERGROUP(10);
        UserSetup.GET(USERID);
        Variant2 := Rec;
        //MicroCreditManagement.ShowApprovalEntries(Variant2, 2);
        Rec.COPY(Variant2);
        Rec.SETRANGE(Posted, FALSE);
    end;

    var
        // MicroCreditManagement: Codeunit "55001";
        Variant2: Variant;
        UserSetup: Record "User Setup";
        UserSetup2: Record "User Setup";
}

