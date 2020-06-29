report 50050 "Capitalize Interest"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(DataItem1; "Loan Application")
        {
            DataItemTableView = WHERE(Posted = FILTER(true));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "No.");
                    ProgressWindow.UPDATE(4, Description);
                    //BOSAManagement.CapitalizeInterest("Loan Application");
                    ProgressWindow.UPDATE(5, (i / TotalAccount * 10000) DIV 1);
                END;
                SLEEP(50);
                LoanApplication.MARK(TRUE);
            end;

            trigger OnPostDataItem()
            begin
                CLEARLASTERROR;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.CLOSE;
                    IF BOSAManagement.PostJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name") THEN BEGIN
                        LoanApplication.MARKEDONLY(TRUE);
                        UpdateNexDueDate(LoanApplication);
                    END ELSE
                        ERROR(GETLASTERRORTEXT);
                END;
            end;

            trigger OnPreDataItem()
            begin
                CBSSetup.GET;
                BOSAManagement.ClearJournal(CBSSetup."Loan Interest Template Name", CBSSetup."Loan Interest Batch Name");

                i := 0;
                TotalAccount := COUNT;
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
        Text000: Label 'Interest Capitalization\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Account No.     #3#############################\\';
        Text004: Label 'Account Name #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        Text006: Label 'Updating Next Due Date\';
        Text007: Label 'Posting failed';
        ProgressWindow: Dialog;
        i: Integer;
        TotalAccount: Integer;
        BOSAManagement: Codeunit "BOSA Management";
        CBSSetup: Record "CBS Setup";
        LoanApplication: Record "Loan Application";
        DateFormula: DateFormula;

    local procedure UpdateNexDueDate(LoanApplication: Record "Loan Application")
    var
        Member: Record "Member";
    begin
        i := 0;
        IF GUIALLOWED THEN BEGIN
            ProgressWindow.OPEN(Text006 + Text001 + Text002 + Text003 + Text004 + Text005);
            IF LoanApplication.FINDSET THEN BEGIN
                TotalAccount := LoanApplication.COUNT;
                REPEAT
                    i += 1;
                    ProgressWindow.UPDATE(1, LoanApplication."Member No.");
                    ProgressWindow.UPDATE(2, LoanApplication."Member Name");
                    ProgressWindow.UPDATE(3, LoanApplication."No.");
                    ProgressWindow.UPDATE(4, LoanApplication.Description);
                    ProgressWindow.UPDATE(5, (i / TotalAccount * 10000) DIV 1);

                    EVALUATE(DateFormula, BOSAManagement.GetRepaymentFrequencyDateFormula(LoanApplication));
                    LoanApplication."Next Due Date" := CALCDATE(DateFormula, TODAY);
                    LoanApplication.MODIFY;
                UNTIL LoanApplication.NEXT = 0;
            END;
            ProgressWindow.CLOSE;
        END;
    end;
}

