page 50971 "File Movement Request List"
{
    // version TL2.0

    Caption = 'InterBranch File Transfer';
    CardPageID = "File Movement Request Card";
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "File Movement";
    SourceTableView = WHERE(Status = filter('New'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("File Movement ID"; "File Movement ID")
                {
                    ApplicationArea = All;
                }
                field("File No."; "File No.")
                {
                    ApplicationArea = All;
                }
                field("File Name"; "File Name")
                {
                    ApplicationArea = All;
                }
                field("Reason Code"; "Reason Code")
                {
                    ApplicationArea = All;
                }
                field("Cabinet No."; "Cabinet No.")
                {
                    ApplicationArea = All;
                }
                field(Volume; Volume)
                {
                    ApplicationArea = All;
                }
                field("From Location"; "From Location")
                {
                    ApplicationArea = All;
                }
                field("To Location"; "To Location")
                {
                    ApplicationArea = All;
                }
                field("Request Remarks"; "Request Remarks")
                {
                    ApplicationArea = All;
                }
                field("Released By"; "Released By")
                {
                    ApplicationArea = All;
                }
                field("Released To"; "Released To")
                {
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    ApplicationArea = All;
                }
                field("Date Released"; "Date Released")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        //user.GET(USERID);
    end;

    var
        user: Record "User Setup";
        RegistryFiles: Record "Registry File";
}

