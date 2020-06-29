page 50137 "Pending ATM Activation List"
{
    // version TL2.0

    Caption = 'Pending ATM Activations';
    CardPageID = "ATM Activation";
    PageType = List;
    SourceTable = "ATM Activation Header";
    SourceTableView = WHERE(Status = FILTER("Pending Approval"));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; "No.")
                {ApplicationArea=All;
                }
                field(Description; Description)
                {ApplicationArea=All;
                }
                field("Request Date"; "Request Date")
                {ApplicationArea=All;
                }
                field("Requested By"; "Requested By")
                {ApplicationArea=All;
                }
                field(Status; Status)
                {ApplicationArea=All;
                }
            }
        }
    }

    actions
    {
    }
}

