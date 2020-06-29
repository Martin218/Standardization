report 50056 "Calculate Arrears & OP"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true),
                                      Cleared = FILTER(false));

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Description);
                    BOSAManagement.CalculateLoanArrears("No.", 0D, TODAY, ArrearsAmount[1], ArrearsAmount[2], OverpaymentAmount[1], OverpaymentAmount[2]);
                    "Principal Arrears Amount" := ArrearsAmount[1];
                    "Interest Arrears Amount" := ArrearsAmount[2];
                    "Total Arrears Amount" := ArrearsAmount[1] + ArrearsAmount[2];
                    "Principal Overpayment" := OverpaymentAmount[1];
                    "Interest Overpayment" := OverpaymentAmount[2];
                    "Total Overpayment" := OverpaymentAmount[1] + OverpaymentAmount[2];
                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                    MODIFY;
                END;
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                i := 0;
                TotalLoan := COUNT;
                IF GUIALLOWED THEN
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
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        Text000: Label 'Calculating Loan Arrears & Overpayment\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ArrearsAmount: array[4] of Decimal;
        OverpaymentAmount: array[4] of Decimal;
}

