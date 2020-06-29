page 50958 "Registry File List"
{
    // version TL2.0

    CardPageID = "Inventory File Card";
    DelayedInsert = false;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Registry File";
    SourceTableView = WHERE(Created = FILTER('Yes'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RegFile Status"; "RegFile Status")
                {
                    Caption = 'File Status';
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    Visible = false;
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                }
                field("File Type"; "File Type")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = All;
                }
                field("Payroll No."; "Payroll No.")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Location; Location1)
                {
                    ApplicationArea = All;
                }
                field("Date Created"; "Date Created")
                {
                    ApplicationArea = All;
                }
                field("File Request Status"; "File Request Status")
                {
                    ApplicationArea = All;
                }
                field("Current User"; "Current User")
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

