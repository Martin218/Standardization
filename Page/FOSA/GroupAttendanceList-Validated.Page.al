page 55029 "Validated Grp Attendance List"
{
    // version MC2.0

    Caption = 'Validated Group Attendance';
    CardPageID = "Group Attendance";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Group Attendance Header";
    SourceTableView = WHERE(Status = FILTER(Validated));

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
                field("Group No."; "Group No.")
                {
                    ApplicationArea = All;
                }
                field("Group Name"; "Group Name")
                {
                    ApplicationArea = All;
                }
                field("Current Meeting Date"; "Current Meeting Date")
                {
                    ApplicationArea = All;
                }
                field("Meeting Venue"; "Meeting Venue")
                {
                    ApplicationArea = All;
                }
                field("Loan Officer ID"; "Loan Officer ID")
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
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
        }
    }

    trigger OnDeleteRecord(): Boolean
    begin
        ERROR(Error000);
    end;

    trigger OnOpenPage()
    begin
        CurrPage.EDITABLE(FALSE);
    end;

    var
        //MicroCreditManagement: Codeunit "55002";
        Member: Record "Member";
        Error000: Label 'You cannot delete this record!';
}

