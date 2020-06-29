page 50977 "Receive Dispatched Files"
{
    // version TL2.0

    CardPageID = "Receive File Card";
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "File Movement";
    SourceTableView = WHERE(Status = filter(Dispatched));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Received; Received)
                {
                    Visible = false;
                    ApplicationArea = All;
                }
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
                field("No. Series"; "No. Series")
                {
                    ApplicationArea = All;
                }
                field("Date Released"; "Date Released")
                {
                    ApplicationArea = All;
                }
                field("Carried By"; "Carried By")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Approval/Rejection Remarks"; "Approval/Rejection Remarks")
                {
                    ApplicationArea = All;
                }
                field("Request Date"; "Request Date")
                {
                    ApplicationArea = All;
                }
                field("Approved Date"; "Approved Date")
                {
                    ApplicationArea = All;
                }
                field("Approver ID"; "Approver ID")
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
        /*User.GET(USERID);
        SETRANGE("To Location",User."Global Dimension 1 Code");
        DimensionValue.RESET;
        DimensionValue.SETRANGE("Global Dimension No.",1);
        DimensionValue.SETRANGE(Code,User."Global Dimension 1 Code");
        IF DimensionValue.FIND('-') THEN BEGIN
           userbranch:=DimensionValue.Name;
        END;
        SETRANGE("To Location",userbranch);*/

    end;

    var
        User: Record "User Setup";
        userbranch: Text[20];
    // DimensionValue : Record "349";
}

