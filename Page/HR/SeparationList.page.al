page 50493 "Separation List"
{
    // version TL2.0

    Caption = 'Separation List';
    CardPageID = "Separation Card";
    DeleteAllowed = false;
    PageType = List;
    SourceTable = 50237;
    SourceTableView = WHERE(Status = filter('Open'));
    UsageCategory = Lists;
    ApplicationArea = all;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Separation No"; "Separation No")
                {
                    ApplicationArea = All;
                }
                field("Employee No."; "Employee No.")
                {
                    ApplicationArea = All;
                }
                field("Employee Name"; "Employee Name")
                {
                    ApplicationArea = All;
                }
                field("Employment Date"; "Employment Date")
                {
                    ApplicationArea = All;
                }
                field(Branch; Branch)
                {
                    ApplicationArea = All;
                }
                field("Job Title"; "Job Title")
                {
                    ApplicationArea = All;
                }
                field("Separation Type"; "Separation Type")
                {
                    ApplicationArea = All;
                }
                field("Notification Start Date"; "Notification Start Date")
                {
                    ApplicationArea = All;
                }
                field("Notice Period"; "Notice Period")
                {
                    ApplicationArea = All;
                }
                field("Notification End Date"; "Notification End Date")
                {
                    ApplicationArea = All;
                }
                field("Last Working Date"; "Last Working Date")
                {
                    ApplicationArea = All;
                }
                field("In Lieu of Notice"; "In Lieu of Notice")
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
        area(creation)
        {
        }
    }
}

