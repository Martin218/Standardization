page 50144 "SpotCash Application List"
{
    // version TL2.0

    Caption = 'New SpotCash Applications';
    CardPageID = "SpotCash Application Card";
    Editable = false;
    PageType = List;
    SourceTable = "SpotCash Application";
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
                field("Phone No."; "Phone No.")
                {
                    ApplicationArea = All;
                }
                field("Service Type"; "Service Type")
                {
                    ApplicationArea = All;
                }
                field("SMS Alert on"; "SMS Alert on")
                {
                    ApplicationArea = All;
                }
                field("E-Mail Alert on"; "E-Mail Alert on")
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
    }
}

