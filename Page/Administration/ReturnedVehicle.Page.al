page 51013 "Returned Vehicle"
{
    // version TL2.0

    PageType = List;
    SourceTable = "Vehicle Booking";

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
                field(User; User)
                {
                    ApplicationArea = All;
                    Caption = 'Returned By';
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field(Status; Status)
                {
                    ApplicationArea = All;
                }
                field("Available Car"; "Available Car")
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Number Plate';
                }
                field("Booking Date"; "Booking Date")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Return Date"; "Vehicle Return Date")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Return time"; "Vehicle Return time")
                {
                    ApplicationArea = All;
                }
                field("Return Vehicle"; "Return Vehicle")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Vehicle Return")
            {
                ApplicationArea = all;
                Caption = 'Vehicle Return';
                Image = Return;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin

                    AdminManagement.ReturnVehicle(Rec);
                    CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        vehicle: Record "Vehicle Register";
        //CurrentUser: Record "91";
        Notices: Record Notice;
        //Employee: Record "5200";
        HODEmail: Text[80];
        // smtpcu: Codeunit "400";
        bdDialog: Dialog;
        //smtpsetup: Record "409";
        mailheader: Text;
        mailbody: Text;
        //depemails: Record "349";
        AdminManagement: Codeunit "Admin Management";
}

