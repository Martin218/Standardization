page 50965 "Files Pending Issuance"
{
    // version TL2.0

    CardPageID = "File Issue Card";
    Editable = false;
    PageType = List;
    RefreshOnActivate = true;
    SourceTable = "File Issuance";
    SourceTableView = WHERE("Request Status" = filter('Active'));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Request ID"; "Request ID")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Required Date"; "Required Date")
                {
                    ApplicationArea = All;
                }
                field("Duration Required(Days)"; "Duration Required(Days)")
                {
                    ApplicationArea = All;
                }
                field("Due Date"; "Due Date")
                {
                    ApplicationArea = All;
                }
                field("Requisiton By"; "Requisiton By")
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
                field(Reason; Reason)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                }
                field("Request Status"; "Request Status")
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
        //User.GET(USERID);
        //SETRANGE("Branch Code",User."Global Dimension 1 Code");
        //FILTERGROUP(0);
        //SETRANGE("Requisiton By", USERID);
        //FILTERGROUP(0);
    end;

    var
        User: Record "User Setup";
}

