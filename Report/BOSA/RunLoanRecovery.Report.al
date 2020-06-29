report 50058 "Run Loan Recovery"
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
                    //BOSAManagement.PostLoanRecovery("Loan Application");
                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
                END;
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                CLEARLASTERROR;
                IF BOSAManagement.PostJournal(CBSSetup."Loan Recovery Template Name", CBSSetup."Loan Recovery Batch Name") THEN BEGIN
                    EXIT;
                END ELSE BEGIN
                    IF GETLASTERRORTEXT <> '' THEN
                        ERROR(GETLASTERRORTEXT);
                END;
                IF GUIALLOWED THEN
                    ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                CBSSetup.GET;
                BOSAManagement.ClearJournal(CBSSetup."Loan Recovery Template Name", CBSSetup."Loan Recovery Batch Name");

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
        Text000: Label 'Loan Recovery Processing\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ArrearsAmount: array[4] of Decimal;
        CBSSetup: Record "CBS Setup";
}

