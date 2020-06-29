report 50061 "Send Dividend Notice"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Dividend Header")
        {

            trigger OnAfterGetRecord()
            begin
                DividendLine.RESET;
                DividendLine.SETRANGE("Document No.", "No.");
                IF DividendLine.FINDSET THEN
                    TotalCount := DividendLine.COUNT;

                LineCount := 0;
                DividendLine.RESET;
                DividendLine.SETRANGE("Document No.", "No.");
                IF DividendLine.FINDSET THEN BEGIN
                    REPEAT
                        LineCount += 1;
                        ProgressWindow.UPDATE(1, DividendLine."Member No.");
                        ProgressWindow.UPDATE(2, DividendLine."Member Name");
                        BOSAManagement.SendDividendsNotice(DividendLine);
                        ProgressWindow.UPDATE(3, (LineCount / TotalCount * 10000) DIV 1);
                        SLEEP(50);
                    UNTIL DividendLine.NEXT = 0;
                END;
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE
            end;

            trigger OnPreDataItem()
            begin

                ProgressWindow.OPEN(Text000 + '\' +
                                    'Member No.   #1######################' + '\' +
                                    'Member Name  #2######################' + '\' +
                                    'Progress     @3@@@@@@@@@@@@@@@@@@@@@@');
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
        Text000: Label 'Sending SMS to Members';
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        LineCount: Integer;
        TotalCount: Integer;
        DividendLine: Record "Dividend Line";
}

