page 51000 "Vehicle Registry list"
{
    // version TL2.0

    CardPageID = "Vehicle Register card";
    PageType = List;
    SourceTable = "Vehicle Register";

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
                field("Fixed Asset Car No."; "Fixed Asset Car No.")
                {
                    ApplicationArea = All;
                }
                field("Responsible Driver"; "Responsible Driver")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Insured; Insured)
                {
                    ApplicationArea = All;
                }
                field("Date of Insurance"; "Date of Insurance")
                {
                    ApplicationArea = All;
                }
                field(Months; Months)
                {
                    ApplicationArea = All;
                }
                field("Insurance Expiry Date"; "Insurance Expiry Date")
                {
                    ApplicationArea = All;
                }
                field("Branch Code"; "Branch Code")
                {
                    ApplicationArea = All;
                }
                field("Number Plate"; "Number Plate")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Chassis No"; "Chassis No")
                {
                    ApplicationArea = All;
                }
                field("Body Type"; "Body Type")
                {
                    ApplicationArea = All;
                }
                field(Colour; Colour)
                {
                    ApplicationArea = All;
                }
                field(Model; Model)
                {
                    ApplicationArea = All;
                }
                field("Engine No"; "Engine No")
                {
                    ApplicationArea = All;
                }
                field(YOM; YOM)
                {
                    ApplicationArea = All;
                }
                field(Registered; Registered)
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Booked; Booked)
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
            action("Print Vehicle register")
            {
                ApplicationArea = all;
                Caption = 'Print Vehicle Register';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    CLEAR("Vehicle Register1");
                    "Vehicle Register".RESET;
                    "Vehicle Register".SETRANGE("No.", "No.");
                    IF "Vehicle Register".FINDFIRST THEN BEGIN
                        REPORT.RUNMODAL(50564, TRUE, FALSE, "Vehicle Register");
                    END;
                end;
            }
            action("Check Insurance Expiry")
            {
                Image = Insurance;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction();
                begin
                    AdminManagement.CheckInsuranceExpirydate(Rec);
                    //CurrPage.CLOSE;
                end;
            }
        }
    }

    var
        "Vehicle Register1": Record "Vehicle Register";
        "Vehicle Register": Record "Vehicle Register";
        //CurrentUser : Record "91";
        // Mail : Codeunit "397";
        //Employee : Record "5200";
        HODEmail: Text[80];
        //smtpcu : Codeunit "400";
        bdDialog: Dialog;
        //smtpsetup : Record "409";
        mailheader: Text;
        mailbody: Text;
        AdminManagement: Codeunit "Admin Management";
}

