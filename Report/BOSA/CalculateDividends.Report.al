report 50059 "Calculate Dividends"
{
    // version TL2.0

    ProcessingOnly = true;
    UsageCategory = Tasks;
    ApplicationArea = All;

    dataset
    {
        dataitem(Member; Member)
        {
            DataItemTableView = SORTING("No.");

            trigger OnAfterGetRecord()
            begin
                i += 1;
                IF GUIALLOWED THEN BEGIN
                    ProgressWindow.UPDATE(1, "No.");
                    ProgressWindow.UPDATE(2, "Full Name");
                    BOSAManagement.CalculateDividends(Member, DividendType, DocumentNo);
                    ProgressWindow.UPDATE(5, (i / TotalMember * 10000) DIV 1);
                END;
                SLEEP(50);
            end;

            trigger OnPostDataItem()
            begin
                ProgressWindow.CLOSE;
            end;

            trigger OnPreDataItem()
            begin
                DividendLine.RESET;
                DividendLine.SETRANGE("Document No.", DocumentNo);
                DividendLine.DELETEALL;

                i := 0;
                TotalMember := COUNT;
                IF GUIALLOWED THEN
                    ProgressWindow.OPEN(Text000 + Text001 + Text002 + Text003);
            end;
        }
    }

    requestpage
    {

        layout
        {

            area(content)
            {

                field(DividendType; DividendType)
                {
                    Caption = 'Dividend Type';
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
        BOSAManagement: Codeunit "BOSA Management";
        ProgressWindow: Dialog;
        i: Integer;
        TotalMember: Integer;
        Text000: Label 'Dividend Processing\';
        Text001: Label 'Member No.      #1#############################\';
        Text002: Label 'Member Name  #2#############################\';
        Text003: Label 'Progress          @5@@@@@@@@@@@@@@@@@@@@@@@\';
        ArrearsAmount: array[4] of Decimal;
        DocumentNo: Code[20];
        DividendLine: Record "Dividend Line";
        DividendType: Option Both,Dividend,Interest;

    procedure SetDocumentNo(var DocNo: Code[20])
    begin
        DocumentNo := DocNo;
    end;
}

