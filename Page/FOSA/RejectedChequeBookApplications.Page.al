page 50175 "Rejected CB Application List"
{
    // version TL2.0

    Caption = 'Rejected Cheque Book Applications';
    CardPageID = "Cheque Book Application";
    PageType = List;
    SourceTable = "Cheque Book Application";
    SourceTableView = WHERE(Status = FILTER(Rejected));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {
                }
                field(Description; Description)
                {
                }
                field("Member No."; "Member No.")
                {
                }
                field("Member Name"; "Member Name")
                {
                }
                field("Cheque Book No."; "Cheque Book No.")
                {
                }
                field("Cheque Book S/No."; "Cheque Book S/No.")
                {
                }
                field("No. of Leaves"; "No. of Leaves")
                {
                }
                field("Account No."; "Account No.")
                {
                }
                field("Account Name"; "Account Name")
                {
                }
                field("Account Balance"; "Account Balance")
                {
                }
                field("Created By"; "Created By")
                {
                }
                field("Approved By"; "Approved By")
                {
                }
            }
        }
    }

    actions
    {
    }
}

