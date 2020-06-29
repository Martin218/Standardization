page 50968 "File Return List"
{
    // version TL2.0

    CardPageID = "File Return Card";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "File Return";
    SourceTableView = WHERE(Posted = filter('Yes'),
                            "File Return Status" = filter('Pending Acceptance'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Return ID"; "Return ID")
                {
                    ApplicationArea = All;
                }
                field("Return Date"; "Return Date")
                {
                    ApplicationArea = All;
                }
                field("Staff Name"; "Staff Name")
                {
                    ApplicationArea = All;
                }
                field("Request ID"; "Request ID")
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage();
    begin
        CurrPage.EDITABLE(FALSE);
        User.GET(USERID);
        //SETRANGE("Branch Code",User."Global Dimension 1 Code");
    end;

    var
        User: Record "User Setup";
}

