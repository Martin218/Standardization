page 50955 "New File List"
{
    // version TL2.0

    CardPageID = "Registry File Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "Registry File";
    //SourceTableView = WHERE(Created = filter('No'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("RegFile Status"; "RegFile Status")
                {
                    Caption = 'File Status';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("File Number"; "File Number")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("ID No."; "ID No.")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Date Created"; "Date Created")
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

