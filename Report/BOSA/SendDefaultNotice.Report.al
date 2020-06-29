report 50055 "Send Default Notice"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem("Loan Default Entry"; "Loan Default Entry")
        {
            DataItemTableView = SORTING("Entry No.");

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "Member No.");
                    ProgressWindow.UPDATE(2, "Member Name");
                    ProgressWindow.UPDATE(3, "Loan No.");
                    ProgressWindow.UPDATE(4, Description);
                    BOSAManagement.SendDefaultNotice("Loan Default Entry", NoticeCategory);
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
                CASE NoticeCategory OF
                    NoticeCategory::"First Notice":
                        SETRANGE("No. of Defaulted Installment", 1);
                    NoticeCategory::"Second Notice":
                        SETRANGE("No. of Defaulted Installment", 2);
                    NoticeCategory::"Third Notice":
                        SETFILTER("No. of Defaulted Installment", '>=%1', 3);
                END;

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
            area(content)
            {
                field(NoticeCategory; NoticeCategory)
                {
                    Caption = 'Notice Category';
                    ApplicationArea = All;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        NoticeCategory: Option "First Notice","Second Notice","Third Notice";
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalLoan: Integer;
        Text000: Label 'Sending Default Notice\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Loan No.          #3#############################\\';
        Text004: Label 'Description       #4#############################\';
        Text005: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
}

