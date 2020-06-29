page 50156 "Rejected SPC Activation List"
{
    // version TL2.0

    Caption = 'Rejected SpotCash Activations';
    CardPageID = "SpotCash Activation";
    PageType = List;
    SourceTable = "SpotCash Activation Header";
    SourceTableView = WHERE(Status = FILTER(Rejected));

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

