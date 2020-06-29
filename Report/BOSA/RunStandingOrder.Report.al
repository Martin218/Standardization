report 50051 "Run Standing Order"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Standing Order"; "Standing Order")
        {
            DataItemTableView = WHERE(Running = FILTER(true));

            trigger OnAfterGetRecord()
            begin
                i += 1;
                StandingOrderLine.RESET;
                StandingOrderLine.SETRANGE("Document No.", "No.");
                IF StandingOrderLine.FINDSET THEN BEGIN
                    REPEAT
                        IF GUIALLOWED THEN BEGIN
                            ProgressWindow.UPDATE(1, Description);
                            ProgressWindow.UPDATE(2, StandingOrderLine."Member No.");
                            ProgressWindow.UPDATE(3, StandingOrderLine."Member Name");
                            ProgressWindow.UPDATE(4, StandingOrderLine."Account No.");
                            ProgressWindow.UPDATE(5, StandingOrderLine."Account Name");
                        END;
                    UNTIL StandingOrderLine.NEXT = 0;
                END;
                BOSAManagement.PostStandingOrder("Standing Order");
                IF GUIALLOWED THEN
                    ProgressWindow.UPDATE(6, (i / TotalSTO * 10000) DIV 1);
            end;

            trigger OnPostDataItem()
            begin
                IF GUIALLOWED THEN
                    ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                CBSSetup.GET;
                BOSAManagement.ClearJournal(CBSSetup."Standing Order Template Name", CBSSetup."Standing Order Batch Name");
                SETRANGE("Next Run Date", TODAY);
                TotalSTO := COUNT;

                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005 + Text006);
                i := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ProgressWindow: Dialog;
        i: Integer;
        TotalSTO: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        StandingOrderLine: Record "Standing Order Line";
        CBSSetup: Record "CBS Setup";
        Text000: Label 'Standing Order Processing\';
        Text001: Label 'Description       #1#############################\';
        Text002: Label 'Member No.     #2#############################\';
        Text003: Label 'Member Name  #3#############################\';
        Text004: Label 'Account No.     #4#############################\\';
        Text005: Label 'Description       #5#############################\';
        Text006: Label 'Progress          @6@@@@@@@@@@@@@@@@@@@@@@@\';
}

