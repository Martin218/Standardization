page 55095 "Rejected Portfolio Transfer"
{
    // version MC2.0

    Caption = 'Rejected Portfolio Transfers';
    CardPageID = "Portfolio Transfer Card";
    Editable = false;
    PageType = List;
    SourceTable = "Portfolio Transfer";
    SourceTableView = WHERE(Status = FILTER(Approved));

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
                field("Transfer Type"; "Transfer Type")
                {
                    ApplicationArea = All;
                }
                field(Category; Category)
                {
                    ApplicationArea = All;
                }
                field("Source Branch Code"; "Source Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Source Branch Name"; "Source Branch Name")
                {
                    ApplicationArea = All;
                }
                field("Source Loan Officer ID"; "Source Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Variant2 := Rec;
        // MicroCreditManagement.ShowApprovalEntries(Variant2,3);
        Rec.COPY(Variant2);
    end;

    var
        // MicroCreditManagement: Codeunit "55001";
        Variant2: Variant;
}

