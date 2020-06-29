page 50115 "Posted Account Transfer List"
{
    // version TL2.0

    CardPageID = "Inter Account Transfer";
    PageType = List;
    SourceTable = Transaction;
    SourceTableView = WHERE(Posted = FILTER(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Transaction Type"; "Transaction Type")
                {ApplicationArea=All;
                }
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field("Account No."; "Account No.")
                {ApplicationArea=All;
                }
                field("Account Name"; "Account Name")
                {ApplicationArea=All;
                }
                field(Amount; Amount)
                {ApplicationArea=All;
                }
                field(Cashier; Cashier)
                {ApplicationArea=All;
                }
                field("Transaction Date"; "Transaction Date")
                {ApplicationArea=All;
                }
                field("Transaction Time"; "Transaction Time")
                {ApplicationArea=All;
                }
                field(Posted; Posted)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SETFILTER(Cashier, USERID);
        FILTERGROUP(2);
    end;

    trigger OnOpenPage()
    begin
        Ok := TellerSetup.GET(USERID);
        IF NOT Ok THEN
            MESSAGE('User %1 Does Not have a Teller Setup', USERID)
        ELSE BEGIN
            FILTERGROUP(2);
            SETFILTER(Cashier, '=%1', TellerSetup."Teller ID");
            FILTERGROUP(0);
        END;
    end;

    var
        TellerSetup: Record "Teller Setup";
        Ok: Boolean;
}

