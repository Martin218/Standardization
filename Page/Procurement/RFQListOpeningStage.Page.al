page 50757 "RFQ List - Opening Stage"
{
    // version TL2.0

    Caption = 'Request For Quotation List - New';
    CardPageID = "Request For Quotation Card";
    PageType = List;
    SourceTable = "Procurement Request";
    SourceTableView = WHERE("Procurement Option" = FILTER("Request For Quotation"),
                            "LPO Generated" = FILTER(false),
                            "Process Status" = FILTER(Opening));

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
                field("Requisition No."; "Requisition No.")
                {
                    ApplicationArea = All;
                }
                field("Procurement Plan No."; "Procurement Plan No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Assigned User"; "Assigned User")
                {
                    ApplicationArea = All;
                }
                field("Created On"; "Created On")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
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

