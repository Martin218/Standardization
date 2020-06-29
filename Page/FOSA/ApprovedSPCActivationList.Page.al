page 50155 "Approved SPC Activation List"
{
    // version TL2.0

    Caption = 'Approved SpotCash Activations';
    CardPageID = "SpotCash Activation";
    PageType = List;
    SourceTable = "SpotCash Activation Header";
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
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Requested By"; "Requested By")
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
}

