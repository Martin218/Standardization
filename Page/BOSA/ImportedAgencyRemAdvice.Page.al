page 50344 "Imported Agency Rem. Advice"
{
    // version TL2.0

    Caption = 'Imported Agency Remittance Advice';
    CardPageID = "Agency Remittance Advice";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Agency Remittance Header";
    SourceTableView = WHERE(Status = FILTER(Imported));
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

