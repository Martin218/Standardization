page 50315 "Dividend Subform"
{
    // version TL2.0

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SourceTable = "Dividend Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("Earning Type"; "Earning Type")
                {
                    ApplicationArea = All;
                }
                field("Gross Earning Amount"; "Gross Earning Amount")
                {
                    ApplicationArea = All;
                }
                field("Excise Duty Amount"; "Excise Duty Amount")
                {
                    ApplicationArea = All;
                }
                field("Withholding Tax Amount"; "Withholding Tax Amount")
                {
                    ApplicationArea = All;
                }
                field("Commission Amount"; "Commission Amount")
                {
                    ApplicationArea = All;
                }
                field("Shares Topup Amount"; "Shares Topup Amount")
                {
                    ApplicationArea = All;
                }
                field("Net Earning Amount"; "Net Earning Amount")
                {
                    ApplicationArea = All;
                }
                field("Distribution Option"; "Distribution Option")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Calculate Dividends")
            {
                Image = CalculateCost;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    DividendHeader.GET("Document No.");
                    DividendHeader.TESTFIELD(Status, DividendHeader.Status::New);
                    CalculateDividends.SetDocumentNo("Document No.");
                    CalculateDividends.RUN;
                end;
            }
            action("Send SMS")
            {
                Image = SendElectronicDocument;
                Promoted = true;
                PromotedCategory = Category7;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    DividendHeader.GET("Document No.");
                    DividendHeader.TESTFIELD(Posted, TRUE);
                    DividendHeader.SETRECFILTER;
                    REPORT.RUN(REPORT::"Send Dividend Notice", TRUE, FALSE, DividendHeader)
                end;
            }
        }
    }

    var
        CalculateDividends: Report "Calculate Dividends";
        DividendHeader: Record "Dividend Header";
}

