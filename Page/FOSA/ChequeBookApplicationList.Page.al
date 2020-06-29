page 50172 "Cheque Book Application List"
{
    // version CTS2.0

    Caption = 'New Cheque Book Applications';
    CardPageID = "Cheque Book Application";
    PageType = List;
    SourceTable = "Cheque Book Application";
    SourceTableView = WHERE(Status = FILTER(New));

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
                field("Member No."; "Member No.")
                {
                    ApplicationArea = All;
                }
                field("Member Name"; "Member Name")
                {
                    ApplicationArea = All;
                }
                field("Global Dimension 1 Code"; "Global Dimension 1 Code")
                {
                    ApplicationArea = All;
                }
                field("Cheque Book No."; "Cheque Book No.")
                {
                    ApplicationArea = All;
                }
                field("Cheque Book S/No."; "Cheque Book S/No.")
                {
                    ApplicationArea = All;
                }
                field("No. of Leaves"; "No. of Leaves")
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
                field("Account Balance"; "Account Balance")
                {
                    ApplicationArea = All;
                }
                field("Created By"; "Created By")
                {
                    ApplicationArea = All;
                }
                field("Approved By"; "Approved By")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin

    end;

    var

}