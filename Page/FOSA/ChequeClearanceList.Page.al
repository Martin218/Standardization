page 50162 "Cheq. Clearance List"
{
    // version TL2.0

    Caption = 'New Cheque Clearance';
    CardPageID = "Cheque Clearance";
    PageType = List;
    SourceTable = "Cheque Clearance Header";
    SourceTableView = WHERE(Status = FILTER(New));

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
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Created Date"; "Created Date")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
    }
}

