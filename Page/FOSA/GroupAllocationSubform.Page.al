page 55036 "Group Allocation Subform"
{
    // version MC2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Group Allocation Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction No."; "Transaction No.")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Sender Name"; "Sender Name")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Deposited Amount"; "Deposited Amount")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Amount to Allocate"; "Amount to Allocate")
                {
                    ApplicationArea = All;
                }
                field("Allocated Amount"; "Allocated Amount")
                {
                    DrillDown = true;
                    DrillDownPageID = "Group Member Allocation";
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    StyleExpr = StyleText;
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Get Collection Entries")
            {
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = false;

                trigger OnAction()
                begin
                    IF GroupAllocationHeader.GET("Document No.") THEN
                        GroupAllocationHeader.TESTFIELD("Group No.");


                end;
            }
            action("Allocate Amount")
            {
                Image = Allocate;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = IsVisibleAllocateAmount;

                trigger OnAction()
                begin
                    GroupMemberAllocation.FILTERGROUP(10);
                    GroupMemberAllocation.SETRANGE("Document No.", Rec."Document No.");
                    GroupMemberAllocation.SETRANGE("Transaction No.", Rec."Transaction No.");
                    GroupMemberAllocation.FILTERGROUP(0);
                    PAGE.RUN(55034, GroupMemberAllocation);
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        PageVisibility;
    end;

    trigger OnAfterGetRecord()
    begin
        StylePage;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        StylePage;
        CurrPage.UPDATE(TRUE);
    end;

    trigger OnOpenPage()
    begin
        StylePage;
        PageVisibility;
    end;

    var

        GroupMemberAllocation: Record "Group Member Allocation";
        GroupAllocationHeader: Record "Group Allocation Header";
        Member: Record Member;
        MeetingDate: array[2] of Date;
        IsVisibleGetCollectionEntries: Boolean;
        IsVisibleAllocateAmount: Boolean;
        StyleText: Text[50];

    local procedure PageVisibility()
    begin
        IF GroupAllocationHeader.GET("Document No.") THEN;
        IF GroupAllocationHeader.Status = GroupAllocationHeader.Status::New THEN BEGIN
            IsVisibleGetCollectionEntries := FALSE;
            IsVisibleAllocateAmount := TRUE;
        END ELSE BEGIN
            IsVisibleGetCollectionEntries := FALSE;
            IsVisibleAllocateAmount := FALSE;
        END;
    end;

    procedure StylePage()
    begin
        IF GroupAllocationHeader.GET("Document No.") THEN;
        IF "Transaction Date" < GroupAllocationHeader."Last Meeting Date" THEN
            StyleText := 'Unfavorable'
        ELSE
            StyleText := 'Standard';
        CALCFIELDS("Allocated Amount");
        IF ("Amount to Allocate" - "Allocated Amount") = 0 THEN
            StyleText := 'Favorable'
    end;
}

