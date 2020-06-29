page 50974 "File Movement Approval List"
{
    // version TL2.0

    CardPageID = "File Movement Approval Card";
    PageType = List;
    SourceTable = "File Movement";
    SourceTableView = WHERE(Status = filter('Approval Pending'));

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
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
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
        /*DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.",1);
        DimensionValue.SETRANGE(Code,User."Global Dimension 1 Code");
        IF DimensionValue.FIND('-') THEN BEGIN
           userbranch:=DimensionValue.Name;
        END;
        //SETRANGE("From Location",User."Global Dimension 1 Code");
        SETRANGE("From Location",userbranch);*/
    end;

    var
        User: Record "User Setup";
        //DimensionValue : Record "349";
        userbranch: Text;
}

