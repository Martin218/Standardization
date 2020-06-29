page 50792 "Open Tender List- Contracts"
{
    // version TL2.0

    Caption = 'Open Tender List-  Contract List';
    CardPageID = "Open Tender Card";
    PageType = List;
    SourceTable = "Procurement Request";
    SourceTableView = WHERE("Procurement Option" = FILTER('Open Tender'),
                            "Process Status" = FILTER(LPO),
                            "LPO Generated" = FILTER(false),
                            "Contract Generated" = FILTER(true));

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
                field("Contract No."; "Contract No.")
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
                field("Process Status"; "Process Status")
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

