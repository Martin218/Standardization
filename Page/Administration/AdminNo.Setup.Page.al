page 50988 "Admin No. Setup"
{
    // version TL2.0

    CardPageID = "Admin No. Card Setup";
    PageType = List;
    SourceTable = "Admin Numbering Setup";

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
                field("Chassis No"; "Chassis No")
                {
                    ApplicationArea = All;
                }
                field("No.Series"; "No.Series")
                {
                    ApplicationArea = All;
                }
                field(Comment; Comment)
                {
                    ApplicationArea = All;
                }
                field("Primary Key"; "Primary Key")
                {
                    ApplicationArea = All;
                }
                field(Mileage; Mileage)
                {
                    ApplicationArea = All;
                }
                field("Boardroom Name"; "Boardroom Name")
                {
                    ApplicationArea = All;
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
                }
                field(Agenda; Agenda)
                {
                    ApplicationArea = All;
                }
                field("HOD File Path"; "HOD File Path")
                {
                    ApplicationArea = All;
                }
                field("Approval Remarks"; "Approval Remarks")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field(Comments; Comments)
                {
                    ApplicationArea = All;
                }
                field("Approver Email"; "Approver Email")
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

