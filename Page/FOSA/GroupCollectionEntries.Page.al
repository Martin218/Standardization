page 55033 "Group Collection Entries"
{
    // version MC2.0

    Caption = 'Group Collections';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Approval Request,Allocation,Posting,Category7';
    SourceTable = "Group Collection Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction No."; "Transaction No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction Time"; "Transaction Time")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Sender Name"; "Sender Name")
                {
                    ApplicationArea = All;
                }
                field("Group Paybill Code"; "Group Paybill Code")
                {
                    ApplicationArea = All;
                }
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Source Code"; "Source Code")
                {ApplicationArea=All;
                }
                field("Deposited Amount"; "Deposited Amount")
                {
                    ApplicationArea = All;
                }
                field("Allocated Amount"; "Allocated Amount")
                {
                    ApplicationArea = All;
                }
                field("Remaining Amount"; "Remaining Amount")
                {
                    ApplicationArea = All;
                }
                field("Debit Account Code"; "Debit Account Code")
                {
                    ApplicationArea = All;
                }
                field("Posting Status"; "Posting Status")
                {
                    ApplicationArea = All;
                }
                field("Posting Message"; "Posting Message")
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

                trigger OnAction()
                begin
                    TESTFIELD("Posting Status", "Posting Status"::Fail);
                    //MicroCreditManagement.PostGroupCollectionEntry(Rec);
                end;
            }
            action(Print)
            {
                Image = Print;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    REPORT.RUN(55004, TRUE, FALSE, Rec);
                end;
            }
            action("Update Collection Entries")
            {

                trigger OnAction()
                begin
                    EVALUATE(CutOffDate, '110819');
                    GroupCollectionEntry.RESET;
                    GroupCollectionEntry.SETRANGE("Posting Status", GroupCollectionEntry."Posting Status"::Success);
                    GroupCollectionEntry.SETRANGE("Transaction Date", 0D, CutOffDate);
                    IF GroupCollectionEntry.FINDSET THEN BEGIN
                        REPEAT
                            GroupCollectionEntry."Allocated Amount" := GroupCollectionEntry."Deposited Amount";
                            GroupCollectionEntry."Remaining Amount" := 0;
                            GroupCollectionEntry.MODIFY(TRUE);
                        UNTIL GroupCollectionEntry.NEXT = 0;
                        MESSAGE('success');
                    END;
                end;
            }
        }
    }

    var
        GroupAllocation: Record "Group Member Allocation";
        // MicroCreditManagement: Codeunit "55001";
        GroupCollectionEntry: Record "Group Collection Entry";
        CutOffDate: Date;
}

