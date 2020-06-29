page 50989 "Admin No. Card Setup"
{
    // version TL2.0

    PageType = Card;
    SourceTable = "Admin Numbering Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field("No."; "No.")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";

                }
                field("Chassis No"; "Chassis No")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("No.Series"; "No.Series")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Primary Key"; "Primary Key")
                {
                    ApplicationArea = All;
                }
                field(Mileage; Mileage)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Booking Date"; "Booking Date")
                {
                    ApplicationArea = All;
                }
                field(Duration; Duration)
                {
                    ApplicationArea = All;
                }
                field(Remarks; Remarks)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field(Agenda; Agenda)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("HOD File Path"; "HOD File Path")
                {
                    ApplicationArea = All;
                }
                field("Approval Remarks"; "Approval Remarks")
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                    LookupPageId = "No. Series";
                }
                field("Approver Email"; "Approver Email")
                {
                    ApplicationArea = All;
                }
                field("Notice File"; "Notice File")
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

