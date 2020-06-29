page 55038 "Pending GP Allocations List"
{
    // version MC2.0

    Caption = 'Pending Group Allocations';
    CardPageID = "Group Allocation";
    PageType = List;
    SourceTable = "Group Allocation Header";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));

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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }
                field("Created Time"; "Created Time")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
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
        //MicroCreditManagement.ShowApprovalEntries(Variant2, 1);
        Rec.COPY(Variant2)
    end;

    var
        //MicroCreditManagement: Codeunit "55001";
        Variant2: Variant;
}

