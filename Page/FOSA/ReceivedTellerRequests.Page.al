page 50113 "Received Teller Requests"
{
    // version TL2.0

    CardPageID = "Issue To Teller Card";
    PageType = List;
    SourceTable = "Treasury Transaction";
    SourceTableView = WHERE(Posted = CONST(true));
    // "Transaction Type" = FILTER(Issue To Teller|Request From Treasury),
    // Issue Received=FILTER(Yes));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                }
                field("Transaction Date"; "Transaction Date")
                {
                    ApplicationArea = All;
                }
                field("Transaction Type"; "Transaction Type")
                {
                    ApplicationArea = All;
                }
                field("Treasury Account"; "Treasury Account")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        /*IF "Transaction Type"="Transaction Type"::"Issue To Teller" THEN BEGIN
           PAGE.RUN(50112,Rec,No);
        END;
        IF "Transaction Type"="Transaction Type"::"Request From Treasury" THEN BEGIN
           PAGE.RUN(50066,Rec,No);
        END;*/

    end;
}

