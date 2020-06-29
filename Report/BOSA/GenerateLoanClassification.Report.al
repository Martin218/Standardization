report 50053 "Generate Loan Classification"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Application"; "Loan Application")
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
                    BOSAManagement.GenerateLoanClassification("Loan Application");
                    ProgressWindow.UPDATE(5, (i / TotalLoan * 10000) DIV 1);
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
                LoanClassificationEntry.DELETEALL;
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
        Text000: Label 'Generating Loan Classification\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        LoanClassificationEntry: Record "Loan Classification Entry";
}

