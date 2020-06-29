page 50803 "Restr. Tender List- Contracts"
{
    // version TL2.0

    Caption = 'Restricted Tender List-  Contract List';
    CardPageID = "Restricted Tender Card";
    PageType = List;
    SourceTable = "Procurement Request";
    SourceTableView = WHERE("Procurement Option" = FILTER("Restricted Tender"),
                            "Process Status" = FILTER(LPO),
                            "LPO Generated" = FILTER('No'),
                            "Contract Generated" = FILTER('Yes'));

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
