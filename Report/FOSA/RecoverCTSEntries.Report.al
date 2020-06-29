report 50003 "Recover CTS Entries"
{
    // version CTS2.0

    ProcessingOnly = true;

    dataset
    {
        dataitem("CTS Entry"; "CTS Entry")
        {
            RequestFilterFields = "Member No.", "Clearance Date", "Account No.";

            trigger OnAfterGetRecord()
            begin
                i += 1;
                ProgressWindow.UPDATE(1, "Member No.");
                ProgressWindow.UPDATE(2, "Member Name");
                ProgressWindow.UPDATE(3, "Document No.");
                ProgressWindow.UPDATE(4, Description);
                FOSAManagement.RecoverUnpaidCTSEntries("CTS Entry");
                ProgressWindow.UPDATE(5, (i / TotalCTSCount * 10000) DIV 1);
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                SETRANGE(Paid, FALSE);
                i := 0;
                TotalCTSCount := COUNT;
                ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003 + Text004 + Text005);
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
        i: Integer;
        ProgressWindow: Dialog;
        TotalCTSCount: Integer;
        LineCount: Integer;
        Text000: Label 'Recovering Unpaid CTS Entries\';
        Text001: Label 'Member No.          #1#############################\';
        Text002: Label 'Member Name       #2#############################\';
        Text003: Label 'Document No.       #3#############################\\';
        Text004: Label 'Description            #4#############################\';
        Text005: Label 'Progress                @5@@@@@@@@@@@@@@@@@@@@@@@\';
        FOSAManagement: Codeunit "FOSA Management";
}

