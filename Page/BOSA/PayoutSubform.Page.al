page 50281 "Payout Subform"
{
    // version TL2.0

    AutoSplitKey = true;
    PageType = ListPart;
    RefreshOnActivate = true;
    SourceTable = "Payout Line";
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
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Gross Amount"; "Gross Amount")
                {
                    ApplicationArea = All;
                }
                field("Charge Amount"; "Charge Amount")
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
                field("Net Amount"; "Net Amount")
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
            action("Import Payout File")
            {
                Image = ImportCodes;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                trigger OnAction()
                begin
                    PayoutHeader.GET("Document No.");
                    PayoutHeader.TESTFIELD(Status, PayoutHeader.Status::New);

                    CLEAR(ImportPayoutFile);
                    ImportPayoutFile.SetPayoutNo(Rec."Document No.");
                    ImportPayoutFile.RUN;
                end;
            }
        }
    }

    var
        ImportPayoutFile: XMLport "Import Payout File";
        PayoutHeader: Record "Payout Header";
}

