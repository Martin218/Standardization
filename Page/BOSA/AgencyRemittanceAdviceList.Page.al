page 50340 "Agency Remittance Advice List"
{
    // version TL2.0

    Caption = 'New Agency Remittance Advice';
    CardPageID = "Agency Remittance Advice";
    Editable = false;
    PageType = List;
    SourceTable = "Agency Remittance Header";
    SourceTableView = WHERE(Status = FILTER(New));
    UsageCategory = Lists;
    ApplicationArea = All;

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
                field("Agency Code"; "Agency Code")
                {
                    ApplicationArea = All;
                }
                field("Agency Name"; "Agency Name")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Period Month"; "Period Month")
                {
                    ApplicationArea = All;
                }
                field("Period Year"; "Period Year")
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
                field("Created Time"; "Created Time")
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

