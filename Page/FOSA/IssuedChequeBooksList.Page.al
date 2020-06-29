page 50169 "Issued Cheque Book List"
{
    // version CTS2.0

    Caption = 'Issued Cheque Books';
    CardPageID = "Cheque Book";
    Editable = false;
    PageType = List;
    SourceTable = "Cheque Book";
    SourceTableView = WHERE(Status = FILTER(Issued));

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

                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Name"; "Account Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Serial No."; "Serial No.")
                {
                    ApplicationArea = All;
                }
                field("No. of Leaves"; "No. of Leaves")
                {
                    ApplicationArea = All;
                }
                field("Last Leaf Used"; "Last Leaf Used")
                {
                    ApplicationArea = All;
                }

                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field(Active; Active)
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
